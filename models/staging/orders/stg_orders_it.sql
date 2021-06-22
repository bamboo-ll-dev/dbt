WITH orders AS(
SELECT 
  /* deduplicate and get last entry */
  row_number() OVER (PARTITION BY o.id ORDER BY updated_at DESC) AS row_number,
  
  o.id AS transaction_id,
  DATE(created_at) AS order_created_at_utc,
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
  test,
  processing_method,
  gateway,
  tags,
  financial_status,
  fulfillment_status,
  f.value.created_at AS shopify_fulfilled_at,
  cancelled_at AS order_cancelled_at,
  updated_at AS order_updated_at,
  processed_at AS order_processed_at,
  closed_at AS order_closed_at,
  user_id AS user_id,
  customer.id AS customer_id,
  o.checkout_id AS checkout_id,
FROM {{source('shopify_it', 'orders')}} o
LEFT JOIN UNNEST(fulfillments) f
LEFT JOIN UNNEST(tax_lines) tl
)

SELECT * EXCEPT(row_number)
FROM ORDERS
WHERE row_number = 1
AND test = false
ORDER BY number ASC
