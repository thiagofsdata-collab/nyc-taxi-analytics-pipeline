-- =============================================================
-- NYC Taxi Analytics Pipeline
-- Phase 1 | Bronze Layer | Raw ingestion of Yellow Taxi trips
--
-- Source: NYC TLC public Parquet (CloudFront), uploaded to a
--         Unity Catalog managed Volume.
-- Strategy: Bronze keeps raw data as-is (no cleaning), adding
--           only ingestion metadata for traceability.
-- =============================================================

-- Catalog and schemas
CREATE CATALOG IF NOT EXISTS nyc_taxi;
CREATE SCHEMA IF NOT EXISTS nyc_taxi.bronze;
CREATE SCHEMA IF NOT EXISTS nyc_taxi.silver;
CREATE SCHEMA IF NOT EXISTS nyc_taxi.gold;

-- Bronze table: raw Yellow Taxi trips (2023-01 sample)
CREATE TABLE nyc_taxi.bronze.yellow_trips
USING DELTA
AS
SELECT
    *,
    current_timestamp() AS ingestion_timestamp,  -- when the row entered the pipeline
    2023 AS source_file_year                       -- reference year for filtering
FROM read_files(
    '/Volumes/nyc_taxi/bronze/raw_files/yellow_tripdata_2023-01.parquet',
    format => 'parquet'
);

-- Validation: row count, vendors and date range
SELECT
    COUNT(*) AS total_trips,
    COUNT(DISTINCT VendorID) AS qtd_vendors,
    MIN(tpep_pickup_datetime) AS pickup_min,
    MAX(tpep_pickup_datetime) AS pickup_max
FROM nyc_taxi.bronze.yellow_trips;