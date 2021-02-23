CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_pilots_bounty_prizes AS
  SELECT
    ei.main_pilot_name,
    bounty.date AS date,
    SUM(bounty.amount) AS tax_earned
  FROM
    ( SELECT
        cwj.second_party_id AS pilot_id,
        DATE(cwj.date) AS date,
        SUM(cwj.amount) AS amount
      FROM
        corporation_wallet_journals cwj
      WHERE
        (cwj.ref_type = 'bounty_prizes') OR -- борьба с неписью
        (cwj.ref_type = 'agent_mission_reward') OR (cwj.ref_type = 'agent_mission_time_bonus_reward') -- миски, агент
      GROUP BY 1, 2
    ) bounty,
    qview_employment_interval AS ei
  WHERE
    ei.pilot_id = bounty.pilot_id AND
    ei.enter_time <= bounty.date AND IF(gone_time IS NULL,TRUE,bounty.date <= ei.gone_time) 
  GROUP BY ei.main_pilot_id, 2
  -- ORDER BY 2 DESC
  ;