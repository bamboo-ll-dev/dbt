SELECT
  user_email,
  job_type,
  project_id,
  SAFE_DIVIDE(SUM(total_bytes_processed), 1000000000) AS gigabytes_processed,
  SAFE_DIVIDE(SUM(total_bytes_processed), 1000000000000)*6.5 AS cost_estimate
FROM
  `region-eu`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
GROUP BY
  user_email,
  job_type,
  project_id
ORDER BY
  gigabytes_processed DESC