with orderitems_de AS (
    SELECT * FROM {{ ref('stg_order_items_de')}}
),
orderitems_fr AS (
     SELECT * FROM {{ ref('stg_order_items_fr')}}
),
orderitems_it AS (
     SELECT * FROM {{ ref('stg_order_items_it')}}
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

