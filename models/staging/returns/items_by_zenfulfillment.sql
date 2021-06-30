SELECT
product_sku
,shipping_address_country
,style
,size
,color
#,sum(SAFE_CAST(product_qty as INT64)) AS quantity
,ordered_at
,ordered_at_month
,ordered_at_year
,CONCAT(ordered_at_year,'-',ordered_at_month) AS ordered_year_and_month
#,CAST(return_processed_at	as date) AS return_processed_at
#, EXTRACT(MONTH FROM CAST(return_processed_at	as date)) AS return_processed_at_month
#, EXTRACT(YEAR FROM CAST(return_processed_at	as date)) AS return_processed_at_year
, sum(one) AS too_big
, sum(two) AS too_small
, sum(three) AS too_long
, sum(four) AS too_short
, sum(five) AS quality_not_like_expected
, sum(six) AS material_not_like_expected
, sum(seven) AS fit_does_not_suit_me
, sum(eight) AS damaged_defective
, sum(nine) AS several_colors_or_sizes_ordered
, sum(ten) AS article_differs_from_website
, sum(eleven) AS late_delivery_wrong_item
, sum(twelve) AS others
FROM ( 
SELECT * FROM `leslunes-prep.returns.unique_returned_items` 
) 
GROUP BY 1,2,3,4,5,6,7,8