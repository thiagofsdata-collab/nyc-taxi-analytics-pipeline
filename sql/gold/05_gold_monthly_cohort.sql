-- =============================================================
-- Phase 3 | Gold Layer | Monthly demand cohort
--
-- Monthly trend of trips and revenue across 2023, with
-- month-over-month variation using LAG window function.
-- Answers: how does demand evolve through the year and how
-- much does each month grow or shrink vs the previous one?
-- =============================================================
CREATE TABLE nyc_taxi.gold.gold_monthly_cohort
USING DELTA
AS
WITH monthly AS (
    SELECT
        MONTH(tpep_pickup_datetime) AS trip_month,
        COUNT(*) AS total_trips,
        ROUND(SUM(total_amount), 2) AS total_revenue,
        ROUND(AVG(total_amount), 2) AS avg_ticket
    FROM nyc_taxi.silver.yellow_trips
    GROUP BY MONTH(tpep_pickup_datetime)
)
SELECT
    trip_month,
    total_trips,
    total_revenue,
    avg_ticket,
    LAG(total_revenue) OVER (ORDER BY trip_month) AS prev_month_revenue,
    ROUND(
        100.0 * (total_revenue - LAG(total_revenue) OVER (ORDER BY trip_month))
        / LAG(total_revenue) OVER (ORDER BY trip_month), 2
    ) AS revenue_mom_pct
FROM monthly;