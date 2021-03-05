SELECT
  CAST(ga_date as DATE) as date
  ,ga_pageviews
  ,ga_sessions
  ,ga_newusers
  ,ga_users
  ga_bouncerate
FROM
  `leslunes-raw.google_analytics_it.Audience_Overview`
ORDER BY date DESC