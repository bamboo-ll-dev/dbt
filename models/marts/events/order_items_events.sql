with orderitems_de AS (
    SELECT * FROM {{ ref('stg_items_de')}}
    UNION ALL 
    SELECT * FROM {{ ref('stg_sets_de')}}
),
orderitems_fr AS (
     SELECT * FROM {{ ref('stg_items_fr')}}
),
orderitems_it AS (
     SELECT * FROM {{ ref('stg_items_it')}}
),

final AS (
    SELECT * 
    FROM orderitems_de OI
    LEFT JOIN {{ ref('stg_orders_de')}} O ON O.transaction_id = OI.order__id
    UNION ALL
    SELECT * 
    FROM orderitems_fr OI
    LEFT JOIN {{ ref('stg_orders_fr')}} O ON O.transaction_id = OI.order__id
    UNION ALL
    SELECT * 
    FROM orderitems_it OI
    LEFT JOIN {{ ref('stg_orders_it')}} O ON O.transaction_id = OI.order__id
)

SELECT 
    line_items__quantity AS quantity,
    line_items__title AS title,
    line_items__sku AS sku,
    line_items__variant_title AS variant_title,
    line_items__name AS line_item_name,
    line_items__price AS price,
    total_discounts AS discount, 
    tax_amount, 
    shipping_costs, 
    total_price,
    tax_rate, 
    tax_title, 
    line_items__price_set__shop_money__currency_code AS currency_code,	
    discount_type, 
    discount_value,
    code,
    test,
    customer_locale,
    processing_method,
    tags,
    fulfilled_at_shopify, 
    cancelled_at,  
    processed_at, 
    closed_at,
    item_type, 
    order_number,shop_order_reference,number,note,
    line_items__taxable	AS taxable,
    line_items__gift_card AS gift_card,  

    line_items__total_discount AS total_discount,	
    line_items__fulfillment_status AS fulfillment_status,
	

   
    line_items__vendor AS vendor,
    line_items__requires_shipping AS requires_shipping,
    line_items__grams AS weight_in_grams,
    line_items__fulfillment_service AS fulfillment_service,

    line_items__origin_location__country_code AS origin_country_code,
    line_items__origin_location__name AS origin_location_name ,
    line_items__origin_location__city AS origin_location__city,
    line_items__origin_location__zip AS origin_location__zip, 


    line_items__destination_location__country_code AS destination_country_code,	
    line_items__destination_location__city AS destination_city,
    line_items__destination_location__zip AS destination_zip,

    --updated_at,
    order__id AS shopify_order_id,
    line_items__id AS line_item_id,
    line_items__variant_id AS line_item_variant_id,
    line_items__product_id AS shopify_product_id, 
    line_items__origin_location__id AS origin_location_id,
    line_items__destination_location__id AS destination_id ,	
    customer_id
FROM final
--WHERE shop_order_reference = "#481697"  
ORDER BY order__id

