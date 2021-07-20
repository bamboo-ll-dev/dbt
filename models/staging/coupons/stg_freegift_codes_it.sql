/*
* freegifts are implemented by script in shopify
*/
SELECT distinct
  li.value.id AS line_item_id,
  dapp.value.title AS fg_title,
  dapp.value.value AS fg_value
FROM {{source('shopify_it', 'orders')}} o,
 UNNEST(line_items) AS li, 
 UNNEST(o.discount_applications) as dapp,
 UNNEST(li.value.properties) livp
WHERE dapp.value.type = "script" AND livp.value.name	= "ll_fg" AND livp.value.value	= "true"
