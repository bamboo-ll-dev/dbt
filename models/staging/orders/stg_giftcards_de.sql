SELECT
  *
FROM
  {{ ref('stg_orders_de')}}
WHERE
  gift_card is not false
