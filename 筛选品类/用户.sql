-- 有过登录

select a.hnuserid from hnuser.user_identity a
join
(SELECT DISTINCT hnUserId
FROM
hnuser.hnuserloginlog FORCE INDEX (idx_loginTime)
WHERE loginTime>='2018-01-01'
) b 
on a.hnUserId=b.hnUserId and a.identityId in (5,7)
-- 发过供应 
SELECT COUNT(DISTINCT a.hnUserId)
from
hnuser.user_identity a
JOIN
( SELECT DISTINCT hnUserId
FROM
b2b_product.supply
WHERE createTime>'2018-01-01'
) b ON a.hnUserId=b.hnUserId

WHERE a.identityId in (5,6)