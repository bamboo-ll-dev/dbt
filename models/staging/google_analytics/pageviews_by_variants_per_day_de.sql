WITH VIEWS AS(
SELECT 
DATE(ga_date) AS date,
ga_pageviews AS pageviews,
ga_uniquepageviews AS unique_pageviews,
CASE 
  WHEN REGEXP_CONTAINS(ga_pagepath, r"\?") THEN REGEXP_EXTRACT(ga_pagepath, r"/products/(.*)\?")
  WHEN REGEXP_CONTAINS(ga_pagepath, r"/collections/.*/products/") THEN REGEXP_EXTRACT(ga_pagepath, r"/collections/.*/products/(.*)")
  WHEN REGEXP_CONTAINS(ga_pagepath, r"/products/") THEN  REGEXP_EXTRACT(ga_pagepath, r"/products/(.*)")
ELSE ga_pagepath END AS product,

CASE 
  WHEN  REGEXP_CONTAINS(ga_pagepath,r'\?variant=') THEN REGEXP_EXTRACT(ga_pagepath, r".*\?variant=(.*)")
  ELSE "" 
END As shopify_variant_id, 

FROM `leslunes-raw.google_analytics_de.KPI_METRICS` 
WHERE ga_pagepath like "%/products/%"
)

SELECT date, sum(pageviews) AS pageviews, REGEXP_REPLACE(product, r"-", " ") AS product, shopify_variant_id
FROM VIEWS
GROUP BY 1,3,4