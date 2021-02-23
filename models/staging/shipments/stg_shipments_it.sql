WITH shipments AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY created_at, product_sku, reference ORDER BY shipment_created_at DESC) AS row_number
  FROM
   {{ source('zenf', 'orders_it')}}
    )
SELECT
  * EXCEPT(row_number)
FROM
  shipments
WHERE row_number = 1