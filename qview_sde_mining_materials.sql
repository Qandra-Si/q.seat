CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_sde_mining_materials AS
  -- parent  id    name                   rus                                 ore/gas
  -- 533     1032  Gas Clouds Materials   Продукты переработки газа
  --  1032   983   Booster Gas Clouds      Газы для производства стимуляторов Amber Mykoserocin, Azure Mykoserocin, Celadon Mykoserocin, ...
  --  1032   1859  Fullerenes              Фуллерены                          Fullerite-C540, Fullerite-C320, Fullerite-C28, ...
  -- 533     1031  Raw Materials          Сырьевые материалы
  --  1031   1855   Ice Ores               Ледяные руды                       Clear Icicle, Glacial Mass, Blue Ice, ...
  --  1031   2479   Abyssal Materials      Материалы бездны                   Crystalline Isogen-10, Zero-Point Condensate
  --  1031   1856   Alloys & Compounds     Сплавы и композиты                 Glossy Compound, Plush Compound, Lustering Alloy, ...
  --  1031   2395   Moon Ores              Руды со спутников
  --   2395  2396    Ubiquitous Moon Ores   Повсеместные руды со спутников    Zeolites, Sylvite, Coesite, ...
  --   2395  2397    Common Moon Ores       Обычные руды со спутников         Cobaltite, Titanite, Euxenite, ...
  --   2395  2398    Uncommon Moon Ores     Необычные руды со спутников       Otavite, Vanadinite, Chromite, ...
  --   2395  2400    Rare Moon Ores         Редкие руды со спутников          Carnotite, Zircon, Pollucite, ...
  --   2395  2401    Exceptional Moon Ores  Исключительные руды со спутников  Xenotime, Monazite, Loparite, ...
  --  1031   54     Standard Ores          Стандартные руды
  --    54   512     Arkonor                Арконор                           Arkonor, Crimson Arkonor, ...
  --    54   514     Bistot                 Бистот                            Bistot, Triclinic Bistot, ...
  --    54   515     Pyroxeres
  --    54   516     Plagioclase
  --    54   517     Spodumain
  --    54   518     Veldspar
  --    54   519     Scordite
  --    54   521     Crokite
  --    54   522     Dark Ochre
  --    54   523     Kernite
  --    54   525     Gneiss
  --    54   526     Omber
  --    54   527     Hedbergite
  --    54   528     Hemorphite
  --    54   529     Jaspet
  --    54   530     Mercoxit
  --    54   2538    Bezdnacine
  --    54   2539    Rakovene
  --    54   2540    Talassonite
SELECT
    mg.parentGroupID AS class_id,
    mg.marketGroupID AS category_id,
    t.typeID AS type_id,
    IF(mg.parentGroupID=54,'ore','moon') AS class_tag,
    mg.marketGroupName AS category_name,
    t.typeName AS name,
    t.volume AS volume
    -- , (t.typeName LIKE 'Compressed %') AS compressed
  FROM
    invMarketGroups mg,
    invTypes t
  WHERE
    mg.parentGroupID IN (54,2395) AND -- 54:Standard Ores, 2395:Moon Ores
    t.marketGroupID = mg.marketGroupID
  union
  SELECT
    t.marketGroupID AS class_id,
    t.marketGroupID AS category_id,
    t.typeID AS type_id,
    IF(t.marketGroupID=1855,'ice',IF(t.marketGroupID=1856,'ac',IF(t.marketGroupID IN (1859,983),'gas','abyss'))) AS class_tag,
    mg.marketGroupName AS category_name,
    t.typeName AS name,
    t.volume AS volume
  FROM
    invMarketGroups mg,
    invTypes t
  WHERE
   -- 1855:Ice Ores, 2479:Abyssal Materials, 1856:Alloys & Compounds, 1859+983:Fullerenes+Mykoserocin
   t.marketGroupID IN (1855,2479,1856,1859,983) AND
   t.marketGroupID = mg.marketGroupID;