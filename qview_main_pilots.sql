CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_main_pilots AS
  SELECT
    mat.pilot_id,
    mat.main_pilot_id,
    u.name AS main_pilot_name,
    (SELECT name FROM seat.character_infos WHERE character_id = mat.pilot_id) AS pilot_name
  FROM
    seat.users AS u,
    seat.qview_main_and_twin_ids AS mat
  WHERE
    u.id = mat.seat_user_id;