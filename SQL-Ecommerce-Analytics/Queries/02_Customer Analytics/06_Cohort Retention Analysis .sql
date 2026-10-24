-- Step 1: Find each user's first purchase month (cohort)
-- Step 2: Calculate months since first purchase
-- Step 3: Count retained users per cohort per period

WITH user_first_purchase AS (
  SELECT
    user_id,
    DATE_TRUNC(MIN(DATE(created_at)), MONTH) AS cohort_month
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE
    status NOT IN ('Cancelled', 'Returned')
  GROUP BY
    user_id
),

user_activity AS (
  SELECT
    oi.user_id,
    DATE_TRUNC(DATE(oi.created_at), MONTH) AS activity_month
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items` oi
  WHERE
    oi.status NOT IN ('Cancelled', 'Returned')
  GROUP BY
    1, 2
),

cohort_data AS (
  SELECT
    uf.cohort_month,
    ua.activity_month,
    DATE_DIFF(ua.activity_month, uf.cohort_month, MONTH) AS month_number,
    COUNT(DISTINCT ua.user_id) AS active_users
  FROM
    user_activity ua
  JOIN
    user_first_purchase uf
    ON ua.user_id = uf.user_id
  GROUP BY
    1, 2, 3
),

cohort_size AS (
  SELECT
    cohort_month,
    active_users AS cohort_users
  FROM
    cohort_data
  WHERE
    month_number = 0
)

SELECT
  cd.cohort_month,
  cs.cohort_users,
  cd.month_number,
  cd.active_users,
  ROUND(cd.active_users / cs.cohort_users * 100, 2) AS retention_pct
FROM
  cohort_data cd
JOIN
  cohort_size cs
  ON cd.cohort_month = cs.cohort_month
WHERE
  cd.month_number <= 12
ORDER BY
  cd.cohort_month, cd.month_number;