SELECT DISTINCT
  email_hash, created_at,
  MIN(created_At) OVER (PARTITION BY email_hash) AS first_purchase_date, 
FROM {{ ref('stg_orderitems_fr') }}
