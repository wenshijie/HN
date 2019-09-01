--买家身份
SELECT b.identity_name`买家身份`,count(a.buyerid)`人数`,count(c.senderuserid)`im`,
        count(d.receiveuserid)`被im`, count(e.hnuserid)`电话`,
        count(f.calleduserid)`被打电话`,count(g.reviewer_hnuserid)`点击过供应详情`
from (
        SELECT DISTINCT buyerid
        from ods_trade.b2b_sale_main_order_full
        where paytime>='2018-05-01' and paytime<'2018-08-01' and day=20180731
    ) a 
    join 
    (
        SELECT DISTINCT hnuserid,identity_name
        from dw_public.dw_user_identity
        where day=20180731
    )b on a.buyerid=b.hnuserid
    LEFT JOIN
    (
        select DISTINCT senderuserid
        from dw_trade.dw_hn_chat_im_message
        where msgtime>='2018-05-01' and msgtime<'2018-08-01' and day=20180731
    )c on a.buyerid=c.senderuserid
    LEFT JOIN
    (
        select DISTINCT receiveuserid
        from dw_trade.dw_hn_chat_im_message
        where msgtime>='2018-05-01' and msgtime<'2018-08-01' and day=20180731
    ) d on a.buyerid=d.receiveuserid
    LEFT JOIN
    (
        select DISTINCT hnuserid
        from ods_trade.hn_manager_calldetail_append
        where day>=20180501 and day<=20180731
    ) e on a.buyerid=e.hnuserid
    LEFT JOIN
    (
        select DISTINCT calleduserid
        from ods_trade.hn_manager_calldetail_append
        where day>=20180501 and day<=20180731
    ) f on a.buyerid=f.calleduserid
    LEFT JOIN
    (
    select DISTINCT reviewer_hnuserid
    from dw_log.dw_supply_click
    where day>=20180501 and day<=20180731
    ) g on a.buyerid=g.reviewer_hnuserid
GROUP BY b.identity_name
-- 卖家身份
SELECT b.identity_name`卖家身份`,count(a.saleuserid)`人数`,count(c.senderuserid)`im`,
        count(d.receiveuserid)`被im`, count(e.hnuserid)`电话`,
        count(f.calleduserid)`被打电话`,count(g.reviewer_hnuserid)`点击过供应详情`
from (
        SELECT DISTINCT mainordercode
        from ods_trade.b2b_sale_main_order_full
        where paytime>='2018-05-01' and paytime<'2018-08-01' and day=20180731
    ) t 
    join
    ( 
    SELECT DISTINCT mainordercode,saleuserid
    from ods_trade.b2b_sale_hn_order_full
    where day=20180731
    
    )a on t.mainordercode=a.mainordercode
    join 
    (
        SELECT DISTINCT hnuserid,identity_name
        from dw_public.dw_user_identity
        where day=20180731
    )b on a.saleuserid=b.hnuserid
    LEFT JOIN
    (
        select DISTINCT senderuserid
        from dw_trade.dw_hn_chat_im_message
        where msgtime>='2018-05-01' and msgtime<'2018-08-01' and day=20180731
    )c on a.saleuserid=c.senderuserid
    LEFT JOIN
    (
        select DISTINCT receiveuserid
        from dw_trade.dw_hn_chat_im_message
        where msgtime>='2018-05-01' and msgtime<'2018-08-01' and day=20180731
    ) d on a.saleuserid=d.receiveuserid
    LEFT JOIN
    (
        select DISTINCT hnuserid
        from ods_trade.hn_manager_calldetail_append
        where day>=20180501 and day<=20180731
    ) e on a.saleuserid=e.hnuserid
    LEFT JOIN
    (
        select DISTINCT calleduserid
        from ods_trade.hn_manager_calldetail_append
        where day>=20180501 and day<=20180731
    ) f on a.saleuserid=f.calleduserid
    LEFT JOIN
    (
    select DISTINCT reviewer_hnuserid
    from dw_log.dw_supply_click
    where day>=20180501 and day<=20180731
    ) g on a.saleuserid=g.reviewer_hnuserid
GROUP BY b.identity_name
-- mysql 567月支付成功类目分类
SELECT k.`name`'一级类目',k.monthdate'月份',k.linkMan'供应商名称',k.userAccount'供应商账户',
            k.allamt'订单总金额',k.sum_order '订单数',k.pay_count'支付人数',i.im_count 'im次数',
            i.people_count 'im人数', j.call_count '打电话人数', j.people_count '打电话次数'            
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
        WHERE a.payTime>='2018-05-01' AND a.payTime<='2018-07-31'
        GROUP BY h.`name`,month(a.payTime),c.linkMan,d.userAccount
        )k 
LEFT JOIN
            (
            SELECT month(msgTime) monthdate,receiveUserId, COUNT(id) im_count,COUNT(DISTINCT senderId) people_count
            FROM hn_chat.im_message
            WHERE msgTime>='2018-05-01'AND msgTime<='2018-07-31'
            GROUP BY  month(msgTime),receiveUserId
            ) i on k.hnUserId=i.receiveUserId AND k.monthdate=i.monthdate
LEFT JOIN 
            (
            SELECT month(dialTime) monthdate,calledUserId,COUNT(id) call_count,COUNT(DISTINCT hnUserId) people_count
            FROM hn_manager.calldetail
            WHERE dialTime>='2018-05-01'AND dialTime<='2018-07-31'
            GROUP BY month(dialTime),calledUserId
            ) j on k.hnUserId=j.calledUserId AND k.monthdate=j.monthdate -- 打电话询盘




