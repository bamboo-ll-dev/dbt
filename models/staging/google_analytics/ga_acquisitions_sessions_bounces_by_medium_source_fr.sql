SELECT
  CAST(start_date as DATE) as date
  ,ga_acquisitionmedium
  ,ga_acquisitionsource
  ,ga_acquisitiontrafficchannel
  ,ga_sessions
  ,ga_bouncerate 
  ,ga_pageviewspersession
  ,ga_avgsessionduration	
FROM `leslunes-raw.google_analytics_fr.Acquisition_Overview`