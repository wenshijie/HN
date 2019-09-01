SELECT DATE(a.createTime),HOUR(a.createTime),b.modifyUserId,COUNT(DISTINCT a.hnUserId)
FROM hnuser.hnuser a
		JOIN
		hnuser.hnuserext b on a.hnUserId=b.hnUserId
WHERE a.createTime>='2018-07-10' AND a.createTime<'2018-08-12' and a.regChannel in (3,4)-- app端
GROUP BY DATE(a.createTime),HOUR(a.createTime),b.modifyUserId
