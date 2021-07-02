/*
returns unique posts with last updated entries
*/

SELECT
  *
FROM (
  SELECT
    cost_currency,
    channel_id,	
    is_analyzed,
    links_to_us_count,
    scheduled_at,
    followers_at_time_of_start,
    assigned_coupon_value,
    mp.id As id,
    had_technical_issues_while_running,
    started_at,
    briefing_id,
    cost,
    ended_at,
    has_reminder_post,
    updated_at,
    status,
    is_auto_generated	,
    wrong_mention_count,
    mentions_us_count,
    crawl_till,
    type,
    shop_id,
    created_at,
    briefing_sent_at,
    influencer_status_at_time_of_start,
    assigned_coupon_id,
    influencer_id	,
    influencer_reported_views,
    link_suffix_id,
    assigned_coupon_code,
    last_crawled_at	,
    url_id,
    wrong_link_count,
    manager_at_time_of_start_id,
    shop,
    ROW_NUMBER() OVER(PARTITION BY mp.id ORDER BY updated_at DESC) AS row_number
  FROM
    `leslunes-raw.unlooped.marketing_post` mp
  LEFT JOIN `leslunes-raw.unlooped.shops` s ON s.id = CAST(mp.shop_id AS STRING)
    )
WHERE row_number = 1