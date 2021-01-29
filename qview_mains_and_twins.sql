CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_mains_and_twins AS
  SELECT
    pilot_name,
    main_pilot_name,
    corp_ticker,
    in_ri4
  FROM
    seat.qview_employment_interval
  ; -- WHERE in_ri4
  -- ORDER BY 1