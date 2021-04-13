SELECT 
*,
#Additionally created columns
#ROUND(SAFE_DIVIDE(SAFE_CAST(total_tax AS FLOAT64), (SAFE_CAST(total_line_items_price AS FLOAT64) - SAFE_CAST(total_tax AS FLOAT64)))) AS tax_rate, 
ROUND(SAFE_DIVIDE(SAFE_CAST(total_discounts AS FLOAT64), SAFE_CAST(total_line_items_price AS FLOAT64))) AS discount_rate, 
ROUND(SAFE_DIVIDE(SAFE_CAST(line_items__price AS FLOAT64), SAFE_CAST(total_line_items_price AS FLOAT64))) AS shipping_rate, 
ROUND(SAFE_DIVIDE(SAFE_CAST(line_items__price AS FLOAT64), SAFE_CAST(total_line_items_price AS FLOAT64))) AS refund_rate
FROM `leslunes-prep.orders.unique_orders_it` as orders #`les-lunes-data-269915.import_it.unique_orders` as orders
LEFT JOIN (SELECT 
#Columns from unique_items view
SAFE_CAST(line_items__id AS STRING) AS line_items__id,
SAFE_CAST(line_items__variant_id AS STRING) AS line_items__variant_id,
SAFE_CAST(line_items__title AS STRING) AS line_items__title,
SAFE_CAST(line_items__quantity AS INT64) AS line_items__quantity,
SAFE_CAST(line_items__sku AS STRING) AS line_items__sku,
SAFE_CAST(line_items__variant_title AS STRING) AS line_items__variant_title,
SAFE_CAST(line_items__vendor AS STRING) AS line_items__vendor,
SAFE_CAST(line_items__fulfillment_service AS STRING) AS line_items__fulfillment_service,
SAFE_CAST(line_items__product_id AS STRING) AS line_items__product_id,
SAFE_CAST(line_items__requires_shipping AS BOOL) AS line_items__requires_shipping,
SAFE_CAST(line_items__taxable AS BOOL) AS line_items__taxable,
SAFE_CAST(line_items__gift_card AS BOOL) AS line_items__gift_card,
SAFE_CAST(line_items__name AS STRING) AS line_items__name,
SAFE_CAST(line_items__variant_inventory_management AS STRING) AS line_items__variant_inventory_management,
SAFE_CAST(line_items__product_exists AS BOOL) AS line_items__product_exists,
SAFE_CAST(line_items__fulfillable_quantity AS INT64) AS line_items__fulfillable_quantity,
SAFE_CAST(line_items__grams AS INT64) AS line_items__grams,
SAFE_CAST(line_items__price AS FLOAT64) AS line_items__price,
SAFE_CAST(line_items__total_discount AS FLOAT64) AS line_items__total_discount,
SAFE_CAST(line_items__fulfillment_status AS STRING) AS line_items__fulfillment_status,
SAFE_CAST(line_items__admin_graphql_api_id AS STRING) AS line_items__admin_graphql_api_id,
SAFE_CAST(line_items__price_set__shop_money__amount AS FLOAT64) AS line_items__price_set__shop_money__amount,
SAFE_CAST(line_items__price_set__shop_money__currency_code AS STRING) AS line_items__price_set__shop_money__currency_code,
SAFE_CAST(line_items__price_set__presentment_money__amount AS FLOAT64) AS line_items__price_set__presentment_money__amount,
SAFE_CAST(line_items__price_set__presentment_money__currency_code AS STRING) AS line_items__price_set__presentment_money__currency_code,
SAFE_CAST(line_items__total_discount_set__shop_money__amount AS FLOAT64) AS line_items__total_discount_set__shop_money__amount,
SAFE_CAST(line_items__total_discount_set__shop_money__currency_code AS STRING) AS line_items__total_discount_set__shop_money__currency_code,
SAFE_CAST(line_items__total_discount_set__presentment_money__amount AS FLOAT64) AS line_items__total_discount_set__presentment_money__amount,
SAFE_CAST(line_items__total_discount_set__presentment_money__currency_code AS STRING) AS line_items__total_discount_set__presentment_money__currency_code,
SAFE_CAST(line_items__origin_location__id AS STRING) AS line_items__origin_location__id,
SAFE_CAST(line_items__origin_location__country_code AS STRING) AS line_items__origin_location__country_code,
SAFE_CAST(line_items__origin_location__province_code AS STRING) AS line_items__origin_location__province_code,
SAFE_CAST(line_items__origin_location__name AS STRING) AS line_items__origin_location__name,
SAFE_CAST(line_items__origin_location__address1 AS STRING) AS line_items__origin_location__address1,
SAFE_CAST(line_items__origin_location__address2 AS STRING) AS line_items__origin_location__address2,
SAFE_CAST(line_items__origin_location__city AS STRING) AS line_items__origin_location__city,
SAFE_CAST(line_items__origin_location__zip AS STRING) AS line_items__origin_location__zip,
#SAFE_CAST(line_items__destination_location__id AS STRING) AS line_items__destination_location__id,
#SAFE_CAST(line_items__destination_location__country_code AS STRING) AS line_items__destination_location__country_code,
#SAFE_CAST(line_items__destination_location__province_code AS STRING) AS line_items__destination_location__province_code,
#SAFE_CAST(line_items__destination_location__name AS STRING) AS line_items__destination_location__name,
#SAFE_CAST(line_items__destination_location__address1 AS STRING) AS line_items__destination_location__address1,
#SAFE_CAST(line_items__destination_location__address2 AS STRING) AS line_items__destination_location__address2,
#SAFE_CAST(line_items__destination_location__city AS STRING) AS line_items__destination_location__city,
#SAFE_CAST(line_items__destination_location__zip AS STRING) AS line_items__destination_location__zip,
SAFE_CAST(order__id AS STRING) AS order__id,
#SAFE_CAST(line_items_properties__name AS STRING) AS line_items_properties__name,
#SAFE_CAST(line_items_properties__value AS STRING) AS line_items_properties__value,
SAFE_CAST(item_type AS STRING) AS item_type
FROM `leslunes-prep.items.unique_items_it`) as items ON CAST(orders.id AS STRING) = items.order__id
LEFT JOIN ( 
#Columns from unique_refunds
SELECT order_id, SUM(refund_amount) AS refund_amount FROM 
(SELECT ROW_NUMBER() OVER (PARTITION BY id, kind ORDER BY _sdc_batched_at DESC) AS rn, id, order_id, status, kind, amount AS refund_amount, _sdc_extracted_at 
FROM `leslunes-raw.shopify_it.transactions` WHERE status='success' AND kind='refund') AS A 
WHERE rn=1
GROUP BY order_id) AS refunds ON CAST(orders.id AS STRING) = CAST(refunds.order_id AS STRING)