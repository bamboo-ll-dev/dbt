/*
 Order items in ZenFulfillment with status "shipped" for DE, FR, IT and Xentral ZenF-accounts
*/

SELECT shipment_created_at, product_sku, style, size, color, count(*) as items_shipped 
FROM
(SELECT
SAFE_CAST(split(shipment_created_at, "T")[SAFE_OFFSET(0)] AS date) AS shipment_created_at
, product_sku,
  CASE 
     WHEN regexp_extract(product_sku, "^(\\w*)") = "W" THEN LEFT(product_sku,5)
     WHEN regexp_extract(product_sku, "^(\\w*)") like "INFLUENCERCARD_%" THEN "n/a" 
     ELSE regexp_extract(product_sku, "^(\\w*)") 
  END as style,
  CASE 
    WHEN regexp_extract(product_sku, "^(\\w*)") = "W" THEN regexp_extract(product_sku,"(\\w*\\/\\w*)$")
    WHEN regexp_extract(product_sku, "-([A-Z/0-9]*)-\\w\\/?\\w*$") = "EC" THEN "UNI"
    WHEN regexp_extract(product_sku, "^(\\w*)") like "INFLUENCERCARD_%" THEN "n/a" 
  ELSE regexp_extract(product_sku, "-([A-Z/0-9]*)-\\w\\/?\\w*$") END AS size,
  ### extract and transform color from skus like W-219-ALEN-07-01-100-101-260-100-XS/S where color is in the 3-digits next to size (at the end)
  CASE WHEN regexp_extract(product_sku, "^(\\w*)") = "W" THEN (
                          SELECT color 
                          from (SELECT "100" as code, "WH" as color
                                UNION ALL
                                SELECT "801" as code, "HG" as color
                                UNION ALL
                                SELECT "999" as code, "BK" as color) 
                                where code = regexp_extract(product_sku,"(\\d{3})-\\w*\\/\\w*$")
                          ) 
  WHEN regexp_extract(product_sku, "^(\\w*)") like "INFLUENCERCARD_%" THEN "n/a" 
  ELSE regexp_extract(product_sku, "(\\w*)$")
  END as color
FROM 
`leslunes-raw.zenfulfillment.orders_xentral` WHERE STATUS = "SHIPPED"
####
UNION ALL
SELECT
SAFE_CAST(split(shipment_created_at, "T")[SAFE_OFFSET(0)] AS date) AS shipment_created_at
, product_sku,
  CASE 
     WHEN regexp_extract(product_sku, "^(\\w*)") = "W" THEN LEFT(product_sku,5)
     WHEN regexp_extract(product_sku, "^(\\w*)") like "INFLUENCERCARD_%" THEN "n/a" 
     ELSE regexp_extract(product_sku, "^(\\w*)") 
  END as style,
  CASE 
    WHEN regexp_extract(product_sku, "^(\\w*)") = "W" THEN regexp_extract(product_sku,"(\\w*\\/\\w*)$")
    WHEN regexp_extract(product_sku, "-([A-Z/0-9]*)-\\w\\/?\\w*$") = "EC" THEN "UNI"
    WHEN regexp_extract(product_sku, "^(\\w*)") like "INFLUENCERCARD_%" THEN "n/a" 
  ELSE regexp_extract(product_sku, "-([A-Z/0-9]*)-\\w\\/?\\w*$") END AS size,
  ### extract and transform color from skus like W-219-ALEN-07-01-100-101-260-100-XS/S where color is in the 3-digits next to size (at the end)
  CASE WHEN regexp_extract(product_sku, "^(\\w*)") = "W" THEN (
                          SELECT color 
                          from (SELECT "100" as code, "WH" as color
                                UNION ALL
                                SELECT "801" as code, "HG" as color
                                UNION ALL
                                SELECT "999" as code, "BK" as color) 
                                where code = regexp_extract(product_sku,"(\\d{3})-\\w*\\/\\w*$")
                          ) 
  WHEN regexp_extract(product_sku, "^(\\w*)") like "INFLUENCERCARD_%" THEN "n/a" 
  ELSE regexp_extract(product_sku, "(\\w*)$")
  END as color
FROM 
`leslunes-raw.zenfulfillment.orders_de` WHERE STATUS = "SHIPPED"

####
UNION ALL
SELECT
SAFE_CAST(split(shipment_created_at, "T")[SAFE_OFFSET(0)] AS date) AS shipment_created_at
, product_sku,
  CASE 
     WHEN regexp_extract(product_sku, "^(\\w*)") = "W" THEN LEFT(product_sku,5)
     WHEN regexp_extract(product_sku, "^(\\w*)") like "INFLUENCERCARD_%" THEN "n/a" 
     ELSE regexp_extract(product_sku, "^(\\w*)") 
  END as style,
  CASE 
    WHEN regexp_extract(product_sku, "^(\\w*)") = "W" THEN regexp_extract(product_sku,"(\\w*\\/\\w*)$")
    WHEN regexp_extract(product_sku, "-([A-Z/0-9]*)-\\w\\/?\\w*$") = "EC" THEN "UNI"
    WHEN regexp_extract(product_sku, "^(\\w*)") like "INFLUENCERCARD_%" THEN "n/a" 
  ELSE regexp_extract(product_sku, "-([A-Z/0-9]*)-\\w\\/?\\w*$") END AS size,
  ### extract and transform color from skus like W-219-ALEN-07-01-100-101-260-100-XS/S where color is in the 3-digits next to size (at the end)
  CASE WHEN regexp_extract(product_sku, "^(\\w*)") = "W" THEN (
                          SELECT color 
                          from (SELECT "100" as code, "WH" as color
                                UNION ALL
                                SELECT "801" as code, "HG" as color
                                UNION ALL
                                SELECT "999" as code, "BK" as color) 
                                where code = regexp_extract(product_sku,"(\\d{3})-\\w*\\/\\w*$")
                          ) 
  WHEN regexp_extract(product_sku, "^(\\w*)") like "INFLUENCERCARD_%" THEN "n/a" 
  ELSE regexp_extract(product_sku, "(\\w*)$")
  END as color
FROM 
`leslunes-raw.zenfulfillment.orders_fr` WHERE STATUS = "SHIPPED"

####
UNION ALL
SELECT
SAFE_CAST(split(shipment_created_at, "T")[SAFE_OFFSET(0)] AS date) AS shipment_created_at
, product_sku,
  CASE 
     WHEN regexp_extract(product_sku, "^(\\w*)") = "W" THEN LEFT(product_sku,5)
     WHEN regexp_extract(product_sku, "^(\\w*)") like "INFLUENCERCARD_%" THEN "n/a" 
     ELSE regexp_extract(product_sku, "^(\\w*)") 
  END as style,
  CASE 
    WHEN regexp_extract(product_sku, "^(\\w*)") = "W" THEN regexp_extract(product_sku,"(\\w*\\/\\w*)$")
    WHEN regexp_extract(product_sku, "-([A-Z/0-9]*)-\\w\\/?\\w*$") = "EC" THEN "UNI"
    WHEN regexp_extract(product_sku, "^(\\w*)") like "INFLUENCERCARD_%" THEN "n/a" 
  ELSE regexp_extract(product_sku, "-([A-Z/0-9]*)-\\w\\/?\\w*$") END AS size,
  ### extract and transform color from skus like W-219-ALEN-07-01-100-101-260-100-XS/S where color is in the 3-digits next to size (at the end)
  CASE WHEN regexp_extract(product_sku, "^(\\w*)") = "W" THEN (
                          SELECT color 
                          from (SELECT "100" as code, "WH" as color
                                UNION ALL
                                SELECT "801" as code, "HG" as color
                                UNION ALL
                                SELECT "999" as code, "BK" as color) 
                                where code = regexp_extract(product_sku,"(\\d{3})-\\w*\\/\\w*$")
                          ) 
  WHEN regexp_extract(product_sku, "^(\\w*)") like "INFLUENCERCARD_%" THEN "n/a" 
  ELSE regexp_extract(product_sku, "(\\w*)$")
  END as color
FROM 
`leslunes-raw.zenfulfillment.orders_it` WHERE STATUS = "SHIPPED"
) 
GROUP BY 1,2,3,4, 5