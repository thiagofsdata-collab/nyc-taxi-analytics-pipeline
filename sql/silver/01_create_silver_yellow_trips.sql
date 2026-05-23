-- =============================================================
-- Phase 2 | Silver Layer | Cleaned Yellow Taxi trips
--
-- Applies data quality rules, handles nulls with business
-- logic, adds derived columns and joins zone dimension to
-- bring borough and zone names for pickup and dropoff.
-- =============================================================
CREATE TABLE nyc_taxi.silver.yellow_trips
USING DELTA
AS
WITH cleaned AS (
    -- Step 1: filter out invalid trips based on business rules
    SELECT *
    FROM nyc_taxi.bronze.yellow_trips
    WHERE YEAR(tpep_pickup_datetime) = 2023   -- keep only 2023
      AND fare_amount >= 0  -- no negative fares
      AND trip_distance > 0  -- distance must be positive
      AND tpep_dropoff_datetime > tpep_pickup_datetime  -- dropoff after pickup
      AND (UNIX_TIMESTAMP(tpep_dropoff_datetime) 
           - UNIX_TIMESTAMP(tpep_pickup_datetime)) <= 86400 -- max 24h (86400 seconds)
),
enriched AS (
    -- Step 2: handle nulls and create derived columns
    SELECT
        c.*,
        COALESCE(c.passenger_count, 1) AS passenger_count_clean,    

        -- Trip duration in minutes (business metric)
        ROUND(
            (UNIX_TIMESTAMP(c.tpep_dropoff_datetime) 
             - UNIX_TIMESTAMP(c.tpep_pickup_datetime)) / 60.0, 2
        ) AS trip_duration_minutes,

        -- Revenue per mile (efficiency metric)
        ROUND(c.total_amount / c.trip_distance, 2) AS revenue_per_mile,

        -- Time dimensions for demand analysis
        HOUR(c.tpep_pickup_datetime) AS hour_of_day,
        DAYOFWEEK(c.tpep_pickup_datetime) AS day_of_week,           
        CASE 
            WHEN DAYOFWEEK(c.tpep_pickup_datetime) IN (1, 7) THEN true
            ELSE false 
        END AS is_weekend
    FROM cleaned c
)
-- Step 3: join zone dimension for pickup and dropoff
SELECT
    e.*,
    pu.borough AS pickup_borough,
    pu.zone AS pickup_zone,
    do.borough AS dropoff_borough,
    do.zone AS dropoff_zone
FROM enriched e
LEFT JOIN nyc_taxi.silver.taxi_zones pu  -- pickup zone
    ON e.PULocationID = pu.location_id
LEFT JOIN nyc_taxi.silver.taxi_zones do  -- dropoff zone
    ON e.DOLocationID = do.location_id;