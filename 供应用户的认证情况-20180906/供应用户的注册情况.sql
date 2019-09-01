-- 供应用户的认证情况
SELECT COUNT(a.hnUserId),COUNT(b.hnUserId),COUNT(c.hnUserId)
FROM
(
	SELECT DISTINCT hnUserId
	FROM b2b_product.supply
	WHERE state=0 AND isCollect=0 AND isTest=0
)a
LEFT JOIN
(
	SELECT DISTINCT hnUserId
	FROM hnuser.usercertifition
	WHERE certifiType=8 
) b ON a.hnUserId=b.hnUserId
LEFT JOIN
(
	SELECT DISTINCT hnUserId
	FROM hnuser.usercertifition
	WHERE certifiType=8 OR certifiType=1 OR certifiType=2
)c on a.hnUserId=c.hnUserId
-- 六月以来
SELECT COUNT(a.hnUserId),COUNT(d.hnUserId),COUNT(b.hnUserId),COUNT(c.hnUserId)
FROM
(
	SELECT DISTINCT hnUserId
	FROM hnuser.hnuserloginlog
	WHERE loginTime>='2018-06-01' AND loginTime<'2018-09-05'
)a
LEFT JOIN
(
	SELECT DISTINCT hnUserId
	FROM b2b_product.supply
	WHERE state=0 AND isCollect=0 AND isTest=0
)d on a.hnUserId=d.hnUserId
LEFT JOIN
(
	SELECT DISTINCT hnUserId
	FROM hnuser.usercertifition
	WHERE certifiType=8 
)b ON d.hnUserId=b.hnUserId
LEFT JOIN
(
	SELECT DISTINCT hnUserId
	FROM hnuser.usercertifition
	WHERE certifiType=8 OR certifiType=1 OR certifiType=2
)c ON d.hnUserId=c.hnUserId