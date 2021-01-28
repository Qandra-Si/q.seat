CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW seat.gstudio_pilots AS
  SELECT
    pilot_name,
    main_pilot_name,
    corp_ticker
  FROM
    seat.qview_employment_interval
  WHERE
    in_ri4
  ORDER BY 1;