CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_pilots_freighter_gate_jumps AS
  SELECT
    ei.main_pilot_name,
    fees.date AS date,
    -SUM(fees.fees_paid) AS fees_paid
  FROM
    ( SELECT
        cwj.character_id AS pilot_id,
        DATE(cwj.date) AS date,
        SUM(cwj.amount) AS fees_paid
      FROM
        character_wallet_journals as cwj
      WHERE
        cwj.ref_type = 'structure_gate_jump' AND
        cwj.amount < (-1500000) -- Freighter amount fees paid
      GROUP BY 1, 2
    ) fees,
    qview_employment_interval ei
  WHERE
    ei.pilot_id = fees.pilot_id AND
    ei.enter_time <= fees.date AND IF(gone_time IS NULL,TRUE,fees.date <= ei.gone_time) 
  GROUP BY ei.main_pilot_id, 2
  -- ORDER BY 1 DESC
  ;
