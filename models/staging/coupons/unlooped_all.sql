SELECT 
c.code
,c.value
,c.fixedAmount
,c.type
,c.startsAt
,c.endsAt
,c.influencerfullName
,c.influencerUsernamesAsString
,c.totalRevenueNet
,c.appliedCount
,(SELECT MAX(source) from `leslunes-raw.deals.deals_data` where UPPER(coupon_code) = UPPER(c.code)) as source
,c.db_entry_created_at
FROM `leslunes-raw.deals.coupons` c
