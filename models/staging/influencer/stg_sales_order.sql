WITH CTE AS(
SELECT * , 
    ROW_NUMBER() OVER( PARTITION BY id ORDER BY updated_at DESC) AS row_number
FROM `leslunes-raw.unlooped.sales_order`
ORDER BY ID
)

SELECT * 
FROM CTE 
WHERE row_number = 1