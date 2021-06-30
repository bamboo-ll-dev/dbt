SELECT * FROM(
SELECT 
SAFE_CAST(day AS DATE) as day 
,variant_sku, variant_title, product_title
,SAFE_CAST(ordered_item_quantity	AS INT64) AS ordered_item_quantity
,"FR" as source
FROM `leslunes-raw.shopify_fr.orderitems`
UNION ALL 
SELECT 
SAFE_CAST(day AS DATE) as day 
,variant_sku, variant_title, product_title
,SAFE_CAST(ordered_item_quantity	AS INT64) AS ordered_item_quantity
,"DE" as source
FROM `leslunes-raw.shopify_de.orderitems`
UNION ALL 
SELECT 
SAFE_CAST(day AS DATE) as day 
,variant_sku, variant_title, product_title
,SAFE_CAST(ordered_item_quantity	AS INT64) AS ordered_item_quantity
,"IT" as source
FROM `leslunes-raw.shopify_it.orderitems`
)
WHERE SAFE_CAST(ordered_item_quantity	AS INT64) > 0
