WITH cte AS(
  SELECT
    T.id as ticket_id,  
    ta.value as tag,
    ROW_NUMBER() OVER (PARTITION BY t.ID ORDER BY updated_at DESC) AS row_number
  FROM
    `leslunes-raw.zendesk.tickets` t,
     UNNEST(tags) AS ta )
    
 SELECT * EXCEPT(row_number) FROM CTE WHERE row_number = 1

