WITH daily_revenue AS (
  SELECT
    DATE(created_at) AS order_date,
    ROUND(SUM(sale_price), 2) AS revenue
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE
    status NOT IN ('Cancelled', 'Returned')
  GROUP BY 1
)
SELECT
  order_date,
  revenue,
  ROUND(AVG(revenue) OVER (
    ORDER BY order_date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ), 2) AS moving_avg_7d,
  ROUND(AVG(revenue) OVER (
    ORDER BY order_date
    ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
  ), 2) AS moving_avg_30d
FROM
  daily_revenue
ORDER BY
  order_date;