WITH daily_users AS (
  SELECT
    DATE(created_at) AS activity_date,
    COUNT(DISTINCT user_id) AS dau
  FROM
    `bigquery-public-data.thelook_ecommerce.events`
  GROUP BY 1
)
SELECT
  activity_date,
  dau,
  ROUND(AVG(dau) OVER (
    ORDER BY activity_date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ), 0) AS rolling_7d_avg_dau,
  SUM(dau) OVER (
    ORDER BY activity_date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ) AS rolling_7d_total_events
FROM
  daily_users
ORDER BY
  activity_date;