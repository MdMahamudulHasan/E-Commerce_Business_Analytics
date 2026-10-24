WITH customer_stats AS (
  SELECT
    user_id,
    COUNT(DISTINCT order_id)                                  AS total_orders,
    ROUND(SUM(sale_price), 2)                                 AS total_spent,
    ROUND(AVG(sale_price), 2)                                 AS avg_order_value,
    MIN(DATE(created_at))                                     AS first_purchase,
    MAX(DATE(created_at))                                     AS last_purchase,
    DATE_DIFF(MAX(DATE(created_at)), MIN(DATE(created_at)), DAY) AS customer_lifespan_days
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE
    status NOT IN ('Cancelled', 'Returned')
  GROUP BY
    user_id
)
SELECT
  user_id,
  total_orders,
  total_spent,
  avg_order_value,
  customer_lifespan_days,
  -- Simple CLV = avg_order_value * purchase_frequency * lifespan_years
  ROUND(
    avg_order_value
    * (total_orders / GREATEST(customer_lifespan_days / 365.0, 0.01))
    * 2,  -- projected 2 years
    2
  ) AS projected_clv_2yr,
  NTILE(5) OVER (ORDER BY total_spent) AS clv_quintile
FROM
  customer_stats
WHERE
  total_orders >= 2
ORDER BY
  total_spent DESC
LIMIT 100;