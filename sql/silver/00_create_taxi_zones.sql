-- Dimension table: taxi zone lookup
-- Translates LocationID into Borough and Zone names
CREATE TABLE nyc_taxi.silver.taxi_zones
USING DELTA
AS
SELECT
    CAST(LocationID AS INT) AS location_id,  
    Zone AS zone,
    service_zone
FROM read_files(
    '/Volumes/nyc_taxi/bronze/raw_files/taxi_zone_lookup.csv',
    format => 'csv',
    header => true
);