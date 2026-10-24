WITH funnel AS (
  SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'home'     THEN user_id END) AS home_visitors,
    COUNT(DISTINCT CASE WHEN event_type = 'department' THEN user_id END) AS dept_visitors,
    COUNT(DISTINCT CASE WHEN event_type = 'product'  THEN user_id END) AS product_viewers,
    COUNT(DISTINCT CASE WHEN event_type = 'cart'     THEN user_id END) AS cart_adders,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchasers
  FROM
    `bigquery-public-data.thelook_ecommerce.events`
)
SELECT
  home_visitors,
  dept_visitors,
  product_viewers,
  cart_adders,
  purchasers,
  ROUND(dept_visitors    * 100.0 / NULLIF(home_visitors, 0), 2) AS home_to_dept_pct,
  ROUND(product_viewers  * 100.0 / NULLIF(dept_visitors, 0), 2) AS dept_to_product_pct,
  ROUND(cart_adders      * 100.0 / NULLIF(product_viewers, 0), 2) AS product_to_cart_pct,
  ROUND(purchasers       * 100.0 / NULLIF(cart_adders, 0), 2)    AS cart_to_purchase_pct,
  ROUND(purchasers       * 100.0 / NULLIF(home_visitors, 0), 2)  AS overall_conversion_pct
FROM
  funnel;