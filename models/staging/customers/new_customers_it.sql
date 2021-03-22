WITH orders AS(
SELECT * EXCEPT (id2) FROM 
(
  SELECT * EXCEPT(row_number) 
  FROM (
    SELECT 
      row_number() OVER (PARTITION BY id ORDER BY updated_at DESC) AS row_number,
      id,
      email,
      test,
      created_at,
      source_name
    FROM {{ source('shopify_it','orders')}} o
    LEFT JOIN UNNEST(fulfillments) AS f
    LEFT JOIN (
            SELECT 
                  checkout_id
                  , dc.value.value_type AS discount_type
                  , dc.value.type
                  , dc.value.value as discount_value
                  ,	dc.value.code
      FROM {{ source('shopify_it','orders')}} o, UNNEST(discount_applications) dc
      WHERE dc.value.type in ("discount_code")
      GROUP BY 1,2,3,4,5) AS dc on dc.checkout_id = o.checkout_id 
      LEFT JOIN UNNEST(discount_codes) AS discount_codes
      LEFT JOIN UNNEST(tax_lines) AS tax_lines
    )
WHERE row_number = 1) AS A

LEFT JOIN
(#Getting getting all payment gateways (gateway shows only the last payment type and when order is edited, sometimes it shows 'manual')
SELECT id AS id2, payment_gateway_names FROM
(SELECT row_number() OVER (PARTITION BY id ORDER BY updated_at DESC) AS rn, updated_at, id, payment_gateway_names FROM
(SELECT updated_at, id, STRING_AGG(payment_gateway_names) AS payment_gateway_names FROM
(SELECT updated_at, id, payment_gateway_names.value AS payment_gateway_names 
  FROM {{ source('shopify_it','orders')}} o
LEFT JOIN UNNEST(payment_gateway_names) AS payment_gateway_names 
GROUP BY updated_at, id, payment_gateway_names) AS A
GROUP BY updated_at, id) AS A
) AS A WHERE rn=1) AS B ON A.id=B.id2
WHERE test = False
)

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
    FROM orders
    WHERE source_name='web'
    GROUP BY email, sale_date) AS A
  LEFT JOIN (
    SELECT email AS email2, MIN(created_at) AS first_sale
    FROM orders
    WHERE source_name='web'
    GROUP BY email) AS B ON  A.email=B.email2) AS A
WHERE 
  new_customer = true
GROUP BY
  date,
  new_customer
ORDER BY
  date