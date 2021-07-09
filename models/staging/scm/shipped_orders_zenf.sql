SELECT
  * EXCEPT(shipping_address_name,
    updated_at),
  SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at
FROM
  `leslunes-raw.zenfulfillment.orders_de`
WHERE STATUS = "SHIPPED"
UNION ALL
SELECT
  * EXCEPT(shipping_address_name,
    updated_at),
  SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at
FROM
  `leslunes-raw.zenfulfillment.orders_fr`
WHERE STATUS = "SHIPPED"
UNION ALL
SELECT
  * EXCEPT(shipping_address_name,
    updated_at),
  SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at
FROM
  `leslunes-raw.zenfulfillment.orders_it`
 WHERE STATUS = "SHIPPED"
UNION ALL
SELECT
  * EXCEPT(shipping_address_name,
    updated_at),
  SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at
FROM
  `leslunes-raw.zenfulfillment.orders_xentral`
WHERE
  #SAFE_CAST(updated_at AS TIMESTAMP) IS NOT NULL
#AND
STATUS = "SHIPPED"