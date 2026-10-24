WITH yearly_monthly AS (
  SELECT
    EXTRACT(YEAR FROM created_at)  AS year,
    EXTRACT(MONTH FROM created_at) AS month,
    ROUND(SUM(sale_price), 2)      AS revenue
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE
    status NOT IN ('Cancelled', 'Returned')
  GROUP BY 1, 2
)
SELECT
  curr.month,
  curr.year                                        AS current_year,
  curr.revenue                                     AS current_revenue,
  prev.year                                        AS previous_year,
  prev.revenue                                     AS previous_revenue,
  ROUND(curr.revenue - prev.revenue, 2)            AS revenue_diff,
  ROUND(
    (curr.revenue - prev.revenue) / NULLIF(prev.revenue, 0) * 100, 2
  ) AS yoy_growth_pct
FROM
  yearly_monthly curr
LEFT JOIN
  yearly_monthly prev
  ON curr.month = prev.month
  AND curr.year = prev.year + 1
WHERE
  prev.revenue IS NOT NULL
ORDER BY
  curr.year, curr.month;