SELECT
  u.country,
  u.state,
  COUNT(DISTINCT oi.order_id)    AS total_orders,
  COUNT(DISTINCT oi.user_id)     AS unique_customers,
  ROUND(SUM(oi.sale_price), 2)   AS total_revenue,
  ROUND(AVG(oi.sale_price), 2)   AS avg_order_value,
  ROUND(
    SUM(oi.sale_price) / NULLIF(COUNT(DISTINCT oi.user_id), 0), 2
  ) AS revenue_per_customer,
  -- Return rate per region
  ROUND(
    COUNT(DISTINCT CASE WHEN oi.status = 'Returned' THEN oi.order_id END) * 100.0
    / NULLIF(COUNT(DISTINCT oi.order_id), 0), 2
  ) AS return_rate_pct
FROM
  `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN
  `bigquery-public-data.thelook_ecommerce.users` u
  ON oi.user_id = u.id
GROUP BY
  1, 2
HAVING
  total_orders >= 50
ORDER BY
  total_revenue DESC
LIMIT 30;