-- =============================================================
-- Phase 3 | Gold Layer | Zone revenue ranking
--
-- Ranks pickup zones by total revenue using window functions.
-- Provides both an overall rank and a rank within each borough,
-- answering: which zones are the top earners, overall and per
-- borough?
-- =============================================================
CREATE TABLE nyc_taxi.gold.gold_zone_ranking
USING DELTA
AS
WITH zone_revenue AS (
    -- Step 1: aggregate revenue and trips per zone
    SELECT
        pickup_borough,
        pickup_zone,
        COUNT(*) AS total_trips,
        ROUND(SUM(total_amount), 2) AS total_revenue
    FROM nyc_taxi.silver.yellow_trips
    GROUP BY pickup_borough, pickup_zone
)
SELECT
    pickup_borough,
    pickup_zone,
    total_trips,
    total_revenue,

    -- Overall rank across all zones by revenue (1 = highest)
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank_overall,

    -- Rank within each borough by revenue
    RANK() OVER (PARTITION BY pickup_borough ORDER BY total_revenue DESC) AS revenue_rank_in_borough,

    -- Each zone's share of total revenue (percentage)
    ROUND(
        100.0 * total_revenue / SUM(total_revenue) OVER (), 2
    ) AS revenue_share_pct
FROM zone_revenue;