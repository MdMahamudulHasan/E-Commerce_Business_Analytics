-- Top 3 revenue-generating products in each category
WITH product_revenue AS (
  SELECT
    p.category,
    p.name                              AS product_name,
    ROUND(SUM(oi.sale_price), 2)        AS revenue,
    COUNT(*)                            AS units_sold,
    ROW_NUMBER() OVER (
      PARTITION BY p.category
      ORDER BY SUM(oi.sale_price) DESC
    ) AS rank_in_category
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
SELECT *
FROM product_revenue
WHERE rank_in_category <= 3
ORDER BY category, rank_in_category;