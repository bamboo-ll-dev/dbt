{{ config(materialized='table') }}

SELECT 
    *, 
    CURRENT_TIMESTAMP() AS bq_updated_at 
FROM  
    `leslunes-raw.gsheets.size-config`