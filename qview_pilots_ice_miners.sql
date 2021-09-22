CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_pilots_ice_miners AS
  SELECT
    mine.date,
    ci.name AS main_pilot_name,
    solar_names.itemName as "solar system",
    t.typeName as ice,
    mine.volume AS volume
  FROM
    ( SELECT
        ei.main_pilot_id,
        stat.date,
        stat.ice_type_id,
        stat.solar_system_id,
        SUM(stat.volume) AS volume
      FROM  
        ( SELECT
            cm.character_id AS pilot_id,
            DATE(cm.date) AS date,
            ore.type_id AS ice_type_id,
            cm.solar_system_id,
            SUM(cm.quantity * ore.volume) AS volume
          FROM
            character_minings cm,
            qview_sde_mining_materials ore
          WHERE
            cm.type_id = ore.type_id AND
            ore.class_tag = 'ice'
          GROUP BY 1, 2, 3, 4
        ) stat,
        qview_employment_interval AS ei
      WHERE
        ei.pilot_id = stat.pilot_id AND
        ei.enter_time <= stat.date AND IF(gone_time IS NULL,TRUE,stat.date <= ei.gone_time) 
      GROUP BY 1, 2, 3, 4
    ) mine,
    character_infos ci,
    invTypes t,
    invNames solar_names
  WHERE
    ci.character_id = mine.main_pilot_id AND
    mine.ice_type_id = t.typeID AND
    solar_names.itemID = mine.solar_system_id
  ORDER BY 1 DESC, 2, 3
  ;
