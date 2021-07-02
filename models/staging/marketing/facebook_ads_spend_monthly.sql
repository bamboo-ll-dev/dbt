SELECT 
CONCAT(EXTRACT(YEAR from DATE),"_",FORMAT_DATE("%m", DATE)) AS month_year,
EXTRACT(MONTH from DATE) as month,
EXTRACT(YEAR from DATE) AS year,
ROUND(sum(total_spend),2) AS total_spend
FROM `leslunes-prep.marketing.facebook_ads_spend_daily` 
GROUP BY month_year, month, year #CONCAT(EXTRACT(YEAR from DATE),"_",EXTRACT(MONTH from DATE))
ORDER BY 3,2 DESC