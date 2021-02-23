SELECT
  *
FROM (
  SELECT
    *,
    ROW_NUMBER() OVER(PARTITION BY id ORDER BY updated_at DESC)AS row_number
  FROM
    `leslunes-raw.unlooped.influencer` )
WHERE
  row_number = 1