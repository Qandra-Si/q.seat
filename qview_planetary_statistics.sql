CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_planetary_statistics AS
  SELECT
    pj.date,
    pj.main_pilot_id,
    pj.main_pilot_name,
    pj.tier_id,
    SUM(pj.quantity) AS quantity,
    SUM(pj.volume) AS volume
  FROM
    qview_pilots_planetary_jobs pj
  GROUP BY 1, 2, 3
  -- ORDER BY 1 DESC
  ;