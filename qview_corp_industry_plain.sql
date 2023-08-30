CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_corp_industry_plain AS
  SELECT
    j.installer_id,
    j.end_date,
    ROUND(SUM(IF(j.activity_id=1,j.duration,0))/3600,0) AS industry_duration, -- hours
    ROUND(SUM(IF(j.activity_id in(3,4,5),j.duration,0))/3600,0) AS mete_duration, -- hours
    ROUND(SUM(IF(j.activity_id=8,j.duration,0))/3600,0) AS invention_duration, -- hours
    ROUND(SUM(IF(j.activity_id=9,j.duration,0))/3600,0) AS reaction_duration, -- hours
    SUM(IF(j.activity_id=1,j.jobs,0)) AS industry_jobs,
    SUM(IF(j.activity_id in(3,4,5),j.jobs,0)) AS mete_jobs,
    SUM(IF(j.activity_id=8,j.jobs,0)) AS invention_jobs,
    SUM(IF(j.activity_id=9,j.jobs,0)) AS reaction_jobs
  FROM
    ( SELECT
        installer_id,
        DATE(end_date) AS end_date,
        activity_id,
        SUM(duration) AS duration, -- sec
        COUNT(1) AS jobs
      FROM
        corporation_industry_jobs
      WHERE
        corporation_id in (98677876,98615601,98400890) AND -- RIID,RI4,DJEW
        status <> 'cancelled'
      GROUP BY 1, 2, 3
    ) j
  GROUP BY 1, 2, j.activity_id
  -- ORDER BY j.end_date DESC
  ;