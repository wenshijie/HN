SELECT a.*,b.hnlinkman
FROM 
(
SELECT mainordercode,detailordercode,buyuserid `采购商id`,linkman `收货人姓名`, deliverylinkman`发货人姓名`,productid,
productname `产品名称`,createtime`订单创建时间`,productcnt`订单数量`,
totalamount`订单总金额`,paymentamount`实际需要支付的金额`
from ods_youxuan.hnbest_new_yx_order_detail_full
WHERE paytime>='2018-10-22' and day=20181030 and status in (1,2,3,4,7)
and ordertype=5
) a 
join
(
SELECT hnuserid,hnlinkman
from ods_youxuan.hnbest_new_yx_user_full
WHERE day=20181030
)b on a.`采购商id`=b.hnuserid