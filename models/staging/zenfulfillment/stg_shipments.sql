{{ config(materialized='table')}}

WITH CTE AS (
### DE
SELECT 
  *
FROM {{ref('stg_shipments_de')}} 

UNION ALL
### XENTRAL
SELECT 
   *
FROM {{ref('stg_shipments_xentral')}}

### FR
UNION ALL
SELECT 
    *
FROM {{ref('stg_shipments_fr')}} 

### IT
UNION ALL
SELECT 
  *
FROM {{ref('stg_shipments_it')}} 
)

SELECT 
CASE 
  WHEN product_sku like "%-old-duplicate" THEN REPLACE(product_sku, "-old-duplicate","")
  WHEN product_sku like "%-duplicate" THEN REPLACE(product_sku, "-duplicate","") 
  WHEN product_sku like "%-old" THEN REPLACE(product_sku, "-old","") 
ELSE product_sku
END AS product_sku,
products_condition_note,	
shipping_address_country,
products_returned
#* EXCEPT(created_at, products_qty, shop)
,PARSE_DATE("%Y-%m-%d", SPLIT(created_at,"T")[SAFE_OFFSET(0)]) as ordered_at
,EXTRACT(MONTH FROM PARSE_DATE("%Y-%m-%d", SPLIT(created_at,"T")[SAFE_OFFSET(0)])) AS ordered_at_month
,EXTRACT(YEAR FROM PARSE_DATE("%Y-%m-%d", SPLIT(created_at,"T")[SAFE_OFFSET(0)])) AS ordered_at_year
,CASE
     WHEN product_sku like "0%" THEN SPLIT(product_sku, "-")[SAFE_OFFSET(2)]
     WHEN regexp_extract(product_sku, "^(\\w*)") = "W" THEN LEFT(product_sku,5)
     WHEN regexp_extract(product_sku, "^(\\w*)") like "INFLUENCERCARD_%" THEN "n/a" 
     ELSE regexp_extract(product_sku, "^(\\w*)") 
  END as style,
  CASE
    WHEN product_sku like "0%" THEN SPLIT(product_sku, "-")[SAFE_OFFSET(4)]
    WHEN regexp_extract(product_sku, "^(\\w*)") = "W" THEN regexp_extract(product_sku,"(\\w*\\/\\w*)$")
    WHEN regexp_extract(product_sku, "-([A-Z/0-9]*)-\\w\\/?\\w*$") = "EC" THEN "UNI"
    WHEN regexp_extract(product_sku, "^(\\w*)") like "INFLUENCERCARD_%" THEN "n/a" 
  ELSE regexp_extract(product_sku, "-([A-Z/0-9]*)-\\w\\/?\\w*$") END AS size,
  ### extract and transform color from skus like W-219-ALEN-07-01-100-101-260-100-XS/S where color is in the 3-digits next to size (at the end)
  CASE 
  WHEN product_sku like "0%" THEN SPLIT(product_sku, "-")[SAFE_OFFSET(3)]
  WHEN regexp_extract(product_sku, "^(\\w*)") = "W" THEN (
                          SELECT color 
                          from (SELECT "100" as code, "WH" as color
                                UNION ALL
                                SELECT "801" as code, "HG" as color
                                UNION ALL
                                SELECT "999" as code, "BK" as color) 
                                where code = regexp_extract(product_sku,"(\\d{3})-\\w*\\/\\w*$")
                          ) 
  WHEN regexp_extract(product_sku, "^(\\w*)") like "INFLUENCERCARD_%" THEN "n/a" 
  ELSE regexp_extract(product_sku, "(\\w*)$")
  END as color
  ,IFNULL(SAFE_CAST(products_qty AS INT64), 0) AS items_returned
  ,CASE
     WHEN product_sku like "0%" THEN SPLIT(product_sku, "-")[SAFE_OFFSET(0)] ELSE "" END AS category
  ,CASE
     WHEN product_sku like "0%" THEN SPLIT(product_sku, "-")[SAFE_OFFSET(1)] 
     WHEN REGEXP_CONTAINS(product_sku, r"^[[:upper:]].*(EC|ECR|BA|CO|MDR|OCO)") THEN SPLIT(product_sku,"-")[SAFE_OFFSET(1)]
     ELSE "" END AS material
  ,CASE
    WHEN LENGTH(products_condition_note) > 32 THEN 0
    WHEN SPLIT(products_condition_note, ".")[SAFE_OFFSET(0)] = "1" THEN 1
    WHEN REGEXP_CONTAINS(products_condition_note, r"(12)") = TRUE THEN 0
    WHEN REGEXP_CONTAINS(products_condition_note, r"(11)") = TRUE THEN 0
    WHEN REGEXP_EXTRACT(products_condition_note, r"([0-9]{1,1})") = "1" THEN 1
    WHEN REGEXP_EXTRACT(products_condition_note, r"^[0-9]{1}") = "1"  THEN 1
    ELSE 0
  END as one,
   CASE
    WHEN LENGTH(products_condition_note) > 32 THEN 0
    WHEN SPLIT(products_condition_note, ".")[SAFE_OFFSET(0)] = "2" THEN 1
    WHEN REGEXP_CONTAINS(products_condition_note, r"(12)") = TRUE THEN 0
    WHEN "2" in UNNEST(SPLIT(products_condition_note, ",")) THEN 1
    WHEN "2" in UNNEST(SPLIT(products_condition_note, "/")) THEN 1
    WHEN "2" in UNNEST(SPLIT(products_condition_note, ".")) THEN 1
     ELSE 0
   END as two, 
   CASE
    WHEN LENGTH(products_condition_note) > 32 THEN 0
    WHEN SPLIT(products_condition_note, ".")[SAFE_OFFSET(0)] = "3" THEN 1
    WHEN REGEXP_CONTAINS(products_condition_note, r"3") = TRUE THEN 1
     ELSE 0
   END as three,
      CASE
    WHEN LENGTH(products_condition_note) > 32 THEN 0
    WHEN SPLIT(products_condition_note, ".")[SAFE_OFFSET(0)] = "4" THEN 1
    WHEN REGEXP_CONTAINS(products_condition_note, r"4") = TRUE THEN 1
     ELSE 0
   END as four,
   CASE
    WHEN LENGTH(products_condition_note) > 32 THEN 0
    WHEN SPLIT(products_condition_note, ".")[SAFE_OFFSET(0)] = "5" THEN 1
    WHEN REGEXP_CONTAINS(products_condition_note, r"5") = TRUE THEN 1
     ELSE 0
   END as five,
   CASE
    WHEN LENGTH(products_condition_note) > 32 THEN 0
    WHEN "6" in UNNEST(SPLIT(products_condition_note, ",")) THEN 1
    WHEN SPLIT(products_condition_note, ".")[SAFE_OFFSET(0)] = "6" THEN 1
    WHEN REGEXP_CONTAINS(products_condition_note, r",?6,?") = TRUE THEN 1
     ELSE 0
   END as six,
      CASE
    WHEN LENGTH(products_condition_note) > 32 THEN 0
    WHEN SPLIT(products_condition_note, ".")[SAFE_OFFSET(0)] = "7" THEN 1
    WHEN REGEXP_CONTAINS(products_condition_note, r"7") = TRUE THEN 1
     ELSE 0
   END as seven,
      CASE
    WHEN LENGTH(products_condition_note) > 32 THEN 0
    WHEN SPLIT(products_condition_note, ".")[SAFE_OFFSET(0)] = "8" THEN 1
    WHEN REGEXP_CONTAINS(products_condition_note, r"8") = TRUE THEN 1
     ELSE 0
   END as eight,
      CASE
    WHEN LENGTH(products_condition_note) > 32 THEN 0
    WHEN SPLIT(products_condition_note, ".")[SAFE_OFFSET(0)] = "9" THEN 1
    WHEN REGEXP_CONTAINS(products_condition_note, r"9") = TRUE THEN 1
     ELSE 0
   END as nine,
      CASE
    WHEN LENGTH(products_condition_note) > 32 THEN 0
    WHEN SPLIT(products_condition_note, ".")[SAFE_OFFSET(0)] = "10" THEN 1
    WHEN REGEXP_CONTAINS(products_condition_note, r"10") = TRUE THEN 1
    ELSE 0
   END as ten,
   CASE
    WHEN LENGTH(products_condition_note) > 32 THEN 0
    WHEN SPLIT(products_condition_note, ".")[SAFE_OFFSET(0)] = "11" THEN 1
    WHEN REGEXP_CONTAINS(products_condition_note, r"11") = TRUE THEN 1
     ELSE 0
   END as eleven,
      CASE
    WHEN products_returned = "yes" AND LENGTH(products_condition_note) > 32 THEN 1
    WHEN products_returned = "yes" AND SPLIT(products_condition_note, ".")[SAFE_OFFSET(0)] = "12" THEN 1
    WHEN products_returned = "yes" AND REGEXP_CONTAINS(products_condition_note, r"[^0-9.,/+]") = TRUE THEN 1
    WHEN products_returned = "yes" AND REGEXP_CONTAINS(products_condition_note, r"12") = TRUE THEN 1
     ELSE 0
   END as twelve,
   CASE
      WHEN REGEXP_CONTAINS(shop, r"IT") THEN "IT" 
      WHEN REGEXP_CONTAINS(shop, r"CS") THEN "CS"
      WHEN REGEXP_CONTAINS(shop, r"FR") THEN "FR"
      WHEN REGEXP_CONTAINS(shop, r"^#\d*") THEN "DE"
      WHEN REGEXP_CONTAINS(shop, r"^\d*") THEN "DE"
      ELSE shop
    END AS shop
FROM CTE
WHERE product_sku IS NOT NULL 