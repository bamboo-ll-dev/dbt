{{ config(materialized='view')}}

WITH CTE AS (
### DE
SELECT 
  *
FROM {{ref('stg_shipments_de')}} 

UNION ALL
### XENTRAL
SELECT 
   *
FROM {{ref('stg_shipments_xentral')}}

### FR
UNION ALL
SELECT 
    *
FROM {{ref('stg_shipments_fr')}} 

### IT
UNION ALL
SELECT 
  *
FROM {{ref('stg_shipments_it')}} 
)

SELECT 
 *
FROM CTE
WHERE product_sku IS NOT NULL 