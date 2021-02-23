WITH coupons AS(
SELECT 
    code
    ,value
    ,fixedAmount
    ,type
    ,startsAt
    ,endsAt
    ,influencerfullName
    ,SPLIT(influencerUsernamesAsString, " / ")[SAFE_OFFSET(0)] AS influencerUsernamesAsString
    ,SPLIT(influencerUsernamesAsString, " / ")[SAFE_OFFSET(1)] AS follower
    ,totalRevenueNet
    ,appliedCount
    ,(SELECT MAX(source) from `leslunes-raw.deals.deals_data` where UPPER(coupon_code) = UPPER(code)) AS source
    ,db_entry_created_at
FROM 
    `leslunes-raw.deals.coupons`
)

SELECT 
    *,   
    CASE 
        WHEN influencerfullName = 'leslunes.de' THEN 'OWN_IG'
        WHEN influencerfullName = 'leslunes.fr' THEN 'OWN_IG_FR'
        WHEN influencerfullName = 'leslunes.it' THEN 'OWN_IG_IT'
        WHEN UPPER(influencerfullName) LIKE '%LES LUNES CUSTOMER CARE%' THEN 'CS'
        WHEN UPPER(influencerfullName) LIKE '%LESLUNES NEWSLETTER%' THEN 'NL'
        WHEN UPPER(influencerfullName) LIKE '%LL FR NL%' THEN 'NL_FR'
        WHEN UPPER(influencerfullName) = 'FACEBOOK DE' THEN 'FB'
        WHEN UPPER(influencerfullName) = 'FACEBOOK FR' THEN 'FB_FR'
        WHEN UPPER(influencerfullName) = 'FACEBOOK IT' THEN 'FB_IT'
        WHEN influencerfullName IS NULL THEN 'UNKNOWN' 
        ELSE 'SMM'
    END AS code_type
FROM coupons
