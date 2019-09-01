SELECT day, case when appversion like '4.7.4%' then '4.7.4'
            when appversion like '4.7.3%' then '4.7.3'
            else '4.7.2' end ,get_json_object(eventargskv,'$.position'),count(DISTINCT deviceid)
from  dw_log.dw_appeventlog
WHERE eventid='hnzone_tab' and day>=20180920 and day<=20180924 and
((appversion like '4.7.4%') or (appversion like '4.7.3%') or(appversion like '4.7.2%' ))
GROUP BY day,case when appversion like '4.7.4%' then '4.7.4'
            when appversion like '4.7.3%' then '4.7.3'
            else '4.7.2' end,
            get_json_object(eventargskv,'$.position')