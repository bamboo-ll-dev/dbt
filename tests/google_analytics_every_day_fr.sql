WITH date_array AS(
    SELECT 
    /* GA data before was invalid */
    GENERATE_DATE_ARRAY('2021-01-01', DATE_SUB(current_date(),INTERVAL 1 DAY), INTERVAL 1 DAY) AS days
), days AS(
    SELECT regexp_replace(SAFE_CAST(days AS STRING), "-", "") AS day
    from date_array, unnest(date_array.days)  as days
)

SELECT * 
FROM days
WHERE day not in (SELECT date
FROM `leslunes-raw.ga_kpi_metrics.report_fr`)

