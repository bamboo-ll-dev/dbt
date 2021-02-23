(#Getting getting all payment gateways (gateway shows only the last payment type and when order is edited, sometimes it shows 'manual')
SELECT id AS id2, payment_gateway_names FROM
(SELECT row_number() OVER (PARTITION BY id ORDER BY updated_at DESC) AS rn, updated_at, id, payment_gateway_names FROM
(SELECT updated_at, id, STRING_AGG(payment_gateway_names) AS payment_gateway_names FROM
(SELECT updated_at, id, payment_gateway_names.value AS payment_gateway_names FROM leslunes-raw.shopify_de.orders
LEFT JOIN UNNEST(payment_gateway_names) AS payment_gateway_names 
GROUP BY updated_at, id, payment_gateway_names) AS A
GROUP BY updated_at, id) AS A
) AS A WHERE rn=1) AS B
