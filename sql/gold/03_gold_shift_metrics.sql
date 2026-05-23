-- =============================================================
-- Phase 3 | Gold Layer | Operational metrics by time-of-day shift
--
-- The public TLC dataset has no driver identifier, so per-driver
-- metrics are not feasible. This table analyzes profitability by
-- time-of-day shift, answering: which shift is most profitable
-- to operate?
-- =============================================================
CREATE TABLE nyc_taxi.gold.gold_shift_metrics
USING DELTA
AS
WITH shifts AS (
    -- Map each trip to an operational shift based on pickup hour
    SELECT
        *,
        CASE
            WHEN hour_of_day >= 0  AND hour_of_day < 6  THEN 'Madrugada' -- 0-6h
            WHEN hour_of_day >= 6  AND hour_of_day < 12 THEN 'Manha' -- 6-12h
            WHEN hour_of_day >= 12 AND hour_of_day < 18 THEN 'Tarde' -- 12-18h
            ELSE 'Noite' -- 18-24h
        END AS shift_period
    FROM nyc_taxi.silver.yellow_trips
)
SELECT
    shift_period,
    COUNT(*) AS total_trips,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_ticket,                  
    ROUND(AVG(trip_distance), 2) AS avg_distance,               
    ROUND(AVG(trip_duration_minutes), 2) AS avg_duration_min,   
    ROUND(SUM(total_amount) / COUNT(*), 2) AS revenue_per_trip  
FROM shifts
GROUP BY shift_period;
