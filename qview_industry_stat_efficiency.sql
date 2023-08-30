SELECT
  jobs.end_date,
  jobs.installer_id,
  ci.name,
  jobs.activity_id,
  -- TIMEDIFF(jobs.end_date, jobs.start_date) AS diff,
  jobs.duration,
  -- SEC_TO_TIME(SUM(jobs.duration)) AS time,
  pl.main_pilot_id,
  IF(jobs.activity_id=1,pl.industry_lines,IF(jobs.activity_id=9,pl.reaction_lines,pl.science_lines)) AS active_lines
FROM
  character_infos ci,
  ( SELECT
      DATE(cij.end_date) AS end_date,
      cij.installer_id,
      cij.activity_id,
      SUM(cij.duration) AS duration
    FROM corporation_industry_jobs cij
    WHERE cij.corporation_id in (98677876,98615601,98400890) -- RIID,RI4,DJEW
    GROUP BY 1, 2, 3
  ) jobs,
  ( SELECT
      ps.pilot_id,
      ps.main_pilot_id,
      1 + IFNULL(ps.mp,0) + IFNULL(ps.amp,0) AS industry_lines,
      IFNULL(ps.lo,0) + IFNULL(ps.alo,0) AS science_lines,
      IFNULL(ps.mr,0) + IFNULL(ps.amr,0) AS reaction_lines
    FROM
      ( SELECT
          p.pilot_id,
          p.main_pilot_id,
          (SELECT active_skill_level FROM character_skills WHERE p.pilot_id = character_id AND skill_id = 3387) AS mp, -- Mass Production
          (SELECT active_skill_level FROM character_skills WHERE p.pilot_id = character_id AND skill_id = 24625) AS amp, -- Advanced Mass Production
          (SELECT active_skill_level FROM character_skills WHERE p.pilot_id = character_id AND skill_id = 3406) AS lo, -- Laboratory Operation
          (SELECT active_skill_level FROM character_skills WHERE p.pilot_id = character_id AND skill_id = 24624) AS alo, -- Advanced Laboratory Operation
          (SELECT active_skill_level FROM character_skills WHERE p.pilot_id = character_id AND skill_id = 45748) AS mr, -- Mass Reactions
          (SELECT active_skill_level FROM character_skills WHERE p.pilot_id = character_id AND skill_id = 45749) AS amr -- Advanced Mass Reactions
        FROM qview_main_and_twin_ids p
      ) ps -- pilots with skills
  ) pl -- pilots with lines
WHERE
  -- jobs.activity_id = 1 AND
  pl.pilot_id = jobs.installer_id AND
  ci.character_id = jobs.installer_id
ORDER BY 1 DESC
  