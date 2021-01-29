CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_main_and_twin_ids AS
  SELECT
    -- mg.group_id,
    mg.old_user_id AS pilot_id,
    mg.new_user_id AS seat_user_id,
    mg.main_character_id AS main_pilot_id
  FROM
    seat.mig_groups AS mg
  ; -- ORDER BY mg.group_id, mg.new_user_id