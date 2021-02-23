WITH kpis AS (SELECT *
FROM UNNEST(["revenue", "shippment_amount"]) as name )

 SELECT
    kpis.name AS KPI,
   {{ dbt_utils.pivot(
      'created_at', dbt_utils.get_column_values(ref('gecko'), 'created_at'), prefix='_', then_value='ROUND(revenue),2)', else_value=0) 
   }},
      {{ dbt_utils.pivot(
      'created_at', dbt_utils.get_column_values(ref('gecko'), 'created_at'), prefix='_', then_value='ROUND(shippment_amount),2)', else_value=0) 
   }}
FROM {{ ref('gecko')}}, kpis
WHERE source = "IT"
GROUP BY KPI
--ORDER BY date desc

