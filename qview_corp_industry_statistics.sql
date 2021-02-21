CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_corp_industry_statistics AS
  SELECT
    end_date,
    industry_duration,
    mete_duration,
    invention_duration,
    reaction_duration
  FROM qview_corp_industry_plain
  GROUP BY 1
  -- ORDER BY end_date DESC
  ;