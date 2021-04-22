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
  GROUP BY 1, 2, 3
    UNION
  SELECT
    cm.year AS year,
    cm.month AS month,
    'mercoxit' AS ore,
    ROUND(SUM(cm.quantity * ore.volume),0) AS volume
  FROM
    character_minings cm,
    qview_sde_mining_materials ore
  WHERE
    cm.type_id = ore.type_id AND
    ore.type_id IN (28412, 28414, 11396, 17870, 28413, 17869)
  GROUP BY 1, 2;
