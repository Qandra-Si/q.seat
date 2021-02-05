CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_pilots_discovery_rewards AS
  SELECT
    (SELECT DISTINCT main_pilot_name FROM qview_main_pilots WHERE main_pilot_id = bounty.main_pilot_id) AS main_pilot_name,
    bounty.date AS date,
    SUM(bounty.amount) AS tax_earned
  FROM
    ( SELECT
        (SELECT main_pilot_id FROM qview_main_and_twin_ids WHERE cwj.second_party_id = pilot_id) AS main_pilot_id,
        DATE(cwj.date) AS date,
        SUM(cwj.amount) AS amount
      FROM
        corporation_wallet_journals cwj
      WHERE
        (cwj.ref_type = 'project_discovery_reward') -- решение головоломок
      GROUP BY 1, 2
    ) bounty
  WHERE
    NOT (main_pilot_name IS NULL)
  GROUP BY 1, 2;