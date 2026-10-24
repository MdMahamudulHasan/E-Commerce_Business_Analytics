WITH price_brackets AS (
  SELECT
    p.category,
    CASE
      WHEN p.retail_price < 20  THEN '01_Under_20'
      WHEN p.retail_price < 50  THEN '02_20_to_50'
      WHEN p.retail_price < 100 THEN '03_50_to_100'
      WHEN p.retail_price < 200 THEN '04_100_to_200'
      ELSE '05_200_plus'
    END AS price_bracket,
    oi.sale_price,
    oi.order_id
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items` oi
  JOIN
    `bigquery-public-data.thelook_ecommerce.products` p
    ON oi.product_id = p.id
  WHERE
    oi.status NOT IN ('Cancelled', 'Returned')
)
SELECT
  category,
  price_bracket,
  COUNT(*)                       AS units_sold,
  ROUND(AVG(sale_price), 2)      AS avg_price,
  ROUND(SUM(sale_price), 2)      AS total_revenue
FROM
  price_brackets
GROUP BY
  1, 2
ORDER BY
  category, price_bracket;