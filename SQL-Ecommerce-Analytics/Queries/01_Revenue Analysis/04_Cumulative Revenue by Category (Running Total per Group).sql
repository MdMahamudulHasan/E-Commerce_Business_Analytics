WITH category_monthly AS (
  SELECT
    p.category,
    FORMAT_TIMESTAMP('%Y-%m', oi.created_at) AS month,
    ROUND(SUM(oi.sale_price), 2)             AS revenue
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items` oi
  JOIN
    `bigquery-public-data.thelook_ecommerce.products` p
    ON oi.product_id = p.id
  WHERE
    oi.status NOT IN ('Cancelled', 'Returned')
  GROUP BY
    1, 2
)
SELECT
  category,
  month,
  revenue,
  ROUND(
    SUM(revenue) OVER (PARTITION BY category ORDER BY month),
    2
  ) AS cumulative_revenue
FROM
  category_monthly
ORDER BY
  category, month;