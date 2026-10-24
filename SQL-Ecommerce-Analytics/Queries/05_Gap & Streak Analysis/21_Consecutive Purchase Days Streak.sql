-- Identify customers with the longest consecutive-day purchase streaks
WITH purchase_days AS (
  SELECT DISTINCT
    user_id,
    DATE(created_at) AS purchase_date
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE
    status NOT IN ('Cancelled', 'Returned')
),

with_gaps AS (
  SELECT
    user_id,
    purchase_date,
    purchase_date - INTERVAL (
      ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY purchase_date)
    ) DAY AS streak_group
  FROM
    purchase_days
),

streaks AS (
  SELECT
    user_id,
    streak_group,
    MIN(purchase_date) AS streak_start,
    MAX(purchase_date) AS streak_end,
    COUNT(*)           AS streak_length
  FROM
    with_gaps
  GROUP BY
    user_id, streak_group
)

SELECT
  user_id,
  streak_start,
  streak_end,
  streak_length
FROM
  streaks
WHERE
  streak_length >= 2
ORDER BY
  streak_length DESC
LIMIT 20;