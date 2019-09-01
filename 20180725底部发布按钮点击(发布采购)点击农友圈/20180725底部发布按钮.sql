#点击了底部发布的人数
select day,count(distinct deviceid) `底部发布`
from  dw_log.dw_appeventlog
where  eventid='hn_publish'  
		and  day>=20180718 and day<=20180724
		and(appversion='4.7.2.0' or appversion='4.7.20')
group by day 
order by day
#点击了底部发布的人数发采购
select day,count(distinct deviceid) `发采购`
from  dw_log.dw_appeventlog
where  eventid='purchase_click' and eventargskv='{"from":"主页按钮"}' 
		and  day>=20180718 and day<=20180724
		and(appversion='4.7.2.0' or appversion='4.7.20')
group by day 
order by day
#点击了底部发布的人数发供应
select day,count(distinct deviceid) `发供应`
from  dw_log.dw_appeventlog
where  eventid='supply_click' and eventargskv='{"from":"主页按钮"}' 
		and  day>=20180718 and day<=20180724
		and(appversion='4.7.2.0' or appversion='4.7.20')
group by day 
order by day
#点击底部发布没点击采购或供应但点击了农友圈
select count(a.deviceid) `农友圈`
from 
    (select distinct deviceid
    from  dw_log.dw_appeventlog
    where  eventid='hn_publish' and day=20180718 
    and (appversion='4.7.2.0' or appversion='4.7.20')) a 
    left join 
    (select distinct deviceid,eventid
    from  dw_log.dw_appeventlog
    where  (eventid='purchase_click' or eventid='supply_click')
    and eventargskv='{"from":"主页按钮"}'and day=20180718 
    and (appversion='4.7.2.0' or appversion='4.7.20')
    )b on a.deviceid=b.deviceid
    left join
    (select distinct deviceid,current_page
    from  dw_log.dw_apppagelog
    where  (current_page='MyMomentsActivity' or current_page='MyFarmersCircleViewController') 
    and day=20180718 
    and (appversion='4.7.2.0' or appversion='4.7.20'))c on a.deviceid=c.deviceid
where b.eventid is null and c.current_page is not null
#点击底部发布没点击采购或供应但点击了农友圈点击发动态
select count(a.deviceid) `农友圈发动态`
from 
    (select distinct deviceid
    from  dw_log.dw_appeventlog
    where  eventid='hn_publish' and day=20180718 
    and (appversion='4.7.2.0' or appversion='4.7.20')) a 
    left join 
    (select distinct deviceid,eventid
    from  dw_log.dw_appeventlog
    where  (eventid='purchase_click' or eventid='supply_click')
    and eventargskv='{"from":"主页按钮"}'and day=20180718 
    and (appversion='4.7.2.0' or appversion='4.7.20')
    )b on a.deviceid=b.deviceid
    left join
    (select distinct deviceid,eventid
    from  dw_log.dw_appeventlog
    where  eventid='hnzone_publish'
    and day=20180718 
    and (appversion='4.7.2.0' or appversion='4.7.20'))c on a.deviceid=c.deviceid
where b.eventid is null and c.eventid is not null
