-- 有限公司，股份有限公司 有效公司名的是否有供应的
SELECT count(DISTINCT a.userid),count(DISTINCT c.hnuserid)
from  
(
SELECT userid,linkman FROM miner.users WHERE link_company IS NOT NULL or linkman like '%公司%' 
)a 
LEFT JOIN
(
SELECT userid,linkman
FROM miner.users 
WHERE  linkman like '%有限公司%' or linkman like '%有限责任公司%'
) b on a.userid=b.userid
LEFT JOIN
(
SELECT DISTINCT supplyid,hnuserid,cate1_name,cate2_name,cate3_name
from dw_trade.dw_b2b_product_supply
WHERE day=20181106 AND state in (0,1,3) and iscollect =0 and istest=0
) c on a.userid=c.hnuserid
WHERE b.userid IS NOT NULL-- 公司名有效/无效
-- 在线供应的三级类目种类数，在线供应的二级类目种类数，在线供应的一级类目种类数 ，供应数（有过或在线）
SELECT a.userid,a.linkman,count(DISTINCT b.supplyid),
count(DISTINCT b.cate1_name),count(b.cate2_name),count(DISTINCT b.cate3_name) 
from  
( 
SELECT userid,linkman 
FROM miner.users  
WHERE linkman like '%公司%'  ) a 
left join 
( 
SELECT DISTINCT supplyid,hnuserid,cate1_name,cate2_name,cate3_name 
from dw_trade.dw_b2b_product_supply 
WHERE day=20181106 and state=0 and iscollect =0 and istest=0 -- state in (0,1,3)
) b on a.userid=b.hnuserid 
WHERE b.hnuserid IS NOT NULL 
GROUP BY a.userid,a.linkman 
---主营类目 取r=1
SELECT *,row_number() over(PARTITION BY c.userid,c.linkman ORDER BY c.num desc) r
from  (
SELECT a.userid,a.linkman,b.cate1_name, count(DISTINCT b.supplyid) num
from 
(
SELECT userid,linkman
FROM miner.users 
WHERE  linkman like '%公司%'  
) a
left join
(
SELECT DISTINCT supplyid,hnuserid,cate1_name,cate2_name,cate3_name
from dw_trade.dw_b2b_product_supply
WHERE day=20181106 and state=0 and iscollect =0 and istest=0
) b on a.userid=b.hnuserid
WHERE b.hnuserid IS NOT NULL
GROUP BY a.userid,a.linkman,b.cate1_name
) c

-- 累计销售交易量，和金额
SELECT a.userid,a.linkman,count(b.ordercode) numorder,sum(b.amount) sumamt
from 
(
SELECT userid,linkman
FROM miner.users 
WHERE  linkman like '%公司%'  
) a
left join
(
SELECT DISTINCT saleuserid,mainordercode,ordercode,amount
from  ods_trade.b2b_sale_hn_order_full
WHERE day=20181107 and state in (1,2,3)
) b on a.userid=b.saleuserid
GROUP BY a.userid,a.linkman
ORDER BY numorder desc,sumamt desc
--最后登录时间
SELECT a.userid,b.lastlog
from 
(
SELECT userid,linkman
FROM miner.users 
WHERE  linkman like '%公司%'  
) a
left join
(
SELECT hnuserid,max(lastlogtime) lastlog
from dw_public.dim_user_base_info
where day=20181107
GROUP BY hnuserid
)b on a.userid=b.hnuserid
---作为发起方的对象数
SELECT a.userid ,a.linkman ,count(DISTINCT receiveuserid)
from 
(
SELECT userid,linkman 
FROM miner.users  
WHERE linkman like '%公司%'
) a 
LEFT JOIN
(
SELECT DISTINCT senderid ,receiveuserid
from dw_trade.dw_hn_chat_im_message
WHERE day=20181115
)b on a.userid=b.senderid
GROUP BY a.userid ,a.linkman
-- 累计采购量
-- 交易量最高的三级类目
-- 采购量最高的三级类目