-- Rank brands by revenue, showing ties properly
SELECT
  p.brand,
  ROUND(SUM(oi.sale_price), 2) AS total_revenue,
  RANK()       OVER (ORDER BY SUM(oi.sale_price) DESC) AS rank_with_gaps,
  DENSE_RANK() OVER (ORDER BY SUM(oi.sale_price) DESC) AS rank_no_gaps,
  ROW_NUMBER() OVER (ORDER BY SUM(oi.sale_price) DESC) AS row_num
FROM
  `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN
  `bigquery-public-data.thelook_ecommerce.products` p
  ON oi.product_id = p.id
WHERE
  oi.status NOT IN ('Cancelled', 'Returned')
GROUP BY
  p.brand
ORDER BY
  total_revenue DESC
LIMIT 30;