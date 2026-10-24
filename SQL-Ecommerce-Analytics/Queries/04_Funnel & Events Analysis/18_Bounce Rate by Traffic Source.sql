WITH session_bounds AS (
  SELECT
    session_id,
    user_id,
    MIN(created_at) AS session_start,
    MAX(created_at) AS session_end,
    COUNT(*)        AS event_count,
    TIMESTAMP_DIFF(MAX(created_at), MIN(created_at), SECOND) AS duration_seconds
  FROM
    `bigquery-public-data.thelook_ecommerce.events`
  GROUP BY
    session_id, user_id
)
SELECT
  CASE
    WHEN duration_seconds = 0          THEN 'Single Event (Bounce)'
    WHEN duration_seconds < 60         THEN 'Under 1 min'
    WHEN duration_seconds < 300        THEN '1-5 min'
    WHEN duration_seconds < 900        THEN '5-15 min'
    ELSE '15+ min'
  END AS session_bucket,
  COUNT(*)                    AS session_count,
  ROUND(AVG(event_count), 1) AS avg_events,
  ROUND(AVG(duration_seconds / 60.0), 1) AS avg_duration_min
FROM
  session_bounds
GROUP BY
  1
ORDER BY
  session_count DESC;