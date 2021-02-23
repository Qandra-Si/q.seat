CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_pilots_mine_volumes AS
  SELECT
    stat.main_pilot_id,
    stat.year,
    stat.month,
    ROUND(SUM(stat.quantity * ore.volume),0) AS volume
  FROM
    ( SELECT
        ei.main_pilot_id AS main_pilot_id,
        cm.year,
        cm.month,
        SUM(cm.quantity) AS quantity,
        cm.type_id
      FROM
        character_minings cm,
        qview_employment_interval AS ei
      WHERE
        ei.pilot_id = cm.character_id AND
        ei.enter_time <= cm.date AND IF(gone_time IS NULL,TRUE,cm.date <= ei.gone_time)
      GROUP BY 1, 2, 3, 5
    ) stat,
    qview_sde_mining_materials ore
  WHERE
    ore.type_id = stat.type_id
  GROUP BY 1, 2, 3;
