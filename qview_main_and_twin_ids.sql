CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_main_and_twin_ids AS
  -- Возможная ситуация: пилоты есть в mig_groups таблице (бэкап миграции),
  -- но отсутствуют в новом справочнике refresh_tokens (удалились). Восстанавливаем
  -- информацию о пилотах  с тем, чтобы не была утрачна статистика.
  -- Возможная ситуация: пилот вышел из состава корпорации, удалился из
  -- сеата, после чего снова пришёл в корпорацию и в сеат, но при этом от имени
  -- нового мейна завёл часть старых персонажей (старые останутся в архиве), а
  -- новые должны быть привязаны к новому мейну.
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
  WHERE
    new_user_id NOT IN (SELECT id FROM users) AND
    old_user_id NOT IN (SELECT character_id FROM refresh_tokens)
  ; -- ORDER BY mg.group_id, mg.new_user_id