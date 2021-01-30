CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_pilots_minings AS
  SELECT
    mine.main_pilot_id,
    mine.date,
    mine.ore,
    mine.volume AS volume,
    ci.name AS main_pilot_name
  FROM
    ( SELECT
        mains.main_pilot_id,
        stat.date,
        stat.ore,
        SUM(stat.volume) AS volume
      FROM  
        ( SELECT
            -- COALESCE(
            --   (SELECT main_pilot_id FROM qview_main_and_twin_ids WHERE cm.character_id = pilot_id)
            -- ,cm.character_id) AS main_pilot_id,
            cm.character_id AS pilot_id,
            DATE(cm.date) AS date,
            ore.class_tag AS ore,
            SUM(cm.quantity * ore.volume) AS volume
          FROM
            character_minings cm,
            qview_sde_mining_materials ore
          WHERE
            cm.type_id = ore.type_id
          GROUP BY 1, 2, 3
        ) stat,
        qview_main_and_twin_ids AS mains
      WHERE mains.pilot_id = stat.pilot_id
      GROUP BY 1, 2, 3
    ) mine,
    character_infos ci
  WHERE
    ci.character_id = mine.main_pilot_id;
