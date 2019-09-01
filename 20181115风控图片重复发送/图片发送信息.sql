SELECT a.senderuserid `用户ID`,b.linkman`用户姓名`,d.useraccount`用户账户`,b.createtime`注册时间`,
case WHEN c.hnuserid IS NULL then '否'else '是'end `是否个人/企业认证`,
coalesce(d.are,'用户没留手机号或没有归属地信息')`手机号归属地`,
coalesce(e.`location`,'未获取到用户启动地址') `app启动地址`,
coalesce(f.supply_num,0)`在线供应条数`,
coalesce(g.purchase_num,0)`发采购条数`,
a.num`图片发送人数`,
a.picturecode`图片编码`,
coalesce(h.sale_num,0)+coalesce(j.buy_num,0) `买和卖订单总数`
from 
(
SELECT senderuserid,get_json_object(detail,'$.md5') picturecode,count(DISTINCT receiveuserid) num
from ods_trade.hn_chat_im_message_update
WHERE day=20181112 and msgtype=1 and detail like '%md5%' and senderid not like '%ocs%'
GROUP BY senderuserid,get_json_object(detail,'$.md5')
HAVING num>2
)a 
LEFT JOIN
(
SELECT DISTINCT hnuserid,linkman,createtime -- 用户姓名，注册时间
from ods_public.hnuser_hnuser_full
WHERE day=20181112
)b  on a.senderuserid=b.hnuserid
LEFT JOIN
(
SELECT DISTINCT hnuserid
from dw_public.dw_user_certification_info
where day=20181112 and identity in (1,2) --个人/企业认证 
)c on a.senderuserid=c.hnuserid
LEFT JOIN
(SELECT aa.hnuserid,aa.useraccount,concat(bb.province,bb.city) are -- 手机号归属地
from 
(SELECT DISTINCT hnuserid,useraccount,substr(mobile,1,7) mobile_7 -- 手机号前七位
from ods_public.hnuser_hnuseraccount_full
WHERE day=20181112 and length(mobile)=11 --取手机号正常的 
)aa
LEFT JOIN
(SELECT  mobile,province,city
from  ods_public.hn_manager_phones_full
)bb on aa.mobile_7=bb.mobile
)d on a.senderuserid=d.hnuserid
LEFT JOIN
(
SELECT DISTINCT userid,`location` -- 启动地址
from dw_log.dw_appstartlog 
WHERE day=20181112 and `location` is not null and userid>0 and length(`location`)>0
)e on a.senderuserid=e.userid
LEFT JOIN
(
SELECT hnuserid ,count(DISTINCT supplyid) supply_num -- 在线供应数
from dw_trade.dw_b2b_product_supply
where day=20181112 AND state=0 and iscollect=0 AND istest=0
GROUP BY hnuserid
)f on a.senderuserid=f.hnuserid
LEFT JOIN 
(
SELECT hnuserid ,count(DISTINCT hnpurchaseid) purchase_num -- 发过的采购的数量
from ods_trade.b2b_supply_hnpurchasedetail_full
where day=20181112
GROUP BY hnuserid
)g on a.senderuserid=g.hnuserid
LEFT JOIN
(
SELECT saleuserid,count(DISTINCT ordercode) sale_num -- 作为卖方的订单数
from ods_trade.b2b_sale_hn_order_full
WHERE day=20181112 and state=3 -- 交易成功
GROUP BY saleuserid
)h on a.senderuserid=h.saleuserid
LEFT JOIN
(
SELECT buyuserid,count(DISTINCT ordercode) buy_num -- 作为买方的订单数
from ods_trade.b2b_sale_hn_order_full
WHERE day=20181112 and state=3 -- 交易成功
GROUP BY buyuserid
) j on a.senderuserid=j.buyuserid
