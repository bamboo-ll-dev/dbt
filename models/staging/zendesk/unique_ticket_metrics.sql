WITH ticket_metrics AS(
SELECT 
*
, row_number() OVER (PARTITION BY id ORDER BY updated_at DESC ) as row_number
FROM `leslunes-raw.zendesk.ticket_metrics`
)

SELECT *
FROM ticket_metrics
WHERE row_number = 1