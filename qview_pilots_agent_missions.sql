CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_pilots_bounty_prizes AS
  SELECT
    mains.main_pilot_name AS main_pilot_name,
    bounty.date AS date,
    SUM(bounty.amount) AS tax_earned
  FROM
    qview_main_pilots AS mains,
    ( SELECT
        (SELECT main_pilot_id FROM qview_main_and_twin_ids WHERE cwj.second_party_id = pilot_id) AS main_pilot_id,
        DATE(cwj.date) AS date,
        SUM(cwj.amount) AS amount
      FROM
        corporation_wallet_journals cwj
      WHERE
        (cwj.ref_type = 'bounty_prizes') OR -- борьба с неписью
        (cwj.ref_type = 'agent_mission_reward') OR (cwj.ref_type = 'agent_mission_time_bonus_reward') -- миски, агент
      GROUP BY 1, 2
    ) bounty
  WHERE
    NOT (bounty.main_pilot_id IS NULL) AND
    mains.main_pilot_id = bounty.main_pilot_id
  GROUP BY 1, 2;