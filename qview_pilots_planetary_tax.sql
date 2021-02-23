CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_pilots_planetary_tax AS
  SELECT
    ei.main_pilot_name,
    tax.date AS date,
    -SUM(tax.tax_paid) AS tax_paid
  FROM
    ( SELECT
        cwj.character_id AS pilot_id,
        DATE(cwj.date) AS date,
        SUM(cwj.amount) AS tax_paid
      FROM
        character_wallet_journals as cwj,
        planets AS p,
        solar_systems AS s
      WHERE
        cwj.ref_type IN ('planetary_construction','planetary_export_tax','planetary_import_tax') AND
        cwj.context_id = p.planet_id AND
        p.system_id = s.system_id AND
        s.security <= 0.0
      GROUP BY 1, 2
    ) tax,
    qview_employment_interval ei
  WHERE
    ei.pilot_id = tax.pilot_id AND
    ei.enter_time <= tax.date AND IF(gone_time IS NULL,TRUE,tax.date <= ei.gone_time) 
  GROUP BY ei.main_pilot_id, 2
  -- ORDER BY 1 DESC
  ;