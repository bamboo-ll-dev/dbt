WITH receiving AS(
  SELECT  
  id, 
  datetime,
  
  event_name,
  event_properties.email_domain,
  event_properties.subject,
  event_properties.campaign_name,

  object,
  
  person._country,
  person._source,
  person._region,
  person.accepts_marketing,
  uuid,
  timestamp,
  ROW_NUMBER() OVER(PARTITION BY id ORDER BY _sdc_received_at DESC) AS row_number
  FROM `leslunes-raw.klaviyo_de.receive` 
  
)

SELECT * EXCEPT(row_number)
FROM receiving
WHERE row_number = 1