SELECT DISTINCT c.id'一级id',c.`name`'一级类目mingc',b.id'二级id',b.`name`'二级类目名称',a.id'三级id',a.`name`'三级类目名称',
d.cateId'品种id',d.`name`'品种名字',d.createTime'品种创建时间',d.checkTime'品种审核时间',d.operator'品种审核人',
CASE WHEN d.`status`=1 THEN '审核通过'
		WHEN d.`status`=2 THEN '审核未通过'
		WHEN d.`status`=3 THEN '停用'
		WHEN d.`status`=4 THEN '未审核'
		ELSE '没有标明状态' end '品种审核状态'
FROM
    b2b_product.category a
JOIN 
   b2b_product.category b ON a.parentId=b.id
JOIN
	b2b_product.category c  ON b.parentId=c.id
left JOIN
	b2b_product.categorybreed d ON a.id=d.cateId
where a.`level`=2  AND a.`status`=0
