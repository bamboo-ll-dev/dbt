WITH sub_list AS(
  SELECT  
  id, 
  datetime,
  
  event_name,
  object,
  
  person._country,
  person._source,
  value,
  person._region,
  person.accepts_marketing,
  uuid,
  timestamp,
  ROW_NUMBER() OVER(PARTITION BY id ORDER BY _sdc_received_at DESC) AS row_number
  FROM `leslunes-raw.klaviyo_de.subscribe_list` 
  LEFT JOIN UNNEST (person.shopify_tags) p 
  
)

SELECT * EXCEPT(row_number)
FROM sub_list
WHERE row_number = 1