-- =============================================================
-- Phase 3 | Gold Layer | Hourly demand by zone
--
-- Aggregates trips and revenue by pickup zone and hour of day.
-- Answers: when and where is demand concentrated?
-- =============================================================
CREATE TABLE nyc_taxi.gold.gold_hourly_demand
USING DELTA
AS
SELECT
    pickup_borough,
    pickup_zone,
    hour_of_day,
    COUNT(*) AS total_trips,                                
    ROUND(SUM(total_amount), 2) AS total_revenue,          
    ROUND(AVG(total_amount), 2) AS avg_ticket,             
    ROUND(AVG(trip_distance), 2) AS avg_distance            
FROM nyc_taxi.silver.yellow_trips
GROUP BY
    pickup_borough,
    pickup_zone,
    hour_of_day;