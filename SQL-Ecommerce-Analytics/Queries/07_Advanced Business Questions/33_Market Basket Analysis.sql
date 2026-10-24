-- Support & Confidence for category-level associations
WITH order_categories AS (
  SELECT DISTINCT
    oi.order_id,
    p.category
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items` oi
  JOIN
    `bigquery-public-data.thelook_ecommerce.products` p
    ON oi.product_id = p.id
  WHERE
    oi.status NOT IN ('Cancelled', 'Returned')
),

total_orders AS (
  SELECT COUNT(DISTINCT order_id) AS total FROM order_categories
),

pairs AS (
  SELECT
    a.category AS category_a,
    b.category AS category_b,
    COUNT(DISTINCT a.order_id) AS pair_count
  FROM
    order_categories a
  JOIN
    order_categories b
    ON a.order_id = b.order_id
    AND a.category < b.category
  GROUP BY 1, 2
),

single_counts AS (
  SELECT
    category,
    COUNT(DISTINCT order_id) AS cat_count
  FROM order_categories
  GROUP BY 1
)

SELECT
  p.category_a,
  p.category_b,
  p.pair_count,
  ROUND(p.pair_count * 100.0 / t.total, 2) AS support_pct,
  ROUND(p.pair_count * 100.0 / sa.cat_count, 2) AS confidence_a_to_b_pct,
  ROUND(p.pair_count * 100.0 / sb.cat_count, 2) AS confidence_b_to_a_pct
FROM pairs p
CROSS JOIN total_orders t
JOIN single_counts sa ON p.category_a = sa.category
JOIN single_counts sb ON p.category_b = sb.category
WHERE p.pair_count >= 50
ORDER BY support_pct DESC
LIMIT 20;