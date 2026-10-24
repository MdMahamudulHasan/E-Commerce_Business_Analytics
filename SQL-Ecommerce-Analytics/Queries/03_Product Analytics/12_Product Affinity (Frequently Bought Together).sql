-- Products frequently purchased in the same order
WITH order_products AS (
  SELECT
    oi.order_id,
    p.name AS product_name,
    p.id   AS product_id
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items` oi
  JOIN
    `bigquery-public-data.thelook_ecommerce.products` p
    ON oi.product_id = p.id
  WHERE
    oi.status NOT IN ('Cancelled', 'Returned')
)
SELECT
  a.product_name AS product_a,
  b.product_name AS product_b,
  COUNT(*)       AS times_bought_together
FROM
  order_products a
JOIN
  order_products b
  ON  a.order_id = b.order_id
  AND a.product_id < b.product_id   -- avoid duplicates & self-join
GROUP BY
  1, 2
HAVING
  COUNT(*) >= 5
ORDER BY
  times_bought_together DESC
LIMIT 20;