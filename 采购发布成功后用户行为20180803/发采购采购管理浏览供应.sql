-- 发完采购浏览供应推荐的人数与条数
select a.day `日期`,count(distinct a.userid) `成功发采购的人数`,
        count(distinct b.userid)`浏览供应推荐的人数`,
        count(distinct b.current_page)`浏览供应推荐的条数`,--注：如果某人发布成功后浏览推荐供应某供应浏览两次算一次
        count(b.current_page) `浏览供应推荐的条数不去重`, --注(此数据需要去掉c，d两个关联表求)：如果某人发布成功后浏览推荐供应某供应浏览多次算多次
        count(distinct c.hnuserid)`浏览过推荐的人供应详情im人数`,
        count(distinct d.hnuserid) `浏览过推荐的人供应详情打电话人数`
from 
(
SELECT distinct userid,day
FROM dw_log.dw_apppagelog
WHERE (current_page='PublishPurchaseSuccessActivity' or current_page='ReleasePurchaseSuccessViewController')
      and day>=20180710 and day<=20180716
) a 
left join
(
SELECT  userid,day,current_page
FROM dw_log.dw_apppagelog
WHERE ((from_page='PublishPurchaseSuccessActivity' and current_page like 'https://mobile.cnhnb.com/html/supply/detail.html?%')
        or(from_page='ReleasePurchaseSuccessViewController' and current_page like 'https://mobile.cnhnb.com/html/supply/detail.html?%'))
      and day>=20180710 and day<=20180716
) b on a.userid=b.userid and a.day=b.day
left join
(
select hnuserid,day
from dw_log.dw_supply_inquiry
where day>=20180710 and day<=20180716 and eventid='chat_click'
)c on b.userid=c.hnuserid and b.day=c.day
left join
(
select hnuserid,day
from dw_log.dw_supply_inquiry
where day>=20180710 and day<=20180716 and eventid='call_click'
)d on b.userid=d.hnuserid and b.day=d.day
group by a.day 

--全部留存
SELECT count(a.userid),count(b.userid)
from 
    (
        SELECT distinct userid 
        FROM dw_log.dw_appstartlog
        WHERE day=20180710
    ) a 
    LEFT JOIN
    (
        SELECT DISTINCT userid
        from dw_log.dw_appstartlog
        where day>=20180711 and day <=20180717
    )b  on a.userid=b.userid
-- 采购留存
SELECT count(distinct a.userid) `发采购人数`,count(distinct t.buyuserid) `被报价人数`,
	   count(distinct b.userid) `有过登录`,count(distinct c.userid)`点击采购管理`
from 
    (
        SELECT distinct userid 
        FROM dw_log.dw_apppagelog
        WHERE (current_page='PublishPurchaseSuccessActivity' or current_page='ReleasePurchaseSuccessViewController')
        and day=20180710
    ) a 
    left JOIN
    (
    SELECT DISTINCT hnuserid,id
    from ods_trade.b2b_supply_hnpurchaseinfo_full
    where createtime>='2018-07-10' and createtime<'2018-07-11'
    ) s on a.userid=s.hnuserid
    left join
    (
    SELECT distinct buyuserid,purchaseinfoid
    from ods_trade.b2b_supply_quotation_full
    where createtime>='2018-07-11' AND  createtime <'2018-07-18'               
    and day=20180718
    ) t on s.id=t.purchaseinfoid
    LEFT JOIN
    (
        SELECT DISTINCT userid
        from dw_log.dw_appstartlog
        where day>=20180711 and day <=20180717
    )b  on a.userid=b.userid
    LEFT JOIN
    (
        select distinct userid
        from dw_log.dw_appeventlog
        where day>=20180711 and day <=20180717
            and(current_page='MyPurchaseListActivity' or current_page='MyPurchaseViewController' ) 
    )c on a.userid=c.userid



--（备用附加需求） 7天内未查看报价的这部分人，后续7天、15天、30天 还有登录的总人数有多少、点击我的采购管理的有多少、点击过im聊天的人数多少、打电话的人数多少
--续七天的
sselect count(a.buyuserid) `被报价人七天内没有查看人数`,count(distinct b.userid) `后续七天后登录的人数`,
		sum(b.guanli)`点击我的采购管理的人数`,
		count(c.eventid)`点击im聊天的人数`,
		count(d.eventid)`点击打电话的人数`
from 
    (SELECT distinct buyuserid
    from ods_trade.b2b_supply_quotation_full
    where createtime>='2018-07-10' AND  createtime <'2018-07-11'               -- 7月10号被报价七天内未查看
    and (datediff(readtime,createtime)>6 or datediff(readtime,createtime) is null)
    and day=20180717) a 
    left join
    (select distinct userid
    from dw_log.dw_appeventlog
    where day>=20180717 and day <=20180723
    and(eventid='MyPurchaseListActivity' or eventid='MyPurchaseViewController' )  -- 后续七天点击过采购管理
    ) b on a.buyuserid=b.userid
    left join
    (select distinct hnuserid,eventid
    from dw_log.dw_supply_inquiry
    where day>=20180717 and day <=20180723 and eventid='chat_click'             -- 后续七天点击过im聊天
    ) c on a.buyuserid=c.hnuserid
    left join
    (select distinct hnuserid,eventid
    from dw_log.dw_supply_inquiry
    where day>=20180717 and day <=20180723 and eventid='call_click'             -- 后续七天点击过打电话聊天
    ) d on a.buyuserid=d.hnuserid
