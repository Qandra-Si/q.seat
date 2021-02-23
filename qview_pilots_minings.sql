CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_pilots_minings AS
  SELECT
    mine.main_pilot_id,
    mine.date,
    mine.ore,
    mine.volume AS volume,
    ci.name AS main_pilot_name
  FROM
    ( SELECT
        ei.main_pilot_id,
        stat.date,
        stat.ore,
        SUM(stat.volume) AS volume
      FROM  
        ( SELECT
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
        qview_employment_interval AS ei
      WHERE
        ei.pilot_id = stat.pilot_id AND
        ei.enter_time <= stat.date AND IF(gone_time IS NULL,TRUE,stat.date <= ei.gone_time) 
      GROUP BY 1, 2, 3
    ) mine,
    character_infos ci
  WHERE ci.character_id = mine.main_pilot_id
  -- ORDER BY 2 DESC
  ;
