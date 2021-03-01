WITH 
returns_de AS(
SELECT *
FROM  {{ref('stg_returns_de')}} 
),

returns_fr AS(
SELECT * 
FROM  {{ref('stg_returns_fr')}} 
),


returns_it AS(
SELECT * 
FROM  {{ref('stg_returns_it')}} 
),

returns_xentral AS(
SELECT * 
FROM  {{ref('stg_returns_xentral')}} 
)


SELECT * 
    , "DE" as zenf_source_acct
FROM returns_de

UNION ALL
SELECT * 
    , "FR" as zenf_source_acct
FROM returns_fr

UNION ALL
SELECT * 
    , "IT" as zenf_source_acct
FROM returns_it

UNION ALL
SELECT * 
    , "IT" as zenf_source_acct
FROM returns_xentral




