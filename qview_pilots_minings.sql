CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_pilots_minings AS
  SELECT
    mains.main_pilot_name AS main_pilot_name,
    mine.date AS date,
    -- mine.ore_category_id,
    (SELECT DISTINCT category_name FROM qview_sde_standard_ores WHERE category_id = mine.ore_category_id) AS ore,
    mine.volume AS volume
  FROM
    qview_main_pilots AS mains,
    ( SELECT
        (SELECT main_pilot_id FROM qview_main_and_twin_ids WHERE cm.character_id = pilot_id) AS main_pilot_id,
        DATE(cm.date) AS date,
        SUM(cm.quantity * ore.volume) AS volume,
        ore.category_id AS ore_category_id
      FROM
        character_minings cm,
        qview_sde_standard_ores ore
      WHERE
        cm.type_id IN (SELECT type_id FROM qview_sde_standard_ores) AND
        cm.type_id = ore.type_id
      GROUP BY 1, 2, 4
    ) mine
  WHERE
    NOT (mine.main_pilot_id IS NULL) AND
    mains.main_pilot_id = mine.main_pilot_id;
