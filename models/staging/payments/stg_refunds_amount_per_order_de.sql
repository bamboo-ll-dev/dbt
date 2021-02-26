SELECT
  * EXCEPT(rn)
FROM (
  SELECT
    order_id,
    amount,
    created_at,
    ROW_NUMBER() OVER (PARTITION BY id ORDER BY _sdc_batched_at DESC) AS rn
  FROM
    {{ source('refunds_de', 'transactions') }}
  WHERE
    kind='refund'
    AND status='success') AS refunds
WHERE
  rn=1