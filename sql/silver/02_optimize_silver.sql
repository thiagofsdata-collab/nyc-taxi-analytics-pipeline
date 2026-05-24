-- =============================================================
-- Phase 2 | Silver Layer | Performance optimization
--
-- Compacts small files (OPTIMIZE) and physically clusters data
-- by the columns most used in filters and joins (ZORDER), so the
-- query engine can skip irrelevant data blocks (data skipping).
--
-- Run this after large writes (e.g. after loading all 12 months).
-- =============================================================
OPTIMIZE nyc_taxi.silver.yellow_trips
ZORDER BY (pickup_borough, hour_of_day);