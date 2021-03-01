SELECT * EXCEPT (id2) FROM 
(SELECT * EXCEPT(row_number) FROM 
(SELECT row_number() OVER (PARTITION BY id ORDER BY updated_at DESC) AS row_number,
id,
email,
closed_at,	
created_at,	
updated_at,
number,
name AS shop_order_reference,
note, 
token,
gateway,
test,
SAFE_CAST(total_price AS FLOAT64) AS total_price,
SAFE_CAST(subtotal_price AS FLOAT64) AS subtotal_price,
SAFE_CAST(total_tax AS FLOAT64) AS total_tax,
tax_lines.value.rate AS tax_rate,
SAFE_CAST(total_weight AS INT64) AS total_weight,
currency,
financial_status,
fulfillment_status,
taxes_included,
confirmed,
SAFE_CAST(total_discounts AS FLOAT64) AS total_discounts,
SAFE_CAST(total_line_items_price AS FLOAT64) AS total_line_items_price,
cart_token,
buyer_accepts_marketing,
cancel_reason,
cancelled_at,
SAFE_CAST(total_price_usd AS FLOAT64) AS total_price_usd,
#discount
SAFE_CAST(discount_codes.value. amount AS FLOAT64) AS discount_codes__amount,
discount_codes.value.code AS discount_codes,
dc.discount_value AS discount_value,
dc.discount_type AS discount_codes__type,
#discount_codes.value.type AS discount_codes__type,

SAFE_CAST(total_tip_received AS FLOAT64) AS total_tip_received,
user_id,
SAFE_CAST(customer. total_spent AS FLOAT64) AS customer__total_spent,

admin_graphql_api_id,
app_id,
billing_address. address1 AS billing_address__address1,
billing_address. address2 AS billing_address__address2,
billing_address. city AS billing_address__city,
billing_address. company AS billing_address__company,
billing_address. country AS billing_address__country,
billing_address. country_code AS billing_address__country_code,
billing_address. first_name AS billing_address__first_name,
billing_address. last_name AS billing_address__last_name,
billing_address. latitude AS billing_address__latitude,
billing_address. longitude AS billing_address__longitude,
billing_address. name AS billing_address__name,
billing_address. phone AS billing_address__phone,
billing_address. province AS billing_address__province,
billing_address. province_code AS billing_address__province_code,
billing_address. zip AS billing_address__zip,

browser_ip,
o.checkout_id,
checkout_token,

contact_email,

customer. accepts_marketing AS customer__accepts_marketing,
customer. admin_graphql_api_id AS customer__admin_graphql_api_id,
customer. created_at AS customer__created_at,
customer. currency AS customer__currency,
customer.default_address. address1 AS customer__default_address__address1,
customer.default_address. address2 AS customer__default_address__address2,
customer.default_address. city AS customer__default_address__city,
customer.default_address. company AS customer__default_address__company,
customer.default_address. country AS customer__default_address__country,
customer.default_address. country_code AS customer__default_address__country_code,
customer.default_address. country_name AS customer__default_address__country_name,
customer.default_address. customer_id AS customer__default_address__customer_id,
customer.default_address. default AS customer__default_address__default,
customer.default_address. first_name AS customer__default_address__first_name,
customer.default_address. id AS customer__default_address__id,
customer.default_address. last_name AS customer__default_address__last_name,
customer.default_address. name AS customer__default_address__name,
customer.default_address. phone AS customer__default_address__phone,
customer.default_address. province AS customer__default_address__province,
customer.default_address. province_code AS customer__default_address__province_code,
customer.default_address. zip AS customer__default_address__zip,
customer. email AS customer__email,
customer. first_name AS customer__first_name,
customer. id AS customer__id,
customer. last_name AS customer__last_name,
customer. last_order_id AS customer__last_order_id,
customer. last_order_name AS customer__last_order_name,
customer. note AS customer__note,
SAFE_CAST(customer. orders_count AS INT64) AS customer__orders_count,
customer. phone AS customer__phone,
customer. state AS customer__state,
customer. tags AS customer__tags,
customer. tax_exempt AS customer__tax_exempt,
customer. updated_at AS customer__updated_at,
customer. verified_email AS customer__verified_email,

customer_locale,
landing_site,
location_id,
order_number,
order_status_url,

payment_details. avs_result_code AS payment_details__avs_result_code,
payment_details. credit_card_bin AS payment_details__credit_card_bin,
payment_details. credit_card_company AS payment_details__credit_card_company,
payment_details. credit_card_number AS payment_details__credit_card_number,
payment_details. cvv_result_code AS payment_details__cvv_result_code,

phone,
presentment_currency,
processed_at,
processing_method,
referring_site,

shipping_address. address1 AS shipping_address__address1,
shipping_address. address2 AS shipping_address__address2,
shipping_address. city AS shipping_address__city,
shipping_address. company AS shipping_address__company,
shipping_address. country AS shipping_address__country,
shipping_address. country_code AS shipping_address__country_code,
shipping_address. first_name AS shipping_address__first_name,
shipping_address. last_name AS shipping_address__last_name,
shipping_address. latitude AS shipping_address__latitude,
shipping_address. longitude AS shipping_address__longitude,
shipping_address. name AS shipping_address__name,
shipping_address. phone AS shipping_address__phone,
shipping_address. province AS shipping_address__province,
shipping_address. province_code AS shipping_address__province_code,
shipping_address. zip AS shipping_address__zip,

/* source_name 580111 appeared out of nowhere; case-statement fixed it */
CASE WHEN source_name = "shopify_draft_order" THEN source_name ELSE "web" END AS source_name,

SAFE_CAST(subtotal_price_set.presentment_money. amount AS FLOAT64) AS subtotal_price_set__presentment_money__amount,
subtotal_price_set.presentment_money. currency_code AS subtotal_price_set__presentment_money__currency_code,
SAFE_CAST(subtotal_price_set.shop_money. amount AS FLOAT64) AS subtotal_price_set__shop_money__amount,
subtotal_price_set.shop_money. currency_code AS subtotal_price_set__shop_money__currency_code,

SAFE_CAST(total_discounts_set.presentment_money. amount AS FLOAT64) AS total_discounts_set__presentment_money__amount,
total_discounts_set.presentment_money. currency_code AS total_discounts_set__presentment_money__currency_code,
SAFE_CAST(total_discounts_set.shop_money. amount AS FLOAT64) AS total_discounts_set__shop_money__amount,
total_discounts_set.shop_money. currency_code AS total_discounts_set__shop_money__currency_code,

SAFE_CAST(total_line_items_price_set.presentment_money. amount AS FLOAT64) AS total_line_items_price_set__presentment_money__amount,
total_line_items_price_set.presentment_money. currency_code AS total_line_items_price_set__presentment_money__currency_code,
SAFE_CAST(total_line_items_price_set.shop_money. amount AS FLOAT64) AS total_line_items_price_set__shop_money__amount,
total_line_items_price_set.shop_money. currency_code AS total_line_items_price_set__shop_money__currency_code,

SAFE_CAST(total_price_set.presentment_money. amount AS FLOAT64) AS total_price_set__presentment_money__amount,
total_price_set.presentment_money. currency_code AS total_price_set__presentment_money__currency_code,
SAFE_CAST(total_price_set.shop_money. amount AS FLOAT64) AS total_price_set__shop_money__amount,
total_price_set.shop_money. currency_code AS total_price_set__shop_money__currency_code,

SAFE_CAST(total_shipping_price_set.presentment_money. amount AS FLOAT64) AS total_shipping_price_set__presentment_money__amount,
total_shipping_price_set.presentment_money. currency_code AS total_shipping_price_set__presentment_money__currency_code,
SAFE_CAST(total_shipping_price_set.shop_money. amount AS FLOAT64) AS total_shipping_price_set__shop_money__amount,
total_shipping_price_set.shop_money. currency_code AS total_shipping_price_set__shop_money__currency_code,

SAFE_CAST(total_tax_set.presentment_money. amount AS FLOAT64) AS total_tax_set__presentment_money__amount,
total_tax_set.presentment_money. currency_code AS total_tax_set__presentment_money__currency_code,
SAFE_CAST(total_tax_set.shop_money. amount AS FLOAT64) AS total_tax_set__shop_money__amount,
total_tax_set.shop_money. currency_code AS total_tax_set__shop_money__currency_code,

tags,
client_details. browser_height AS client_details__browser_height,
client_details. browser_ip AS client_details__browser_ip,
client_details. browser_width AS client_details__browser_width,
client_details. session_hash AS client_details__session_hash,
REPLACE(client_details. accept_language, ',', ';') AS client_details__accept_language,
REPLACE(client_details. user_agent, ',', ';') AS client_details__user_agent,

f.value.updated_at as filfillment_updated_at,	f.value.status

FROM
leslunes-raw.shopify_de.orders o
LEFT JOIN UNNEST(fulfillments) AS f
LEFT JOIN (SELECT 
checkout_id
, dc.value.value_type AS discount_type
, dc.value.type
, dc.value.value as discount_value
,	dc.value.code
FROM {{source('shopify_de', 'orders')}}
, UNNEST(discount_applications) dc
WHERE dc.value.type in ("discount_code")
GROUP BY 1,2,3,4,5) AS dc on dc.checkout_id = o.checkout_id 
LEFT JOIN UNNEST(discount_codes) AS discount_codes
LEFT JOIN UNNEST(tax_lines) AS tax_lines)
WHERE row_number = 1) AS A

LEFT JOIN
(#Getting getting all payment gateways (gateway shows only the last payment type and when order is edited, sometimes it shows 'manual')
SELECT id AS id2, payment_gateway_names FROM
(SELECT row_number() OVER (PARTITION BY id ORDER BY updated_at DESC) AS rn, updated_at, id, payment_gateway_names FROM
(SELECT updated_at, id, STRING_AGG(payment_gateway_names) AS payment_gateway_names FROM
(SELECT updated_at, id, payment_gateway_names.value AS payment_gateway_names FROM {{source('shopify_de', 'orders')}}
LEFT JOIN UNNEST(payment_gateway_names) AS payment_gateway_names 
GROUP BY updated_at, id, payment_gateway_names) AS A
GROUP BY updated_at, id) AS A
) AS A WHERE rn=1) AS B
ON A.id=B.id2
