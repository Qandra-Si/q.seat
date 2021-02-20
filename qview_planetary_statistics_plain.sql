CREATE OR REPLACE ALGORITHM = UNDEFINED VIEW qview_planetary_statistics_plain AS
  SELECT
    dp.d AS date,
    dp.m AS main_pilot_name,
    (SELECT quantity FROM qview_planetary_statistics WHERE tier_id=1 AND dp.d=date AND dp.p=main_pilot_id) p1q,
    (SELECT quantity FROM qview_planetary_statistics WHERE tier_id=2 AND dp.d=date AND dp.p=main_pilot_id) p2q,
    (SELECT quantity FROM qview_planetary_statistics WHERE tier_id=3 AND dp.d=date AND dp.p=main_pilot_id) p3q,
    (SELECT quantity FROM qview_planetary_statistics WHERE tier_id=4 AND dp.d=date AND dp.p=main_pilot_id) p4q,
    (SELECT volume FROM qview_planetary_statistics WHERE tier_id=1 AND dp.d=date AND dp.p=main_pilot_id) p1v,
    (SELECT volume FROM qview_planetary_statistics WHERE tier_id=2 AND dp.d=date AND dp.p=main_pilot_id) p2v,
    (SELECT volume FROM qview_planetary_statistics WHERE tier_id=3 AND dp.d=date AND dp.p=main_pilot_id) p3v,
    (SELECT volume FROM qview_planetary_statistics WHERE tier_id=4 AND dp.d=date AND dp.p=main_pilot_id) p4v
  FROM
    (SELECT DISTINCT date AS d, main_pilot_id AS p, main_pilot_name AS m FROM qview_planetary_statistics) dp
  -- ORDER BY 1 DESC
  ;