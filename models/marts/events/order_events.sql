WITH shipments AS(
    SELECT 
        shop_order_id,
        reference,
        shipment_created_at,
        shipment_shipping_option,
        shipment_tracking_number,
        status AS zenf_fulfillment_status
    FROM {{ ref('fct_shipments') }}
)


SELECT * EXCEPT(shop_order_id)
FROM {{ ref('fct_orders') }} o
LEFT JOIN shipments s ON s.shop_order_id = SAFE_CAST(o.shopify_order_id AS STRING)
LEFT JOIN 
  `leslunes-rep.cxm.survey_answers_de` german_answser
  ON german_answser.ordernumber = regexp_extract(name, r"[0-9].*")
  AND orders.source = "DE"