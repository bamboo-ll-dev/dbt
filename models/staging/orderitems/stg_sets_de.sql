SELECT * FROM (
#Sets
(SELECT * EXCEPT(row_number) FROM 
   (SELECT row_number() OVER (PARTITION BY line_items.value.id, line_items.value.sku ORDER BY updated_at DESC) AS row_number,
          line_items.value.id AS line_items__id,
          line_items.value.variant_id AS line_items__variant_id,
          SAFE_CAST(line_items.value.quantity AS INT64) AS line_items__quantity,
          line_items.value.title AS line_items__title,
          CASE WHEN UPPER(line_items.value.sku) LIKE '%SET' OR UPPER(line_items.value.sku) LIKE '%BUNDLE%' OR UPPER(line_items.value.sku) LIKE '%DUO' THEN '' ELSE line_items.value.sku END AS line_items__sku,
          line_items.value.variant_title AS line_items__variant_title,
          line_items.value.vendor AS line_items__vendor,
          line_items.value.fulfillment_service AS line_items__fulfillment_service,
          line_items.value.product_id AS line_items__product_id,
          line_items.value.requires_shipping AS line_items__requires_shipping,
          line_items.value.taxable AS line_items__taxable,
          line_items.value.gift_card AS line_items__gift_card,
          line_items.value.name AS line_items__name,
          line_items.value.variant_inventory_management AS line_items__variant_inventory_management,
          line_items.value.product_exists AS line_items__product_exists,
          SAFE_CAST(line_items.value.fulfillable_quantity AS INT64) AS line_items__fulfillable_quantity,
          SAFE_CAST(line_items.value.grams AS INT64) AS line_items__grams,
          SAFE_CAST(line_items.value.price AS FLOAT64) AS line_items__price,
          SAFE_CAST(line_items.value.total_discount AS FLOAT64) AS line_items__total_discount,
          line_items.value.fulfillment_status AS line_items__fulfillment_status,
          line_items.value.admin_graphql_api_id AS line_items__admin_graphql_api_id,
          SAFE_CAST(line_items.value.price_set.shop_money.amount AS FLOAT64) AS line_items__price_set__shop_money__amount,
          line_items.value.price_set.shop_money.currency_code AS line_items__price_set__shop_money__currency_code,
          SAFE_CAST(line_items.value.price_set.presentment_money.amount AS FLOAT64) AS line_items__price_set__presentment_money__amount,
          line_items.value.price_set.presentment_money.currency_code AS line_items__price_set__presentment_money__currency_code,
          SAFE_CAST(line_items.value.total_discount_set.shop_money.amount AS FLOAT64) AS line_items__total_discount_set__shop_money__amount,
          line_items.value.total_discount_set.shop_money.currency_code AS line_items__total_discount_set__shop_money__currency_code,
          SAFE_CAST(line_items.value.total_discount_set.presentment_money.amount AS FLOAT64)  AS line_items__total_discount_set__presentment_money__amount,
          line_items.value.total_discount_set.presentment_money.currency_code AS line_items__total_discount_set__presentment_money__currency_code,
          line_items.value.origin_location.id AS line_items__origin_location__id,
          line_items.value.destination_location.id AS line_items__destination_location__id,
          id AS order__id,
          updated_at AS updated_at,
          'SET' AS item_type
    FROM `leslunes-raw.shopify_de.orders`
    LEFT JOIN UNNEST(line_items) AS line_items
    #LEFT JOIN UNNEST(line_items.value.properties) AS prop
    WHERE (line_items.value. sku='' OR UPPER(line_items.value. sku) LIKE '%SET' OR UPPER(line_items.value.sku) LIKE '%BUNDLE%' OR UPPER(line_items.value.sku) LIKE '%DUO%') AND line_items.value.properties[SAFE_OFFSET(0)].value.value IS NOT NULL) AS B
WHERE row_number = 1) 
ORDER BY line_items__id DESC)