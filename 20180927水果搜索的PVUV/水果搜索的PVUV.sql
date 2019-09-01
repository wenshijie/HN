-- 水果搜索的PV UV
SELECT day ,count(*),count(DISTINCT deviceid)
from  log_edw_hn_source_new.appsearchlog  
WHERE day >= 20180919 and day <=20180925 and 
(
get_json_object(kv,'$.keyCateId1')='2000001' or 
get_json_object(kv,'$.cateId')='2000001' or 
(get_json_object(kv,'$.cateId')>='2000050' and get_json_object(kv,'$.cateId')<='2000054')or 
(get_json_object(kv,'$.cateId')>='2001301' and get_json_object(kv,'$.cateId')<='2001340')or
(get_json_object(kv,'$.cateId')>='2001243' and get_json_object(kv,'$.cateId')<='2001247')or
(get_json_object(kv,'$.cateId')>='2001686' and get_json_object(kv,'$.cateId')<='2001689')or 
(get_json_object(kv,'$.cateId')>='2001636' and get_json_object(kv,'$.cateId')<='2001671')or
get_json_object(kv,'$.cateId') in ('2002125','2002325','2002145','2002156')
)
and id <> 'pagedown'-- 去掉往下翻页产生的pv
group by day 
