-- =============================================================
-- Phase 1 | Bronze Layer | Raw ingestion of all 2023 months
--
-- IMPORTANT: the 12 monthly files have inconsistent schemas
-- (e.g. column 'airport_fee' is capitalized as 'Airport_fee' in
-- some months). Reading them together with a wildcard misaligns
-- columns and produces null values. Each file is therefore read
-- individually with explicit columns and combined with UNION ALL,
-- which respects each file's own schema.
-- =============================================================
CREATE TABLE nyc_taxi.bronze.yellow_trips
USING DELTA
AS
SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, RatecodeID, store_and_fwd_flag, PULocationID, DOLocationID, payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge, total_amount, congestion_surcharge, airport_fee
FROM read_files('/Volumes/nyc_taxi/bronze/raw_files/yellow_tripdata_2023-01.parquet', format => 'parquet')
UNION ALL
SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, RatecodeID, store_and_fwd_flag, PULocationID, DOLocationID, payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge, total_amount, congestion_surcharge, airport_fee
FROM read_files('/Volumes/nyc_taxi/bronze/raw_files/yellow_tripdata_2023-02.parquet', format => 'parquet')
UNION ALL
SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, RatecodeID, store_and_fwd_flag, PULocationID, DOLocationID, payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge, total_amount, congestion_surcharge, airport_fee
FROM read_files('/Volumes/nyc_taxi/bronze/raw_files/yellow_tripdata_2023-03.parquet', format => 'parquet')
UNION ALL
SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, RatecodeID, store_and_fwd_flag, PULocationID, DOLocationID, payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge, total_amount, congestion_surcharge, airport_fee
FROM read_files('/Volumes/nyc_taxi/bronze/raw_files/yellow_tripdata_2023-04.parquet', format => 'parquet')
UNION ALL
SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, RatecodeID, store_and_fwd_flag, PULocationID, DOLocationID, payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge, total_amount, congestion_surcharge, airport_fee
FROM read_files('/Volumes/nyc_taxi/bronze/raw_files/yellow_tripdata_2023-05.parquet', format => 'parquet')
UNION ALL
SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, RatecodeID, store_and_fwd_flag, PULocationID, DOLocationID, payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge, total_amount, congestion_surcharge, airport_fee
FROM read_files('/Volumes/nyc_taxi/bronze/raw_files/yellow_tripdata_2023-06.parquet', format => 'parquet')
UNION ALL
SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, RatecodeID, store_and_fwd_flag, PULocationID, DOLocationID, payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge, total_amount, congestion_surcharge, airport_fee
FROM read_files('/Volumes/nyc_taxi/bronze/raw_files/yellow_tripdata_2023-07.parquet', format => 'parquet')
UNION ALL
SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, RatecodeID, store_and_fwd_flag, PULocationID, DOLocationID, payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge, total_amount, congestion_surcharge, airport_fee
FROM read_files('/Volumes/nyc_taxi/bronze/raw_files/yellow_tripdata_2023-08.parquet', format => 'parquet')
UNION ALL
SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, RatecodeID, store_and_fwd_flag, PULocationID, DOLocationID, payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge, total_amount, congestion_surcharge, airport_fee
FROM read_files('/Volumes/nyc_taxi/bronze/raw_files/yellow_tripdata_2023-09.parquet', format => 'parquet')
UNION ALL
SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, RatecodeID, store_and_fwd_flag, PULocationID, DOLocationID, payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge, total_amount, congestion_surcharge, airport_fee
FROM read_files('/Volumes/nyc_taxi/bronze/raw_files/yellow_tripdata_2023-10.parquet', format => 'parquet')
UNION ALL
SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, RatecodeID, store_and_fwd_flag, PULocationID, DOLocationID, payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge, total_amount, congestion_surcharge, airport_fee
FROM read_files('/Volumes/nyc_taxi/bronze/raw_files/yellow_tripdata_2023-11.parquet', format => 'parquet')
UNION ALL
SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, RatecodeID, store_and_fwd_flag, PULocationID, DOLocationID, payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge, total_amount, congestion_surcharge, airport_fee
FROM read_files('/Volumes/nyc_taxi/bronze/raw_files/yellow_tripdata_2023-12.parquet', format => 'parquet');