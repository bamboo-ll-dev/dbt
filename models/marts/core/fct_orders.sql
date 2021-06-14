SELECT
  transaction_id AS shopify_order_id
  ,order_created_at	
  ,number
  ,shop_order_reference
  ,regexp_extract(shop_order_reference, r"[0-9].*") AS order_number
  ,total_price
  ,tax_amount
  ,tax_rate
  ,financial_status
  ,gateway
  ,total_discounts
  ,code
  ,discount_value
  ,discount_type
  ,shipping_costs
  ,processing_method
  ,source
  ,tags
  ,note
  ,shopify_fulfilled_at
  ,fulfillment_status
  ,order_updated_at
FROM
  {{ ref('stg_orders_combined') }}
