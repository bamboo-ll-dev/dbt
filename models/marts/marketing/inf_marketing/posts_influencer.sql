SELECT * 
EXCEPT (_sdc_received_at,_sdc_sequence, row_number, id, _sdc_extracted_at, assigned_coupon_id,	_sdc_batched_at	,influencer_id, created_at, primary_shop_id, _sdc_table_version, updated_at),
(SELECT max(full_name) FROM `leslunes-raw.unlooped.user` u WHERE p.manager_at_time_of_start_id = u.id) AS manager,
(SELECT SHOP from `leslunes-raw.unlooped.shops` s  WHERE SAFE_CAST(p.shop_id AS STRING) = s.ID) AS shop
FROM {{ref('stg_influencer_posts')}} p
JOIN {{ref('stg_influencer')}} i on p.influencer_id = i.id 


