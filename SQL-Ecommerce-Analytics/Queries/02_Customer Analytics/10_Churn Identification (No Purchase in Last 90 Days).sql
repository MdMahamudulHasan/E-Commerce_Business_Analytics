WITH last_purchase AS (
  SELECT
    user_id,
    MAX(DATE(created_at))  AS last_purchase_date,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sale_price), 2) AS total_spent
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE
    status NOT IN ('Cancelled', 'Returned')
  GROUP BY
    user_id
)
SELECT
  user_id,
  last_purchase_date,
  DATE_DIFF(CURRENT_DATE(), last_purchase_date, DAY) AS days_since_last_purchase,
  total_orders,
  total_spent,
  CASE
    WHEN DATE_DIFF(CURRENT_DATE(), last_purchase_date, DAY) <= 30  THEN 'Active'
    WHEN DATE_DIFF(CURRENT_DATE(), last_purchase_date, DAY) <= 90  THEN 'Warm'
    WHEN DATE_DIFF(CURRENT_DATE(), last_purchase_date, DAY) <= 180 THEN 'Cold'
    ELSE 'Churned'
  END AS churn_status
FROM
  last_purchase
ORDER BY
  days_since_last_purchase DESC;