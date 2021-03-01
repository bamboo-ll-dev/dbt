SELECT 
    id
    , email
    , created_at
    , updated_at
    , number
    , shop_order_reference
    , note
    , gateway
    , payment_gateway_names
    , test, total_price
    , subtotal_price
    , total_tax
    , tax_rate
    , financial_status
    , fulfillment_status
    , confirmed
    , total_discounts
    , total_line_items_price
    , cancelled_at
    , cancel_reason
    , discount_codes__amount
    , discount_codes
    , discount_value
    , discount_codes__type
    , source_name
    , tags
    , checkout_id
    , user_id
    , total_shipping_price_set__presentment_money__amount AS shippment_amount
    , filfillment_updated_at, status, 'DE' AS source  
FROM {{ ref('stg_unique_orders_de') }}
UNION ALL
SELECT 
    id
    , email
    , created_at
    , updated_at
    , number
    , shop_order_reference
    , note
    , gateway
    , payment_gateway_names
    , test, total_price
    , subtotal_price
    , total_tax
    , tax_rate
    , financial_status
    , fulfillment_status
    , confirmed
    , total_discounts
    , total_line_items_price
    , cancelled_at
    , cancel_reason
    , discount_codes__amount
    , discount_codes
    , discount_value
    , discount_codes__type
    , source_name
    , tags
    , checkout_id
    , user_id
    , total_shipping_price_set__presentment_money__amount AS shippment_amount
    , filfillment_updated_at, status, 'FR' AS source  
FROM {{ ref('stg_unique_orders_fr') }}
UNION ALL
SELECT 
    id
    , email
    , created_at
    , updated_at
    , number
    , shop_order_reference
    , note
    , gateway
    , payment_gateway_names
    , test, total_price
    , subtotal_price
    , total_tax
    , tax_rate
    , financial_status
    , fulfillment_status
    , confirmed
    , total_discounts
    , total_line_items_price
    , cancelled_at
    , cancel_reason
    , discount_codes__amount
    , discount_codes
    , discount_value
    , discount_codes__type
    , source_name
    , tags
    , checkout_id
    , user_id
    , total_shipping_price_set__presentment_money__amount AS shippment_amount
    , filfillment_updated_at, status, 'IT' AS source  
FROM {{ ref('stg_unique_orders_it') }} 