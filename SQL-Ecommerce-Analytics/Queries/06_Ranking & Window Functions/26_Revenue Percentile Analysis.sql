WITH customer_revenue AS (
  SELECT
    user_id,
    ROUND(SUM(sale_price), 2) AS total_revenue
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE
    status NOT IN ('Cancelled', 'Returned')
  GROUP BY user_id
)
SELECT
  user_id,
  total_revenue,
  ROUND(PERCENT_RANK() OVER (ORDER BY total_revenue) * 100, 2) AS percentile_rank,
  NTILE(100) OVER (ORDER BY total_revenue) AS percentile_bucket
FROM
  customer_revenue
ORDER BY
  total_revenue DESC
LIMIT 50;