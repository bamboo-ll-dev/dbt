SELECT distinct
  o.id AS transaction_id,
  dapp.value.value_type AS code_value_type,
  dapp.value.type AS code_type,	
  dapp.value.value AS code_value,
  dapp.value.code AS code
FROM  
    {{source('shopify_de', 'orders')}} o,
    UNNEST(o.discount_applications) AS dapp 
WHERE dapp.value.type != "script"