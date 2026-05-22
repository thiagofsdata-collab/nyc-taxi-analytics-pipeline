# Data Quality Findings

## Bronze Layer (2023-01 sample)

| Issue | Detail | Action |
|-------|--------|--------|
| Corrupted pickup dates | Records dated 2008-12-31 found in the 2023-01 file | Filter in Silver: keep only year 2023 |
| Month spillover | A few records dated 2023-02-01 leaked into the January file | Filter in Silver by pickup month/year |

Total raw rows (2023-01): 3,066,766
Distinct vendors: 2