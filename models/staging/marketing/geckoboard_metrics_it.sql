SELECT
PARSE_DATE('%Y%m%d',date) AS date,
CAST(sessions	AS INT64) AS sessions,
CAST(users AS INT64) AS users,
CAST(sessions_with_product_views	AS INT64) AS sessions_with_product_views,
CAST(sessions_with_add_to_cart	AS INT64) AS sessions_with_add_to_cart,
CAST(sessions_with_checkout	AS INT64) AS sessions_with_checkout,
CAST(sessions_with_transactions AS INT64) AS sessions_with_transactions
FROM `leslunes-raw.ga_kpi_metrics.report_it` order by date desc