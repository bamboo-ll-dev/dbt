with orderitems_de AS (
    SELECT * FROM {{ ref('stg_orders_de')}}
),
orderitems_fr AS (
     SELECT * FROM {{ ref('stg_orders_fr')}}
),
orderitems_it AS (
     SELECT * FROM {{ ref('stg_orders_it')}}
),

final AS (
    SELECT * FROM orderitems_de
    UNION ALL
    SELECT * FROM orderitems_fr
    UNION ALL
    SELECT * FROM orderitems_it
)

SELECT * 
FROM final

