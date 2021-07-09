{{ config(
materialized='table'
) }}

SELECT *, CURRENT_TIMESTAMP()as bq_updated_at FROM  `leslunes-raw.gsheets.fob_shipments_tracking_cost`