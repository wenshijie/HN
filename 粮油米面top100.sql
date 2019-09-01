SELECT b.supplyid `商品ID`,b.autotitle `商品名称`,a.cate_name3 `所属三级类目`,c.useraccount `用户账户`,
	count(a.reviewer_hnuserid) `总询盘数`,
	sum(case when a.eventid='chat_click' then 1 else 0 end) `IM询盘`
from(
	SELECT DISTINCT hnuserid,supplyid,cate_name3,eventid,reviewer_hnuserid
	from dw_log.dw_supply_inquiry
	where cateid1=2000004 and day=20180726 ) a 
	left join
	(SELECT supplyid,autotitle
	from dw_trade.dw_b2b_product_supply
	where day=20180726
	) b on a.supplyid=b.supplyid
	LEFT JOIN 
	(select hnuserid,useraccount
	from ods_public.hnuser_hnuseraccount_full
	where day=20180726
	) c on a.hnuserid=c.hnuserid
GROUP BY b.supplyid,b.autotitle,a.cate_name3,c.useraccount
ORDER BY `总询盘数` DESC,`IM询盘` DESC
limit 100