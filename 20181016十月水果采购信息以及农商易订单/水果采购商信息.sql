SELECT DISTINCT f.linkMan '用户名',g.mobile'手机号',c.`name`'三级类目名称',h.`name`'省',i.`name`'市',
	a.qty'采购数量',a.measureUnit'单位',b.createTime '创建时间'
FROM 
b2b_supply.hnpurchasedetail a
JOIN
b2b_supply.hnpurchaseinfo b ON a.hnPurchaseId=b.id AND b.createTime>='2018-10-01'
JOIN 
b2b_product.category c ON a.cateId=c.id AND c.`status`=0
JOIN
b2b_product.category d ON c.parentId=d.id AND d.`status`=0
JOIN
b2b_product.category e ON d.parentId=e.id AND e.`status`=0 AND e.id='2000001'
JOIN
hnuser.hnuser f ON b.hnUserId=f.hnUserId
JOIN
hnuser.hnuseraccount g ON b.hnUserId=g.hnUserId
LEFT JOIN
b2b_product.area h ON b.placeProvinceId=h.id
LEFT JOIN
b2b_product.area i ON b.placeCityId = i.id
