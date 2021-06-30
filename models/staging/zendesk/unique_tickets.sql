WITH cte AS(
  SELECT
    T.id as ticket_id, created_at, updated_at,
    raw_subject, status,
    type, cf.value AS main_category,
     
    assignee_id,
    ROW_NUMBER() OVER (PARTITION BY t.ID ORDER BY updated_at DESC) AS row_number
  FROM
    `leslunes-raw.zendesk.tickets` t,
    UNNEST(t.custom_fields) AS cf
    )
 SELECT "" --* 
 
 FROM CTE WHERE row_number = 1