WITH CTE AS(
SELECT  
    row_number() OVER(PARTITION BY i.id, full_name, email order by last_status_updated_at DESC) as row_number
    ,full_name	
    ,username
    ,follower
    ,manager_id 
    ,last_posted_at
    ,next_post_scheduled_at
    ,current_Cost
    ,internal_status
    ,last_contacted_at
    ,gender
    ,
    CASE 
        WHEN primary_shop_id = 1 THEN "leslunes.de"
        WHEN primary_shop_id = 3 THEN "leslunes.fr"
        WHEN primary_shop_id = 6 THEN "leslunes.it"
    END as shop
    ,is_longterm_influencer
    ,email
    ,planned_available_at
    ,disqualify_reason
    ,last_contact_type
    ,first_contacted_at
    ,last_status_updated_at AS last_status_updated_at
    ,agency_name	
    ,SAFE_CAST(all_time_order_count AS FLOAT64) all_time_order_count
    ,SAFE_CAST(average_influencer_reported_views AS FLOAT64) average_influencer_reported_views
    ,SAFE_CAST(all_time_revenue_gross AS FLOAT64) all_time_revenue_gross
    ,SAFE_CAST(average_order_count AS FLOAT64) average_order_count
    ,SAFE_CAST(average_cost_per_order AS FLOAT64) average_cost_per_order
    ,SAFE_CAST(all_time_influencer_reported_views AS FLOAT64) all_time_influencer_reported_views
    ,SAFE_CAST(alltime_roi AS FLOAT64) alltime_roi
    ,SAFE_CAST(average_revenue_net AS FLOAT64) average_revenue_net
    ,SAFE_CAST(all_time_revenue_net AS FLOAT64) all_time_revenue_net
    ,SAFE_CAST(average_unique_views AS FLOAT64) average_unique_views
    ,SAFE_CAST(alltime_total_views AS FLOAT64) alltime_total_views
    ,SAFE_CAST(alltime_unique_views AS FLOAT64) alltime_unique_views
    ,SAFE_CAST(alltime_cost AS FLOAT64) alltime_cost
    ,SAFE_CAST(expected_revenue_net_per_post AS FLOAT64) expected_revenue_net_per_post
    ,SAFE_CAST(alltime_cts AS FLOAT64) alltime_cts
    ,SAFE_CAST(average_unique_views AS FLOAT64) stats_alltimeUniqueViews
    #,bq_updated_at
FROM `leslunes-raw.unlooped.influencer` i
LEFT JOIN `leslunes-raw.unlooped.influencer_stats` stats on stats.id = i.id
LEFT JOIN `leslunes-raw.unlooped.influencer_channel` ch on ch.id = i.id

GROUP BY 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,i.id
)

SELECT * EXCEPT(row_number) FROM CTE WHERE row_number = 1