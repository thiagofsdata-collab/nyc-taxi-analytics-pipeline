# Data Quality Findings

## Bronze Layer (2023-01 sample)

Raw rows: 3,066,766
Distinct vendors: 2

## Silver Layer cleaning rules

| Rule | Reason | Rows flagged |
|------|--------|--------------|
| Keep only year 2023 | Corrupted dates found (e.g. 2008) | 38 |
| fare_amount >= 0 | Negative fares are system errors | 25,049 |
| trip_distance > 0 | Zero/negative distance is invalid | 45,862 |
| dropoff > pickup | Dropoff cannot precede pickup | 1,121 |
| duration <= 24h | A taxi trip should not exceed one day | included above |

Note: categories overlap, so the sum is not exact.

## Null handling

| Field | Decision | Reason |
|-------|----------|--------|
| passenger_count | Fill nulls with 1 | If a trip generated revenue, at least one passenger existed. The project analyzes revenue, not car occupancy. |

## Cleaning impact

| Layer | Rows |
|-------|------|
| Bronze | 3,066,766 |
| Silver | 2,998,744 |
| Removed | 68,022 (2.2%) |

## Zone join validation

LEFT JOIN with taxi_zones covered 100% of trips.
Null boroughs after join: 0 (pickup and dropoff).