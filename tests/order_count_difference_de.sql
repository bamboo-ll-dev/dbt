with stitch_orders AS(
SELECT 
SAFE_CAST(DATE(created_at) AS STRING) AS ordered_at,
count(*) as order_count
FROM {{ ref('stg_unique_orders_de')}}
GROUP BY 1
ORDER BY 1 DESC)

, shopify_csv_orders AS(
SELECT 
day	AS ordered_at
,SAFE_CAST(orders AS INT64) AS orders
FROM {{source('shopify_de', 'sales_summary')}}
order by day desc
),

date_array AS (
SELECT
  FORMAT_DATE("%Y-%m-%d", date)  as ordered_at 
FROM UNNEST(GENERATE_DATE_ARRAY('2019-09-11', current_date(), INTERVAL 1 DAY)) AS date
ORDER BY date desc
)

SELECT 
date_array.ordered_at
,IFNULL(shopify_csv_orders.orders,0) AS shopify_csv_orders_count
,IFNULL(stitch_orders.order_count,0) AS stitch_orders_count
FROM date_array
LEFT JOIN shopify_csv_orders USING(ordered_at)
LEFT JOIN stitch_orders USING(ordered_at)
WHERE ((IFNULL(shopify_csv_orders.orders,0) - IFNULL(stitch_orders.order_count,0))) != 0
ORDER BY ordered_at DESC
