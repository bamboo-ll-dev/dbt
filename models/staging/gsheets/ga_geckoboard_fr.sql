{{ config(materialized='table') }}

SELECT *, CURRENT_TIMESTAMP() as bq_updated_at FROM  `leslunes-raw.gsheets.ga_geckoboard_fr`