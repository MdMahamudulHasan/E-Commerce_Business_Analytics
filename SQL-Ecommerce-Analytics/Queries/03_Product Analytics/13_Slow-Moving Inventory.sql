SELECT
  ii.product_id,
  ii.product_name,
  ii.product_category,
  COUNT(*)                                                     AS inventory_count,
  SUM(CASE WHEN ii.sold_at IS NOT NULL THEN 1 ELSE 0 END)     AS sold_count,
  SUM(CASE WHEN ii.sold_at IS NULL THEN 1 ELSE 0 END)         AS unsold_count,
  ROUND(
    SUM(CASE WHEN ii.sold_at IS NULL THEN 1 ELSE 0 END) * 100.0
    / COUNT(*), 2
  ) AS unsold_pct,
  ROUND(AVG(
    CASE
      WHEN ii.sold_at IS NOT NULL
      THEN TIMESTAMP_DIFF(ii.sold_at, ii.created_at, DAY)
    END
  ), 1) AS avg_days_to_sell
FROM
  `bigquery-public-data.thelook_ecommerce.inventory_items` ii
GROUP BY
  1, 2, 3
HAVING
  inventory_count >= 10
ORDER BY
  unsold_pct DESC
LIMIT 30;