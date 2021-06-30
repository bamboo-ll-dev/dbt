SELECT
  sku
  ,SAFE_CAST(quantity_on_stock AS INT64) AS quantity_on_stock
  ,title
  ,SAFE_CAST(date as DATE) as date 
  FROM
    `leslunes-raw.scm.historic_stock`
  WHERE
    SAFE_CAST(quantity_on_stock AS INT64) != 0
  ORDER BY date DESC


/*SELECT
  CONCAT(date, sku_edited) AS date_and_sku,
  date,
  sku_edited,
  quantity_on_stock
FROM (
  SELECT
    date,
    SUM(SAFE_CAST(quantity_on_stock AS INT64)) AS quantity_on_stock,
    CASE
      WHEN SUBSTR(REGEXP_EXTRACT(sku, r'^[A-Z \d\W]+'),-3)='-2-' THEN SUBSTR(REGEXP_EXTRACT(sku, r'^[A-Z \d\W]+'),1,LENGTH(REGEXP_EXTRACT(sku, r'^[A-Z \d\W]+'))-3)
      WHEN SUBSTR(REGEXP_EXTRACT(sku, r'^[A-Z \d\W]+'),-1)='-' THEN SUBSTR(REGEXP_EXTRACT(sku, r'^[A-Z \d\W]+'),1,LENGTH(REGEXP_EXTRACT(sku, r'^[A-Z \d\W]+'))-1)
      WHEN REGEXP_CONTAINS(sku, r'^[a-z]+') THEN sku
    ELSE
    REGEXP_EXTRACT(sku, r'^[A-Z \d\W]+')
  END
    AS sku_edited
  FROM
    `leslunes-raw.scm.historic_stock`
  WHERE
    SAFE_CAST(quantity_on_stock AS INT64) != 0
  GROUP BY
    sku_edited,
    date) */