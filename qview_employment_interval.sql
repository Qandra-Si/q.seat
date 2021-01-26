CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW seat.qview_employment_interval AS
  SELECT
    qmp.*,
    ept.enter_time,
    lpt.last_time,
    cch.corporation_id IN (98615601,98650099,98553333) AS in_ri4
  FROM
    (SELECT
       character_id AS pilot_id,
       MAX(id) AS last_id,
       MAX(start_date) AS last_time
     FROM seat.character_corporation_histories
     GROUP BY character_id
    ) AS lpt, -- last pilot' time
    (SELECT
       cch.character_id AS pilot_id,
       MIN(cch.start_date) AS enter_time
     FROM
       seat.character_corporation_histories cch
     WHERE cch.corporation_id IN (98615601,98650099,98553333)
     GROUP BY cch.character_id
    ) AS ept, -- enter pilot' time
    seat.character_corporation_histories AS cch,
    seat.qview_main_pilots AS qmp
  WHERE
    cch.character_id = lpt.pilot_id AND
    cch.id = lpt.last_id AND
    qmp.pilot_id = cch.character_id AND
    ept.pilot_id = cch.character_id;
