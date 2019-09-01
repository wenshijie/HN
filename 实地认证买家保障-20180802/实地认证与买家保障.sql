--买家保障 实地认证


SELECT DISTINCT a.userAccount '用户账号',CASE WHEN b.safeguard is NULL THEN '否' ELSE '是' END '是否开通买家保障',
CASE WHEN c.certifiType=5 THEN '是' ELSE '否' END '是否开通实地认证' 
FROM hnuser.hnuseraccount a
     LEFT JOIN
		 hn_area_partner.hn_area_partner b ON a.hnUserId=b.hn_user_id and b.safeguard=1 
     LEFT JOIN
     hnuser.usercertifition c ON a.hnUserId=c.hnUserId and c.certifiType=5
WHERE b.safeguard=1 OR c.certifiType=5