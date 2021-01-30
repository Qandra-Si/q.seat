CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_mining_statistics AS
  SELECT
    cm.year AS year,
    cm.month AS month,
    ore.class_tag AS ore,
    ROUND(SUM(cm.quantity * ore.volume),0) AS volume
  FROM
    character_minings cm,
    qview_sde_mining_materials ore
  WHERE
    cm.type_id = ore.type_id
  GROUP BY 1, 2, 3;
