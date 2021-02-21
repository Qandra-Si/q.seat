CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_corp_industry AS
  SELECT
    -- ep.pilot_id,
    -- ep.main_pilot_id,
    -- ep.pilot_name,
    -- ep.main_pilot_name,
    cij.installer_id,
    -- DATE(cij.start_date) AS start_date,
    DATE(cij.end_date) AS end_date,
    cij.activity_id,
    SUM(cij.duration) AS duration_sec -- sec
  FROM
    corporation_industry_jobs cij
    -- , qview_employment_interval ep
  WHERE
    cij.corporation_id = 98615601 AND -- RI4
    -- cij.installer_id = ep.pilot_id AND
    -- ep.in_ri4 AND -- blame: ((cij.end_date IS NULL) OR (cij.end_date <= pilot.end_date)) AND
    cij.status <> 'cancelled'
  GROUP BY 1, 2;