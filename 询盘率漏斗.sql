SELECT a.day`日期`,a.num`DAU`,b.num`供应列表页UV`,e.num`供应详情页UV`,
	count(c.userid)`供应详情页询盘点击`,count(d.senderuserid)`供应详情页询盘成功`
from 
	(
		SELECT day,count(DISTINCT deviceid) num
		from dw_log.dw_apppagelog
		where day=20180823
		GROUP BY day
	) a
join
	(
		SELECT day,count(DISTINCT deviceid) num
		from dw_log.dw_apppagelog
		where (current_page='SupplyListActivity' or current_page='SupplyListViewController' 
		or current_page like '%goodslist%' 
		or current_page='GoodHallActivity'or current_page='SupplyListOneTableViewController')
		and day=20180823
		group by day
	) b on a.day=b.day
join
	(
		SELECT day,count(DISTINCT deviceid) num
		from dw_log.dw_apppagelog
		where day=20180823 and current_page like '%supply/detail%'
		GROUP BY day
	)e on a.day=e.day
join
	(
		SELECT DISTINCT day,userid
		from  dw_log.dw_appeventlog
		where (current_page='BaseWebViewActivity' or current_page='HNWWebViewController') and (eventid='chat_click' or eventid='call_click') and day=20180823
	)c on a.day=c.day
left join
	(
		SELECT DISTINCT senderuserid
		from dw_trade.dw_hn_chat_im_message
		where day=20180823 and msgtime>='2018-08-23'
	)d on c.userid=d.senderuserid
GROUP BY a.day,a.num,b.num,e.num


SELECT a.day `日期`,a.channels`来源渠道`,count(DISTINCT a.deviceid)`供应列表页UV`,
count(DISTINCT b.deviceid)`供应详情UV`,count(b.deviceid)`供应详情PV`,count(DISTINCT c.userid)`供应详情询盘按钮`,
count(DISTINCT c.call_userid)`供应详情打电话`,count(DISTINCT c.chat_userid)`供应详情IM`
from 
(
SELECT DISTINCT day,
case when current_page='SupplyListActivity' or current_page='SupplyListViewController' then '供应大厅'
	 when current_page like '%goodslist%' then '货品分类'
	 else '好货推荐' end channels ,deviceid,userid
from dw_log.dw_apppagelog
where (current_page='SupplyListActivity' or current_page='SupplyListViewController' 
or current_page like '%goodslist%' 
or current_page='GoodHallActivity'or current_page='SupplyListOneTableViewController')
and day=20180823
) a 
LEFT JOIN
(
SELECT 
case when from_page='SupplyListActivity' or from_page='SupplyListViewController' then '供应大厅'
	 when from_page like '%goodslist%' then '货品分类'
	 else '好货推荐' end channels ,deviceid,userid
from dw_log.dw_apppagelog
where (from_page='SupplyListActivity' or from_page='SupplyListViewController' 
or from_page like '%goodslist%' 
or from_page='GoodHallActivity'or from_page='SupplyListOneTableViewController')
and day=20180823 and current_page like '%supply/detail%'
)b on a.channels=b.channels AND a.deviceid=b.deviceid
LEFT JOIN
(
SELECT DISTINCT userid,case when eventid='chat_click' then userid else NUll end chat_userid,
case when eventid='call_click' then userid else NUll end call_userid
from  dw_log.dw_appeventlog
where (current_page='BaseWebViewActivity' or current_page='HNWWebViewController') 
and (eventid='chat_click' or eventid='call_click') and day=20180823
)c on b.userid=c.userid
GROUP BY a.day,a.channels
-- IM点击
 SELECT a.day`日期`,a.channels`来源`,count(DISTINCT a.userid)`IM点击人数`,count(DISTINCT a.userid,a.targetuser)`IM点击对数`,
 count(DISTINCT b.senderuserid)`IM发出人数`,count(DISTINCT c.senderuserid,c.receiveuserid)`IM发出对数`,
 row_number() over( ORDER BY count(DISTINCT a.userid)  desc) rank
	from 
	(
	SELECT day,get_json_object(eventargskv,'$.from') channels,userid,get_json_object(eventargskv,'$.targetUser') targetuser
	from dw_log.dw_appeventlog
	where eventid='chat_click' and day=20180823 and osytype='Android'
	)a
	LEFT JOIN
	(
	SELECT senderuserid
	from dw_trade.dw_hn_chat_im_message
	where day=20180823 and msgtime>='2018-08-23'
	)b on a.userid=b.senderuserid
	LEFT JOIN
	(
	SELECT  senderuserid,receiveuserid
	from dw_trade.dw_hn_chat_im_message
	where day=20180823 and msgtime>='2018-08-23'
	)c on a.userid=c.senderuserid and a.targetuser=c.receiveuserid
	GROUP BY a.day, a.channels

-- 电话按钮点击

SELECT a.day`日期`,a.channels`渠道`,count(DISTINCT a.userid)`电话按钮点击人数`,count(DISTINCT a.userid,a.targetuser)`电话按钮点击对数`,
	row_number() over( ORDER BY count(DISTINCT a.userid) desc) rank
	from 
	(
	SELECT day, userid,get_json_object(eventargskv,'$.targetUser') targetuser,
	case when get_json_object(eventargskv,'$.from')=1 then '供应详情'
		 when get_json_object(eventargskv,'$.from')=2 then '采购详情'
		 when get_json_object(eventargskv,'$.from')=3 then '店铺详情'
		 when get_json_object(eventargskv,'$.from')=4 then '买家订单'
		 when get_json_object(eventargskv,'$.from')=5 then '卖家订单'
		 when get_json_object(eventargskv,'$.from')=6 then '收到的报价'
		 when get_json_object(eventargskv,'$.from')=7 then '购物车'
		 when get_json_object(eventargskv,'$.from')=8 then '个人主页'
		 when get_json_object(eventargskv,'$.from')=9 then '代卖详情'
		 when get_json_object(eventargskv,'$.from')=10 then '退款'
		 when get_json_object(eventargskv,'$.from')=11 then '评论'
		 when get_json_object(eventargskv,'$.from')=12 then '店铺流量'
		 when get_json_object(eventargskv,'$.from')=13 then '商机推送'
		 when get_json_object(eventargskv,'$.from')=14 then '发出的报价'
		 when get_json_object(eventargskv,'$.from')=15 then '通话记录'
		 when get_json_object(eventargskv,'$.from')=16 then 'IM'
		 when get_json_object(eventargskv,'$.from')=17 then '产地合伙人'
		 when get_json_object(eventargskv,'$.from')=18 then '申诉'
		 when get_json_object(eventargskv,'$.from')=19 then '发出的报价'
		 else get_json_object(eventargskv,'$.from') end channels
	from dw_log.dw_appeventlog
	where eventid='call_click' and day=20180823 and osytype='Android'
	)a
GROUP BY a.day,a.channels 

-- 电话成功率 
SELECT a.day,a.clicknum,b.launchnum,b.linknum,c.successnum
FROM
(
SELECT day,count(DISTINCT userid) clicknum
from dw_log.dw_appeventlog
where eventid='call_click' and day=20180823
GROUP BY day 
)a
join
(
SELECT day,count(DISTINCT hnuserid) launchnum,count(DISTINCT hnuserid,calleduserid)  linknum
from ods_trade.hn_manager_calldetail_append
WHERE day=20180823 
GROUP BY day
)b on a.day =b.day
join
(
SELECT day,count(DISTINCT hnuserid,calleduserid)  successnum
from ods_trade.hn_manager_calldetail_append
WHERE day=20180823 and state=2
GROUP BY day
)c on a.day =c.day