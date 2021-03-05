SELECT
  SAFE_CAST(sale_date AS DATE) as date,
  COUNT(DISTINCT email) AS new_customers,
FROM (
  SELECT
    *,
    first_sale=sale_date AS new_customer
  FROM (
    SELECT
      email,
      created_at AS sale_date
    FROM {{ ref('stg_unique_orders_fr') }}
    WHERE source_name='web'
    GROUP BY email, sale_date) AS A
  LEFT JOIN (
    SELECT email AS email2, MIN(created_at) AS first_sale
     FROM {{ ref('stg_unique_orders_fr') }}
    WHERE source_name='web'
    GROUP BY email) AS B
  ON  A.email=B.email2) AS A
  WHERE new_customer = true
GROUP BY
  date,
  new_customer
ORDER BY
  date