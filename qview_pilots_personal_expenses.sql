CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_pilots_personal_expenses AS
  SELECT 
    tax.type,
    tax.main_pilot_name,
    tax.date,
    SUM(tax.fees_paid) AS exprenses
  FROM
    ( SELECT 'J' type, j.* FROM qview_pilots_freighter_gate_jumps j
      union
      SELECT 'P', p.* FROM qview_pilots_planetary_tax p
    ) tax
  WHERE tax.main_pilot_name IS NOT NULL
  GROUP BY 1, 2, 3;