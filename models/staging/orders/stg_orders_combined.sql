SELECT 
    *
    , 'DE' AS source  
FROM {{ ref('stg_orders_de') }}
UNION ALL
SELECT 
    *
    , 'FR' AS source  
FROM {{ ref('stg_orders_fr') }}
UNION ALL
SELECT 
    *
    , 'IT' AS source  
FROM {{ ref('stg_orders_it') }} 