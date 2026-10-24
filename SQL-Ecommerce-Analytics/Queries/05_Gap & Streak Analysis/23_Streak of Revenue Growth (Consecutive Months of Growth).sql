WITH monthly AS (
  SELECT
    FORMAT_TIMESTAMP('%Y-%m', created_at) AS month,
    ROUND(SUM(sale_price), 2)             AS revenue
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE
    status NOT IN ('Cancelled', 'Returned')
  GROUP BY 1
),

with_growth AS (
  SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_revenue,
    CASE
      WHEN revenue > LAG(revenue) OVER (ORDER BY month) THEN 1
      ELSE 0
    END AS is_growth
  FROM monthly
),

with_groups AS (
  SELECT
    *,
    SUM(CASE WHEN is_growth = 0 THEN 1 ELSE 0 END) OVER (ORDER BY month) AS streak_group
  FROM with_growth
)

SELECT
  streak_group,
  MIN(month) AS streak_start,
  MAX(month) AS streak_end,
  COUNT(*)   AS consecutive_growth_months
FROM
  with_groups
WHERE
  is_growth = 1
GROUP BY
  streak_group
ORDER BY
  consecutive_growth_months DESC;