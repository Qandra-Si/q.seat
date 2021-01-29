CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW seat.qview_capital_construction_skills AS
  SELECT
    typeID AS id,
    typeName AS name
  FROM seat.invTypes
  WHERE
    typeID IN (22242, -- Capital Ship Construction
               3387, -- Mass Production
               24625); -- Advanced Mass Production