SELECT 
    *
    , 'DE' AS source  
FROM {{ ref('stg_orderitems_de') }}
UNION ALL
SELECT 
    *
    , 'FR' AS source  
FROM {{ ref('stg_orderitems_fr') }}
UNION ALL
SELECT 
    *
    , 'IT' AS source  
FROM {{ ref('stg_orderitems_it') }} 