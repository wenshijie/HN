#mysql

SELECT a.payTime '支付时间',f.userAccount '买家账户', d.linkMan '买家名称',g.userAccount '卖家账户', 
		e.linkMan '卖家名称',c.productName '产品名称',c.price '单价',c.qty '单位',
		c.unit '数量', a.amt '金额'
FROM b2b_sale.main_order a -- 实付金额 支付时间 
     JOIN
     b2b_sale.hn_order b  ON a.mainOrderCode=b.mainOrderCode-- 买家id，卖家id
     JOIN
     b2b_sale.order_detail c ON  b.orderCode=c.saleOrderCode-- 产品名称
     JOIN
     hnuser.hnuser d ON b.buyUserId=d.hnUserId -- 买家名字
     JOIN
     hnuser.hnuser e ON b.saleUserId=e.hnUserId-- 卖家名字
     JOIN
     hnuser.hnuseraccount f ON b.buyUserId=f.hnUserId-- 买家账户
     JOIN
     hnuser.hnuseraccount g ON b.saleUserId=g.hnUserId-- 卖家账户
WHERE a.payTime>='2018-07-10'AND a.payTime<'2018-07-11'
AND a.amt>=10000
=====================================================================================================
SELECT a.payTime '支付时间',f.userAccount '买家账户', d.linkMan '买家名称',g.userAccount '卖家账户', 
		e.linkMan '卖家名称',c.productName '产品名称',c.price '单价',c.qty '单位',
		c.unit '数量', a.amt '金额'
FROM
	(SELECT  payTime,mainOrderCode,amt -- 主订单号  实付金额 买家id
	FROM b2b_sale.main_order
	WHERE payTime>='2018-07-10'AND payTime<'2018-07-11'
	AND amt>=10000
	) a JOIN
	(
	SELECT mainOrderCode,orderCode,buyUserId,saleUserId-- 卖家id，买家id
	FROM b2b_sale.hn_order
	)b ON a.mainOrderCode=b.mainOrderCode
	JOIN
	(SELECT saleOrderCode,productId,productName,price,qty,unit-- 单价 单位 数量
	FROM b2b_sale.order_detail
	)c ON b.orderCode=c.saleOrderCode
	JOIN
	(SELECT hnUserId,linkMan
	 FROM hnuser.hnuser
	) d ON b.buyUserId=d.hnUserId -- 买家名字
	JOIN
	(SELECT hnUserId,linkMan
	 FROM hnuser.hnuser
	) e ON b.saleUserId=e.hnUserId-- 卖家名字
	JOIN
	(SELECT hnUserId,userAccount 
	 FROM hnuser.hnuseraccount
	) f ON b.buyUserId=f.hnUserId-- 买家账户
	JOIN
	(SELECT hnUserId,userAccount
	 FROM hnuser.hnuseraccount
	)g ON b.saleUserId=g.hnUserId-- 卖家账户
