WITH line_items AS(
#Line items
SELECT row_number() OVER (PARTITION BY li.value.id, li.value.sku ORDER BY updated_at DESC) AS row_number, 
  li, 
  id,
  o.created_at,
  o.note,
  o.number,
  o.order_number,
  o.name
  FROM  `leslunes-raw.shopify_de.orders` o,  
  UNNEST(line_items) AS li 
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

  SAFE_CAST(da.value.amount_set.shop_money.amount AS NUMERIC) AS item_discount,
  tx.value.rate AS tax_rate,
  tx.value.price AS tax_amount,
  tx.value.title AS tax_type,

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
UNNEST(li.value.tax_lines)As tx,
UNNEST(li.value.discount_allocations) AS da
WHERE row_number = 1
ORDER BY id

