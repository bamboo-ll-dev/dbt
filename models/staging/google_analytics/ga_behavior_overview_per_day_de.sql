SELECT
  CAST(start_date AS DATE) AS date,
  ga_pagepath,
  ga_pagetitle,
  ga_pageviews,
  ga_avgtimeonpage,
  ga_uniquepageviews,
  ga_exitrate,
  ga_exits,
  ga_bouncerate
FROM
  `leslunes-raw.google_analytics_de.Behavior_Overview`
ORDER BY
  date DESC