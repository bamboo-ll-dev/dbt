WITH cte AS(
  SELECT
    campaign_name,
    MAX(unique_ctr) AS unique_ctr,
    ad_name,
    MAX(impressions) AS impressions,
    MAX(cost_per_unique_click) AS cost_per_unique_click,
    MAX(unique_clicks) AS unique_clicks,
    MAX(cost_per_inline_link_click) AS cost_per_inline_link_click,
    MAX(unique_link_clicks_ctr) AS unique_link_clicks_ctr,
    MAX(inline_link_click_ctr) AS inline_link_click_ctr,
    MAX(cpp) AS cpp,
    MAX(ctr) AS ctr,
    MAX(cpm) AS cpm,
    MAX(conversion_rate_ranking) AS conversion_rate_ranking ,
    MAX(engagement_rate_ranking) AS engagement_rate_ranking,
    MAX(clicks) AS clicks,
    MAX(quality_ranking) AS quality_ranking,
    MAX(spend) AS spend,
    date_stop,
    date_start,
    ROW_NUMBER() OVER(PARTITION BY date_start, campaign_name, ad_name) AS row_number
  FROM
    {{ source('facebook_ads_costs','ads_insights') }}
  GROUP BY
  1,3,18,19
 )

SELECT  DATE(date_start) AS date, ROUND(sum(spend),2) AS total_spend 
FROM CTE
GROUP BY 1 
ORDER BY 1 DESC