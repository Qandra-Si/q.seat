CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW seat.qview_pilot_employments AS
  SELECT
    cch.character_id,
    cch.start_date,
    cch.corporation_id,
    qmp.pilot_name,
    qmp.main_pilot_id,
    qmp.main_pilot_name
  FROM
    seat.character_corporation_histories AS cch,
    seat.qview_main_pilots AS qmp
  WHERE
    qmp.pilot_id = cch.character_id
  ; -- ORDER BY 1

