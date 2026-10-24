WITH customer_orders AS (
  SELECT
    user_id,
    COUNT(DISTINCT order_id) AS order_count
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE
    status NOT IN ('Cancelled', 'Returned')
  GROUP BY
    user_id
)
SELECT
  CASE
    WHEN order_count = 1 THEN 'One-Time'
    WHEN order_count BETWEEN 2 AND 3 THEN 'Repeat (2-3)'
    WHEN order_count BETWEEN 4 AND 6 THEN 'Loyal (4-6)'
    ELSE 'VIP (7+)'
  END AS customer_type,
  COUNT(*)                           AS customer_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct
FROM
  customer_orders
GROUP BY
  1
ORDER BY
  customer_count DESC;