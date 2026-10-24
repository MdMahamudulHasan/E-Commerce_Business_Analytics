WITH purchase_dates AS (
  SELECT
    user_id,
    DATE(created_at) AS purchase_date,
    LEAD(DATE(created_at)) OVER (
      PARTITION BY user_id ORDER BY created_at
    ) AS next_purchase_date
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE
    status NOT IN ('Cancelled', 'Returned')
)
SELECT
  user_id,
  purchase_date,
  next_purchase_date,
  DATE_DIFF(next_purchase_date, purchase_date, DAY) AS gap_days,
  CASE
    WHEN DATE_DIFF(next_purchase_date, purchase_date, DAY) > 90 THEN 'Inactive Gap'
    ELSE 'Normal'
  END AS gap_type
FROM
  purchase_dates
WHERE
  next_purchase_date IS NOT NULL
  AND DATE_DIFF(next_purchase_date, purchase_date, DAY) > 90
ORDER BY
  gap_days DESC
LIMIT 30;