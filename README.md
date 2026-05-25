# 🚕 NYC Taxi Revenue & Demand Analytics Pipeline

End-to-end analytics engineering project on NYC Yellow Taxi trip data (2023), built with Databricks SQL, Delta Lake and a Medallion Architecture (Bronze, Silver, Gold). Includes a natural-language analytics app powered by an LLM.

## Business Question

> Where, when and how much revenue does the NYC taxi fleet generate, and where are the biggest demand gaps?

## Architecture

The pipeline follows the Medallion Architecture:

- **Bronze**: raw ingestion of the 12 monthly Parquet files, kept as-is with ingestion metadata.
- **Silver**: cleaned and enriched data (quality rules, derived columns, zone joins).
- **Gold**: five business-ready analytical tables.

## Tech Stack

- **Storage & Processing**: Databricks SQL, Delta Lake
- **Architecture**: Medallion (Bronze / Silver / Gold)
- **Analytics App**: Streamlit + Google Gemini (Text-to-SQL)
- **Version Control**: Git, Conventional Commits, feature-branch workflow

## Data

- Source: NYC TLC Yellow Taxi Trip Records 2023 (public)
- Volume: 38.3M raw trips, 37.2M after cleaning (2.92% removed)
- Total revenue analyzed: ~$1.08 billion

## Key Findings

- **Airports drive revenue**: JFK is the top earning zone (14.5% of total); JFK + LaGuardia together reach ~22.5%.
- **Manhattan drives volume**: highest revenue overall, mostly by trip count, with a lower average ticket.
- **Seasonality**: demand peaks in May and October, drops sharply in July (summer vacation).
- **Best shift**: afternoon has the highest revenue; overnight has the highest average ticket.

## Gold Tables

| Table | Purpose |
|-------|---------|
| gold_hourly_demand | Trips and revenue by zone and hour |
| gold_borough_revenue | Revenue by borough and month |
| gold_shift_metrics | Operational metrics by time-of-day shift |
| gold_zone_ranking | Zone revenue ranking (window functions) |
| gold_monthly_cohort | Monthly demand trend with month-over-month variation |

## Engineering Highlights

- Resolved a real schema-evolution bug: inconsistent column casing across monthly files (airport_fee vs Airport_fee) caused column misalignment when read with a wildcard. Fixed by reading each file individually and combining with UNION ALL.
- Applied Delta Lake optimization: OPTIMIZE (file compaction) and ZORDER on the most-filtered columns to enable data skipping.
- Documented data quality rules and null-handling business decisions.

## Natural Language Analytics App

A Streamlit app lets non-technical users query the Gold layer in plain English. The question and the table schema are sent to an LLM (Google Gemini), which generates SQL; the query runs on Databricks and the result is displayed.

## Repository Structure

\`\`\`
sql/
  bronze/   raw ingestion
  silver/   cleaning, enrichment, optimization
  gold/     analytical tables
docs/       data dictionary and findings
app/        natural-language analytics app
\`\`\`

## Author

Thiago Feliciano — Data Analyst | Analytics Engineer
\`\`\`