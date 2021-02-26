SELECT * FROM(
SELECT 
  id 
  ,customer_locale
  ,email
  ,abandoned_checkout_url
  ,name 
  ,updated_at 
  ,created_at
  , row_number() OVER(PARTITION BY id, email,name, created_at) as row_number
FROM  {{ source('abondoned_checkouts_it','abandoned_checkouts') }}

)
WHERE row_number = 1