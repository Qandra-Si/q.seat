CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW seat.qview_pilots_activity AS
  SELECT
    egt.main_pilot_id,
    egt.main_pilot_name,
    egt.enter_time,
    IF(egt.pilots_in_ri4=0, egt.gone_time, NULL) AS gone_time,
    egt.pilots_in_ri4,
    egt.twins
  FROM
   (SELECT
      main_pilot_id,
      main_pilot_name,
      MIN(enter_time) AS enter_time,
      MAX(last_time) AS gone_time,
      SUM(in_ri4) AS pilots_in_ri4,
      COUNT(1) AS twins
    FROM seat.qview_employment_interval
    GROUP BY main_pilot_id
   ) egt; -- enter and gone times