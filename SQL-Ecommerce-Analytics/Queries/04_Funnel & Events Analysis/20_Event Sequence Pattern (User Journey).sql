-- Find the most common 3-step event sequences
WITH event_sequence AS (
  SELECT
    user_id,
    session_id,
    event_type,
    LEAD(event_type, 1) OVER (PARTITION BY session_id ORDER BY created_at) AS step_2,
    LEAD(event_type, 2) OVER (PARTITION BY session_id ORDER BY created_at) AS step_3
  FROM
    `bigquery-public-data.thelook_ecommerce.events`
)
SELECT
  event_type AS step_1,
  step_2,
  step_3,
  COUNT(*) AS frequency
FROM
  event_sequence
WHERE
  step_2 IS NOT NULL
  AND step_3 IS NOT NULL
GROUP BY
  1, 2, 3
ORDER BY
  frequency DESC
LIMIT 20;