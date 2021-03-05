SELECT 
REPLACE(SAFE_CAST(created_at AS STRING),"-","") AS created_at, 
SUBSTR(created_at,1,7) AS month, source,revenue, refunds, 
ROUND(revenue - refunds ,2) AS revenue_minus_refunds,
#ROUND(SAFE_DIVIDE(avg_disc_with_tax_part1,avg_disc_with_tax_part2),4) AS avg_disc_with_tax,
#ROUND(SAFE_DIVIDE(avg_disc_without_tax_part1,avg_disc_without_tax_part2),4) AS avg_disc_without_tax,
avg_disc_with_tax_part1, avg_disc_with_tax_part2, avg_disc_without_tax_part1, avg_disc_without_tax_part2,
orders_shop,	avg_cart_size,	
#ROUND(SAFE_DIVIDE(sum_cost_posted,orders_shop),2) AS CPO, 
#ROUND(SAFE_DIVIDE(revenue,orders_shop),2) AS CTS,
Revenue_SMM, Revenue_OWN_IG,	Revenue_NL,	Revenue_FB,	Revenue_CS,	Revenue_Unknown, Revenue_Without_coupon,
#ROUND(SAFE_DIVIDE(sum_cost_posted,Revenue_SMM),2) AS Revenue_CTS,
sum_cost_planned, sum_cost_posted, avg_cost_planned, post_planned,	post_posted, unique_influencers_planned, unique_influencers_posted,
#ROUND(SAFE_DIVIDE(orders_shop,sessions),2) AS CR_Sessions_to_order,
returning_cust_orders, #ROUND(SAFE_DIVIDE(returning_cust_orders,orders_shop),2) AS returning_cust_orders_perc, 
returning_cust_revenue, #ROUND(SAFE_DIVIDE(returning_cust_revenue,revenue),2) AS returning_cust_revenue_perc,
sessions,	unique_visitors, sessions_with_product_views, sessions_with_add_to_cart, sessions_with_checkout, sessions_with_transactions,
#ROUND(SAFE_DIVIDE(refunds,revenue),2) AS return_rate, 
shippment_amount, total_discounts, total_price, new_customers_count

FROM

(SELECT
SUBSTR(SAFE_CAST(created_at AS STRING),1,10) AS created_at, source,
ROUND(SUM(total_price-total_tax),2) AS revenue,
ROUND(SUM(ROUND(CASE WHEN refunds IS NULL THEN 0 ELSE refunds END - 
CASE WHEN total_tax IS NULL THEN 0 ELSE total_tax END * 
CASE WHEN SAFE_DIVIDE(refunds,total_price) IS NULL THEN 0 ELSE SAFE_DIVIDE(refunds,total_price) END,2)),2) AS refunds,
ROUND(SUM(CASE WHEN shippment_amount IS NULL THEN 0 ELSE shippment_amount END),2) AS shippment_amount,
ROUND(SUM(CASE WHEN total_discounts IS NULL THEN 0 ELSE total_discounts END),2) AS total_discounts,
ROUND(SUM(CASE WHEN total_price IS NULL THEN 0 ELSE total_price END),2) AS total_price,

#It is needed to divide formulas into part 1 and 2 because of average aggregations in chartio
ROUND(SUM(CASE WHEN total_discounts=0 OR total_price=0 OR discount_codes IS NULL THEN 0 ELSE total_discounts END),4) AS avg_disc_with_tax_part1,
ROUND(SUM(CASE WHEN total_discounts=0 OR total_price=0 OR discount_codes IS NULL THEN 0 ELSE (total_discounts+total_price/*-shippment_amount*/) END),4) AS avg_disc_with_tax_part2,

ROUND(SUM(CASE WHEN total_discounts=0 OR total_price=0 OR discount_codes IS NULL THEN 0 ELSE total_discounts*(1-tax_rate) END),4) AS avg_disc_without_tax_part1,
ROUND(SUM(CASE WHEN total_discounts=0 OR total_price=0 OR discount_codes IS NULL THEN 0 ELSE (total_discounts*(1-tax_rate)+total_price/*-shippment_amount*/) END),4) AS avg_disc_without_tax_part2,

COUNT(DISTINCT id) AS orders_shop,
ROUND(AVG(total_price),2) AS avg_cart_size,
ROUND(SUM(CASE WHEN code_type='SMM' THEN total_price-total_tax ELSE 0 END),2) AS Revenue_SMM,
ROUND(SUM(CASE WHEN code_type='OWN_IG' THEN total_price-total_tax ELSE 0 END),2) AS Revenue_OWN_IG,
ROUND(SUM(CASE WHEN code_type='NL' THEN total_price-total_tax ELSE 0 END),2) AS Revenue_NL,
ROUND(SUM(CASE WHEN code_type='FB' THEN total_price-total_tax ELSE 0 END),2) AS Revenue_FB,
ROUND(SUM(CASE WHEN code_type='CS' THEN total_price-total_tax ELSE 0 END),2) AS Revenue_CS,
ROUND(SUM(CASE WHEN code_type='UNKNOWN' THEN total_price-total_tax ELSE 0 END),2) AS Revenue_Unknown,
ROUND(SUM(CASE WHEN code_type IS NULL THEN total_price-total_tax ELSE 0 END),2) AS Revenue_Without_coupon,
COUNT(CASE WHEN th_purchase>1 THEN id END) AS returning_cust_orders,
ROUND(SUM(CASE WHEN th_purchase>1 THEN total_price-total_tax END),2) AS returning_cust_revenue,
ROUND(COUNT(DISTINCT CASE WHEN th_purchase=1 THEN email END),2) AS new_customers_count,
FROM

#Shopify sales data
(SELECT id, ROW_NUMBER () OVER (PARTITION BY email, source ORDER BY created_at) AS th_purchase,
SAFE_CAST(created_at AS DATE) AS created_at, email, discount_codes, source, total_price, subtotal_price, total_tax, total_discounts, shippment_amount,
(CASE WHEN tax_rate IS NULL THEN 0 ELSE tax_rate END) AS tax_rate
FROM leslunes-prep.orders.orders_combined WHERE source_name='web'
) AS A
LEFT JOIN
(SELECT code, code_type FROM {{ref('coupons')}} GROUP BY code, code_type) AS B
ON A.discount_codes=B.code
LEFT JOIN 
(SELECT order_id, SUM(amount) AS refunds, source AS source3 FROM leslunes-prep.refunds.refunds_amount_per_order_combined GROUP BY order_id, source) AS C
ON A.id=c.order_id

GROUP BY created_at, source) AS A

#im.leslunes data posts planned
FULL OUTER JOIN

(SELECT SUBSTR(SAFE_CAST(scheduled_at AS STRING),1,10) AS scheduled_at, source AS source2,
ROUND(SUM(cost),2) AS sum_cost_planned,
ROUND(AVG(cost),2) AS avg_cost_planned,
COUNT(DISTINCT post_id) AS post_planned,
COUNT(DISTINCT ig_handle) AS unique_influencers_planned
FROM leslunes-prep.marketing.deals_unique_casted_types_snapshot
GROUP BY scheduled_at, source
ORDER BY scheduled_at DESC) AS B1 ON A.source=B1.source2 AND A.created_at=B1.scheduled_at

#im.leslunes data posts posted
FULL OUTER JOIN
(SELECT SUBSTR(SAFE_CAST(started_at AS STRING),1,10) AS started_at, source AS source2,
ROUND(SUM(CASE WHEN status='posted' THEN cost ELSE 0 END),2) AS sum_cost_posted,
COUNT(DISTINCT CASE WHEN status='posted' THEN post_id END) AS post_posted,
COUNT(DISTINCT CASE WHEN status='posted' THEN ig_handle END) AS unique_influencers_posted
FROM leslunes-prep.marketing.deals_unique_casted_types_snapshot
GROUP BY started_at, source
ORDER BY started_at DESC) AS B2 ON A.source=B2.source2 AND A.created_at=B2.started_at

#GA data
FULL OUTER JOIN
(SELECT SUBSTR(SAFE_CAST(date AS STRING),1,10) AS date, 
SUM(CASE WHEN sessions IS NULL THEN 0 ELSE sessions END) AS sessions,	
SUM(CASE WHEN users IS NULL THEN 0 ELSE users END) AS unique_visitors, 
SUM(CASE WHEN sessions_with_product_views IS NULL THEN 0 ELSE sessions_with_product_views END) AS sessions_with_product_views, 
SUM(CASE WHEN sessions_with_add_to_cart IS NULL THEN 0 ELSE sessions_with_add_to_cart END) AS sessions_with_add_to_cart,
SUM(CASE WHEN sessions_with_checkout IS NULL THEN 0 ELSE sessions_with_checkout END) AS sessions_with_checkout, 
SUM(CASE WHEN sessions_with_transactions IS NULL THEN 0 ELSE sessions_with_transactions END) AS sessions_with_transactions,	source AS source3 FROM leslunes-prep.marketing.geckoboard_metrics_combined GROUP BY date, source3) AS C
ON A.source=C.source3 AND A.created_at=C.date
WHERE created_at IS NOT NULL 
ORDER BY created_at DESC