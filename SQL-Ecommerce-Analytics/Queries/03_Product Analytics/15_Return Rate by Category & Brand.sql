SELECT
  p.category,
  p.brand,
  COUNT(DISTINCT oi.order_id) AS total_orders,
  COUNT(DISTINCT CASE WHEN oi.status = 'Returned' THEN oi.order_id END) AS returned_orders,
  ROUND(
    COUNT(DISTINCT CASE WHEN oi.status = 'Returned' THEN oi.order_id END) * 100.0
    / NULLIF(COUNT(DISTINCT oi.order_id), 0),
    2
  ) AS return_rate_pct
FROM
  `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN
  `bigquery-public-data.thelook_ecommerce.products` p
  ON oi.product_id = p.id
GROUP BY
  1, 2
HAVING
  total_orders >= 20
ORDER BY
  return_rate_pct DESC
LIMIT 30;