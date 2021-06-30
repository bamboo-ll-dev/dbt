SELECT * EXCEPT(shipping_address_name, updated_at) 
,SAFE_CAST(updated_at AS TIMESTAMP) as updated_at
FROM `leslunes-raw.zenfulfillment.orders_de`
UNION ALL
SELECT  * EXCEPT(shipping_address_name, updated_at) 
,SAFE_CAST(updated_at AS TIMESTAMP) as updated_at FROM `leslunes-raw.zenfulfillment.orders_fr`
UNION ALL
SELECT  * EXCEPT(shipping_address_name, updated_at) 
,SAFE_CAST(updated_at AS TIMESTAMP) as updated_at FROM `leslunes-raw.zenfulfillment.orders_it`
UNION ALL
SELECT  * EXCEPT(shipping_address_name, updated_at) 
,SAFE_CAST(updated_at AS TIMESTAMP) as updated_at 
FROM `leslunes-raw.zenfulfillment.orders_xentral` 
where SAFE_CAST(updated_at AS TIMESTAMP) is not null