# q.seat
Q.Seat Database Extention

## qview_main_pilots
Для связи main-пилотов и твинков.
* main_pilot_id, main_pilot_name - id и имя основного пилота
* pilot_id, pilot_name - id и имя твинка
```
main_pilot_id pilot_id   main_pilot_name pilot_name
92477528      92477528   Ash Hakoke      Ash Hakoke
92477528      2112214318 Ash Hakoke      Ash Dunier
1579068260    1579068260 l7PO100CJIECAPb l7PO100CJIECAPb
2116129465    2116129465 Qandra Si       Qandra Si
2116129465    2116156168 Qandra Si       Qunibbra Do
2116129465    2116301331 Qandra Si       Ances Do
2116129465    2116746261 Qandra Si       Kekuit Void
```

## qview_pilot_employments
Для получения истории принадлежности к корпорациям в группах main-пилотов.
* main_pilot_id, main_pilot_name - id и имя основного пилота
* character_id, pilot_name - id и имя твинка
* start_date - когда вступил в корпорацию
* corporation_id - id корпорации
```
main_pilot_id start_date corporation_id pilot_name      main_pilot_id main_pilot_name
2116129465    2020-01-03 1000169        Qandra Si       2116129465    Qandra Si
2116129465    2020-01-05 98550309       Qandra Si       2116129465    Qandra Si
2116129465    2020-04-26 1000107        Qandra Si       2116129465    Qandra Si
2116129465    2020-06-15 98615601       Qandra Si       2116129465    Qandra Si
2116156168    2020-07-02 98615601       Qunibbra Do     2116129465    Qandra Si
1579068260    2019-12-03 98615601       l7PO100CJIECAPb 1579068260    l7PO100CJIECAPb
1579068260    2020-01-27 1000060        l7PO100CJIECAPb 1579068260    l7PO100CJIECAPb
1579068260    2020-01-27 98129702       l7PO100CJIECAPb 1579068260    l7PO100CJIECAPb
1579068260    2020-11-22 98550309       l7PO100CJIECAPb 1579068260    l7PO100CJIECAPb
```

## qview_employment_interval
Для получения интервалов присутствия твинков в корпорациях Инициативы.
* main_pilot_id, main_pilot_name - id и имя основного пилота
* pilot_id, pilot_name - id и имя твинка
* enter_time - когда твинк вступил в какую либо корпу Инициативы
* gone_time - когда твинк вышел из корпораций Инициативы
* in_ri4 - признак присутствия твинка в какой либо корпорации Инициативы "прямо сейчас"
```
main_pilot_id pilot_id   main_pilot_name pilot_name      enter_time gone_time  in_ri4
92477528      92477528   Ash Hakoke      Ash Hakoke      2020-10-31 NULL            1
92477528      2112214318 Ash Hakoke      Ash Dunier      2020-11-19 NULL            1
1579068260    1579068260 l7PO100CJIECAPb l7PO100CJIECAPb 2019-12-03 2019-12-03      0
2116129465    2116129465 Qandra Si       Qandra Si       2020-06-15 NULL            1
2116129465    2116156168 Qandra Si       Qunibbra Do     2020-06-20 NULL            1
2116129465    2116301331 Qandra Si       Ances Do        2020-06-25 NULL            1
2116129465    2116746261 Qandra Si       Kekuit Void     2020-06-20 NULL            1
```

## qview_pilots_activity
Для получения сведений и присутствии пилотов в корпорациях Инициативы.
* main_pilot_id, main_pilot_name - id и имя основного пилота
* enter_time - когда пилот (любой его твинк) вступил в какую либо корпу Инициативы
* gone_time - когда пилот (все его твинки) покинул все корпорации Инициативы
* pilots_in_ri4 - кол-во твинков пилота в корпорациях Инициативы
* twins - кол-во зарегистрированных ткинков пилота
```
main_pilot_id main_pilot_name enter_time gone_time  pilots_in_ri4 twins
816125095     Imine Mc'Gowan  2019-10-05 NULL                  11    14
1579068260    l7PO100CJIECAPb 2019-12-03 2020-11-22             0     1
2116129465    Qandra Si       2020-06-15 NULL                   4     4
92477528      Ash Hakoke      2020-10-31 NULL                   2     2
```
