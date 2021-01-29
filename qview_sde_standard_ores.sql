CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_sde_standard_ores AS
  SELECT
    t.typeID AS type_id,
    t.typeName AS name,
    t.volume AS volume,
    mg.marketGroupID AS category_id,
    mg.marketGroupName AS category_name,
    (t.typeName LIKE 'Compressed %') AS compressed
  FROM
    invMarketGroups mg,
    invTypes t
  WHERE
    mg.parentGroupID = 54 AND -- Standard Ores: Arkonor, Veldspar, ...
    t.marketGroupID = mg.marketGroupID;