CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_ntt_goal AS
  SELECT
    t.typeName AS type_name,
    (SELECT IF(average_price=0,NULL,ROUND(average_price,0)) FROM market_prices WHERE t.typeID = type_id) AS price
  FROM
    invTypes t,
    invGroups g
  WHERE
    t.groupID = g.groupID AND
    g.categoryID = 6 AND -- Ship
    t.published AND
    CONCAT(t.typeName, ' Blueprint') IN (SELECT typeName FROM invTypes WHERE published) AND
    t.typeID NOT IN (SELECT product_type_id FROM corporation_industry_jobs) AND
    t.typeID NOT IN (SELECT product_type_id FROM character_industry_jobs)
  -- ORDER BY 1
  ;