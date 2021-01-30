CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_pilots_mine_volumes AS
  SELECT
    mains.main_pilot_id,
    stat.year,
    stat.month,
    ROUND(SUM(stat.quantity * ore.volume),0) AS volume
  FROM
    ( SELECT
        -- COALESCE(
        --  (SELECT main_pilot_id FROM qview_main_and_twin_ids WHERE cm.character_id = pilot_id)
        -- ,cm.character_id) AS main_pilot_id,
        cm.character_id AS pilot_id,
        cm.year,
        cm.month,
        SUM(cm.quantity) AS quantity,
        cm.type_id
      FROM
        character_minings cm
      GROUP BY 1, 2, 3, 5
    ) stat,
    qview_sde_mining_materials ore,
    qview_main_and_twin_ids AS mains
  WHERE
    ore.type_id = stat.type_id AND
    mains.pilot_id = stat.pilot_id
  GROUP BY 1, 2, 3;
