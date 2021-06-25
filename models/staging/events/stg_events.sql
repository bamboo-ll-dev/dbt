with orderitems_de AS (
    SELECT * FROM {{ ref('stg_orderitems_de')}}
),
orderitems_fr AS (
     SELECT * FROM {{ ref('stg_orderitems_fr')}}
),
orderitems_it AS (
     SELECT * FROM {{ ref('stg_orderitems_it')}}
),

final AS (
    SELECT * FROM orderitems_de
    UNION ALL
    SELECT * FROM orderitems_fr
    UNION ALL
    SELECT * FROM orderitems_it
    UNION ALL

)

SELECT * 
FROM final

