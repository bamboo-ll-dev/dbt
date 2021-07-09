{{ config(materialized='table') }}


SELECT *, CURRENT_TIMESTAMP() as bq_updated_at FROM  `leslunes-raw.gsheets.all_other_suppliers_shipments`