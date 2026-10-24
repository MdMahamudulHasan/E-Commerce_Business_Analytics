WITH first_touch AS (
  SELECT
    user_id,
    traffic_source,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at ASC) AS rn
  FROM
    `bigquery-public-data.thelook_ecommerce.events`
)
SELECT
  ft.traffic_source                    AS first_touch_source,
  COUNT(DISTINCT ft.user_id)           AS total_users,
  COUNT(DISTINCT oi.user_id)           AS converted_users,
  ROUND(SUM(oi.sale_price), 2)         AS attributed_revenue,
  ROUND(
    COUNT(DISTINCT oi.user_id) * 100.0
    / NULLIF(COUNT(DISTINCT ft.user_id), 0), 2
  ) AS conversion_rate_pct
FROM
  first_touch ft
LEFT JOIN
  `bigquery-public-data.thelook_ecommerce.order_items` oi
  ON ft.user_id = oi.user_id
  AND oi.status NOT IN ('Cancelled', 'Returned')
WHERE
  ft.rn = 1
GROUP BY
  1
ORDER BY
  attributed_revenue DESC;