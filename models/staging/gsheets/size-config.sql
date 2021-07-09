{{ config(materialized='table') }}

AS SELECT *, CURRENT_TIMESTAMP() as bq_updated_at FROM  `leslunes-raw.gsheets.size-config`