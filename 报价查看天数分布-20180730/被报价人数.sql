-- 总报价条数以及间隔几天被查看的条数
SELECT COUNT(*)'总报价',SUM(DATEDIFF(readTime,createTime)=0) '第一天',
						SUM(DATEDIFF(readTime,createTime)=1) '第二天',
						SUM(DATEDIFF(readTime,createTime)=2) '第三天',
						SUM(DATEDIFF(readTime,createTime)=3) '第四天',
						SUM(DATEDIFF(readTime,createTime)=4) '第五天',
						SUM(DATEDIFF(readTime,createTime)=5) '第六天',
						SUM(DATEDIFF(readTime,createTime)=6) '第七天',
						SUM(DATEDIFF(readTime,createTime)>=7) '七天后',
						SUM(DATEDIFF(readTime,createTime) is NULL) '没有查看'

FROM b2b_supply.quotation
WHERE createTime>='2018-07-01' AND createTime<='2018-07-28'
GROUP BY date_form
-- 被报价的人数（发采购者）以及间隔几天的报价查看者人数
	-- 总被报价的人数（去重）
SELECT COUNT(DISTINCT buyUserId)
FROM b2b_supply.quotation
WHERE createTime>='2018-07-01' AND createTime<='2018-07-28'
	-- 间隔几天查看报价的人数占比 总和不等于总报价人数 因为有的人可能在一天内查看过一些报价 在其他天内产看过其他报价
SELECT case when DATEDIFF(readTime,createTime)=0 then '第一天查看人数' 
			when DATEDIFF(readTime,createTime)=1 then '第二天查看人数' 
			when DATEDIFF(readTime,createTime)=2 then '第三天查看人数' 
			when DATEDIFF(readTime,createTime)=3 then '第四天查看人数' 
			when DATEDIFF(readTime,createTime)=4 then '第五天查看人数' 
			when DATEDIFF(readTime,createTime)=5 then '第六天查看人数' 
			when DATEDIFF(readTime,createTime)=6 then '第七天查看人数'
			when DATEDIFF(readTime,createTime)>=7 then '七天后查看人数' 
			else '没有查看人数' end,COUNT(DISTINCT buyUserId)
FROM b2b_supply.quotation
WHERE createTime>='2018-07-01' AND createTime<='2018-07-28'
GROUP BY case when DATEDIFF(readTime,createTime)=0 then '第一天查看人数' 
			when DATEDIFF(readTime,createTime)=1 then '第二天查看人数'
			when DATEDIFF(readTime,createTime)=2 then '第三天查看人数' 
			when DATEDIFF(readTime,createTime)=3 then '第四天查看人数' 
			when DATEDIFF(readTime,createTime)=4 then '第五天查看人数' 
			when DATEDIFF(readTime,createTime)=5 then '第六天查看人数' 
			when DATEDIFF(readTime,createTime)=6 then '第七天查看人数' 
			when DATEDIFF(readTime,createTime)>=7 then '七天后查看人数' 
			else '没有查看人数' end
--取用户查看报价的最小间隔天数，如果用户有一天查看的也有两天查看的认为他的最短查看时间为一天，各天人数等于总人数
SELECT case when a.jiange=0 then '第一天查看人数' 
            when a.jiange=1 then '第二天查看人数' 
            when a.jiange=2 then '第三天查看人数' 
            when a.jiange=3 then '第四天查看人数' 
            when a.jiange=4 then '第五天查看人数' 
            when a.jiange=5 then '第六天查看人数' 
            when a.jiange=6 then '第七天查看人数'
            when a.jiange>=7 then '七天后查看人数' 
            else '没有查看人数' end,COUNT( DISTINCT a.buyUserId)
FROM(
        SELECT buyUserId,MIN(DATEDIFF(readTime,createTime)) jiange
                                
        FROM b2b_supply.quotation
        WHERE createTime>='2018-07-01' AND createTime<='2018-07-28'
        GROUP BY buyUserId
        ) a
GROUP BY case when a.jiange=0 then '第一天查看人数' 
            when a.jiange=1 then '第二天查看人数' 
            when a.jiange=2 then '第三天查看人数' 
            when a.jiange=3 then '第四天查看人数' 
            when a.jiange=4 then '第五天查看人数' 
            when a.jiange=5 then '第六天查看人数' 
            when a.jiange=6 then '第七天查看人数'
            when a.jiange>=7 then '七天后查看人数' 
            else '没有查看人数' end


--每天
SELECT DATE_FORMAT(createTime,'%Y%m%d'), COUNT(*)'总报价',COUNT(DISTINCT buyUserId)'总人数',SUM(DATEDIFF(readTime,createTime)=0) '第一天查看的条数',
						COUNT(DISTINCT case when DATEDIFF(readTime,createTime)=0 then buyUserId ELSE null END) '第一天查看人数',
						SUM(DATEDIFF(readTime,createTime)=1) '第二天查看的条数',
						COUNT(DISTINCT case when DATEDIFF(readTime,createTime)=1 then buyUserId ELSE null END) '第二天查看人数',
						SUM(DATEDIFF(readTime,createTime)=2) '第三天查看的条数',
						COUNT(DISTINCT case when DATEDIFF(readTime,createTime)=2 then buyUserId ELSE null END) '第三天查看人数',
						SUM(DATEDIFF(readTime,createTime)=3) '第四天查看的条数',
						COUNT(DISTINCT case when DATEDIFF(readTime,createTime)=3 then buyUserId ELSE null END) '第四天查看人数',
						SUM(DATEDIFF(readTime,createTime)=4) '第五天查看的条数',
						COUNT(DISTINCT case when DATEDIFF(readTime,createTime)=4 then buyUserId ELSE null END) '第五天查看人数',
						SUM(DATEDIFF(readTime,createTime)=5) '第六天查看的条数',
						COUNT(DISTINCT case when DATEDIFF(readTime,createTime)=5 then buyUserId ELSE null END) '第六天查看人数',
						SUM(DATEDIFF(readTime,createTime)=6) '第七天查看的条数',
						COUNT(DISTINCT case when DATEDIFF(readTime,createTime)=6 then buyUserId ELSE null END) '第七天查看人数',
						SUM(DATEDIFF(readTime,createTime)>=7) '七天后查看的条数',
						COUNT(DISTINCT case when DATEDIFF(readTime,createTime)>=7 then buyUserId ELSE null END) '七天后查看人数',
						SUM(DATEDIFF(readTime,createTime) is NULL) '没有查看的条数',
						COUNT(DISTINCT case when DATEDIFF(readTime,createTime) is NULL then buyUserId ELSE null END) '没有查看的人数'
FROM b2b_supply.quotation
WHERE createTime>='2018-07-01' AND createTime<='2018-07-28'
GROUP BY DATE_FORMAT(createTime,'%Y%m%d')