CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_pilots_planetary_jobs AS
  SELECT
    pp.date,
    pp.main_pilot_id,
    (SELECT DISTINCT main_pilot_name FROM qview_main_pilots WHERE main_pilot_id = pp.main_pilot_id) AS main_pilot_name,
    pp.material_id,
    pp.quantity,
    -- 1034 = 2 => 01 => 10000001010 => 1010 => xx1x:1xx0
    -- 1040 = 3 => 10 => 10000010000 => 0000 => xx0x:0xx0
    -- 1041 = 4 => 11 => 10000010001 => 0001 => xx0x:0xx1
    -- 1042 = 1 => 00 => 10000010010 => 0010 => xx1x:0xx0
    ((t.groupID & b'0010') ^ b'0010') + ((t.groupID & b'1000') >> 3 | (t.groupID & b'0001')) + 1 AS tier_id,
    pp.quantity * t.volume AS volume,
    t.typeName as material_name,
    pp.quantity * (SELECT average_price FROM market_prices WHERE type_id=pp.material_id) AS today_price
  FROM
    ( SELECT
        ppp.date,
        ppp.main_pilot_id,
        ppp.material_id,
        SUM(ppp.quantity) AS quantity
      FROM (
        (SELECT
          DATE(cwt.date) AS date,
          (SELECT main_pilot_id FROM qview_main_and_twin_ids WHERE cwt.character_id = pilot_id) AS main_pilot_id,
          cwt.type_id AS material_id,
          SUM(cwt.quantity) AS quantity
        FROM
          character_wallet_transactions AS cwt,
          invTypes AS t,
          invGroups AS g
        WHERE
          cwt.date <= '2021-01-21' AND -- последний день, когда сдавалась планетарка по старой схеме
          cwt.unit_price = 0.01 AND
          cwt.is_buy = 0 AND
          t.typeID = cwt.type_id AND
          -- Basic Commodities - Tier 1
          -- Refined Commodities - Tier 2
          -- Specialized Commodities - Tier 3
          -- Advanced Commodities - Tier 4
          t.groupID = g.groupID AND
          -- Planetary Commodities
          g.categoryID = 43
        GROUP BY 1, 2, 3)
          UNION
        (SELECT
          DATE(cwt.date) AS date,
          p.main_pilot_id,
          cwt.type_id AS material_id,
          SUM(cwt.quantity) AS quantity
        FROM
          corporation_wallet_transactions cwt
            LEFT OUTER JOIN corporation_wallet_journals cwj ON (cwt.journal_ref_id = cwj.reference_id),
          invTypes AS t,
          invGroups AS g,
          qview_main_and_twin_ids p
        WHERE
          cwt.date >= '2021-04-22' AND -- начиная с этого дня планетарка сдаётся по новой схеме
          cwt.corporation_id IN (98677876) AND
          ( p.pilot_id = cwt.client_id AND cwt.is_buy = 1 OR
            p.pilot_id = cwj.second_party_id AND cwt.is_buy = 0
          ) AND
          t.typeID = cwt.type_id AND
          -- Basic Commodities - Tier 1
          -- Refined Commodities - Tier 2
          -- Specialized Commodities - Tier 3
          -- Advanced Commodities - Tier 4
          t.groupID = g.groupID AND
          -- Planetary Commodities
          g.categoryID = 43
        GROUP BY 1, 2, 3)
      ) ppp
      GROUP BY 1, 2, 3
    ) pp,
    invTypes AS t
  WHERE
    t.typeID = pp.material_id
  -- ORDER BY 1 DESC
  ;