# Key Findings (Full Year 2023)

## Scale
- Total trips ingested (Bronze): 38,310,226
- Clean trips (Silver): 37,192,018 (2.92% removed by quality rules)
- Total revenue 2023: ~$1.08 billion

## Airports dominate revenue
- JFK Airport is the single highest-earning pickup zone
- JFK + LaGuardia together drive a large share of total revenue
- Airport trips have high average ticket due to long distances

## Manhattan drives volume
- Manhattan accounts for the largest share of revenue, mostly by trip volume
- Average ticket in Manhattan is lower than airports

## Seasonality (month-over-month)
- Strongest growth: March (+20.76%) and October (+21.33%)
- Sharpest drop: July (-13.70%), summer vacation period
- August is the yearly low point for demand
- Average ticket stays stable (~$27-30) all year: variation is driven by volume, not price

## Best shift to operate
- Afternoon (12-18h) is the highest-revenue shift
- Overnight (0-6h) has the highest average ticket and longest trips

## Performance engineering
- Applied OPTIMIZE (file compaction) and ZORDER on Silver
- ZORDER on pickup_borough and hour_of_day enables data skipping
- Computed table statistics with ANALYZE for better query plans