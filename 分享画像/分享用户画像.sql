select distinct userid 
from log_edw_hn_source_new.appeventlog
where day >= 20180725 and day <= 20180731 and id = 'share_click' and kv like '%/share/stable/html/supply/detail.html%'

-- 性别
SELECT   
	case 
	when length(b.card_no)=18 and substring(b.card_no,17,1) in (1,3,5,7,9) then '男'
	when length(b.card_no)=15 and substring(b.card_no,15 ,1) in (1,3,5,7,9) then '男'
	when length(b.card_no)=18 and substring(b.card_no,17,1) in (2,4,6,8) then '女'
	when length(b.card_no)=15 and substring(b.card_no,15 ,1) in (2,4,6,8) then '女'
	when length(b.card_no)!=18 and length(c.cardno)=18 and substring(c.cardno,17 ,1) in (1,3,5,7,9) then '男'
	when length(b.card_no)!=18 and length(c.cardno)=15 and substring(c.cardno,15 ,1) in (1,3,5,7,9) then '男'
	when length(b.card_no)!=15 and length(c.cardno)=18 and substring(c.cardno,17 ,1) in (2,4,6,8) then '女'
	when length(b.card_no)!=15 and length(c.cardno)=15 and substring(c.cardno,15 ,1) in (2,4,6,8) then '女' 
	else '未知' END `性别`,count( DISTINCT a.userid) `人数`
  from
    (
    	select distinct userid 
		from log_edw_hn_source_new.appeventlog
		where day >= 20180725 and day <= 20180731 and id = 'share_click' and kv like '%/share/stable/html/supply/detail.html%'
    )a
    left join
    (
    	SELECT DISTINCT hn_user_id,card_no
	    from dw_public.dim_hnuser_risk_verified_info
	    where day='20180731'
    )b on a.userid=b.hn_user_id 
    left join
    (
    	select DISTINCT hnuserid,cardno
	    from ods_public.hnuser_personalcertification_full
	    where day='20180731'
    )c on a.userid=c.hnuserid

group by(case 
		 when length(b.card_no)=18 and substring(b.card_no,17,1) in (1,3,5,7,9) then '男'
		 when length(b.card_no)=15 and substring(b.card_no,15 ,1) in (1,3,5,7,9) then '男'
		 when length(b.card_no)=18 and substring(b.card_no,17,1) in (2,4,6,8) then '女'
		 when length(b.card_no)=15 and substring(b.card_no,15 ,1) in (2,4,6,8) then '女'
		 when length(b.card_no)!=18 and  length(c.cardno)=18 and substring(c.cardno,17 ,1) in (1,3,5,7,9) then '男'
		 when length(b.card_no)!=18 and  length(c.cardno)=15 and substring(c.cardno,15 ,1) in (1,3,5,7,9) then '男'
		 when length(b.card_no)!=15 and length(c.cardno)=18 and substring(c.cardno,17 ,1) in (2,4,6,8) then '女'
		 when length(b.card_no)!=15 and length(c.cardno)=15 and substring(c.cardno,15 ,1) in (2,4,6,8) then '女' 
		 else '未知' END
		)
-- 年龄
SELECT  
	case 
	when length(b.card_no) in (15,18)  and (2018-cast(substring(b.card_no,7,4) as int))<18 then '(0,18)'
	when length(b.card_no) in (15,18)  and (2018-cast(substring(b.card_no,7,4) as int))>=18 and (2018-cast(substring(b.card_no,7,4) as int))<=24 then '[18,24]'
 	when length(b.card_no) in (15,18)  and (2018-cast(substring(b.card_no,7,4) as int))>=25 and (2018-cast(substring(b.card_no,7,4) as int))<=34 then '[25,34]'
	when length(b.card_no) in (15,18)  and (2018-cast(substring(b.card_no,7,4) as int))>=35 and (2018-cast(substring(b.card_no,7,4) as int))<=44 then '[35,44]'
	when length(b.card_no) in (15,18)  and (2018-cast(substring(b.card_no,7,4) as int))>=45 and (2018-cast(substring(b.card_no,7,4) as int))<=54 then '[45,54]'
	when length(b.card_no) in (15,18)  and (2018-cast(substring(b.card_no,7,4) as int))>=55 and (2018-cast(substring(b.card_no,7,4) as int))<=64 then '[55,64]'
	when length(b.card_no) in (15,18)  and (2018-cast(substring(b.card_no,7,4) as int))>=55  then '[65,]'
	when length(b.card_no) not in (15,18) and length(c.cardno) in (15,18) and (2018-cast(substring(c.cardno,7,4) as int))<18 then '(0,18)'
	when length(b.card_no) not in (15,18) and length(c.cardno) in (15,18) and (2018-cast(substring(c.cardno,7,4) as int))>=18 and (2018-cast(substring(b.card_no,7,4) as int))<=24 then '[18,24]'
 	when length(b.card_no) not in (15,18) and length(c.cardno) in (15,18) and (2018-cast(substring(c.cardno,7,4) as int))>=25 and (2018-cast(substring(b.card_no,7,4) as int))<=34 then '[25,34]'
	when length(b.card_no) not in (15,18) and length(c.cardno) in (15,18) and (2018-cast(substring(c.cardno,7,4) as int))>=35 and (2018-cast(substring(b.card_no,7,4) as int))<=44 then '[35,44]'
	when length(b.card_no) not in (15,18) and length(c.cardno) in (15,18) and (2018-cast(substring(c.cardno,7,4) as int))>=45 and (2018-cast(substring(b.card_no,7,4) as int))<=54 then '[45,54]'
	when length(b.card_no) not in (15,18) and length(c.cardno) in (15,18) and (2018-cast(substring(c.cardno,7,4) as int))>=55 and (2018-cast(substring(b.card_no,7,4) as int))<=64 then '[55,64]'
	when length(b.card_no) not in (15,18) and length(c.cardno) in (15,18) and (2018-cast(substring(c.cardno,7,4) as int))>=55  then '[65,]'
	else '未知' END `年龄` ,count( DISTINCT a.userid) `人数`

from
    (
    	select distinct userid 
		from log_edw_hn_source_new.appeventlog
		where day >= 20180725 and day <= 20180731 and id = 'share_click' and kv like '%/share/stable/html/supply/detail.html%'
    )a
    left join
    (
    	SELECT DISTINCT hn_user_id,card_no
	    from dw_public.dim_hnuser_risk_verified_info
	    where day='20180731'
    )b on a.userid=b.hn_user_id 
    left join
    (
    	select DISTINCT hnuserid,cardno
    	from ods_public.hnuser_personalcertification_full
   		where day='20180731'
    )c on a.userid=c.hnuserid 

group by 
	(case 
	when length(b.card_no) in (15,18)  and (2018-cast(substring(b.card_no,7,4) as int))<18 then '(0,18)'
	when length(b.card_no) in (15,18)  and (2018-cast(substring(b.card_no,7,4) as int))>=18 and (2018-cast(substring(b.card_no,7,4) as int))<=24 then '[18,24]'
 	when length(b.card_no) in (15,18)  and (2018-cast(substring(b.card_no,7,4) as int))>=25 and (2018-cast(substring(b.card_no,7,4) as int))<=34 then '[25,34]'
	when length(b.card_no) in (15,18)  and (2018-cast(substring(b.card_no,7,4) as int))>=35 and (2018-cast(substring(b.card_no,7,4) as int))<=44 then '[35,44]'
	when length(b.card_no) in (15,18)  and (2018-cast(substring(b.card_no,7,4) as int))>=45 and (2018-cast(substring(b.card_no,7,4) as int))<=54 then '[45,54]'
	when length(b.card_no) in (15,18)  and (2018-cast(substring(b.card_no,7,4) as int))>=55 and (2018-cast(substring(b.card_no,7,4) as int))<=64 then '[55,64]'
	when length(b.card_no) in (15,18)  and (2018-cast(substring(b.card_no,7,4) as int))>=55  then '[65,]'
	when length(b.card_no) not in (15,18) and length(c.cardno) in (15,18) and (2018-cast(substring(c.cardno,7,4) as int))<18 then '(0,18)'
	when length(b.card_no) not in (15,18) and length(c.cardno) in (15,18) and (2018-cast(substring(c.cardno,7,4) as int))>=18 and (2018-cast(substring(b.card_no,7,4) as int))<=24 then '[18,24]'
 	when length(b.card_no) not in (15,18) and length(c.cardno) in (15,18) and (2018-cast(substring(c.cardno,7,4) as int))>=25 and (2018-cast(substring(b.card_no,7,4) as int))<=34 then '[25,34]'
	when length(b.card_no) not in (15,18) and length(c.cardno) in (15,18) and (2018-cast(substring(c.cardno,7,4) as int))>=35 and (2018-cast(substring(b.card_no,7,4) as int))<=44 then '[35,44]'
	when length(b.card_no) not in (15,18) and length(c.cardno) in (15,18) and (2018-cast(substring(c.cardno,7,4) as int))>=45 and (2018-cast(substring(b.card_no,7,4) as int))<=54 then '[45,54]'
	when length(b.card_no) not in (15,18) and length(c.cardno) in (15,18) and (2018-cast(substring(c.cardno,7,4) as int))>=55 and (2018-cast(substring(b.card_no,7,4) as int))<=64 then '[55,64]'
	when length(b.card_no) not in (15,18) and length(c.cardno) in (15,18) and (2018-cast(substring(c.cardno,7,4) as int))>=55  then '[65,]'
	else '未知' END
	)
-- 身份
SELECT b.identity_name `用户身份`,count( a.userid) `人数`
from 
	(
		select distinct userid 
		from log_edw_hn_source_new.appeventlog
		where day >= 20180725 and day <= 20180731 and id = 'share_click' and kv like '%/share/stable/html/supply/detail.html%'
	) a--时间内访问我的页面的用户
	left join 
	(
		SELECT hnuserid,identity_name 
	    FROM dw_public.dw_user_identity 
		where day='20180731'
	) b on a.userid=b.hnuserid 
GROUP BY b.identity_name
--地域
SELECT b.province `用户地域`,count( a.userid) `人数`
from
	(
		select distinct userid 
		from log_edw_hn_source_new.appeventlog
		where day >= 20180725 and day <= 20180731 and id = 'share_click' and kv like '%/share/stable/html/supply/detail.html%'
	) a--时间内访问我的页面的用户
	left join 
	(SELECT DISTINCT userid,province
		from dw_log.dw_log_app_start_address
		where day='20180731'
	) b on a.userid=b.userid 
GROUP BY b.province
