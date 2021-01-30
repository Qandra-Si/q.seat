CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_mining_statistics_plain AS
  SELECT
    STR_TO_DATE(CONVERT(d.y*10000+d.m*100+1,char),'%Y%m%d') AS date,
    d.y AS year,
    d.m AS month,
    (SELECT volume FROM qview_mining_statistics WHERE year=d.y AND month=d.m AND ore='ore') AS ore,
    (SELECT volume FROM qview_mining_statistics WHERE year=d.y AND month=d.m AND ore='moon') AS moon,
    (SELECT volume FROM qview_mining_statistics WHERE year=d.y AND month=d.m AND ore='ice') AS ice,
    (SELECT volume FROM qview_mining_statistics WHERE year=d.y AND month=d.m AND ore='gas') AS gas,
    (SELECT volume FROM qview_mining_statistics WHERE year=d.y AND month=d.m AND ore='abyss') AS abyss
  FROM
    (SELECT DISTINCT year AS y, month AS m FROM character_minings) d;
