CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_industry_stat_start_count AS
  SELECT
    -- cij.start_date,
   -- WEEKDAY(cij.start_date),
    HOUR(cij.start_date) AS hour,
    -- ROUND(AVG(cij.duration) / 60*60, 1)
    -- CEIL(cij.duration / (60*60)),
    COUNT(1) AS count,
    SUM(IF(cij.activity_id=1,1,0)) AS industry_count,
    SUM(IF(cij.activity_id in(3,4,5),1,0)) AS mete_count,
    SUM(IF(cij.activity_id=8,1,0)) AS invent_count,
    SUM(IF(cij.activity_id=9,1,0)) AS reaction_count
  FROM
    corporation_industry_jobs cij
  WHERE
    -- cij.activity_id = 1 AND
    cij.duration <= (60*60*24*7) AND -- 1.5 year stat: only 138 industry runs longer then 1 week
    cij.corporation_id in (98677876,98615601) AND -- RIID,RI4
    cij.status <> 'cancelled'
  GROUP BY 1 -- , 2 -- , 3
  -- ORDER BY 1 -- DESC -- 1, 2, 3
  ;
