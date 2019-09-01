-- 卖家 

SELECT b.saleUserId,SUM(a.amt) sum_amt
FROM 
b2b_sale.main_order a
JOIN
b2b_sale.hn_order b ON a.mainOrderCode=b.mainOrderCode -- 卖家 订单数

GROUP BY b.saleUserId
ORDER BY sum_amt DESC
LIMIT 100

-- 各类目前五
SELECT *
FROM
(
SELECT b1.saleUserId,e1.`name` cat,COUNT(DISTINCT a1.mainOrderCode) ordernum,COUNT( DISTINCT d1.supplyId),SUM(a1.amt) amt  
FROM 
b2b_sale.main_order a1
JOIN
b2b_sale.hn_order b1 ON a1.mainOrderCode=b1.mainOrderCode -- 卖家 订单数
JOIN
b2b_sale.order_detail c1 ON a1.mainOrderCode=c1.saleOrderCode
JOIN 
b2b_product.supply d1 on c1.productId=d1.supplyId
JOIN 
b2b_product.category e1 on d1.cateId=e1.id
GROUP BY b1.saleUserId,e1.`name`
) a
WHERE 5>(select count(*) 
from 
(
SELECT b1.saleUserId,e1.`name` cat,COUNT(DISTINCT a1.mainOrderCode) ordernum,COUNT( DISTINCT d1.supplyId),SUM(a1.amt) amt  
FROM 
b2b_sale.main_order a1
JOIN
b2b_sale.hn_order b1 ON a1.mainOrderCode=b1.mainOrderCode -- 卖家 订单数
JOIN
b2b_sale.order_detail c1 ON a1.mainOrderCode=c1.saleOrderCode
JOIN 
b2b_product.supply d1 on c1.productId=d1.supplyId
JOIN 
b2b_product.category e1 on d1.cateId=e1.id
GROUP BY b1.saleUserId,e1.`name`
)b
 where a.saleUserId=a.saleUserId and b.cat=a.cat and b.amt>a.amt)
ORDER BY a.saleUserId,a.amt DESC

--  买家保障
SELECT c.userid,case WHEN d.safeguard=1 THEN '是' else '否' END stage,d.create_time
FROM
(
SELECT b.saleUserId userid,SUM(a.amt) sum_amt,a.mainOrderCode
FROM 
b2b_sale.main_order a
JOIN
b2b_sale.hn_order b ON a.mainOrderCode=b.mainOrderCode -- 卖家 订单数
WHERE a.isPay=1
GROUP BY b.saleUserId
ORDER BY sum_amt DESC
LIMIT 100
)c
LEFT JOIN
hn_area_partner.hn_area_partner d ON c.userid= d.hn_user_id




