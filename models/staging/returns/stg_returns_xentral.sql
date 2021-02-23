WITH shipments AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY processed_at, products_sku, reference ORDER BY updated_at DESC) AS row_number
  FROM
   {{ source('zenf', 'returns_xentral')}}
    )
SELECT
  * EXCEPT(row_number)
FROM
  shipments
WHERE row_number = 1