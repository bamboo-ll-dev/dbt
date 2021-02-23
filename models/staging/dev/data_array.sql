SELECT
  FORMAT_DATE("%Y_%m_%d", date)  as date 
FROM UNNEST(GENERATE_DATE_ARRAY('2019-04-01', current_date(), INTERVAL 1 DAY)) AS date
ORDER BY date desc