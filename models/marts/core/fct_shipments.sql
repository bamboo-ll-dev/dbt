WITH 
shipments_de AS(
SELECT * EXCEPT(shop_order_reference),
CONCAT("#",shop_order_reference) shop_order_reference 
FROM  {{ref('stg_shipments_de')}} 
),

shipments_fr AS(
SELECT * 
FROM  {{ref('stg_shipments_fr')}} 
),


shipments_it AS(
SELECT * 
FROM  {{ref('stg_shipments_it')}} 
),

shipments_xentral AS(
SELECT * 
FROM  {{ref('stg_shipments_xentral')}} 
)


SELECT * 
    , "DE" as zenf_source_acct
FROM shipments_de

UNION ALL
SELECT * 
    , "FR" as zenf_source_acct
FROM shipments_fr

UNION ALL
SELECT * 
    , "IT" as zenf_source_acct
FROM shipments_it

UNION ALL
SELECT * 
    , "IT" as zenf_source_acct
FROM shipments_xentral




