WITH rfm_base AS (
  SELECT
    user_id,
    DATE_DIFF(
      CURRENT_DATE(),
      DATE(MAX(created_at)),
      DAY
    )                                    AS recency,
    COUNT(DISTINCT order_id)             AS frequency,
    ROUND(SUM(sale_price), 2)            AS monetary
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE
    status NOT IN ('Cancelled', 'Returned')
  GROUP BY
    user_id
),

rfm_scores AS (
  SELECT
    *,
    NTILE(5) OVER (ORDER BY recency DESC)  AS r_score,   -- lower recency = better
    NTILE(5) OVER (ORDER BY frequency ASC)  AS f_score,
    NTILE(5) OVER (ORDER BY monetary ASC)   AS m_score
  FROM
    rfm_base
)

SELECT
  *,
  (r_score + f_score + m_score) AS rfm_total,
  CASE
    WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champion'
    WHEN r_score >= 4 AND f_score >= 3                   THEN 'Loyal Customer'
    WHEN r_score >= 4 AND f_score <= 2                   THEN 'New Customer'
    WHEN r_score <= 2 AND f_score >= 3                   THEN 'At Risk'
    WHEN r_score <= 2 AND f_score <= 2                   THEN 'Lost'
    ELSE 'Other'
  END AS customer_segment
FROM
  rfm_scores
ORDER BY
  rfm_total DESC;