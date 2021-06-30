WITH satisfaction_ratings AS (
SELECT * 
  EXCEPT(_sdc_batched_at, _sdc_received_at, _sdc_sequence, _sdc_table_version)
  ,row_number() OVER(PARTITION BY ticket_id order by created_at DESC) as row_number
FROM `leslunes-raw.zendesk.satisfaction_ratings` 
)

SELECT "" --* 

FROM satisfaction_ratings WHERE row_number = 1
AND score in ('good', 'bad')
