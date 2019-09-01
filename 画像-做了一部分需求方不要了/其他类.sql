#我的 用户属性
#性别
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
    (SELECT DISTINCT userid
    from dw_log.dw_apppagelog
     where day>='20180703' 
    	and day<'20180710' 
    	and (current_page='MineFragment' or current_page ='MeViewController')
    )a
    left join
    (SELECT DISTINCT hn_user_id,card_no
    from dw_public.dim_hnuser_risk_verified_info
    where day='20180709'
    )b on a.userid=b.hn_user_id 
    left join
    (select DISTINCT hnuserid,cardno
    from ods_public.hnuser_personalcertification_full
    where day='20180709'
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
#年龄
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
    (SELECT DISTINCT userid
    from dw_log.dw_apppagelog
     where day>='20180703' 
    	and day<'20180710' 
    	and (current_page='MineFragment' or current_page ='MeViewController')
    )a
    left join
    (SELECT DISTINCT hn_user_id,card_no
    from dw_public.dim_hnuser_risk_verified_info
    where day='20180709'
    )b on a.userid=b.hn_user_id 
    left join
    (select DISTINCT hnuserid,cardno
    from ods_public.hnuser_personalcertification_full
    where day='20180709'
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
#新老用户

select 
	case 
    when b.regtime between '2018-07-03 00:00:00.0' and '2018-07-10 00:00:00.0' then '新用户'
    when b.regtime<'2018-07-03 00:00:00.0'  then '老用户'
    else '系统刷新时间不匹配' end new_old ,count(a.userid) `人数`
from
    (SELECT DISTINCT userid
    from dw_log.dw_apppagelog
     where day>='20180703' 
    	and day<'20180710' 
    	and (current_page='MineFragment' or current_page ='MeViewController')
    )a 
    left join
    (SELECT DISTINCT hnuserid,regtime
    from dw_public.dim_user_base_info
    where day='20180709'
    )b on a.userid=b.hnuserid
    
group by 
	(case 
    when b.regtime between '2018-07-03 00:00:00.0' and '2018-07-10 00:00:00.0' then '新用户'
    when b.regtime<'2018-07-03 00:00:00.0'  then '老用户'
    else '系统刷新时间不匹配' end
    )
#我的  手机品牌 
SELECT b.brand `手机品牌`,count(a.deviceid) `人数`
from 
	(SELECT DISTINCT deviceid
		FROM dw_log.dw_apppagelog
		where day>='20180703' 
		and day<'20180710' 
		and (current_page='MineFragment' or current_page ='MeViewController')
	) a--时间内访问我的页面的用户
	left join 
	(SELECT deviceid,brand
		from dw_log.dw_appdevicelog
		where day='20180709'
		) b on a.deviceid=b.deviceid--手机类别结果中NULL应该为iPhone
									-- 【去掉和加上（or current_page ='MeViewController'ios我的埋点）差值刚好为null的值】
GROUP BY b.brand
#我的 手机屏幕
SELECT b.screen `手机屏幕`,count( a.deviceid) `人数`
from 
	(SELECT DISTINCT deviceid
		FROM dw_log.dw_apppagelog
		where day>='20180703' 
		and day<'20180710' 
		and (current_page='MineFragment' or current_page ='MeViewController')
	) a--时间内访问我的页面的用户
	left join 
	(SELECT deviceid,screen
		from dw_log.dw_appdevicelog
		where day='20180709'
	) b on a.deviceid=b.deviceid 
GROUP BY b.screen
#我的 用户身份
SELECT b.identity_name `用户身份`,count( a.userid) `人数`
from 
	(SELECT DISTINCT userid
		FROM dw_log.dw_apppagelog
		where day>='20180703' 
		and day<'20180710' 
		and (current_page='MineFragment' or current_page ='MeViewController')
	) a--时间内访问我的页面的用户
	left join 
	(SELECT hnuserid,identity_name 
	    FROM dw_public.dw_user_identity 
		where day='20180709'
	) b on a.userid=b.hnuserid 
GROUP BY b.identity_name
#我的 用户地域
SELECT b.province `用户地域`,count( a.userid) `人数`
from
	(SELECT DISTINCT userid
		FROM dw_log.dw_apppagelog
		where day>='20180703' 
		and day<'20180710' 
		and (current_page='MineFragment' or current_page ='MeViewController')
	) a--时间内访问我的页面的用户
	left join 
	(SELECT DISTINCT userid,province
		from dw_log.dw_log_app_start_address
		where day='20180709'
	) b on a.userid=b.userid 
GROUP BY b.province

#我的 用户访问时间（用户访问页面的时间）
select a.shijian `访问时间段`, count(userid) `人数` 
FROM	
	(SELECT DISTINCT userid,
	    case 
	    when hour(f_starttime) =0  then '[0,1)'
		when hour(f_starttime) =1  then '[1,2)'
		when hour(f_starttime) =2  then '[2,3)'
		when hour(f_starttime) =3  then '[3,4)'
		when hour(f_starttime) =4  then '[4,5)'
		when hour(f_starttime) =5  then '[[5,6)'
		when hour(f_starttime) =6  then '[6,7)'
		when hour(f_starttime) =7  then '[7,8)'
		when hour(f_starttime) =8  then '[8,9)'
		when hour(f_starttime) =9  then '[9,10)'
		when hour(f_starttime) =10  then '[10,11)'
		when hour(f_starttime) =11  then '[11,12)'
		when hour(f_starttime) =12  then '[12,13)'
		when hour(f_starttime) =13  then '[13,14)'
		when hour(f_starttime) =14  then '[14,15)'
		when hour(f_starttime) =15  then '[15,16)'
		when hour(f_starttime) =16  then '[16,17)'
		when hour(f_starttime) =17  then '[17,18)'
		when hour(f_starttime) =18  then '[18,19)'
		when hour(f_starttime) =19  then '[19,20)'
		when hour(f_starttime) =20  then '[20,21)'
		when hour(f_starttime) =21  then '[21,22)'
		when hour(f_starttime) =22  then '[22,23)'
		else '[23,24)' end shijian
		FROM dw_log.dw_apppagelog
		where day>='20180703' 
		and day<'20180710' 
		and (current_page='MineFragment' or current_page ='MeViewController')
	)a
group by a.shijian
#我的 收藏品类
SELECT c.cate3_name `收藏品类`,count(a.userid) `人数`
from 
	(SELECT DISTINCT userid
		FROM dw_log.dw_apppagelog
		where day>='20180703' 
		and day<'20180710' 
		and (current_page='MineFragment' or current_page ='MeViewController')
	) a--时间内访问我的页面的用户
	left join 
	(SELECT DISTINCT hnuserid,collectid
		from ods_public.hnuser_user_collect_append 
		where collecttype=2 and
		day>='20180703' and day<'20180710'--一周内有收藏的用户以及收藏的物品id 取产品（collecttype=2）
	) b on a.userid=b.hnuserid
	left join
   （select DISTINCT supplyid,cate3_name
   		FROM dw_trade.dw_b2b_product_supply 
   		where day='20180709'
	）c on b.collectid=c.supplyid--收藏品id与商品名关联
GROUP BY c.cate3_name--以三级目录分组有911组？
#我的 im品类
SELECT b.cate_name3 `IM品类`,count(a.userid) `人数`
from 
	(SELECT DISTINCT userid
		FROM dw_log.dw_apppagelog
		where day>='20180703' 
		and day<'20180710' 
		and (current_page='MineFragment' or current_page ='MeViewController')
	) a--时间内访问我的页面的用户
	left JOIN
	(select hnuserid,cate_name3
	from dw_log.dw_supply_inquiry
	where day>='20180703' and day<'20180710' 
	)b on a.userid=b.hnuserid
GROUP BY b.cate_name3--以三级目录分组有671组？
#我的 下单品类
SELECT d.cate3_name `下单品类`,count(a.userid) `人数`
from 
	(SELECT DISTINCT userid
		FROM dw_log.dw_apppagelog
		where day>='20180703' 
		and day<'20180710' 
		and (current_page='MineFragment' or current_page ='MeViewController')
	) a join --时间内访问我的页面的用户
    (SELECT buyuserid,ordercode
		from ods_trade.b2b_sale_hn_order_full
		where day='20180709' 
	) b on a.userid=b.buyuserid--下单买家和子订单号（包含退货退款的）
	 join 
	(select saleordercode , productid
   		FROM ods_trade.b2b_sale_order_detail_append
   		where day>='20180703' 
		and day<'20180710' 
	)c on b.ordercode=c.saleordercode--子订单和产品id
	JOIN 
	(select supplyid,cate3_name
   		FROM dw_trade.dw_b2b_product_supply 
   		where day='20180709'
	) d on c.productid=d.supplyid--产品id和三级名称329类
group by d.cate3_name
#我的 电话品类 

