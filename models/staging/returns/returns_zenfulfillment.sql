SELECT * except(order_name, updated_at) 
,SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at FROM `leslunes-prep.dbt_returns.stg_returns_de`
UNION ALL
SELECT * except(order_name, updated_at) 
,SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at FROM `leslunes-prep.dbt_returns.stg_returns_fr`
UNION ALL
SELECT * except(order_name, updated_at) 
,SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at FROM `leslunes-prep.dbt_returns.stg_returns_it`
UNION ALL
SELECT * except(order_name, updated_at) 
,SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at FROM `leslunes-prep.dbt_returns.stg_returns_xentral`