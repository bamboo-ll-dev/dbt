SELECT date, sessions, users, sessions_with_product_views, sessions_with_add_to_cart, sessions_with_checkout, sessions_with_transactions, 'DE' AS source  
FROM `leslunes-prep.marketing.geckoboard_metrics_de`
UNION ALL
SELECT date, sessions, users, sessions_with_product_views, sessions_with_add_to_cart, sessions_with_checkout, sessions_with_transactions, 'FR' AS source  
FROM `leslunes-prep.marketing.geckoboard_metrics_fr`
UNION ALL
SELECT date, sessions, users, sessions_with_product_views, sessions_with_add_to_cart, sessions_with_checkout, sessions_with_transactions, 'IT' AS source  
FROM `leslunes-prep.marketing.geckoboard_metrics_it`

