SELECT CONCAT(A.supplier, A.country, type, category) AS id, A.supplier, A.country, type, category, avg_weight_g, import_duty_percentage, avg_price_per_kg_without_customs_euro, avg_weight_g*avg_price_per_kg_without_customs_euro/1000 AS freigh_cost FROM
(SELECT *,
        #Not all suppliers are in database, for some freigt cost we need to take of other suppliers
        CASE WHEN supplier IN ('Erius', 'Clothius') AND country='Portugal' THEN 'Daily Day'
        WHEN supplier IN ('ITC Accessories') THEN 'Kashion' 
        ELSE supplier END AS supplier_con
FROM `leslunes-prep.products.fob_suppliers`) AS A
#All transport modes
INNER JOIN
(SELECT country, 'air' AS type, air AS value FROM `leslunes-prep.products.fob_countries_transport_mode`
UNION ALL
SELECT country, 'sea' AS type, sea FROM `leslunes-prep.products.fob_countries_transport_mode`
UNION ALL
SELECT country, 'seaair' AS type, seaair FROM `leslunes-prep.products.fob_countries_transport_mode`
UNION ALL
SELECT country, 'truck' AS type, truck FROM `leslunes-prep.products.fob_countries_transport_mode`
UNION ALL
SELECT country, 'rail' AS type, rail FROM `leslunes-prep.products.fob_countries_transport_mode`
) AS B
ON A.country=B.country
CROSS JOIN
(SELECT * EXCEPT(id) FROM `leslunes-prep.products.fob_cat`) AS C
INNER JOIN
(SELECT * FROM `leslunes-prep.products.fob_countries_import_duty`) AS D
ON A.country=D.country
INNER JOIN
(SELECT freigh_mode, supplier, AVG(price_per_kg_without_customs_euro) AS avg_price_per_kg_without_customs_euro
FROM `leslunes-prep.products.fob_shipments_tracking_cost` 
WHERE freigh_mode IS NOT NULL
GROUP BY freigh_mode,	supplier) AS E
ON A.supplier_con=E.supplier AND UPPER(B.type)=UPPER(E.freigh_mode)
WHERE avg_weight_g IS NOT NULL AND value='1'

