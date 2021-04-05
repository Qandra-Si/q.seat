CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_corp_ceo_actualization AS
  SELECT
    -- ci.corporation_id,
    ci.name AS corporation_name,
    ci.ticker,
    -- ci.ceo_id,
    pi.name AS ceo_name,
    pi.updated_at AS ceo_updated,
    IF(pi.name IS NULL OR pi.updated_at IS NULL,
       'CEO not connected to the system !!!',
       IF(DATEDIFF(CURDATE(),pi.updated_at)<=1,
          NULL, -- CONCAT(pi.name,' data is up-to-date (ok).'),
          CONCAT(pi.name,' data is outdated, orders may be out of date !!!')
       )
      ) AS is_actualized
  FROM corporation_infos ci
         LEFT OUTER JOIN character_infos pi ON (pi.character_id = ci.ceo_id)
  WHERE ci.corporation_id IN (98677876,98615601,98553333,98650099) -- 'RIID','RI4','R ST','R I5'
  ;