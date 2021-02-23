CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_corp_industry_statistics AS
  SELECT
    end_date,
    SUM(industry_duration) AS industry_duration,
    SUM(mete_duration) AS mete_duration,
    SUM(invention_duration) AS invention_duration,
    SUM(reaction_duration) AS reaction_duration
  FROM qview_corp_industry_plain
  GROUP BY 1
  -- ORDER BY end_date DESC
  ;