-- 总打电话
SELECT day,count(DISTINCT deviceid),count(*)
from dw_log.dw_appeventlog
where day>=20180820 and day<=20180905 and eventid='call_click'
GROUP BY day
-- im打电话
SELECT day,count(DISTINCT deviceid),count(*)
from dw_log.dw_appeventlog
where day>=20180820 and day<=20180905 and eventid='call_click' and get_json_object(eventargskv,'$.from')=16
GROUP BY day
-- 右上角三个点点击
SELECT day,count(DISTINCT deviceid),count(*)
from dw_log.dw_appeventlog
where day>=20180820 and day<=20180905 and eventid='fastentrance_menu' 
GROUP BY day
-- 举报
SELECT day,count(DISTINCT deviceid),count(*)
from dw_log.dw_appeventlog
where day>=20180820 and day<=20180905 and eventid='fastentrance_menu' 
and get_json_object(eventargskv,'$.menu_type')='举报'
GROUP BY day
