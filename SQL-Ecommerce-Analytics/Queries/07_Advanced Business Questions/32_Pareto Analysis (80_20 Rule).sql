-- Are 20% of products driving 80% of revenue?
WITH product_revenue AS (
  SELECT
    p.id AS product_id,
    p.name,
    ROUND(SUM(oi.sale_price), 2) AS revenue
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items` oi
  JOIN
    `bigquery-public-data.thelook_ecommerce.products` p
    ON oi.product_id = p.id
  WHERE
    oi.status NOT IN ('Cancelled', 'Returned')
  GROUP BY 1, 2
),

ranked AS (
  SELECT
    *,
    ROW_NUMBER() OVER (ORDER BY revenue DESC) AS product_rank,
    COUNT(*) OVER () AS total_products,
    SUM(revenue) OVER () AS total_revenue,
    SUM(revenue) OVER (ORDER BY revenue DESC) AS cumulative_revenue
  FROM product_revenue
)

SELECT
  product_rank,
  name,
  revenue,
  ROUND(cumulative_revenue / total_revenue * 100, 2) AS cumulative_revenue_pct,
  ROUND(product_rank * 100.0 / total_products, 2) AS cumulative_product_pct,
  CASE
    WHEN cumulative_revenue / total_revenue <= 0.8 THEN 'Top 80% Revenue'
    ELSE 'Bottom 20% Revenue'
  END AS pareto_class
FROM ranked
ORDER BY product_rank
LIMIT 50;