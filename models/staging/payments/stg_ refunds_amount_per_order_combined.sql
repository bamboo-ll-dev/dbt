SELECT order_id, amount, created_at, 'DE' AS source 
FROM {{ ref('stg_refunds_amount_per_order_de') }}
UNION ALL
SELECT order_id, amount, created_at, 'FR' AS source  
FROM {{ ref('stg_refunds_amount_per_order_fr') }}
UNION ALL
SELECT order_id, amount, created_at, 'IT' AS source  
FROM {{ ref('stg_refunds_amount_per_order_it') }}