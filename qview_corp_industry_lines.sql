CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_corp_industry_lines AS
  SELECT
    DATE(cij.end_date) AS end_date,
    cij.activity_id,
    COUNT(1) AS job_lines
  FROM
    corporation_industry_jobs cij
  WHERE
    cij.corporation_id in (98677876,98615601) AND -- RIID,RI4
    cij.status <> 'cancelled'
  GROUP BY 1, 2;