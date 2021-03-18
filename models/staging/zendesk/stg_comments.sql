WITH comments AS (
SELECT * , row_number() OVER (PARTITION BY id) AS row_number
FROM `leslunes-raw.zendesk.ticket_comments` 
WHERE type = 'Comment'

)

SELECT * FROM comments

where row_number = 1

