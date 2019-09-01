SELECT a.supplyid,a.title,count(DISTINCT b.reviewer_hnuserid) 
from 
(
	SELECT  DISTINCT supplyid,title
	FROM dw_trade.dw_b2b_product_supply
	where day=20180911 and  cate3_name='板栗' and iscollect=0 and istest=0 and state=0
	and( (createtime>='2018-06-10' and createtime<'2018-09-11') or
	    (updatetime>='2018-06-10' and updatetime<'2018-09-11')) 
)a 
LEFT JOIN
(
	SELECT DISTINCT reviewer_hnuserid,supplyid
	from dw_log.dw_supply_inquiry
	WHERE day>=20180610 and day<=20180910
)b on a.supplyid=b.supplyid
GROUP BY a.supplyid,a.title