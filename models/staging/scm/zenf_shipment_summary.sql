SELECT
Auftrag_Nr
,Bestell_Nr
,Mandant
,Mandant_ID
,
CASE 
  WHEN REGEXP_CONTAINS(Abgeschlossen_um_Auftrag, r'\d{1,2}.\d{1,2}.20\d\d\s\d\d:\d\d')
    THEN PARSE_TIMESTAMP("%d.%m.%Y %T" , Abgeschlossen_um_Auftrag)
 WHEN REGEXP_CONTAINS(Abgeschlossen_um_Auftrag, r'^(\d{1,2}.\d{1,2}.)21')
  THEN PARSE_TIMESTAMP("%d.%m.%Y %H:%M" , regexp_replace(Abgeschlossen_um_Auftrag, r'^(\d{1,2}.\d{1,2}.)21', '\\12021'))
END AS  Abgeschlossen_um_Auftrag
,Zielland
,CASE 
  WHEN REGEXP_CONTAINS(Uebernahmezeitpunkt, r'\d{1,2}.\d{1,2}.20\d\d\s\d\d:\d\d')
    THEN PARSE_TIMESTAMP("%d.%m.%Y %T" , Uebernahmezeitpunkt)
 WHEN REGEXP_CONTAINS(Uebernahmezeitpunkt, r'^(\d{1,2}.\d{1,2}.)21')
  THEN PARSE_TIMESTAMP("%d.%m.%Y %H:%M" , regexp_replace(Uebernahmezeitpunkt, r'^(\d{1,2}.\d{1,2}.)21', '\\12021'))
END AS  Uebernahmezeitpunkt
,Letzte_Batchlaufnr
,CASE 
  WHEN REGEXP_CONTAINS(Geplant_um, r'\d{1,2}.\d{1,2}.20\d\d\s\d\d:\d\d')
    THEN PARSE_TIMESTAMP("%d.%m.%Y %T" , Geplant_um)
 WHEN REGEXP_CONTAINS(Geplant_um, r'^(\d{1,2}.\d{1,2}.)21')
  THEN PARSE_TIMESTAMP("%d.%m.%Y %H:%M" , regexp_replace(Geplant_um, r'^(\d{1,2}.\d{1,2}.)21', '\\12021'))
END AS  Geplant_um
,PaketNr
,Verpackungsmaterial
,Spedition
,Versandoption
,Sendungsnummer
,CASE 
  WHEN REGEXP_CONTAINS(Gedruckt_Um, r'\d{1,2}.\d{1,2}.20\d\d\s\d\d:\d\d')
    THEN PARSE_TIMESTAMP("%d.%m.%Y %T" , Gedruckt_Um)
 WHEN REGEXP_CONTAINS(Gedruckt_Um, r'^(\d{1,2}.\d{1,2}.)21')
  THEN PARSE_TIMESTAMP("%d.%m.%Y %H:%M" , regexp_replace(Gedruckt_Um, r'^(\d{1,2}.\d{1,2}.)21', '\\12021'))
END AS  Gedruckt_Um
,Artikelnr_Zen
,Artikelnr_Kunde
,SKU
,Artikeltext
,SAFE_CAST(REPLACE(Gewicht,",", ".") AS FLOAT64) AS Gewicht
,SAFE_CAST(Menge AS INT64) AS Menge
,Packplatz
,CASE 
  WHEN REGEXP_CONTAINS(Kommissioniert_Um, r'\d{1,2}.\d{1,2}.20\d\d\s\d\d:\d\d')
    THEN PARSE_TIMESTAMP("%d.%m.%Y %T" , Kommissioniert_Um)
 WHEN REGEXP_CONTAINS(Kommissioniert_Um, r'^(\d{1,2}.\d{1,2}.)21')
  THEN PARSE_TIMESTAMP("%d.%m.%Y %H:%M" , regexp_replace(Kommissioniert_Um, r'^(\d{1,2}.\d{1,2}.)21', '\\12021'))
END AS  Kommissioniert_Um
FROM `leslunes-raw.zenfulfillment.shipment_summary`

