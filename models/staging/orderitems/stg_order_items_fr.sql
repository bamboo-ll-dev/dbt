WITH line_items AS(
SELECT row_number() OVER (PARTITION BY li.value.id, li.value.sku ORDER BY updated_at DESC) AS row_number, 
  li, 
  id,
  o.created_at,
  o.updated_at,
  o.note,
  o.number,
  o.order_number,
  o.name,
  
  SAFE_CAST(dall.value.amount_set.shop_money.amount AS NUMERIC) AS item_discount,
  discount_applications
  
 FROM  `leslunes-raw.shopify_fr.orders` o,  
 UNNEST(line_items) AS li,

 UNNEST(li.value.discount_allocations) AS dall
),

special_codes AS(
/*
* freegifts are implemented by script in shopify
*/
SELECT distinct
  id,
  dapp.value.value_type,	
  dapp.value.target_type,	
  dapp.value.description,	
  dapp.value.target_selection,	
  dapp.value.title,	
  dapp.value.type,	
  dapp.value.value,
  li.value.id AS line_item_id
FROM  `leslunes-raw.shopify_de.orders` o  
CROSS JOIN UNNEST(line_items) AS li 
CROSS JOIN UNNEST(o.discount_applications) as dapp, UNNEST(li.value.properties) livp
WHERE dapp.value.type = "script" AND livp.value.name	= "ll_fg" AND livp.value.value	= "true"
)

SELECT 
  i.id AS shopify_order_id,
  DATE(created_at) AS created_at_utc,
  
  li.value.sku AS shopify_sku,
  li.value.title AS shopify_product_title,
  li.value.variant_title AS shopify_variant_title ,	
  li.value.name AS shopify_product_name,
  li.value.price AS item_price_original,
  li.value.quantity AS ordered_quantity,

  item_discount,
  tx.value.rate AS tax_rate,
  tx.value.price AS tax_amount,
  tx.value.title AS tax_type,

  dapp.value.value_type AS coupon_value_type,	
  dapp.value.target_type AS coupon_target_type,	 
  dapp.value.type AS coupon_type,
  dapp.value.value AS coupon_value,	
  dapp.value.code AS coupon_code,
  
  /* freegifts */
  sc.value_type AS freegift_type,
  sc.target_type AS freegift_target_type,
  sc.description AS freegift_description,
  sc.target_selection AS freegift_selection,
  sc.type AS freegift_mode,
  sc.value AS freegift_value,

  li.value.total_discount_set.shop_money.currency_code,
  li.value.taxable,
  li.value.gift_card,
  li.value.requires_shipping,
  li.value.vendor,

  note,
  number,
  order_number,
  name AS shopify_order_identifier,
  li.value.id AS line_item_id,
  li.value.product_id AS shopify_product_id,
  li.value.variant_id AS shopify_variant_id

FROM line_items i,
UNNEST(li.value.tax_lines) AS tx,
UNNEST(discount_applications) AS dapp
# add freegift in separate processing step
LEFT JOIN special_codes sc ON  sc.line_item_id = li.value.id

WHERE i.row_number = 1 
# erase freegift from initial dataset
AND dapp.value.type != "script"
ORDER BY i.id