SELECT
  status,
  COUNT(*) AS order_count
FROM
  `bigquery-public-data.thelook_ecommerce.orders`
GROUP BY
  status
ORDER BY
  order_count DESC;