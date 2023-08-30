CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_corp_orders AS
  SELECT
    o.buy,
    o.ticker,
    o.wallet_division,
    o.type_name,
    o.volume_remain,
    o.volume_total,
    o.price,
    -- o.system_id,
    (SELECT name FROM solar_systems WHERE system_id=o.system_id) AS system_name
  FROM
    ( SELECT
        -- co.is_buy_order,
        IFNULL(co.is_buy_order,0) AS buy,
        (SELECT ticker FROM corporation_infos WHERE corporation_id=co.corporation_id) AS ticker,
        co.wallet_division,
        t.typeName AS type_name,
        co.volume_remain,
        co.volume_total,
        co.price,
        -- co.location_id,
        IF(co.location_id<100000000,
           (SELECT system_id FROM universe_stations WHERE station_id = co.location_id),
           (SELECT solar_system_id FROM universe_structures us WHERE structure_id = co.location_id)) AS system_id
        -- co.updated_at
        -- , co.*
      FROM
        (SELECT corporation_id, MAX(updated_at) AS time FROM corporation_orders GROUP BY 1) AS active,
        corporation_orders co,
        invTypes t
      WHERE
        co.corporation_id in (98677876,98553333,98615601,98650099,98400890) AND -- 'RIID', 'RI4', 'R ST', 'RI 5', 'DJEW'
        active.corporation_id = co.corporation_id AND
        t.typeID = co.type_id AND
        co.updated_at >= active.time
    ) o
  -- ORDER BY co.issued DESC
  ;