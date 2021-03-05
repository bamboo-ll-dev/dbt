SELECT 
    SAFE_CAST(Datum AS DATE) AS Datum
    ,Internet
    ,Status
    ,Name
    ,Belegnr
    ,Bezeichnung	
    ,Nummer
    ,Internetseite
    ,Bearbeiter
FROM {{ source('xentral', 'influencer_orders') }}