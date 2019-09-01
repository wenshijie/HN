-- 播放次数
SELECT b.Id,b.PlayCount
FROM 
hn_circle.posts a
JOIN
hn_circle.postclicks b ON a.Id=b.Id
WHERE a.DataType=1 
ORDER BY PlayCount DESC
-- 播放次数 hive
SELECT a.num,b.userid,c.linkman
from 
(
SELECT get_json_object(eventargskv,'$.detail_id') id,count(*) num
from dw_log.dw_appeventlog
where eventid='hnzone_video_play' and 
day>=date_format(date_sub(current_date(),7),'yyyyMMdd') and day<date_format(current_date(),'yyyyMMdd')
GROUP BY get_json_object(eventargskv,'$.detail_id')
ORDER BY num desc 
LIMIT 10
) a 
join
(
SELECT id,userid
from ods_circle.hn_circle_posts_full
where day=date_format(date_sub(current_date(),1),'yyyyMMdd')
)b on a.id=b.id
join
(
SELECT hnuserid,linkman
from ods_public.hnuser_hnuser_full
where day=date_format(date_sub(current_date(),1),'yyyyMMdd')
)c on b.userid=c.hnuserid
ORDER BY a.num desc
-- 视频连接和id mysql
SELECT PostId,CONCAT('http://video.cnhnb.com/',FilePath)
FROM hn_circle.attachments
WHERE MediaType=1

-- 农友圈广告点击
SELECT day,case when eventargskv like '%param%' then get_json_object(get_json_object(eventargskv,'$.url'),'$.param')
        ELSE get_json_object(eventargskv,'$.url') end name,count(*) pv,count(DISTINCT deviceid)uv
from dw_log.dw_appeventlog 
where eventid='hnzone_banner' and day>=20181001 and day<=20181009 -- 有空的{"url":"{\"page\":\"web\",\"param\":null}"}
GROUP BY day,case when eventargskv like '%param%' then get_json_object(get_json_object(eventargskv,'$.url'),'$.param')
        ELSE get_json_object(eventargskv,'$.url') end
-- 我的
SELECT day,count(*) pv,count(DISTINCT deviceid) uv
from dw_log.dw_apppagelog
where day<=20181009 and day>=20181001 and 
(current_page = 'MyMomentsActivity' or current_page='MyFarmersCircleViewController')
GROUP BY day
-- 看过我的
SELECT day,count(*) pv,count(DISTINCT deviceid) uv
from dw_log.dw_apppagelog
where day<=20181009 and day>=20181001 and 
(current_page = 'MomentBrowseHistoryActivity' or current_page='FCVisitorsTableViewController')
GROUP BY day
