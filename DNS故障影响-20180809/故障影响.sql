--分时注册用户数
select date(createTime),HOUR(createTime),COUNT(DISTINCT hnUserId)
FROM hnuser.hnuser
WHERE createTime>='2018-07-15' and createTime<'2018-08-08'
GROUP BY date(createTime),HOUR(createTime)


SELECT count(a.deviceid) new_no_reg,count(b.deviceid) firstday_leave,count(c.deviceid) secondday_leave
from 
	(
		SELECT   deviceid,
		max(case when date_format(dev_first_time,'yyyy-MM-dd') = date_format(user_first_time,'yyyy-MM-dd') then userid else null end) as userid
		from miner.user_dev_relate
		WHERE  dday = '2018-08-08'  and  ( dev_first_time <= user_first_time  or user_first_time is NULL)
		and  dev_first_time >= '2018-08-02' and dev_first_time < '2018-08-03'
		GROUP BY deviceid
	)a                                                                 --新增包含注册未注册
	LEFT JOIN
	(
		SELECT DISTINCT deviceid
		from dw_log.dw_apppagelog
		where day=20180803
	)b on a.deviceid=b.deviceid                                        -- 次日留存
	LEFT JOIN
	(
		SELECT DISTINCT deviceid
		from dw_log.dw_apppagelog
		where day=20180804
	)c on a.deviceid=c.deviceid                                        -- 二日留存
WHERE a.userid IS NULL                                                 -- 未注册


--- 新增注册未注册
SELECT a.daydate, count( a.deviceid) new_no_reg
from 
(
    SELECT   to_date(dev_first_time) daydate,deviceid,
    max(case when date_format(dev_first_time,'yyyy-MM-dd') = date_format(user_first_time,'yyyy-MM-dd') then userid else null end) as userid
    from miner.user_dev_relate
    WHERE  dday = '2018-08-08'  and  ( dev_first_time <= user_first_time  or user_first_time is NULL)
    and  dev_first_time >= '2018-07-22' and dev_first_time < '2018-08-08'
    GROUP BY to_date(dev_first_time),deviceid
)a
WHERE a.userid IS NOT NULL
GROUP BY  a.daydate
ORDER BY a.daydate
----新增注册未注册n天留存
SELECT a.daydate, count(b.deviceid) firstday_leave
from 
(
    SELECT   to_date(dev_first_time) daydate,deviceid,
    max(case when date_format(dev_first_time,'yyyy-MM-dd') = date_format(user_first_time,'yyyy-MM-dd') then userid else null end) as userid
    from miner.user_dev_relate
    WHERE  dday = '2018-08-08'  and  ( dev_first_time <= user_first_time  or user_first_time is NULL)
    and  dev_first_time >= '2018-07-22' and dev_first_time < '2018-08-08'
    GROUP BY to_date(dev_first_time),deviceid
)a
LEFT JOIN
(
    SELECT  DISTINCT deviceid, to_date(f_systime) daydate
    from dw_log.dw_apppagelog
    where day >= 20180723 AND day<=20180808
)b on a.deviceid=b.deviceid 
WHERE datediff(b.daydate,a.daydate)=2 AND a.userid IS NULL
GROUP BY a.daydate
ORDER BY a.daydate