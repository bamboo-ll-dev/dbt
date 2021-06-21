WITH line_items AS(
SELECT row_number() OVER (PARTITION BY li.value.id, li.value.sku ORDER BY updated_at DESC) AS row_number, 
  li, 
  id,
  o.created_at,
  o.note,
  o.number,
  o.order_number,
  o.name,
  
  SAFE_CAST(dall.value.amount_set.shop_money.amount AS NUMERIC) AS item_discount,
  
  dapp.value.value_type AS coupon_value_type,	
  dapp.value.target_type AS coupon_target_type,	 
  dapp.value.type AS coupon_type,
  dapp.value.value AS coupon_value,	
  dapp.value.code AS coupon_code
  
 FROM  `leslunes-raw.shopify_de.orders` o,  
 UNNEST(line_items) AS li,
 UNNEST(discount_applications) AS dapp,
 UNNEST(li.value.discount_allocations) AS dall
)


SELECT 
  id AS shopify_order_id,
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
  
  coupon_value_type,	
  coupon_target_type,	
  coupon_type,
  coupon_value,	
  coupon_code,

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

FROM line_items,
UNNEST(li.value.tax_lines) AS tx
WHERE row_number = 1
ORDER BY id