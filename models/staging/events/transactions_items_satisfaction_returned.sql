SELECT
  orders.created_at AS created_at_UTC,
  number,
  regexp_extract(name, r"[0-9].*") AS ordernumber,
  line_items__title,
  #CASE WHEN line_items_properties__value is not null THEN SPLIT(line_items_properties__value, " | ")[SAFE_OFFSET(0)] ELSE SPLIT(line_items__sku, "-")[SAFE_OFFSET(1)] END as size,
  #CASE WHEN line_items_properties__value is not null THEN SPLIT(line_items_properties__value, " | ")[SAFE_OFFSET(1)] ELSE SPLIT(line_items__sku, "-")[SAFE_OFFSET(2)] END as color,
  line_items__sku, line_items__quantity,item_type,
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
  ig_handle, returns.products_returned
FROM
  `leslunes-prep.orders.orders_with_items_combined` orders
LEFT JOIN 
  `leslunes-rep.cxm.survey_answers_de` german_answser
  ON german_answser.ordernumber = regexp_extract(name, r"[0-9].*") AND orders.source = "DE"
LEFT JOIN
  `leslunes-raw.deals.deals_data`deals ON deals.coupon_code = discount_codes
LEFT JOIN 
  (SELECT * FROM `leslunes-raw.zenfulfillment.returns_de`
  UNION ALL
  SELECT * FROM `leslunes-raw.zenfulfillment.returns_it`
  UNION ALL
  SELECT * FROM `leslunes-raw.zenfulfillment.returns_fr`
  UNION ALL
  SELECT * FROM `leslunes-raw.zenfulfillment.returns_xentral`
 ) returns on returns.order_shop_order_reference = ordernumber and line_items__sku = products_sku
  
where returns.products_returned is not null
GROUP BY 
  orders.created_at,
  number,
  name,
  line_items__title,
  line_items__sku,
  line_items__quantity,
  item_type,
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
  ig_handle,
  returns.products_returned
 order by number