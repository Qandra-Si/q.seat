CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_industry_stat_t2 AS
  SELECT
    a.end_date,
    a.ship_count AS ship_count,
    CEILING(a.module_count/50) AS module_fifties,
    CEILING(a.charge_count/5000) AS charge_five_thousands,
    CEILING(a.drone_count/10) AS drone_dozens,
    a.fighter_count AS fighter_count
  FROM
    ( SELECT
        DATE(cij.end_date) AS end_date,
        -- cij.product_type_id AS t2_type_id,
        -- c.categoryName AS category_name,
        -- g.groupName AS group_name,
        -- , mt.parentTypeID AS t1_type_id
        -- SUM(cij.runs * t.portionSize) AS produced,
        -- 6   Ship (avg=46.6)
        -- 7   Module (avg=1755.7)
        -- 8   Charge (avg=208139.3)
        -- 18  Drone (avg=928.4)
        -- 87  Fighter (avg=119.9)
        SUM(IF(c.categoryID=6,cij.runs*t.portionSize,0)) AS ship_count,
        SUM(IF(c.categoryID=7,cij.runs*t.portionSize,0)) AS module_count,
        SUM(IF(c.categoryID=8,cij.runs*t.portionSize,0)) AS charge_count,
        SUM(IF(c.categoryID=18,cij.runs*t.portionSize,0)) AS drone_count,
        SUM(IF(c.categoryID=87,cij.runs*t.portionSize,0)) AS fighter_count
      FROM
        corporation_industry_jobs cij,
        invMetaTypes mt,
        invTypes t,
        invGroups g,
        invCategories c
      WHERE
        cij.product_type_id = mt.typeID AND cij.product_type_id = t.typeID AND
        mt.metaGroupID = 2 AND
        cij.activity_id = 1 AND
        cij.corporation_id in (98677876,98615601,98400890) AND -- RIID,RI4,DJEW
        t.groupID = g.groupID AND
        g.categoryID = c.categoryID
        -- AND c.categoryName NOT IN ('Module','Drone','Ship','Charge','Fighter')
      GROUP BY 1 -- , c.categoryID
    ) a
  GROUP BY 1
  -- ORDER BY 1 DESC
  ;
