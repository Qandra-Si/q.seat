CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_pilots_mine_types AS
  SELECT
    stat.year,
    stat.month,
    stat.main_pilot_name,
    solar_names.itemName as "solar system",
    t.typeName as "name",
    ROUND(SUM(stat.quantity * ore.volume),0) AS volume
  FROM
    ( SELECT
        ei.main_pilot_name AS main_pilot_name,
        cm.year,
        cm.month,
        cm.solar_system_id,
        SUM(cm.quantity) AS quantity,
        cm.type_id
      FROM
        character_minings cm,
        qview_employment_interval AS ei
      WHERE
        ei.pilot_id = cm.character_id AND
        ei.enter_time <= cm.date AND IF(gone_time IS NULL,TRUE,cm.date <= ei.gone_time)
      GROUP BY 1, 2, 3, 4, 6
    ) stat,
    qview_sde_mining_materials ore,
    invTypes t,
    invNames solar_names
  WHERE
    ore.type_id = stat.type_id AND
    t.typeID = stat.type_id AND
    solar_names.itemID = stat.solar_system_id
  GROUP BY 1, 2, 3, 4, 5
  ORDER BY 1 DESC, 2 DESC, 3, 4, 5;
