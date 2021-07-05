SELECT DISTINCT
    email,
    TO_BASE64(MD5(UPPER(email))) AS uppercase_email_hash
 FROM {{source('shopify_de', 'orders')}}