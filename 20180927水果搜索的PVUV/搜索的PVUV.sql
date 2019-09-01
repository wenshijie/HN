-- 搜索桑树苗的PVUV
SELECT day '日期', count(*) PV,count(DISTINCT deviceid) UV
from log_edw_hn_source_new.appsearchlog  
where 
(
	get_json_object(kv,'$.keyword') like '%桑树苗%' or --关键词搜索
	get_json_object(kv,'$.cateId')='2000741' or --  直接点击匹配出来的id （这个id可以为一级，二级，三级类目id，如下面水果的搜索）
	get_json_object(kv,'$.keyCateId3')='2000741' -- 关键词搜索匹配出来的三级类目id
)
and day>=20180901 and day<=20180925 -- 日期范围
and id<>'pagedown' -- 搜索出来后往下翻页时的浏览，如果算pv删去此行；不算pv加上此行。 
GROUP BY day 

-- 水果搜索的pvuv
SELECT day ,count(*),count(DISTINCT deviceid)
from  log_edw_hn_source_new.appsearchlog  
WHERE day >= 20180919 and day <=20180925 and 
(
get_json_object(kv,'$.keyCateId1')='2000001' or -- 关键词搜索会出现一级类目，和三级类目。
get_json_object(kv,'$.cateId')='2000001' or -- 水果的一级类目
(get_json_object(kv,'$.cateId')>='2000050' and get_json_object(kv,'$.cateId')<='2000054')or -- 水果的二级类目
(get_json_object(kv,'$.cateId')>='2001301' and get_json_object(kv,'$.cateId')<='2001340')or -- 水果的三级类目
(get_json_object(kv,'$.cateId')>='2001243' and get_json_object(kv,'$.cateId')<='2001247')or -- 水果的三级类目
(get_json_object(kv,'$.cateId')>='2001686' and get_json_object(kv,'$.cateId')<='2001689')or -- 水果的三级类目
(get_json_object(kv,'$.cateId')>='2001636' and get_json_object(kv,'$.cateId')<='2001671')or -- 水果的三级类目
get_json_object(kv,'$.cateId') in ('2002125','2002325','2002145','2002156') -- 水果的三级类目
)
and id <> 'pagedown'-- 去掉往下翻页产生的pv
group by day 