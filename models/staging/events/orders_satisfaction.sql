SELECT
  number,
  regexp_extract(name, r"[0-9].*") AS ordernumber,
  gateway,
  total_price,
  total_tax,
  financial_status,
  fulfillment_status,
  total_discounts,
  discount_codes,
  discount_codes__type,
  orders.source,
  german_answser.score,
  german_answser.score_type,
  ig_handle 
FROM
  `leslunes-prep.orders.orders_combined` orders
JOIN 
  `leslunes-rep.cxm.survey_answers_de` german_answser
  ON german_answser.ordernumber = regexp_extract(name, r"[0-9].*")
  AND orders.source = "DE"
LEFT JOIN
  `leslunes-raw.deals.deals_data`deals
  ON deals.coupon_code = discount_codes
GROUP BY 
  number,
  name,
  gateway,
  total_price,
  total_tax,
  financial_status,
  fulfillment_status,
  total_discounts,
  discount_codes,
  discount_codes__type,
  source,
  german_answser.score,
  german_answser.score_type,
  ig_handle