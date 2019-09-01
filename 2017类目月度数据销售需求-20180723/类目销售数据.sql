#询盘
select hnuserid,month(day)
from dw_log.dw_supply_inquiry
where cate_name1 in ('水果','畜牧水产','农副加工')
and day>=20170101 and day<20180101

#月度订单数和总金额（mysql）**
SELECT f.`name` ,month(a.payTime),COUNT(DISTINCT a.mainOrderCode),SUM(a.amt)
FROM b2b_sale.main_order a
     JOIN
		b2b_sale.order_detail b ON a.mainOrderCode=b.saleOrderCode and a.payTime>='2017-01-01' and a.payTime<'2018-01-01'
		JOIN
		b2b_product.supply c ON b.productId=c.supplyId
		JOIN 
		b2b_product.category d ON c.cateId=d.id 
		JOIN
		b2b_product.category e ON d.parentId=e.id
		JOIN 
		b2b_product.category f ON e.parentId=f.id AND f.`name` in ('水果','畜牧水产','农副加工')
GROUP BY f.`name` ,month(a.payTime)

#hive 没有这么早的数据
SELECT a.yue `月份`,COUNT(a.mainordercode),SUM(amt) `月成功付款总金额`
FROM(

			SELECT MONTH(payTime) yue,amt,mainordercode,cate1_name
			FROM dw_trade.dw_product_order_detail
			WHERE payTime>='2017-01-01' and payTime<'2018-01-01' and
			cate1_name in ('水果','畜牧水产','农副加工') AND day>=20170101 and day<20180101
		)a
GROUP BY a.yue
#供应数据**
SELECT a.cate1_name `类目`, a.shijian `月份`,count(a.supplyid) `当月新增供应`
from 
(SELECT DISTINCT supplyid,month(createtime) shijian,cate1_name
from dw_trade.dw_b2b_product_supply
where cate1_name in ('水果','畜牧水产','农副加工') AND createtime>='2017-01-01'and createtime<'2018-01-01'
and day=20180722
) a 
GROUP BY a.cate1_name,a.shijian
#采购数据**
SELECT e.`name` ,MONTH(b.startTime),COUNT( DISTINCT a.hnPurchaseId)
FROM b2b_supply.hnpurchasedetail a
    JOIN
	b2b_supply.hnpurchaseinfo b ON a.hnPurchaseId=b.id AND b.startTime>='2017-01-01'AND b.startTime<'2018-01-01'
    JOIN
    b2b_product.category c ON a.cateId=c.id
    JOIN
	b2b_product.category d ON c.parentId=d.id
    join 
    b2b_product.category e on d.parentId=e.id  AND e.`name` in ('水果','畜牧水产','农副加工')
GROUP BY e.`name` ,MONTH(b.startTime)
#订单没有以及类目各月三级类目top20
SELECT f.`name` ,month(a.payTime),d.`name`,SUM(a.amt)
FROM b2b_sale.main_order a
     JOIN
		b2b_sale.order_detail b ON a.mainOrderCode=b.saleOrderCode and a.payTime>='2017-01-01' and a.payTime<'2018-01-01'
		JOIN
		b2b_product.supply c ON b.productId=c.supplyId
		JOIN 
		b2b_product.category d ON c.cateId=d.id 
		JOIN
		b2b_product.category e ON d.parentId=e.id
		JOIN 
		b2b_product.category f ON e.parentId=f.id AND f.`name` in ('水果','畜牧水产','农副加工')
GROUP BY f.`name` ,month(a.payTime),d.name 
