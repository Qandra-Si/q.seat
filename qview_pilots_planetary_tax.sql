CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_pilots_planetary_tax AS
  SELECT
    (SELECT DISTINCT main_pilot_name FROM qview_main_pilots WHERE main_pilot_id = tax.main_pilot_id) AS main_pilot_name,
    tax.date AS date,
    -SUM(tax.tax_paid) AS tax_paid
  FROM
    ( SELECT
        (SELECT main_pilot_id FROM qview_main_and_twin_ids WHERE cwj.character_id = pilot_id) AS main_pilot_id,
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
    ) tax
  -- WHERE tax.main_pilot_id IS NOT NULL
  GROUP BY 1, 2;