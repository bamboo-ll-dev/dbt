with CTE as(
SELECT 

ROW_NUMBER() OVER (PARTITION BY id ORDER BY CAST(created_at AS timestamp) DESC) AS row_number,
*
EXCEPT(payment_details,
_sdc_table_version, 
_sdc_received_at, 
_sdc_sequence, 
_sdc_batched_at, 
_sdc_extracted_at, 
admin_graphql_api_id, 
authorization	)

FROM `leslunes-raw.shopify_de.transactions`

UNION ALL 

SELECT
ROW_NUMBER() OVER (PARTITION BY id ORDER BY CAST(created_at AS timestamp) DESC) AS row_number,
*
EXCEPT(payment_details,
_sdc_table_version, 
_sdc_received_at, 
_sdc_sequence, 
_sdc_batched_at, 
_sdc_extracted_at, 
admin_graphql_api_id, 
authorization	)
FROM `leslunes-raw.shopify_fr.transactions`

UNION ALL 

SELECT
ROW_NUMBER() OVER (PARTITION BY id ORDER BY CAST(created_at AS timestamp) DESC) AS row_number, 
*
EXCEPT(payment_details,
_sdc_table_version, 
_sdc_received_at, 
_sdc_sequence, 
_sdc_batched_at, 
_sdc_extracted_at, 
admin_graphql_api_id, 
authorization)
FROM `leslunes-raw.shopify_it.transactions`
)

SELECT * EXCEPT(row_number) FROM CTE WHERE row_number = 1