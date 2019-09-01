SELECT a.daytime,COUNT( DISTINCT a.hnUserId) allperson,COUNT( DISTINCT b.hnUserId) supplyperson,COUNT(DISTINCT c.hnUserId) purperson,
SUM((b.hnUserId is NULL) and (c.hnUserId is NULL)) notall
FROM 
(
SELECT DISTINCT DATE(loginTime) daytime,hnUserId
FROM hnuser.hnuserloginlog 
WHERE loginTime>'2018-09-11' AND loginTime<='2018-09-19'
)a
LEFT JOIN 
b2b_product.supply b ON a.hnUserId=b.hnUserId AND b.isTest=0 AND b.isCollect=0 AND state=0
LEFT JOIN
b2b_supply.hnpurchaseinfo c ON a.hnUserId=c.hnUserId AND c.state=1 AND c.isTest=0
GROUP BY a.daytime