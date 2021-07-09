SELECT 
post_id
, manager_initials
, ig_handle
, scheduled_at
, CASE WHEN started_at = "not started yet" THEN "" ELSE started_at END AS started_at
, SAFE_CAST(SPLIT(followers, ".")[SAFE_OFFSET(0)] AS INT64) AS followers
, unique_views
, SAFE_CAST(SPLIT(orders, ".")[SAFE_OFFSET(0)] AS INT64) AS orders
, revenue_net
, cost
, ROUND(SAFE_CAST(cost_to_sales AS FLOAT64) ,4) AS cost_to_sales
, status
, SAFE_CAST(SPLIT(follower_at_time_of_start, ".")[SAFE_OFFSET(0)] AS INT64) AS follower_at_time_of_start
, SAFE_CAST(SPLIT(current_followers, ".")[SAFE_OFFSET(0)] AS INT64) AS current_followers
, total_views
, total_customer
, new_customer
, SAFE_CAST(SPLIT(influencer_reported_views, ".")[SAFE_OFFSET(0)] AS INT64) AS influencer_reported_views
, total_real_order_cost_net
, coupon_code, cost_per_order
, ROUND(SAFE_CAST(return_of_investment AS FLOAT64) ,4) AS return_of_investment
, ROUND(SAFE_CAST(average_order_value_net AS FLOAT64) ,2) AS average_order_value_net
, customer_aquisition_cost
, new_customer_count
, total_customer_count
, new_customer_in_percent
, ROUND(SAFE_CAST(click_through_rate AS FLOAT64) ,4) AS click_through_rate
, ROUND(SAFE_CAST(unique_click_through_rate_based_on_influencer_reported_views AS FLOAT64) ,4) AS unique_click_through_rate_based_on_influencer_reported_views
, influencer_coupons
, type
, influencer_status_at_time_of_start
, briefing
, advertised_products
, agency_name
, influencer_average_views
, overall_post_rating
, has_reminder
, refund_ratio
, expected_revenue
, bq_updated_at 
FROM `leslunes-raw.unlooped.post_performance_de`