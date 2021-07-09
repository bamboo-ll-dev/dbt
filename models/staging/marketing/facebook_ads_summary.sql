SELECT
  ad_name,
  ROUND(SUM(spend),2) AS spend,
  DATE(date_start) AS date_utc,
  EXTRACT(week FROM date_start) AS week,
  EXTRACT(MONTH FROM date_start) AS month,
  EXTRACT(YEAR FROM date_start) AS year
   ,unique_ctr
   ,
    impressions,
    cost_per_unique_click,
    unique_clicks,
    cost_per_inline_link_click,
    unique_link_clicks_ctr,
    inline_link_click_ctr,
    cpp,
    ctr,
    cpm,
    conversion_rate_ranking,
    engagement_rate_ranking,
    clicks,
    quality_ranking, 
FROM (
  SELECT
    campaign_name,
    unique_ctr,
    ad_name,
    impressions,
    cost_per_unique_click,
    unique_clicks,
    cost_per_inline_link_click,
    unique_link_clicks_ctr,
    inline_link_click_ctr,
    cpp,
    ctr,
    cpm,
    conversion_rate_ranking,
    engagement_rate_ranking,
    clicks,
    quality_ranking,
    spend,
    date_stop,
    date_start,
    ROW_NUMBER() OVER(PARTITION BY date_start) AS row_number
  FROM
    `leslunes-raw.facebook_ads.ads_insights`
  GROUP BY
    campaign_name,
    unique_ctr,
    ad_name,
    impressions,
    cost_per_unique_click,
    unique_clicks,
    cost_per_inline_link_click,
    unique_link_clicks_ctr,
    inline_link_click_ctr,
    cpp,
    ctr,
    cpm,
    conversion_rate_ranking,
    engagement_rate_ranking,
    clicks,
    quality_ranking,
    spend,
    date_stop,
    date_start
  ORDER BY
    date_start )
WHERE
  row_number = 1
GROUP BY
  1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
ORDER BY 3,1