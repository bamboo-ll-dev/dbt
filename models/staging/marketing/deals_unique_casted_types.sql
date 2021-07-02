SELECT
  DATE(SAFE_CAST(scheduled_at as Timestamp)) AS scheduled_at 
  ,DATE(SAFE_CAST(started_at as Timestamp))AS started_at
  ,SAFE_CAST(date AS DATE) AS date
  ,SAFE_CAST(orders AS FLOAT64) AS orders  
  ,SAFE_CAST(unique_views AS FLOAT64) AS unique_views  
  ,SAFE_CAST(revenue_net AS FLOAT64) AS revenue_net
  ,SAFE_CAST(cost AS FLOAT64) AS cost
  ,ROUND(SAFE_CAST(cost_to_sales AS FLOAT64), 3) AS cost_to_sales
  ,SAFE_CAST(total_views AS FLOAT64) AS total_views
  ,SAFE_CAST(total_customer AS FLOAT64) AS total_customer 
  ,SAFE_CAST(new_customer AS FLOAT64) AS new_customer
  ,SAFE_CAST(influencer_reported_views AS FLOAT64) AS influencer_reported_views
  ,SAFE_CAST(total_real_order_cost_net AS FLOAT64) AS total_real_order_cost_net
  ,ROUND(SAFE_CAST(cost_per_order AS FLOAT64),3) AS cost_per_order
  ,ROUND(SAFE_CAST(return_of_investment AS FLOAT64),3) AS return_of_investment
  ,ROUND(SAFE_CAST(average_order_value_net AS FLOAT64),3) AS average_order_value_net
  ,ROUND(SAFE_CAST(customer_aquisition_cost AS FLOAT64),3) AS customer_aquisition_cost
  ,ROUND(SAFE_CAST(new_customer_in_percent AS FLOAT64),3) AS new_customer_in_percent
  ,ROUND(SAFE_CAST(refund_ratio AS FLOAT64),3) AS refund_ratio
  ,ROUND(SAFE_CAST(follower_at_time_of_start AS FLOAT64),3) AS follower_at_time_of_start
  ,ROUND(SAFE_CAST(current_followers AS FLOAT64),3) AS current_followers
  ,ROUND(SAFE_CAST(new_customer_count AS FLOAT64),3) AS new_customer_count
  ,ROUND(SAFE_CAST(total_customer_count AS FLOAT64),3) AS total_customer_count
  ,ROUND(SAFE_CAST(click_through_rate AS FLOAT64),3) AS click_through_rate
  ,ROUND(SAFE_CAST(unique_click_through_rate_based_on_influencer_reported_views AS FLOAT64),4) AS unique_click_through_rate_based_on_influencer_reported_views 
  ,*
  EXCEPT(scheduled_at
  ,started_at
  ,date
  ,orders
  ,unique_views 
  ,row_number 
  ,revenue_net
  ,cost
  ,cost_to_sales
  ,total_views, 
  total_customer, 
  new_customer, 
  influencer_reported_views,
  total_real_order_cost_net,
  cost_per_order,
  return_of_investment, 
  average_order_value_net, 
  customer_aquisition_cost, 
  new_customer_in_percent, 
  refund_ratio,
  follower_at_time_of_start,
  current_followers,
  new_customer_count,
  total_customer_count,
  click_through_rate,
  unique_click_through_rate_based_on_influencer_reported_views
  )
FROM (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY post_id ORDER BY date DESC) AS row_number
  FROM
    leslunes-raw.deals.deals_data) AS A
WHERE
  row_number=1
AND SAFE_CAST(date AS DATE) = current_date()