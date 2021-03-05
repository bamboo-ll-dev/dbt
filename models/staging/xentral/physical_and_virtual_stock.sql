SELECT
  sku,
  SAFE_CAST(quantity_on_stock AS INT64) AS quantity_on_stock,
  SAFE_CAST(ordered_items_pending AS INT64) AS ordered_items_pending,
  SAFE_CAST(difference AS INT64) AS difference,
  name
FROM {{ source('xentral', 'physical_and_virtual_stock') }}