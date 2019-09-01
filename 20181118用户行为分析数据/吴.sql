-- 供应商
SELECT a.hnuserid,f.username,f.useraccount,f.regtime,f.lastlogtime,a.supplinum,a.opernum,
b.ordernum,c.imnum ,d.callnum,t.attentionnum
from   
(
    SELECT cc.hnuserid,count(DISTINCT cc.supplyid) supplinum,sum(oprtnum) opernum
    from  
    (
    SELECT DISTINCT hnuserid,supplyid
    from dw_trade.dw_b2b_product_supply
    WHERE day=20181118 and iscollect=0 and istest=0 and state in (0,1,3) and createtime>='2018-05-01'
    )cc 
    left join
    (
    select supplyid ,count(*) oprtnum
    from ods_trade.b2b_product_supplyupdatetime_append
    WHERE day>=20180501 and oper in(0,5,6,7) and `from`=1
    GROUP BY supplyid
    )dd on cc.supplyid=dd.supplyid
    GROUP BY cc.hnuserid
)a 
left join 
(
    SELECT saleuserid,count(DISTINCT ordercode) ordernum
    from ods_trade.b2b_sale_hn_order_full
    where day=20181118 and state in (1,2,3) and createtime>='2018-05-01'
    group by saleuserid
)b on a.hnuserid=b.saleuserid
left join
(
    SELECT  aa.userid ,count(distinct aa.others) imnum
    from 
    (
    SELECT DISTINCT senderuserid as userid,receiveuserid others
    from dw_trade.dw_hn_chat_im_message
    WHERE day=20181118 and msgtime>='2018-05-01'
    UNION all
    SELECT DISTINCT receiveuserid as userid,senderuserid others
    from dw_trade.dw_hn_chat_im_message
    WHERE day=20181118 and msgtime>='2018-05-01' 
    ) aa
    GROUP BY aa.userid
    )c on a.hnuserid=c.userid
LEFT JOIN
    (
    SELECT bb.uesid,count(distinct bb.others) callnum
    from 
    (
    SELECT DISTINCT hnuserid as uesid,calleduserid as others
    from ods_trade.hn_manager_calldetail_append
    WHERE day>20180501 and day<=20181118 and state=2 and hnuserid>0 and dialtime>='2018-05-01'
    UNION all
    SELECT DISTINCT calleduserid as uesid,hnuserid as others
    from ods_trade.hn_manager_calldetail_append
    WHERE day>20180501 and state=2 and calleduserid>0 and dialtime>='2018-05-01'
    )bb
    GROUP BY bb.uesid
) d on a.hnuserid=d.uesid
LEFT JOIN
(
    SELECT followuserid,count(DISTINCT mainuserid) attentionnum
    from ods_trade.hn_chat_im_attention_full
    WHERE day =20181118 
    GROUP BY followuserid
)t on a.hnuserid=t.followuserid
LEFT JOIN
(
    select hnuserid,username,useraccount,regtime,lastlogtime
    from dw_public.dim_user_base_info
    WHERE day =20181118
)f on a.hnuserid=f.hnuserid
ORDER BY a.supplinum desc
limit 5000
-- 采购商
SELECT a.hnuserid,f.username,f.useraccount,f.regtime,f.lastlogtime,a.purchasenum,a.quotationnum,
b.ordernum,c.imnum ,d.callnum,t.attentionnum
from  
    (
    SELECT aa.hnuserid,count(DISTINCT id) purchasenum,sum(bb.num) quotationnum
    FROM 
        (
        SELECT distinct  hnuserid,id
        from ods_trade.b2b_supply_hnpurchaseinfo_full
        WHERE day=20181118 and istest=0 and starttime>='2018-05-01' AND hnuserid>0
        )aa
    left join
        (
        SELECT purchaseinfoid,count(DISTINCT saleuserid) num
        from ods_trade.b2b_supply_quotation_full
        WHERE day=20181118 and createtime>='2018-05-01' 
        GROUP BY purchaseinfoid
        )bb on aa.id=bb.purchaseinfoid
    GROUP BY aa.hnuserid
    )a 
left join 
    (
        SELECT buyuserid,count(DISTINCT ordercode) ordernum
        from ods_trade.b2b_sale_hn_order_full
        where day=20181118 and state in (1,2,3) and createtime>='2018-05-01'
        group by buyuserid
    )b on a.hnuserid=b.buyuserid
left join
    (
    SELECT  cc.userid ,count(distinct cc.others) imnum
    from 
    (
    SELECT DISTINCT senderuserid as userid,receiveuserid others
    from dw_trade.dw_hn_chat_im_message
    WHERE day=20181118 and msgtime>='2018-05-01'
    UNION all
    SELECT DISTINCT receiveuserid as userid,senderuserid others
    from dw_trade.dw_hn_chat_im_message
    WHERE day=20181118 and msgtime>='2018-05-01' 
    ) cc
    GROUP BY cc.userid
    )c on a.hnuserid=c.userid
LEFT JOIN
    (
    SELECT dd.uesid,count(distinct dd.others) callnum
    from 
    (
    SELECT DISTINCT hnuserid as uesid,calleduserid as others
    from ods_trade.hn_manager_calldetail_append
    WHERE day>20180501 and day<=20181118 and state=2 and hnuserid>0 and dialtime>='2018-05-01'
    UNION all
    SELECT DISTINCT calleduserid as uesid,hnuserid as others
    from ods_trade.hn_manager_calldetail_append
    WHERE day>20180501 and state=2 and calleduserid>0 and dialtime>='2018-05-01'
    )dd
    GROUP BY dd.uesid
    ) d on a.hnuserid=d.uesid
LEFT JOIN
    (
        SELECT mainuserid,count(DISTINCT followuserid) attentionnum
        from ods_trade.hn_chat_im_attention_full
        WHERE day =20181118 
        GROUP BY mainuserid
    )t on a.hnuserid=t.mainuserid
LEFT JOIN
(
    select hnuserid,username,useraccount,regtime,lastlogtime
    from dw_public.dim_user_base_info
    WHERE day =20181118
)f on a.hnuserid=f.hnuserid
ORDER BY b.ordernum desc
LIMIT 5000
---农友圈
SELECT a.userid,f.username,f.useraccount,f.regtime,f.lastlogtime,
count(a.id)postnum,sum(b.sharecount) sharenum,sum(c.likenum) likenum ,sum(d.comnum) comnum
from 
(
SELECT distinct userid,id
from ods_circle.hn_circle_posts_full
WHERE day=20181118 and posttype=0 AND publisheddate>='2018-05-01'
)a
LEFT JOIN
(
SELECT DISTINCT  postid,sharecount
from ods_circle.hn_circle_postsextend_full
WHERE day=20181118 and createtime>='2018-05-01'

)b on a.id=b.postid
LEFT JOIN
(
SELECT objectid,count(*) likenum
from ods_circle.hn_circle_likes_full
WHERE day=20181118 and status=0 and likedate>='2018-05-01' and posttype=1
GROUP BY objectid
)c on a.id=c.objectid
LEFT JOIN
(
SELECT postid,count(*) comnum
from ods_circle.hn_circle_comments_full
WHERE day=20181118 and createtime>='2018-05-01' and commenttype=0 AND status=0
GROUP BY postid
) d on a.id=d.postid
LEFT JOIN
(
    select hnuserid,username,useraccount,regtime,lastlogtime
    from dw_public.dim_user_base_info
    WHERE day =20181118
)f on a.userid=f.hnuserid
GROUP BY a.userid,f.username,f.useraccount,f.regtime,f.lastlogtime
ORDER BY postnum desc
LIMIT 5000
-- 
SELECT  UserId,count(DISTINCT Id) num,SUM(DataType=0),SUM(DataType=1)
FROM hn_circle.posts 
WHERE PublishedDate>='2018-05-01' AND PublishedDate<'2018-11-19' AND PostType=0 AND `Status`=0
GROUP BY UserId 
ORDER BY num DESC
LIMIT 5000
-- 农友圈分享点击
SELECT day ,count(DISTINCT deviceid),count(*)
from dw_log.dw_appeventlog
WHERE day>=20181110 and day<=20181120 and eventid='share_click' and eventargskv like '%/friends/detail.html%'
GROUP BY day 