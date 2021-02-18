CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_pilots_freighter_gate_jumps AS
  SELECT
    (SELECT DISTINCT main_pilot_name FROM qview_main_pilots WHERE main_pilot_id = fees.main_pilot_id) AS main_pilot_name,
    fees.date AS date,
    -SUM(fees.fees_paid) AS fees_paid
  FROM
    ( SELECT
        (SELECT main_pilot_id FROM qview_main_and_twin_ids WHERE cwj.character_id = pilot_id) AS main_pilot_id,
        DATE(cwj.date) AS date,
        SUM(cwj.amount) AS fees_paid
      FROM
        character_wallet_journals as cwj
      WHERE
        cwj.ref_type = 'structure_gate_jump' AND
        cwj.amount < (-1500000) -- Freighter amount fees paid
      GROUP BY 1, 2
    ) fees
  -- WHERE fees.main_pilot_id IS NOT NULL
  GROUP BY 1, 2;