WITH date_array AS(
    SELECT 
    /* GA data before was invalid */
    GENERATE_DATE_ARRAY('2019-06-01', current_date(), INTERVAL 1 DAY) AS days
), days AS(
    SELECT regexp_replace(SAFE_CAST(days AS STRING), "-", "") AS day
    from date_array, unnest(date_array.days)  as days
)

SELECT * 
FROM `leslunes-raw.ga_kpi_metrics.report_de` 
WHERE date not in ( SELECT day from days)

UNION ALL
SELECT * 
FROM `leslunes-raw.ga_kpi_metrics.report_fr` 
WHERE date not in ( SELECT day from days)

UNION ALL
SELECT * 
FROM `leslunes-raw.ga_kpi_metrics.report_it` 
WHERE date not in ( SELECT day from days)