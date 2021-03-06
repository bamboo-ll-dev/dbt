/*
returns unique posts with last updated entries
*/

SELECT
  *
FROM (
  SELECT
    *,
    ROW_NUMBER() OVER(PARTITION BY id ORDER BY updated_at DESC) AS row_number
  FROM
    {{ source('posts','marketing_post')}} 
    )
WHERE row_number = 1