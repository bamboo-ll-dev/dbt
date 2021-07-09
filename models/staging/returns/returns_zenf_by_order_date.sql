SELECT
  product_sku
  , CASE 
    WHEN regexp_contains(product_sku, r'(set|SET)') THEN product_sku
    WHEN regexp_contains(product_sku, r'4007') THEN 'High waisted Leggings'
    WHEN regexp_contains(product_sku, r'07-BA-(LUNA|HWLEG)-(FG|VV|TM|MR)') THEN 'Luna Leggings KN'
    WHEN regexp_contains(product_sku, r'07-BA-(LUNA|HWLEG)-(DT|CH|RT|HG|DN|BK|LL|EB|LG|WL)') THEN 'Luna Leggings SA'
    WHEN regexp_contains(product_sku, r'(04-BA-STELLA|WSTELL125|WSTELLA125).*(XSP|XS\/S|S\/M|M\/L|L\/XL|M\/L)') THEN 'Stella Jumpsuit SA DS'
    WHEN regexp_contains(product_sku, r'04-BA-STELLA-(MR|VV|DQ|CH|TM|DN|FG)-(XS|S|M|L|XL)$') THEN 'Stella Jumpsuit SA SS'
    WHEN regexp_contains(product_sku, r'STEV') THEN 'Steve Turtleneck SA'
    WHEN regexp_contains(product_sku, r'03-ALENA-(BK|WH|SGR|FG)') THEN 'Alena UTG DS'
    WHEN regexp_contains(product_sku, r'ALEN') THEN 'Alena SA DS'
    WHEN regexp_contains(product_sku, r'GRACE') THEN 'Grace Jumpsuit'
    WHEN regexp_contains(product_sku, r'LANA') THEN 'Lana Jumpsuit'
    WHEN regexp_contains(product_sku, r'SOPHIA') THEN 'Sophia Jumpsuit AB'
    WHEN regexp_contains(product_sku, r'MIA') THEN 'Mia Tshirt'
    WHEN regexp_contains(product_sku, r'(CHARLT|CHARLOTTE)') THEN 'Charlotte Bodysuit'
    WHEN regexp_contains(product_sku, r'EMMA') THEN 'Emma Bodysuit'
    WHEN regexp_contains(product_sku, r'(07|MICHELLE)-EC-(MICHEL-(BK|FD))?((XS|S|M|L|XL)-(FD|BK))?') THEN 'Michelle SJ'
    WHEN regexp_contains(product_sku, r'(07|MICHELLE)-ECR-(MICHEL-(BK|FD|RR|FG))?((XS|S|M|L|XL)-(FD|BK|RR|FG))?') THEN 'Michelle RIB'
    WHEN regexp_contains(product_sku, r'OLIVIA') THEN 'Olivia Hairband'
    WHEN regexp_contains(product_sku, r'ROBIN') THEN 'Robin Jumpsuit'
    WHEN regexp_contains(product_sku, r'PAULBELT') THEN 'Paul Belt'
    WHEN regexp_contains(product_sku, r'PAUL') THEN 'Paul Jumpsuit SA'
    WHEN regexp_contains(product_sku, r'AVA') THEN 'Ava Dress'
    WHEN regexp_contains(product_sku, r'VALERY') THEN 'Valery Scarf'
    WHEN regexp_contains(product_sku, r'MILEY') THEN 'Miley Mask'
    WHEN regexp_contains(product_sku, r'RUBY') THEN 'Ruby Scrunchie'
    WHEN regexp_contains(product_sku, r'JADE') THEN 'Jade Pants'
    WHEN regexp_contains(product_sku, r'ABBY') THEN 'Abby Longsleeve'
    WHEN regexp_contains(product_sku, r'CARA2') THEN 'Cara Jumpsuit DB'
    WHEN regexp_contains(product_sku, r'CARA') THEN 'Cara Jumpsuit AB'
    WHEN regexp_contains(product_sku, r'DAISY') THEN 'Daisy Tshirt'
    WHEN regexp_contains(product_sku, r'LILY') THEN 'Lily Top' 
    WHEN regexp_contains(product_sku, r'LOU') THEN 'Lou Top'
    WHEN regexp_contains(product_sku, r'BELLE') THEN 'Belle Pants'
    WHEN regexp_contains(product_sku, r'HARPER') THEN 'Harper Socks'
    WHEN regexp_contains(product_sku, r'HALEY') THEN 'Hayley Bag'
    
    WHEN regexp_contains(product_sku, r'APRIL') THEN 'April'
    WHEN regexp_contains(product_sku, r'02-BA-ROB') THEN 'Rob'
    
    ELSE product_sku END AS metabase_line_style_name
  , shipping_address_country
  , style
  , sc.size_ll  as size
  , color
  , items.category AS sku_category
  , CASE WHEN pm.category IS NULL THEN os.category ELSE pm.category END AS product_category
  
  ,CASE 
    WHEN regexp_contains(product_sku, r'LANA') THEN 'BA'
    WHEN regexp_contains(product_sku, r'PAUL') THEN 'BA'
    WHEN regexp_contains(product_sku, r'(04-BA-STELLA|WSTELL125|WSTELLA125).*(XSP|XS\/S|S\/M|M\/L|L\/XL|M\/L)') THEN 'BA'
    WHEN regexp_contains(product_sku, r'ALEN') THEN 'BA'
    WHEN regexp_contains(product_sku, r'STEV') THEN 'BA'
    WHEN regexp_contains(product_sku, r'ROBIN') THEN 'BA'
    ELSE material 
   END AS material

  , pm.active_vs_not_active 
  , SUM(CASE WHEN products_returned = "yes" THEN 1 ELSE 0 END)  AS items_returned
  , count(*) AS items_shipped
  , ordered_at
  , ordered_at_month
  , ordered_at_year
  , shop
  , CONCAT(ordered_at_year,'-',ordered_at_month) AS ordered_at_year_and_month
  , sum(one) AS too_big
  , sum(two) AS too_small
  , sum(three) AS too_long
  , sum(four) AS too_short
  , sum(five) AS quality_not_like_expected
  , sum(six) AS material_not_like_expected
  , sum(seven) AS fit_does_not_suit_me
  , sum(eight) AS damaged_defective
  , sum(nine) AS several_colors_or_sizes_ordered
  , sum(ten) AS article_differs_from_website
  , sum(eleven) AS late_delivery_wrong_item
  , sum(twelve) AS others
  , sum(one)+sum(two)+sum(three)+sum(four)+sum(five)+sum(six)+sum(seven)+sum(eight)+sum(nine)+sum(ten)+sum(eleven)+sum(twelve) AS all_reasons_count
FROM `leslunes-prep.returns.unique_returned_items` items
LEFT JOIN `leslunes-prep.gsheets.size-config` sc on sc.size_ll = size
LEFT JOIN `leslunes-prep.products.masterlist` pm on UPPER(pm.sku) = UPPER(product_sku)
LEFT JOIN `leslunes-raw.products.old_skus` os on UPPER(os.sku) = UPPER(product_sku)
GROUP BY 1,2,3,4,5,6,7,8,9,10,13,14,15,16
