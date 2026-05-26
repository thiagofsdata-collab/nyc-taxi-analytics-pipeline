"""
NYC Taxi Analytics - Natural Language Query App
Ask questions in plain English, get answers from the Gold layer.
"""
import os
import streamlit as st
import pandas as pd
from google import genai
from databricks import sql
from dotenv import load_dotenv

load_dotenv()

client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))

GOLD_SCHEMA = """
Catalog: nyc_taxi, Schema: gold

Table: nyc_taxi.gold.gold_hourly_demand
- pickup_borough (string), pickup_zone (string), hour_of_day (int)
- total_trips (long), total_revenue (double), avg_ticket (double), avg_distance (double)

Table: nyc_taxi.gold.gold_borough_revenue
- pickup_borough (string), trip_month (int)
- total_trips (long), total_revenue (double), avg_ticket (double), total_tips (double)

Table: nyc_taxi.gold.gold_shift_metrics
- shift_period (string: Overnight, Morning, Afternoon, Evening)
- total_trips (long), total_revenue (double), avg_ticket (double)
- avg_distance (double), avg_duration_min (double), revenue_per_trip (double)

Table: nyc_taxi.gold.gold_zone_ranking
- pickup_borough (string), pickup_zone (string)
- total_trips (long), total_revenue (double)
- revenue_rank_overall (int), revenue_rank_in_borough (int), revenue_share_pct (double)

Table: nyc_taxi.gold.gold_monthly_cohort
- trip_month (int), total_trips (long), total_revenue (double), avg_ticket (double)
- prev_month_revenue (double), revenue_mom_pct (double)
"""


def generate_sql(question):
    """Send schema + question to Gemini, get back a SQL query."""
    prompt = f"""You are a SQL assistant for Databricks SQL.
Given the schema below, write ONE SQL query to answer the question.
Rules:
- Use only the tables and columns in the schema.
- Return ONLY the SQL, no explanation, no markdown fences.
- Always use fully qualified table names (nyc_taxi.gold.table).

Schema:
{GOLD_SCHEMA}

Question: {question}

SQL:"""

    # temperature=0 keeps the SQL deterministic (no creativity/hallucination)
    response = client.models.generate_content(
        model="gemini-flash-latest",
        contents=prompt,
        config={"temperature": 0}
    )
    # Clean possible markdown fences the model might add
    sql_text = response.text.strip().replace("```sql", "").replace("```", "").strip()
    return sql_text


def run_query(query):
    """Execute the SQL query on Databricks and return a DataFrame."""
    with sql.connect(
        server_hostname=os.getenv("DATABRICKS_HOST"),
        http_path=os.getenv("DATABRICKS_HTTP_PATH"),
        access_token=os.getenv("DATABRICKS_TOKEN")
    ) as connection:
        with connection.cursor() as cursor:
            cursor.execute(query)
            result = cursor.fetchall()
            columns = [desc[0] for desc in cursor.description]
    return pd.DataFrame(result, columns=columns)


# ---------- Streamlit interface ----------
st.set_page_config(page_title="NYC Taxi Analytics", page_icon="🚕")
st.title("🚕 NYC Taxi Analytics")
st.caption("Ask questions in plain English about 2023 NYC Yellow Taxi data")

question = st.text_input(
    "Your question:",
    placeholder="e.g. Which pickup zone generated the most revenue?"
)

if st.button("Ask") and question:
    with st.spinner("Generating SQL..."):
        generated_sql = generate_sql(question)

    if not generated_sql.strip().upper().startswith("SELECT"):
        st.error("⚠️ The model did not return a valid SELECT statement. Please rephrase your question.")
        st.stop()

    if "LIMIT" not in generated_sql.upper():
        generated_sql = generated_sql.rstrip().rstrip(";") + "\nLIMIT 500"

    st.subheader("Generated SQL")
    st.code(generated_sql, language="sql")

    with st.spinner("Running query on Databricks..."):
        try:
            df = run_query(generated_sql)
            st.subheader("Result")
            st.dataframe(df)

            cat_cols = [c for c in df.columns if df[c].dtype == object]
            num_cols = [c for c in df.columns if pd.api.types.is_numeric_dtype(df[c])]
            if len(cat_cols) == 1 and len(num_cols) >= 1:
                st.subheader("Chart")
                st.bar_chart(df.set_index(cat_cols[0])[num_cols])
        except Exception as e:
            st.error(f"Error running query: {e}")