{{ config(materialized='table') }}


SELECT *, CURRENT_TIMESTAMP() as bq_updated_at FROM  `leslunes-raw.gsheets.fob_cat`