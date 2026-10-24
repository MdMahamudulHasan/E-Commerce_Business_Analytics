WITH category_monthly AS (
  SELECT
    p.category,
    FORMAT_TIMESTAMP('%Y-%m', oi.created_at) AS month,
    ROUND(SUM(oi.sale_price), 2) AS revenue
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items` oi
  JOIN
    `bigquery-public-data.thelook_ecommerce.products` p
    ON oi.product_id = p.id
  WHERE
    oi.status NOT IN ('Cancelled', 'Returned')
  GROUP BY 1, 2
)
SELECT
  category,
  month,
  revenue,
  LAG(revenue, 1)  OVER (PARTITION BY category ORDER BY month) AS prev_month_rev,
  LEAD(revenue, 1) OVER (PARTITION BY category ORDER BY month) AS next_month_rev,
  ROUND(
    (revenue - LAG(revenue, 1) OVER (PARTITION BY category ORDER BY month))
    / NULLIF(LAG(revenue, 1) OVER (PARTITION BY category ORDER BY month), 0) * 100,
    2
  ) AS mom_change_pct
FROM
  category_monthly
ORDER BY
  category, month;