WITH orders_with_prev AS (
  SELECT
    user_id,
    order_id,
    DATE(created_at) AS order_date,
    LAG(DATE(created_at)) OVER (
      PARTITION BY user_id ORDER BY created_at
    ) AS prev_order_date
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE
    status NOT IN ('Cancelled', 'Returned')
)
SELECT
  user_id,
  order_id,
  order_date,
  prev_order_date,
  DATE_DIFF(order_date, prev_order_date, DAY) AS days_between_orders
FROM
  orders_with_prev
WHERE
  prev_order_date IS NOT NULL
ORDER BY
  days_between_orders DESC
LIMIT 50;