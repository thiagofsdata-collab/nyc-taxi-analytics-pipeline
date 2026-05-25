-- =============================================================
-- Phase 2 | Silver Layer | Cleaned Yellow Taxi trips (full 2023)
--
-- Applies data quality rules, handles nulls with business logic,
-- adds derived columns and joins the zone dimension to bring
-- borough and zone names for pickup and dropoff.
--
-- Note: zone aliases are pickup_z / dropoff_z (avoid reserved
-- words like 'do' as table aliases).
-- =============================================================
CREATE TABLE nyc_taxi.silver.yellow_trips
USING DELTA
AS
WITH cleaned AS (
    SELECT *
    FROM nyc_taxi.bronze.yellow_trips
    WHERE YEAR(tpep_pickup_datetime) = 2023
      AND fare_amount >= 0
      AND trip_distance > 0
      AND tpep_dropoff_datetime > tpep_pickup_datetime
      AND (UNIX_TIMESTAMP(tpep_dropoff_datetime)
           - UNIX_TIMESTAMP(tpep_pickup_datetime)) <= 86400
),
enriched AS (
    SELECT
        c.*,
        COALESCE(c.passenger_count, 1) AS passenger_count_clean,
        ROUND(
            (UNIX_TIMESTAMP(c.tpep_dropoff_datetime)
             - UNIX_TIMESTAMP(c.tpep_pickup_datetime)) / 60.0, 2
        ) AS trip_duration_minutes,
        ROUND(c.total_amount / c.trip_distance, 2) AS revenue_per_mile,
        HOUR(c.tpep_pickup_datetime) AS hour_of_day,
        DAYOFWEEK(c.tpep_pickup_datetime) AS day_of_week,
        CASE
            WHEN DAYOFWEEK(c.tpep_pickup_datetime) IN (1, 7) THEN true
            ELSE false
        END AS is_weekend
    FROM cleaned c
)
SELECT
    e.*,
    pickup_z.borough AS pickup_borough,
    pickup_z.zone AS pickup_zone,
    dropoff_z.borough AS dropoff_borough,
    dropoff_z.zone AS dropoff_zone
FROM enriched e
LEFT JOIN nyc_taxi.silver.taxi_zones pickup_z
    ON e.PULocationID = pickup_z.location_id
LEFT JOIN nyc_taxi.silver.taxi_zones dropoff_z
    ON e.DOLocationID = dropoff_z.location_id;