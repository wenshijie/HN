-- 表1 所有有在线交易的供应商，采购商1-9月汇总表
-------供应
SELECT h.`name` '一级类目',c.hnUserId '供应商id',c.linkMan'供应商名称',d.userAccount'供应商账号',
       SUM(a.amt) '成交金额',COUNT(a.mainOrderCode) '出售订单总数',COUNT(DISTINCT b.buyUserId) '支付人数（去重）'
FROM 
        b2b_sale.main_order a       -- mainOrderCode,amt,payTime
        JOIN
        b2b_sale.hn_order b on a.mainOrderCode=b.mainOrderCode -- 卖家saleUserId
        JOIN
        hnuser.hnuser c on b.saleUserId=c.hnUserId -- 姓名
        JOIN 
        hnuser.hnuseraccount d on b.saleUserId=d.hnUserId -- 账户
        JOIN 
        b2b_sale.order_detail e on b.mainOrderCode=e.saleOrderCode -- 产品id
        JOIN
        b2b_product.supply t on e.productId=t.supplyId
        JOIN
        b2b_product.category f on t.cateId=f.id -- 三级id 
        JOIN 
        b2b_product.category g on f.parentId=g.id -- 二级id
        JOIN 
        b2b_product.category h on g.parentId=h.id -- 一级id和名字
WHERE a.payTime>='2018-01-01' AND a.payTime<='2018-10-01'
GROUP BY h.`name`,c.hnUserId,c.linkMan,d.userAccount
------采购
SELECT h.`name` '一级类目',c.hnUserId '采购id',c.linkMan'采购商名称',d.userAccount'采购商账号',
       SUM(a.amt) '成交金额',COUNT(a.mainOrderCode) '购买订单总数',COUNT(DISTINCT b.saleUserId) '卖家人数（去重）'
FROM 
        b2b_sale.main_order a       -- mainOrderCode,amt,payTime
        JOIN
        b2b_sale.hn_order b on a.mainOrderCode=b.mainOrderCode -- 卖家saleUserId
        JOIN
        hnuser.hnuser c on b.buyUserId=c.hnUserId -- 姓名
        JOIN 
        hnuser.hnuseraccount d on b.buyUserId=d.hnUserId -- 账户
        JOIN 
        b2b_sale.order_detail e on b.mainOrderCode=e.saleOrderCode -- 产品id
        JOIN
        b2b_product.supply t on e.productId=t.supplyId
        JOIN
        b2b_product.category f on t.cateId=f.id -- 三级id 
        JOIN 
        b2b_product.category g on f.parentId=g.id -- 二级id
        JOIN 
        b2b_product.category h on g.parentId=h.id -- 一级id和名字
WHERE a.payTime>='2018-01-01' AND a.payTime<='2018-10-01'
GROUP BY h.`name`,c.hnUserId,c.linkMan,d.userAccount

---表2 取在线交易金额top50，商家数不足50的按实际数量排序供应

SELECT k.`name`'一级类目',k.monthdate'月份',k.linkMan'供应商名称',k.userAccount'供应商账户',
            k.allamt'订单总金额',k.sum_order '订单数',k.pay_count'支付人数',i.im_count '供应商接收im次数',
            i.people_count '供应商接收im人数', j.call_count '供应商打电话次数', j.people_count '供应商打电话人数'            
FROM 
        (SELECT h.`name`,month(a.payTime) monthdate,c.hnUserId,c.linkMan,d.userAccount,
                        SUM(a.amt) allamt,COUNT(a.mainOrderCode) sum_order,COUNT(DISTINCT b.buyUserId) pay_count
        FROM 
                        b2b_sale.main_order a       -- mainOrderCode,amt,payTime
                        JOIN
                        b2b_sale.hn_order b on a.mainOrderCode=b.mainOrderCode -- 卖家saleUserId
                        JOIN
                        hnuser.hnuser c on b.saleUserId=c.hnUserId -- 姓名
                        JOIN 
                        hnuser.hnuseraccount d on b.saleUserId=d.hnUserId -- 账户
                        JOIN 
                        b2b_sale.order_detail e on b.mainOrderCode=e.saleOrderCode -- 产品id
                        JOIN
                        b2b_product.supply t on e.productId=t.supplyId
                        JOIN
                        b2b_product.category f on t.cateId=f.id -- 三级id 
                        JOIN 
                        b2b_product.category g on f.parentId=g.id -- 二级id
                        JOIN 
                        b2b_product.category h on g.parentId=h.id -- 一级id和名字
        WHERE a.payTime>='2018-08-01' AND a.payTime<='2018-10-01'
        GROUP BY h.`name`,month(a.payTime),c.linkMan,d.userAccount
        )k 
LEFT JOIN
            (
            SELECT month(msgTime) monthdate,receiveUserId, COUNT(id) im_count,COUNT(DISTINCT senderUserId) people_count
            FROM hn_chat.im_message
            WHERE msgTime>='2018-08-01'AND msgTime<='2018-10-01'
            GROUP BY  month(msgTime),receiveUserId
            ) i on k.hnUserId=i.receiveUserId AND k.monthdate=i.monthdate
LEFT JOIN 
            (
            SELECT month(dialTime) monthdate,calledUserId,COUNT(id) call_count,COUNT(DISTINCT hnUserId) people_count
            FROM hn_manager.calldetail
            WHERE dialTime>='2018-08-01'AND dialTime<='2018-10-01'
            GROUP BY month(dialTime),calledUserId
            ) j on k.hnUserId=j.calledUserId AND k.monthdate=j.monthdate -- 打电话询盘

-- 采购
SELECT k.`name`'一级类目',k.monthdate'月份',k.linkMan'采购商名称',k.userAccount'采购商账户',
            k.allamt'订单总金额',k.sum_order '订单数',k.pay_count'卖家人数',i.im_count '采购商发送im次数',
            i.people_count '采购商发送im人数', j.call_count '采购商打电话次数', j.people_count '采购商打电话人数'            
FROM 
        (SELECT h.`name`,month(a.payTime) monthdate,c.hnUserId,c.linkMan,d.userAccount,
                        SUM(a.amt) allamt,COUNT(a.mainOrderCode) sum_order,COUNT(DISTINCT b.saleUserId) pay_count
        FROM 
                        b2b_sale.main_order a       -- mainOrderCode,amt,payTime
                        JOIN
                        b2b_sale.hn_order b on a.mainOrderCode=b.mainOrderCode -- 卖家saleUserId
                        JOIN
                        hnuser.hnuser c on b.buyUserId=c.hnUserId -- 姓名
                        JOIN 
                        hnuser.hnuseraccount d on b.buyUserId=d.hnUserId -- 账户
                        JOIN 
                        b2b_sale.order_detail e on b.mainOrderCode=e.saleOrderCode -- 产品id
                        JOIN
                        b2b_product.supply t on e.productId=t.supplyId
                        JOIN
                        b2b_product.category f on t.cateId=f.id -- 三级id 
                        JOIN 
                        b2b_product.category g on f.parentId=g.id -- 二级id
                        JOIN 
                        b2b_product.category h on g.parentId=h.id -- 一级id和名字
        WHERE a.payTime>='2018-08-01' AND a.payTime<='2018-10-01'
        GROUP BY h.`name`,month(a.payTime),c.linkMan,d.userAccount
        )k 
LEFT JOIN
            (
            SELECT month(msgTime) monthdate,senderUserId, COUNT(id) im_count,COUNT(DISTINCT receiveUserId) people_count
            FROM hn_chat.im_message
            WHERE msgTime>='2018-08-01'AND msgTime<='2018-10-01'
            GROUP BY  month(msgTime),senderUserId
            ) i on k.hnUserId=i.senderUserId AND k.monthdate=i.monthdate
LEFT JOIN 
            (
            SELECT month(dialTime) monthdate,hnUserId,COUNT(id) call_count,COUNT(DISTINCT calledUserId) people_count
            FROM hn_manager.calldetail
            WHERE dialTime>='2018-08-01'AND dialTime<='2018-10-01'
            GROUP BY month(dialTime),hnUserId
            ) j on k.hnUserId=j.hnUserId AND k.monthdate=j.monthdate -- 打电话询盘


--- 表3。1   7，8,9月一级类目 二级类目    三级类目    订单总数    订单金额    供应详情pv  供应详情uv  供应详情询盘按钮点击次数供应详情询盘按钮点击人数

SELECT a.cate1_name,a.cate2_name,a.cate3_name,a.count_order,a.sum_amt,
b.supplydetail_pv,b.supplydetail_uv,c.num_time,c.num_people
from  
(
SELECT cate1_name,cate2_name,cate3_name,
count(DISTINCT mainordercode) count_order,sum(amt) sum_amt
from dw_trade.dw_product_order_detail
WHERE createtime>='2018-08-01' and createtime<'2018-09-01' and day>=20180801 
and ispay =1
GROUP BY cate1_name,cate2_name,cate3_name
)a
left join
(
SELECT cate_name1,cate_name2,cate_name3,count(*) supplydetail_pv,count(DISTINCT deviceid) supplydetail_uv
from dw_log.dw_supply_click
WHERE day>=20180801 and day<20180901
group by cate_name1,cate_name2,cate_name3
)b on a.cate1_name=b.cate_name1 AND a.cate2_name=b.cate_name2 and a.cate3_name=b.cate_name3
left join
(
SELECT cate_name1,cate_name2,cate_name3,count(*) num_time,count(DISTINCT deviceid) num_people
from dw_log.dw_supply_inquiry
where day>=20180801 and day<20180901
group by cate_name1,cate_name2,cate_name3
)c on a.cate1_name=c.cate_name1 and a.cate2_name=c.cate_name2 and a.cate3_name=c.cate_name3

-- 表3.2
SELECT  h.`name`,g.`name`,f.`name`,COUNT(DISTINCT a.mainOrderCode),SUM(a.amt)
FROM 
b2b_sale.main_order a
JOIN
b2b_sale.order_delivery b ON a.mainOrderCode=b.mainOrderCode AND b.createTime>='2018-09-01' AND b.createTime<'2018-09-29'
JOIN
b2b_sale.order_detail c ON a.mainOrderCode=c.saleOrderCode AND b.createTime>='2018-09-01' AND b.createTime<'2018-09-29'
JOIN
b2b_product.supplyaddress d ON c.productId=d.supplyId
JOIN
b2b_product.supply e ON c.productId=e.supplyId
JOIN
b2b_product.category f on e.cateId=f.id -- 三级id 
JOIN 
b2b_product.category g on f.parentId=g.id -- 二级id
JOIN 
b2b_product.category h on g.parentId=h.id -- 一级id和名字
WHERE a.isPay=1 AND b.createTime>='2018-09-01' AND b.createTime<'2018-09-29' AND b.provinceId=d.provinceId
GROUP BY h.`name`,g.`name`,f.`name`
-- 取每月每个类目的top50 py
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 19 15:57:02 2018

@author: HN00242
"""

import pandas as pd
data=pd.read_excel('C:/Users/HN00242/Desktop/top.xlsx')
datagroup=data.groupby(['一级类目','月份'])                  #按此两列分组
writer = pd.ExcelWriter('C:/Users/HN00242/Desktop/top_50.xlsx')
for name,group in datagroup:
    data_sort=group.sort_values('订单总金额',ascending=False)#排序
    if len(data_sort)>=50:                                  #前50
        data_sort=data_sort.iloc[:50,:]
    else:
        data_sort=data_sort
    table_name=name[0]+str(name[1])+'月top50'
    data_sort.to_excel(writer,sheet_name=table_name)
writer.save()
-- 十月类目销售 精确到三级类目
select 
a.cate_name1 as `一级类目名`
,a.cate_name2 as `二级类目名`
,a.cate_name3 as `三级类目名`
, a.dau  as `供应列表、供应详情UV`
, coalesce(b.ask,0) as `供应详情页询盘按钮点击人数`
, coalesce(b.cnt,0) as `供应详情页询盘按钮点击次数`
, coalesce(round(c.amt,2),0) as `支付金额`
, coalesce(c.order_cnt,0) as `支付订单数`

from 
(select cate_name1,cate_name2,cate_name3,count(distinct t.deviceid) as dau 
    from
  (select cate1_name as cate_name1,cate2_name as cate_name2 ,
  cate3_name as cate_name3 ,deviceid 
  from dw_log.dw_search_cate_list_view_detail 
  where day>=20181001 and day<=20181031 
  and searchtype in('关键字搜索','类目搜索')
  union all
  select cate_name1,cate_name2,cate_name3,deviceid from dw_log.dw_supply_click 
  where day>=20181001 and day<=20181031
  and cateid1>2000000
  ) t
  group by t.cate_name1,t.cate_name2,t.cate_name3
)a 
left join 
(select cate_name1,cate_name2,cate_name3,count(distinct deviceid) as ask,count(*) cnt 
  from dw_log.dw_supply_inquiry
  where day>=20181001 and day<=20181031  
  group by cate_name1,cate_name2,cate_name3
) b 
on  a.cate_name1=b.cate_name1 and a.cate_name2=b.cate_name2 and a.cate_name3=b.cate_name3
left join 
(select aa.cate1_name,aa.cate2_name,aa.cate3_name,sum(aa.amt) as amt,count(aa.mainordercode) order_cnt
from 
(
select distinct cate1_name,cate2_name,cate3_name,amt,mainordercode,ordercode
from dw_trade.dw_product_order_detail
where day>=20181001 and day<=20181031 and day=date_format(paytime,'yyyyMMdd')
  and ispay=1 
)aa
group by aa.cate1_name,aa.cate2_name,aa.cate3_name
) c 
on  a.cate_name1=c.cate1_name and a.cate_name2=c.cate2_name and a.cate_name3=c.cate3_name

-- 产品运营日报 月度
select a.day
,a.cate_name1 as `一级类目名`
, a.dau  as `供应列表、供应详情UV`
, coalesce(b.ask,0) as `供应详情页询盘按钮点击人数`
, coalesce(b.cnt,0) as `供应详情页询盘按钮点击次数`
, coalesce(round(c.amt,2),0) as `支付金额`
, coalesce(c.order_cnt,0) as `支付订单数`
from 
(select day,cate_name1,count(distinct t.deviceid) as dau 
    from
  (select day, cate1_name as cate_name1,deviceid 
  from dw_log.dw_search_cate_list_view_detail 
  where day>=20181001 and day<=20181031  
  and searchtype in('关键字搜索','类目搜索')
  union all
  select day, cate_name1,deviceid from dw_log.dw_supply_click 
  where day>=20181001 and day<=20181031 
  and cateid1>2000000
  ) t
  group by day, t.cate_name1
)a 
left join 
(select day,cate_name1,count(distinct deviceid) as ask,count(*) cnt 
  from dw_log.dw_supply_inquiry
  where day>=20181001 and day<=20181031   
  group by day,cate_name1
) b 
on  a.cate_name1=b.cate_name1 and a.day=b.day
left join 
(select aa.day,aa.cate1_name,sum(aa.amt) as amt,count(aa.mainordercode) order_cnt
from 
(
select distinct day, cate1_name,amt,mainordercode,ordercode
from dw_trade.dw_product_order_detail
where day>=20181001 and day<=20181031  and day=date_format(paytime,'yyyyMMdd')
  and ispay=1 
)aa
group by aa.day , aa.cate1_name
) c 
on  a.cate_name1=c.cate1_name and a.day=c.day