#当日版本使用最多的人数
select day,max(a.num)
from (
    select  day,appver,count(distinct userid) num
    from dw_log.dw_appstartlog
    where day>=20180101 and day<=20180716
    group by day,appver
    order by day
    )a
group by a.day 
#当前状态下禁用的用户，历史使用版本取使用过相同版本的最后的日期
select a.hnuserid,b.appversion,max(b.day)
from
    (
    SELECT distinct hnuserid
    from ods_public.hnuser_hnuser_full
    where day=20180718 and status=2
    ) a join
    (select distinct userid,appversion,day
    from dw_log.dw_apppagelog
    where day>=20180101 and day<=20180716
    )b on a.hnuserid=b.userid
group by a.hnuserid,b.appversion

#当前没禁用状态为1的用户，历史使用版本取使用过相同版本的最后的日期，以及各版本使用情况
select c.shijian,c.appversion,count(hnuserid)
from (
        select a.hnuserid,b.appversion,max(b.day) shijian 
        from
            (
            SELECT distinct hnuserid
            from ods_public.hnuser_hnuser_full
            where day=20180718 and status=1
            ) a join
            (select distinct userid,appversion,day
            from dw_log.dw_apppagelog
            where day>=20180101 and day<=20180716
            )b on a.hnuserid=b.userid
        group by a.hnuserid,b.appversion
    )c
group by c.shijian,c.appversion

#当前状态下被设置风险的用户，历史使用版本取使用过相同版本的最后的日期
select a.hnuserid,a.risklevel,b.appversion,max(b.day)
from
    (
    SELECT distinct hnuserid,risklevel
    from ods_public.hnuser_hnuser_full
    where day=20180718 and risklevel !=4
    ) a join
    (select distinct userid,appversion,day
    from dw_log.dw_apppagelog
    where day>=20180101 and day<=20180716
    )b on a.hnuserid=b.userid
group by a.hnuserid,a.risklevel,b.appversion

select c.shijian,c.risklevel,c.appversion,count(c.hnuserid)
from (
#当前状态下无风险的用户，历史使用版本取使用过相同版本的最后的日期（取人数）
select a.hnuserid,a.risklevel,b.appversion,max(b.day) shijian
from
    (
    SELECT distinct hnuserid,risklevel
    from ods_public.hnuser_hnuser_full
    where day=20180718 and risklevel =4
    ) a join
    (select distinct userid,appversion,day
    from dw_log.dw_apppagelog
    where day>=20180101 and day<=20180716
    )b on a.hnuserid=b.userid
group by a.hnuserid,a.risklevel,b.appversion
) c
group by c.shijian,c.risklevel,c.appversion