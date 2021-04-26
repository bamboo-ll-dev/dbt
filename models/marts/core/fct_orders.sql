SELECT
   transaction_id AS order_id
  ,number
  ,name AS shop_order_refrence
  ,regexp_extract(name, r"[0-9].*") AS ordernumber
  ,gateway
  ,total_price
  ,total_tax
  ,tax_rate
  ,financial_status
  ,fulfillment_status
  ,total_discounts
  ,discount_codes
  ,discount_value
  ,discount_codes__type AS discount_codes_type
  ,shippment_amount
  ,filfillment_updated_at
  ,status	
  ,source
  ,created_at	
  ,updated_at
FROM
  {{ ref('stg_orders_combined') }}
