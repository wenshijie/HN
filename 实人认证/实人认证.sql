SELECT COUNT(DISTINCT a.hnUserId),COUNT(DISTINCT b.hnUserId),COUNT(DISTINCT c.mainUserId)
FROM 
b2b_product.supply a
LEFT JOIN
hnuser.usercertifition b ON a.hnUserId=b.hnUserId AND a.state=0 AND b.`status`=1
LEFT JOIN
(SELECT DISTINCT mainUserId
FROM hn_chat.im_attention
where `status`=0
)c ON a.hnUserId=c.mainUserId 