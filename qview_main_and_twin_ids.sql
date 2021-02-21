CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_main_and_twin_ids AS
  SELECT
    rt.character_id AS pilot_id,
    u.id AS seat_user_id,
    u.main_character_id AS main_pilot_id
  FROM users u, refresh_tokens rt
  WHERE u.id = rt.user_id
    union
  SELECT
    old_user_id,
    new_user_id,
    main_character_id
  FROM mig_groups
  WHERE new_user_id NOT IN (SELECT id FROM users)
  ; -- ORDER BY mg.group_id, mg.new_user_id