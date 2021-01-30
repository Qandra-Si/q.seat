CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_mining_leaders AS
  SELECT
    STR_TO_DATE(CONVERT(max.year*10000+max.month*100+1,char),'%Y%m%d') AS date,
    max.year,
    max.month,
    max.volume,
    pmv.main_pilot_id,
    ci.name AS main_pilot_name
  FROM
    ( SELECT year, month, MAX(volume) AS volume
      FROM qview_pilots_mine_volumes
      GROUP BY 1, 2) max,
    qview_pilots_mine_volumes pmv,
    character_infos ci
  WHERE
    max.year = pmv.year AND
    max.month = pmv.month AND
    max.volume = pmv.volume AND
    ci.character_id = pmv.main_pilot_id;
