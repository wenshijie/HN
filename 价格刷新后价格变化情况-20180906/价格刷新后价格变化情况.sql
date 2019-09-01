SELECT DISTINCT a.supplyid,b.price,c.price
from 
(
	SELECT DISTINCT supplyid
	from ods_trade.b2b_product_supplyupdatetime_append
	WHERE day=20180904 and afterstate=0 and `from`=1 AND oper=6
)a 
join 
(
	SELECT supplyid,price
	from dw_trade.dw_b2b_product_supply
	WHERE day=20180904
) b on a.supplyid=b.supplyid
join
(
	SELECT supplyid,price
	from dw_trade.dw_b2b_product_supply
	WHERE day=20180903
)c on a.supplyid=c.supplyid
