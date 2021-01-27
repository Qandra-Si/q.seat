CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW seat.qview_employment_interval AS
  SELECT
    qmp.*,
    ept.enter_time,
    -- lpt.last_time,
    IF(gpt.gone_id=lpt.last_id, NULL, gpt.gone_time) AS gone_time,
    -- cch.corporation_id IN (98615601,98650099,98553333) AS in_ri4,
    IF(gpt.gone_id=lpt.last_id, 1, 0) AS in_ri4
  FROM
    (SELECT
       character_id AS pilot_id,
       MAX(id) AS gone_id,
       MAX(start_date) AS gone_time
     FROM seat.character_corporation_histories
     WHERE corporation_id IN (98615601,98650099,98553333)
     GROUP BY character_id
    ) AS gpt, -- gone pilot' time
    (SELECT
       character_id AS pilot_id,
       MAX(id) AS last_id,
       MAX(start_date) AS last_time
     FROM seat.character_corporation_histories
     GROUP BY character_id
    ) AS lpt, -- last pilot' time
    (SELECT
       character_id AS pilot_id,
       MIN(start_date) AS enter_time
     FROM
       seat.character_corporation_histories
     WHERE corporation_id IN (98615601,98650099,98553333)
     GROUP BY character_id
    ) AS ept, -- enter pilot' time
    seat.character_corporation_histories AS cch,
    seat.qview_main_pilots AS qmp
  WHERE
    cch.character_id = lpt.pilot_id AND
    cch.id = lpt.last_id AND
    qmp.pilot_id = cch.character_id AND
    ept.pilot_id = cch.character_id AND
    gpt.pilot_id = cch.character_id;
