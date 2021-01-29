CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW seat.qview_capital_constructors AS
  SELECT
    qei.pilot_name,
    qei.main_pilot_name,
    qei.corp_ticker,
    sl.skill_id,
    (SELECT name FROM seat.qview_capital_construction_skills WHERE id=sl.skill_id) AS skill_name,
    sl.active_skill_level
  FROM
    seat.qview_employment_interval AS qei,
    ( SELECT
        skill_id,
        active_skill_level,
        character_id
      FROM character_skills
      WHERE skill_id IN (SELECT id FROM seat.qview_capital_construction_skills)
    ) AS sl
  WHERE
    qei.in_ri4 AND
    qei.pilot_id = sl.character_id;