-- 发供应



-- 发采购
SELECT
FROM 
b2b_supply.hnpurchaseinfo a
JOIN
b2b_supply.hnpurchasedetail b on a.id=b.id 
JOIN
b2b_product.category c ON b.cateId=c.id
JOIN
b2b_product.category d ON c.parentId=d.id
JOIN
b2b_product.category e ON d.parentId=e.id
WHERE a.createTime>='2018-08-01' AND a.createTime<'2018-08-27' AND a.placeProvinceId in (15,16,3,10,12,1,2,4)

-- 地区
SELECT a.day,b.cate_name1,a.province,count(DISTINCT a.userid)
FROM 
(
SELECT userid,day,province
from dw_log.dw_log_app_start_address
WHERE day>=20180801 and day<=20180826 and province in ('山东省','河南省','河北省','江苏省','安徽省','北京市','天津市','山西省')
)a
join 
(
SELECT reviewer_hnuserid,day,cate_name1
from dw_log.dw_supply_inquiry
where day>=20180801 and day<=20180826
)b on a.userid=b.reviewer_hnuserid and a.day=b.day
GROUP BY a.day,b.cate_name1,a.province