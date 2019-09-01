SELECT c.areaName,COUNT(a.hnUserId)
FROM
(
SELECT DISTINCT hnUserId
FROM
hnuser.hnuserloginlog FORCE INDEX (idx_loginTime)
WHERE loginTime>='2018-01-01'
)a
LEFT JOIN
(
SELECT DISTINCT hnUserId,province
FROM hnuser.useraddress
)b ON a.hnUserId=b.hnUserId
LEFT JOIN
(
SELECT id,areaName
FROM hnuser.area
WHERE  `level`=1
)c on b.province=c.id
GROUP BY c.areaName

----- 三级品类占比
SELECT t.name ,SUM(t.num)
FROM
(
SELECT c.`name`,COUNT(DISTINCT b.hnUserId) num
FROM 
b2b_product.supply b
JOIN
b2b_product.category c ON b.cateId=c.id and c.`level`=2
WHERE b.isCollect=0 AND b.isTest=0 AND b.updateTime>='2018-01-01'
GROUP BY c.`name`
UNION ALL
SELECT f.`name`,COUNT(DISTINCT e.hnUserId) num
FROM
b2b_supply.hnpurchasedetail e 
JOIN
b2b_supply.hnpurchaseinfo a ON e.hnPurchaseId=a.id AND a.modefyTime>'2018-01-01'
JOIN
b2b_product.category f ON e.cateId=f.id and `level`=2
GROUP BY f.`name`
)t
GROUP BY t.`name`