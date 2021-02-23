

WITH CTE AS (
### DE
SELECT 
  *
FROM {{ref('stg_returns_de')}} 

UNION ALL
### XENTRAL
SELECT 
   *
FROM {{ref('stg_returns_xentral')}}

### FR
UNION ALL
SELECT 
    *
FROM {{ref('stg_returns_fr')}} 

### IT
UNION ALL
SELECT 
  *
FROM {{ref('stg_returns_it')}} 
)

SELECT 
 *
FROM CTE
WHERE products_sku IS NOT NULL 