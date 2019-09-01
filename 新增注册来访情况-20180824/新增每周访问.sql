SELECT a.hnuserid`注册id`,a.createtime`注册时间`,e.certifitype`个人认证`,c.cnt`登陆次数`,d.cnt`发供应次数`,
f.cnt`发布报价次数`, g.cnt `询盘对数`,h.cnt `搜索行情点击`,i.cnt`农友圈动态次数`,k.cnt `咨询模块聊生意点击`
from 
(
	SELECT DISTINCT hnuserid,createtime -- 注册
	FROM ods_public.hnuser_hnuser_full
	WHERE createtime>='2018-08-07' AND createTime<'2018-08-08' and day=20180823
)a 
join
(
	SELECT DISTINCT hnuserid -- 卖家
	from dw_public.dw_user_identity
	where day=20180823 and purpose=0 
)b on a.hnuserid=b.hnuserid
LEFT JOIN
(
	SELECT userid,count(DISTINCT userid,day) cnt  -- 登录次数
	from dw_log.dw_apppagelog
	where day>=20180808 and day<=20180814 and userid>0
	GROUP BY userid
)c on a.hnuserid=c.userid
LEFT JOIN
(
	SELECT hnuserid,count(DISTINCT supplyid) cnt-- 发供应次数
	from dw_trade.dw_b2b_product_supply
	WHERE day=20180823 and createtime>='2018-08-07'and createtime<'2018-08-14' 
	GROUP BY hnuserid
)d on a.hnuserid=d.hnuserid 
LEFT JOIN
(
	select hnuserid,certifitype -- 认证信息  certifitype=1 个人认证
	from ods_public.hnuser_usercertifition_full
	WHERE day=20180823 and certifitype=1
)e on a.hnuserid=e.hnuserid
LEFT JOIN
(
	SELECT saleuserid ,count(buyuserid) cnt --发布报价
	from ods_trade.b2b_supply_quotation_full
	where createtime>='2018-08-07'and createtime<'2018-08-14' and day=20180823
	group by saleuserid
)f on a.hnuserid=f.saleuserid
LEFT JOIN
(
	SELECT senderuserid,count(DISTINCT senderuserid,receiveuserid) as cnt -- im询盘对数
	from dw_trade.dw_hn_chat_im_message
	where day>=20180807 and day<=20180813
	GROUP BY senderuserid
)g on a.hnuserid=g.senderuserid
LEFT JOIN
(
select userid,count(*) cnt
from dw_log.dw_apppagelog -- 搜索行情点击
WHERE current_page like '%/market/%' and day>=20180807 and day<=20180813
and userid>0
GROUP BY userid
) h on a.hnuserid=h.userid
LEFT JOIN
(
SELECT userid,count(*) as cnt -- 农友圈发动态次数 0是发布动态
from ods_circle.hn_circle_posts_full
where posttype=0 and publisheddate>='2018-08-07' AND publisheddate<'2018-08-14'
and day=20180823
GROUP BY userid
)i on a.hnuserid=i.userid
LEFT JOIN
(
SELECT userid,count(*) as cnt
from dw_log.dw_apppagelog -- 咨询模块
where (current_page='MessageFragment' or current_page='MessageTableViewController')
and day>=20180807 and day<=20180813 and userid>0
GROUP BY userid
)k on a.hnuserid=k.userid


--意向点击次数
SELECT a.hnuserid`注册id`,a.createtime`注册时间`, c.num 
from 
(
	SELECT DISTINCT hnuserid,createtime -- 注册
	FROM ods_public.hnuser_hnuser_full
	WHERE createtime>='2018-08-07' AND createTime<'2018-08-08' and day=20180823
)a 
join
(
	SELECT DISTINCT hnuserid -- 卖家
	from dw_public.dw_user_identity
	where day=20180823 and purpose=0 
)b on a.hnuserid=b.hnuserid
LEFT JOIN
(
SELECT userid,count(*) num
from dw_log.dw_apppagelog
where day>=20180807 and day<=20180813 
and (current_page='IntentCustomerListActivity' or current_page='IntentCustomerViewController')
GROUP BY userid
)c on a.hnuserid=c.userid