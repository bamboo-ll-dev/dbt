SELECT
  *
FROM
  {{ ref('stg_orders_fr')}}
WHERE
  gift_card is not false
