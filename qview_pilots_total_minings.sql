CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_pilots_total_minings AS
  SELECT
   ci.name AS main_pilot_name,
   -- mine.main,
   mine.ore,
   CEIL(mine.v) AS volume
  FROM (
    SELECT
     tot.main_pilot_id AS main,
     IF(tot.type_id IN (28412, 28414, 11396, 17870, 28413, 17869), 'mercoxit', mm.class_tag) AS ore,
     SUM(mm.volume * tot.q) AS v
    FROM (
      SELECT
       ei.main_pilot_id,
       m.type_id,
       SUM(m.quantity) as q
      FROM
       seat.qview_employment_interval ei,
       seat.character_minings m
      WHERE
       ei.in_ri4 AND
       ei.pilot_id = m.character_id
      GROUP BY 1, 2
     ) AS tot,
     seat.qview_sde_mining_materials mm
    WHERE mm.type_id = tot.type_id
    GROUP BY 1, 2
    ) AS mine,
    character_infos ci
  WHERE ci.character_id = mine.main
;