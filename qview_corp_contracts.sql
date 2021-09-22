CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_corp_contracts AS
  SELECT
    ( SELECT ticker -- 'RI4','R ST','RI 5'
      FROM corporation_infos
      WHERE corporation_id = cntrcts.issuer_corporation_id) AS ticker,
    cntrcts.issuer_corporation_id AS issuer_corporation_id,
    (SELECT DISTINCT main_pilot_name FROM qview_main_pilots WHERE main_pilot_id = cntrcts.main_pilot_id) AS main_pilot_name,
    cntrcts.date AS date,
    SUM(cntrcts.amount) AS amount,
    SUM(cntrcts.count) AS count
  FROM
    ( SELECT
        issuer_corporation_id,
        (SELECT main_pilot_id FROM qview_main_and_twin_ids WHERE cd.issuer_id = pilot_id) AS main_pilot_id,
        DATE(cc.created_at) AS date,
        SUM(cd.price) AS amount,
        COUNT(1) AS count
      FROM
        corporation_contracts cc,
        contract_details cd
      WHERE
        cc.contract_id = cd.contract_id AND
        cd.price > 0 AND -- фильтруем пустые (сюда могут попадать корпделивери)
        cd.for_corporation = 1 AND
        cd.date_accepted IS NOT NULL AND
        cd.issuer_corporation_id IN (98677876,98615601,98650099,98553333) -- RIID,RI4,RI5,RS
      GROUP BY 1, 2, 3
    ) cntrcts
  -- WHERE cntrcts.main_pilot_id IS NOT NULL
  GROUP BY 1, 2, 3, 4;