WITH orders AS(
SELECT row_number() OVER (PARTITION BY o.id ORDER BY updated_at DESC) AS row_number,
o.id AS transaction_id,
user_id AS user_id,
customer.id AS customer_id,
o.checkout_id AS checkout_id,
created_at,
order_number,
name AS shop_order_reference,
number,
note,
currency,
ROUND(total_price + total_discounts - SAFE_CAST(total_shipping_price_set.shop_money.amount AS FLOAT64),2) AS subtotal,
total_price,
total_discounts,
tl.value.price AS tax_amount,	
total_shipping_price_set.shop_money.amount AS shipping_costs,
tl.value.rate AS tax_rate,
tl.value.title As tax_title,
dc.value.value_type AS discount_type,
dc.value.value as discount_value,
dc.value.code,
anythin_else_but_gift_card.gift_card,
test,
customer_locale,	
processing_method,
tags,
f.value.created_at AS fulfilled_at_shopify,
cancelled_at,
updated_at,
processed_at,
closed_at,
token,
checkout_token
FROM {{source('shopify_de', 'orders')}} o
LEFT JOIN UNNEST(fulfillments) f
LEFT JOIN UNNEST(refunds) r
LEFT JOIN UNNEST(discount_applications) dc
LEFT JOIN UNNEST(tax_lines) tl
LEFT JOIN UNNEST(line_items) li
LEFT JOIN(
SELECT 
  id, CASE WHEN li.value.gift_card = false THEN false END as gift_card
FROM  {{source('shopify_de', 'orders')}} o
LEFT JOIN UNNEST(line_items) li
WHERE  CASE WHEN li.value.gift_card = False THEN False END is not null
GROUP BY id, gift_card
) AS anythin_else_but_gift_card ON anythin_else_but_gift_card.id = o.id
)

SELECT * EXCEPT(row_number)
FROM ORDERS
WHERE row_number = 1
AND test = false
--AND gift_card = false
ORDER BY number ASC
