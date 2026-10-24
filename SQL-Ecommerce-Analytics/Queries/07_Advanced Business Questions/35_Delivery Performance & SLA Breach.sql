WITH delivery_data AS (
  SELECT
    order_id,
    user_id,
    status,
    created_at,
    shipped_at,
    delivered_at,
    TIMESTAMP_DIFF(shipped_at, created_at, HOUR)    AS hours_to_ship,
    TIMESTAMP_DIFF(delivered_at, shipped_at, HOUR)   AS hours_in_transit,
    TIMESTAMP_DIFF(delivered_at, created_at, HOUR)   AS total_delivery_hours
  FROM
    `bigquery-public-data.thelook_ecommerce.orders`
  WHERE
    status = 'Complete'
    AND shipped_at IS NOT NULL
    AND delivered_at IS NOT NULL
)
SELECT
  CASE
    WHEN total_delivery_hours <= 48   THEN '1_Within_2_Days'
    WHEN total_delivery_hours <= 120  THEN '2_3_to_5_Days'
    WHEN total_delivery_hours <= 240  THEN '3_5_to_10_Days'
    ELSE '4_Over_10_Days'
  END AS delivery_bucket,
  COUNT(*)                                  AS order_count,
  ROUND(AVG(hours_to_ship / 24.0), 1)      AS avg_days_to_ship,
  ROUND(AVG(hours_in_transit / 24.0), 1)   AS avg_days_in_transit,
  ROUND(AVG(total_delivery_hours / 24.0), 1) AS avg_total_days,
  ROUND(
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2
  ) AS pct_of_orders,
  -- SLA Breach: > 7 days
  SUM(CASE WHEN total_delivery_hours > 168 THEN 1 ELSE 0 END) AS sla_breach_count
FROM
  delivery_data
GROUP BY
  1
ORDER BY
  1;