#1、是否有注册；2、注册时间；3、从哪个渠道包下载。
select username,mobile,regtime,regchannel
from dw_public.dim_user_base_info
where mobile in ('15284620706',
'18286761086',
'18285765161',
'18798001800',
'15284655576',
'18586357635',
'15885212354',
'15772762781',
'18386131581',
'13984550921',
'18076011133',
'18386308008',
'13985354497',
'15186120467',
'15085386698',
'18188571118',
'17808628050',
'18984731766',
'18798833127',
'18285742496',
'18383050787',
'15086383773',
'18744901006',
'18230762808'
)


#2  为了评估下焦点图是否需要做成按不同用户展示，需要咱们数据这边帮忙统计下 2018-7-16 至 7-17  
#这两天App首页点击 和田大枣（https://mobile.cnhnb.com/html/purchase/shop.html?d=1e252f）焦点图用户在 浏览的三级类目 上的数据分布情况， 
select b.cate_name3,count(a.userid)
from
	(select userid
	from dw_log.dw_apppagelog
	where current_page like'%.cnhnb.com/html/purchase/shop.html?d=1e252f%'
	and day>='20180716' and day <='20180717'
	) a left join 
	(select distinct hnuserid,cate_name3
	from dw_log.dw_supply_click
	where day>='20180716' and day <='20180717'
	) b on a.userid=b.hnuserid
group by b.cate_name3


#2018.07.01至今唤醒过APP的用户版本使用情况（包含未上传版本的用户）需求一
#假如时间内用户多次登录，以最新一次登录的版本计算


select a.`版本`,count(a.deviceid)
from (
	select  deviceid,max(appversion) `版本`
	from dw_log.dw_appeventlog
	where day>=20180701 and day<=20180716
	group by  deviceid
	) a
group by a.`版本`
#各天
select a.day,a.`版本`,count(deviceid)
from(
    select day,deviceid,max(appversion) `版本`--取当天登录的新版本
    from dw_log.dw_appeventlog
    where day>=20180701 and day<=20180716
    group by  day ,deviceid
    ) a 
group by a.day,a.`版本`


#2017.07.01至今唤醒过APP的用户中被禁用、被设风险等级的用户的版本使用情况

select a.userid,max(a.appversion)
from
	(select distinct userid,appversion
	from dw_log.dw_appeventlog
	where day>=20180701 and day<=20180716
	) a join
	(select hnuserid
	from dw_public.dim_user_base_info
	where status=2 and day=20180717--禁用的用户
	)b on a.userid=b.hnuserid
	join
	(select hn_user_id
	from ods_public.hnuser_risk_user_level_full
	where level in (1,2,3) and day=20180717--风险等级
	)c on b.hnuserid=c.hn_user_id
group by a.userid

#被禁用的用户最早使用
select a.appversion,count(userid)
from
	(select distinct userid,appversion,day
	from dw_log.dw_appeventlog
	where day>=20180701 and day<=20180716
	) a join
	(select hnuserid,min(day) daydate--取被禁用的最早的时间
	from dw_public.dim_user_base_info
	where status=2 and day>=20180701 and day<=20180716--禁用的用户
	group by hnuserid
	)b on a.userid=b.hnuserid
where a.day=b.daydate
group by a.appversion

#当日版本使用最多的人数
select day,max(a.num)
from (
	select  day,appver,count(distinct userid) num
	from dw_log.dw_appstartlog
	where day>=20180101 and day<=20180716
	group by day,appver
	order by day
	)a
group by a.day 
#day=day
select a.level,b.appver, count(a.hn_user_id)
from 
    (
        select hn_user_id,level,min(day) daydate
        from ods_public.hnuser_risk_user_level_full
        where day>=20180101 and day<=20180716
        and level !=4
        group by hn_user_id,level
    ) a 
    join 
    (
        select distinct userid,appver,day
        from dw_log.dw_appstartlog
        where day>=20180101 and day<=20180716
    ) b on a.hn_user_id=b.userid
where a.daydate = b.day
group by a.level,b.appver
