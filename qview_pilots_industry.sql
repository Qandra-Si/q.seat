CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_pilots_industry AS
  SELECT
    -- mp.pilot_id,
    -- mp.main_pilot_id,
    -- mp.pilot_name,
    mp.main_pilot_name,
    stat.end_date,
    COUNT(DISTINCT stat.installer_id) AS workers_count,
    SUM(stat.industry_duration) AS industry_duration,
    SUM(stat.mete_duration) AS mete_duration,
    SUM(stat.invention_duration) AS invention_duration,
    SUM(stat.reaction_duration) AS reaction_duration,
    SUM(stat.industry_jobs) AS industry_jobs,
    SUM(stat.mete_jobs) AS mete_jobs,
    SUM(stat.invention_jobs) AS invention_jobs,
    SUM(stat.reaction_jobs) AS reaction_jobs
  FROM
    qview_corp_industry_plain stat,
    qview_main_pilots mp
  WHERE
    stat.installer_id = mp.pilot_id
  GROUP BY mp.main_pilot_id, stat.end_date;