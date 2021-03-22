SELECT
  *
FROM
  {{ ref('stg_orders_it')}}
WHERE
  gift_card is not false
