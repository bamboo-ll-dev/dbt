WITH line_items_sets AS(
  SELECT row_number() OVER (PARTITION BY li.value.id, li.value.sku ORDER BY updated_at DESC) AS row_number, 
  id,
  li,
  o.created_at,
  o.updated_at,
  o.note,
  o.number,
  o.order_number,
  o.name, 
  li.value.id AS line_item_id,
  li.value.price_set.shop_money.amount,
  "set_item" AS item_type,
  email, 
  tags,
  source_name
FROM  {{source('shopify_de', 'orders')}} o,  
UNNEST(line_items) AS li
WHERE test = False
),

line_items AS(
  SELECT 
    row_number() OVER (PARTITION BY li.value.id, li.value.sku ORDER BY updated_at DESC) AS row_number, 
    o.id, 
    li.value.sku, 
    note, 
    name, 
    created_at, 
    order_number,  
    li.value.title AS order_item,
    li.value.title AS item_title, 
    li.value.id AS line_item_id,
    li.value.price_set.shop_money.amount,
    CASE 
      WHEN 
        LOWER(li.value.title) LIKE '%set%' 
        OR LOWER(li.value.title) LIKE '%duo%' 
        OR LOWER(li.value.title) LIKE '%trio%' 
        OR LOWER(li.value.title) LIKE '%bundle%' 
       THEN 'set'
       ELSE "single_item" END AS item_type,
    email,
    tags,
    source_name
FROM {{source('shopify_de', 'orders')}} o,  
UNNEST(line_items) AS li
WHERE test = False
), tax AS (
 
 SELECT 
  distinct 
  id AS shopify_transaction_id ,tx.value.rate AS tax_rate, 
  FROM {{source('shopify_de', 'orders')}},
  UNNEST(line_items) AS li,
  UNNEST(li.value.tax_lines) AS tx
 
), shipping AS(
SELECT 
  distinct
  o.id AS shopify_transaction_id,
  sl.value.code AS shipping_method,
  shipping_address.country As shipping_country
FROM  
  {{source('shopify_de', 'orders')}} o,
  UNNEST(shipping_lines) AS sl
),freegift_codes AS(
/*
* freegifts are implemented by script in shopify
*/
SELECT distinct
  li.value.id AS line_item_id,
  dapp.value.title AS fg_title,
  dapp.value.value AS fg_value
FROM {{source('shopify_de', 'orders')}} o,
 UNNEST(line_items) AS li, 
 UNNEST(o.discount_applications) as dapp,
 UNNEST(li.value.properties) livp
WHERE dapp.value.type = "script" AND livp.value.name	= "ll_fg" AND livp.value.value	= "true"
),
coupon_codes AS(
  SELECT distinct
    o.id AS shopify_transaction_id,
    dapp.value.value_type AS code_value_type,
    dapp.value.type AS code_type,	
    dapp.value.value AS code_value,
    dapp.value.code AS code
  FROM  
    {{source('shopify_de', 'orders')}} o,
    UNNEST(o.discount_applications) AS dapp 
  WHERE dapp.value.type != "script"
),
final AS(
  SELECT 
   id AS shopify_transaction_id,
   email,
   created_at,
   
   note AS order_note, 
   name AS shop_order_ref,
   order_number, 
   
   li.value.title AS order_item, 
   p.value.name AS item_title,	
   p.value.value AS item_desc, 
   
   CASE WHEN REGEXP_CONTAINS(p.value.name, r"Set") THEN amount ELSE "0" END AS amount,
   
   line_item_id AS LID,
   item_type,
   tags,
   source_name
FROM line_items_sets i, unnest(li.value.properties) p

WHERE 
  row_number = 1
  AND p.value.name not in("ll_fg", "ll_hash","ll_min_total")
  
UNION ALL

SELECT 
 id AS shopify_transaction_id, 
 email ,
 created_at,
 
 note AS order_note, 
 name AS shop_order_ref,
 order_number, 
 
 CASE WHEN sku = "" THEN order_item ELSE sku END AS order_item, 
 order_item AS item_title,
 sku AS item_desc,
 
 amount,
 
 line_item_id as LID,
 item_type, 
 tags,
 source_name
FROM line_items li 
WHERE 
  row_number = 1
  AND order_item not in("ll_fg", "ll_hash","ll_min_total")
), first_purchase_date AS(

SELECT DISTINCT
  TO_BASE64(MD5(UPPER(email))) AS email_hash, created_at,
  MIN(created_At) OVER (PARTITION BY TO_BASE64(MD5(UPPER(email)))) AS first_purchase_date, 
FROM final
)

SELECT DISTINCT
  f.shopify_transaction_id,	
  TO_BASE64(MD5(UPPER(email))) AS email_hash,
  f.created_at AS bought_at_utc,	
  item_title,
    CASE 
    WHEN REGEXP_CONTAINS(item_desc, r"\(SKU: (.*?)\)") 
    THEN REGEXP_EXTRACT(item_desc, r"\(SKU: (.*?)\)") 
    ELSE item_desc END 
  AS sku,
  order_item,
  s.shipping_method,
  s.shipping_country,
  SAFE_CAST(amount AS FLOAT64) AS order_item_price,
  SAFE_CAST(tax_rate AS FLOAT64) AS tax_rate,
  IFNULL(SAFE_CAST(fg_value AS FLOAT64), 0) AS fg_value,
  code_value,
  code,
  code_value_type,
  fg_title,
  code_type,
  item_desc,
  item_type,
  tags,
  order_note,	
  CASE WHEN f.created_at = c.first_purchase_date THEN 1 ELSE 0 END AS new_customer,
  CASE WHEN f.created_at = c.first_purchase_date THEN 0 ELSE 1 END AS returning_customer,
  CASE WHEN source_name = "580111" THEN "web" ELSE source_name END AS source_name,
  shop_order_ref,
  order_number
FROM final f
LEFT JOIN freegift_codes sc ON  sc.line_item_id = LID
LEFT JOIN coupon_codes cc ON  cc.shopify_transaction_id  = f.shopify_transaction_id
LEFT JOIN tax t ON f.shopify_transaction_id = t.shopify_transaction_id
LEFT JOIN shipping s ON s.shopify_transaction_id = f.shopify_transaction_id

LEFT JOIN  first_purchase_date c ON c.email_hash = TO_BASE64(MD5(UPPER(f.email))) 

--ORDER BY shopify_transaction_id