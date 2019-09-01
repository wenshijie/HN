/*im询盘对数（回复对数）*/
SELECT a.daydate,COUNT(*)/2
FROM 
(SELECT DISTINCT DATE_FORMAT(msgTime,'%m-%d') daydate,senderUserId,receiveUserId
FROM hn_chat.im_message
WHERE msgTime>='2018-08-08'
AND msgTime<'2018-08-15'
AND platform in (1,2,3)
)a
JOIN 
(SELECT DISTINCT DATE_FORMAT(msgTime,'%m-%d')daydate, senderUserId,receiveUserId
from hn_chat.im_message
WHERE msgTime>='2018-08-08'
AND msgTime<'2018-08-15'
AND platform in (1,2,3)
)b
ON (a.senderUserId=b.receiveUserId AND a.receiveUserId=b.senderUserId AND a.daydate=b.daydate)
GROUP BY a.daydate

/*im询盘总对数*/
SELECT DATE_FORMAT(msgTime,'%m-%d'),COUNT(DISTINCT fullSessionId)
from hn_chat.im_message
WHERE msgTime>=DATE_SUB(CURDATE(),INTERVAL 8 DAY)
AND msgTime<CURDATE()
AND platform in (1,2,3)
GROUP BY DATE_FORMAT(msgTime,'%m-%d')


/* app询盘人数, 在APP端成功拨打电话用户和APP端IM发送用户的去重人数*/
SELECT COUNT(DISTINCT  a.hnuserid)
FROM 
(SELECT DISTINCT hnUserId  /* APP端成功拨打电话人数 */
FROM hn_manager.calldetail
WHERE dialTime>=DATE_SUB(CURDATE(),INTERVAL 1 DAY)
AND dialTime<CURDATE()
AND duration>0
AND state=2
AND callType=1
AND sourceFrom in (3,4)
UNION 
SELECT DISTINCT senderUserId AS hnuserid  /* APP端IM发送人数*/
FROM hn_chat.im_message
WHERE msgTime>=DATE_SUB(CURDATE(),INTERVAL 1 DAY)
AND msgTime<CURDATE()
AND platform in (1,2)
)a

--- dau
SELECT daydate,SUM(active_users)
FROM hn_bi.umeng_basic_acc
WHERE daydate>='2018-08-11' AND date_seg='daily' AND daydate<='2018-10-26'
GROUP BY daydate
----app询盘
SELECT a.time,COUNT(DISTINCT  a.hnuserid)
FROM 
(SELECT DISTINCT DATE(dialtime) time,hnUserId  /* APP端成功拨打电话人数 */
FROM hn_manager.calldetail
WHERE dialTime>='2018-08-01'
AND dialTime<='2018-11-15'
AND duration>0
AND state=2
AND callType=1
AND sourceFrom in (3,4)
UNION 
SELECT DISTINCT DATE(msgTime) time,senderUserId AS hnuserid  /* APP端IM发送人数*/
FROM hn_chat.im_message
WHERE msgTime>='2018-08-01' AND msgTime<='2018-11-15'
AND platform in (1,2)
)a
GROUP BY a.time


---
SELECT COUNT(DISTINCT a.senderUserId,a.receiveUserId),COUNT(DISTINCT b.senderUserId,b.receiveUserId)
FROM
(
SELECT DISTINCT senderUserId,receiveUserId
FROM hn_chat.im_message
WHERE msgTime>='2018-10-14' AND msgTime<'2018-10-15' AND platform in (1,2)
) a
LEFT JOIN
(
SELECT DISTINCT senderUserId,receiveUserId
from hn_chat.im_message
WHERE msgTime <'2018-10-14' AND msgTime>='2018-10-01' AND platform in (1,2)
)b ON a.senderUserId=b.senderUserId AND a.receiveUserId=b.receiveUserId 
--
SELECT a.day,b.from_page,count(a.senderuserid)
from  
(
SELECT date_format(msgtime,'yyyyMMdd') day,senderuserid
from dw_trade.dw_hn_chat_im_message
WHERE day=20181104 and msgtime>='2018-08-01' and platform=1
GROUP BY date_format(msgtime,'yyyyMMdd'),senderuserid
)a
JOIN
(
SELECT day,userid,get_json_object(eventargskv,'$.from') from_page
from dw_log.dw_appeventlog 
WHERE day<=20181104 and day >=20180801 and ( eventid='chat_click' or eventid='call_click') and 
get_json_object(eventargskv,'$.from') in ('动态详情','抖货详情','发出的报价',
        '买家订单','卖家订单','收到的报价','收到的报价详情') 
and channel <> 'AppStore'
GROUP BY day, userid,get_json_object(eventargskv,'$.from')
) b on a.day=b.day AND a.senderuserid=b.userid
GROUP BY a.day,b.from_page
--
SELECT count(a.senderuserid),count(c.senderuserid)
from  
(
SELECT DISTINCT senderuserid,receiveuserid
from dw_trade.dw_hn_chat_im_message
WHERE day=20181104 and msgtime>='2018-10-12' and msgtime<'2018-10-13'  and platform=1
)a
JOIN
(
SELECT DISTINCT userid
from dw_log.dw_appeventlog 
WHERE day=20181012  and ( eventid='chat_click' or eventid='call_click') and 
get_json_object(eventargskv,'$.from') ='联系人列表'
and channel <> 'AppStore'
)b on a.senderuserid=b.userid
LEFT JOIN 
(
SELECT DISTINCT senderuserid,receiveuserid
from dw_trade.dw_hn_chat_im_message
WHERE day=20181104 and msgtime>='2018-07-12' and msgtime<'2018-10-12'  and platform=1
)c on a.senderuserid=c.senderuserid and a.receiveuserid=c.receiveuserid

----采购、供应 询盘者身份
SELECT aa.day_time,COUNT(aa.senderUserId)
FROM
(
SELECT DISTINCT DATE(msgTime) day_time, senderUserId  /* APP端IM发送人数*/
FROM hn_chat.im_message
WHERE msgTime>='2018-08-01'
AND msgTime<'2018-10-27'
AND platform in (1,2)
)aa
LEFT JOIN
(
SELECT DISTINCT hnUserId
FROM b2b_supply.hnpurchaseinfo
)a ON aa.senderUserId=a.hnUserId
LEFT JOIN
(
SELECT DISTINCT hnUserId
from b2b_product.supply
WHERE isCollect=0 AND isTest=0
)b ON aa.senderUserId=b.hnUserId
WHERE b.hnUserId is  NULL AND a.hnUserId is NOT NULL -- 只发供应的/采购
GROUP BY aa.day_time
ORDER BY aa.day_time

-- 被动询盘
SELECT a.day_time ,COUNT(*)
FROM
(
SELECT DISTINCT DATE(msgTime) day_time,fullSessionId, MIN(msgTime) min_time  /* APP端IM发送人数*/
FROM hn_chat.im_message
WHERE msgTime>='2018-08-01'
AND msgTime<'2018-10-27'
AND platform in (1,2)
GROUP BY DATE(msgTime) ,fullSessionId
)t
JOIN
(
SELECT DISTINCT DATE(msgTime) day_time,fullSessionId, msgTime,senderUserId,receiveUserId  /* APP端IM发送人数*/
FROM hn_chat.im_message
WHERE msgTime>='2018-08-01'
AND msgTime<'2018-10-27'
AND platform in (1,2)
)a ON t.day_time=a.day_time AND t.fullSessionId=a.fullSessionId AND t.min_time=a.msgTime
JOIN
(
SELECT DISTINCT DATE(msgTime) day_time,senderUserId,receiveUserId  /* APP端IM发送人数*/
FROM hn_chat.im_message
WHERE msgTime>='2018-08-01'
AND msgTime<'2018-10-27'
AND platform in (1,2)
) s ON a.receiveUserId=s.senderUserId AND a.senderUserId=s.receiveUserId AND a.day_time=s.day_time
LEFT JOIN
(
SELECT DISTINCT hnUserId
FROM b2b_supply.hnpurchaseinfo
)c ON a.receiveUserId=c.hnUserId
LEFT JOIN
(
SELECT DISTINCT hnUserId
from b2b_product.supply
WHERE isCollect=0 AND isTest=0
)d ON a.receiveUserId=d.hnUserId
WHERE c.hnUserId is  NULL AND d.hnUserId is  NULL -- 只发供应的/采购
GROUP BY a.day_time
-- 滑三屏 问 询盘回复回复率
SELECT aa.day,count(aa.fullsessionid)
from (
SELECT c.day,c.fullsessionid,count( DISTINCT c.senderuserid,c.receiveuserid) num
from  
(
SELECT date_format(msgtime,'yyyyMMdd') day,senderuserid,fullsessionid
from dw_trade.dw_hn_chat_im_message
WHERE day=20181114 and msgtime>='2018-10-01' and platform=1 and detail
--and( detail='最低批发价多少？' or detail='运费怎么算？')
GROUP BY date_format(msgtime,'yyyyMMdd'),senderuserid,fullsessionid
)a
join
(
SELECT  date_format(msgtime,'yyyyMMdd') day,fullsessionid,senderuserid,receiveuserid
from dw_trade.dw_hn_chat_im_message
WHERE day=20181114 and msgtime>='2018-10-01' and platform=1
GROUP BY date_format(msgtime,'yyyyMMdd') ,fullsessionid,senderuserid,receiveuserid
)c on a.day=c.day and a.fullsessionid=c.fullsessionid 
GROUP BY c.day,c.fullsessionid
HAVING num=2 -- 等于1 未回复 等于2 回复
)aa 
GROUP BY aa.day

-- 采购发布成功询盘回复
SELECT aa.day,count(aa.fullsessionid)
from (
SELECT c.day,c.fullsessionid,count( DISTINCT c.senderuserid,c.receiveuserid) num
from  
(
SELECT date_format(msgtime,'yyyyMMdd') day,senderuserid,fullsessionid
from dw_trade.dw_hn_chat_im_message
WHERE day=20181114 and msgtime>='2018-09-01' and platform=1 and detail like '%id%'
GROUP BY date_format(msgtime,'yyyyMMdd'),senderuserid,fullsessionid
)a
JOIN
(
SELECT day,userid
from dw_log.dw_appeventlog 
WHERE day<=20181114 and day >=20180901 and ( eventid='chat_click' or eventid='call_click') and 
get_json_object(eventargskv,'$.from') ='采购发布成功' 
and channel <> 'AppStore'
GROUP BY day, userid
) b on a.day=b.day AND a.senderuserid=b.userid
join
(
SELECT  date_format(msgtime,'yyyyMMdd') day,fullsessionid,senderuserid,receiveuserid
from dw_trade.dw_hn_chat_im_message
WHERE day=20181114 and msgtime>='2018-10-01' and platform=1
GROUP BY date_format(msgtime,'yyyyMMdd') ,fullsessionid,senderuserid,receiveuserid
)c on a.day=c.day and a.fullsessionid=c.fullsessionid 
GROUP BY c.day,c.fullsessionid
HAVING num=1
)aa 
GROUP BY aa.day