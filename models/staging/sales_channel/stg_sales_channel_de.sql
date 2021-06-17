SELECT 
  transaction_id,
  order_created_at,
  o.code,
  value,
  fixedAmount,
  type,
  startsAt,
  endsAt,
  influencerfullName,
  influencerUsernamesAsString,
  follower,
  totalRevenueNet,
  appliedCount,
  c.source,
  db_entry_created_at,
  code_type
FROM {{ ref('stg_orders_combined')}} o 
LEFT JOIN {{ ref('coupons') }} c ON UPPER(c.code) = UPPER(o.code) --AND DATETIME(o.created_at) BETWEEN c.startsAt AND c.endsAt
--WHERE UPPER(o.code) = "HIELENA40"
AND endsAt is null