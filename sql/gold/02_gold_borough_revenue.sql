-- =============================================================
-- Phase 3 | Gold Layer | Revenue by borough and month
--
-- Aggregates revenue and trips by pickup borough and month.
-- Answers: which borough drives revenue and how does it
-- change month over month?
-- =============================================================
CREATE TABLE nyc_taxi.gold.gold_borough_revenue
USING DELTA
AS
SELECT
    pickup_borough,
    MONTH(tpep_pickup_datetime) AS trip_month,               
    COUNT(*) AS total_trips,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_ticket,
    ROUND(SUM(tip_amount), 2) AS total_tips                   
FROM nyc_taxi.silver.yellow_trips
GROUP BY
    pickup_borough,
    MONTH(tpep_pickup_datetime);

