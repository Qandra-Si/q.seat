CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW `qview_main_pilots` AS
  SELECT
    -- mg.group_id,
    -- u.id,
    mg.main_character_id AS main_pilot_id,
    mg.old_user_id AS pilot_id,
    u.name AS main_pilot_name,
    (SELECT name FROM seat.character_infos WHERE character_id=mg.old_user_id) AS pilot_name
  FROM
    seat.users AS u,
    seat.mig_groups AS mg
  WHERE
    u.id = mg.new_user_id 
  ; -- ORDER BY mg.group_id, u.id