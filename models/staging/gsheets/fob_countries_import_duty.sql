{{ config(materialized='table') }}


SELECT *, CURRENT_TIMESTAMP() as bq_updated_at FROM  `leslunes-raw.gsheets.fob_countries_import_duty`