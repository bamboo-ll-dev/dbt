SELECT 
    number, 
    count(number)
FROM {{ ref('stg_orders_combined') }}
GROUP BY number
HAVING count(number) > 2
