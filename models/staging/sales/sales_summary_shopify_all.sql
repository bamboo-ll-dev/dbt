SELECT 
    SAFE_CAST(day AS DATE) as day 
    ,SAFE_CAST(orders as INT64) AS orders
    ,SAFE_CAST(gross_sales AS FLOAT64) AS	gross_sales
    ,SAFE_CAST(discounts AS FLOAT64) AS discounts
    ,SAFE_CAST(net_sales	AS FLOAT64) AS net_sales
    ,SAFE_CAST(shipping	AS FLOAT64) AS shipping
    ,SAFE_CAST(taxes AS FLOAT64) AS taxes
    ,SAFE_CAST(total_sales as FLOAT64) AS total_sales
    ,SAFE_CAST(ordered_item_quantity	AS INT64) AS ordered_item_quantity
,"FR" as source
FROM `leslunes-raw.shopify_fr.sales_summary`
UNION ALL 
SELECT 
    SAFE_CAST(day AS DATE) as day 
    ,SAFE_CAST(orders as INT64) AS orders
    ,SAFE_CAST(gross_sales AS FLOAT64) AS	gross_sales
    ,SAFE_CAST(discounts AS FLOAT64) AS discounts
    ,SAFE_CAST(net_sales	AS FLOAT64) AS net_sales
    ,SAFE_CAST(shipping	AS FLOAT64) AS shipping
    ,SAFE_CAST(taxes AS FLOAT64) AS taxes
    ,SAFE_CAST(total_sales as FLOAT64) AS total_sales
    ,SAFE_CAST(ordered_item_quantity	AS INT64) AS ordered_item_quantity
    ,"DE" as source
FROM `leslunes-raw.shopify_de.sales_summary`
UNION ALL 
SELECT 
    SAFE_CAST(day AS DATE) as day 
    ,SAFE_CAST(orders as INT64) AS orders
    ,SAFE_CAST(gross_sales AS FLOAT64) AS	gross_sales
    ,SAFE_CAST(discounts AS FLOAT64) AS discounts
    ,SAFE_CAST(net_sales	AS FLOAT64) AS net_sales
    ,SAFE_CAST(shipping	AS FLOAT64) AS shipping
    ,SAFE_CAST(taxes AS FLOAT64) AS taxes
    ,SAFE_CAST(total_sales as FLOAT64) AS total_sales
    ,SAFE_CAST(ordered_item_quantity	AS INT64) AS ordered_item_quantity
    ,"IT" as source
FROM `leslunes-raw.shopify_it.sales_summary`
ORDER BY DAY DESC