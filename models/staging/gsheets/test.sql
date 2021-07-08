{{ config(
materialized='table'
) }}


SELECT processed_at, discount_codes,usage_count FROM `leslunes-rep.sales_reports.coupon_kpis_daily_de` WHERE discount_codes = 'COZY50';