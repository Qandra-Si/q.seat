CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_tracked_corporate_property AS
 SELECT
  t.typeName AS thing,
  name AS name,
  ei.main_pilot_name AS main_pilot,
  ei.pilot_name AS pilot,
  ei.in_ri4,
  ei.corp_ticker
 FROM
  seat.character_assets ch
   LEFT OUTER JOIN seat.invTypes AS t ON (t.typeID=ch.type_id),
  seat.qview_employment_interval ei
 where
  name LIKE '{corp%' AND
  ei.pilot_id=ch.character_id
 union
 SELECT 
  t.typeName,
  co.name,
  NULL,
  NULL,
  TRUE,
  ci.ticker
 FROM
  seat.corporation_assets co
   LEFT OUTER JOIN seat.invTypes AS t ON (t.typeID=co.type_id)
   LEFT OUTER JOIN seat.corporation_infos AS ci ON (ci.corporation_id=co.corporation_id) 
 WHERE
  co.name LIKE '{corp%' AND
  co.corporation_id IN (98677876,98553333,98615601,98650099,98400890); -- RIID,RI4,R ST,RI 5,DJEW
