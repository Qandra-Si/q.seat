CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW seat.gstudio_freighter_skills AS
  SELECT
    typeID AS id,
    typeName AS name
  FROM seat.invTypes
  WHERE
    typeID IN (21610, -- Jump Fuel Conservation
               21611, -- Jump Drive Calibration
               29029, -- Jump Freighters
               20524, -- Amarr Freighter
               20526, -- Caldari Freighter
               20527, -- Gallente Freighter
               20528); -- Minmatar Freighter