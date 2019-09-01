select a.shijian `访问时间段`, count(userid) `人数` 
FROM	
	(SELECT DISTINCT userid,
	    case 
	    when substr(f_starttime,12) >'00:00:00' and substr(f_starttime,12) <='01:00:00' then '(0,1]'
		when substr(f_starttime,12) >'01:00:00' and substr(f_starttime,12) <='02:00:00' then '(1,2]'
		when substr(f_starttime,12) >'02:00:00' and substr(f_starttime,12) <='03:00:00' then '(2,3]'
		when substr(f_starttime,12) >'03:00:00' and substr(f_starttime,12) <='04:00:00' then '(3,4]'
		when substr(f_starttime,12) >'04:00:00' and substr(f_starttime,12) <='05:00:00' then '(4,5]'
		when substr(f_starttime,12) >'05:00:00' and substr(f_starttime,12) <='06:00:00' then '(5,6]'
		when substr(f_starttime,12) >'06:00:00' and substr(f_starttime,12) <='07:00:00' then '(6,7]'
		when substr(f_starttime,12) >'07:00:00' and substr(f_starttime,12) <='08:00:00' then '(7,8]'
		when substr(f_starttime,12) >'08:00:00' and substr(f_starttime,12) <='09:00:00' then '(8,9]'
		when substr(f_starttime,12) >'09:00:00' and substr(f_starttime,12) <='10:00:00' then '(9,10]'
		when substr(f_starttime,12) >'10:00:00' and substr(f_starttime,12) <='11:00:00' then '(10,11]'
		when substr(f_starttime,12) >'11:00:00' and substr(f_starttime,12) <='12:00:00' then '(11,12]'
		when substr(f_starttime,12) >'12:00:00' and substr(f_starttime,12) <='13:00:00' then '(12,13]'
		when substr(f_starttime,12) >'13:00:00' and substr(f_starttime,12) <='14:00:00' then '(13,14]'
		when substr(f_starttime,12) >'14:00:00' and substr(f_starttime,12) <='15:00:00' then '(14,15]'
		when substr(f_starttime,12) >'15:00:00' and substr(f_starttime,12) <='16:00:00' then '(15,16]'
		when substr(f_starttime,12) >'16:00:00' and substr(f_starttime,12) <='17:00:00' then '(16,17]'
		when substr(f_starttime,12) >'17:00:00' and substr(f_starttime,12) <='18:00:00' then '(17,18]'
		when substr(f_starttime,12) >'18:00:00' and substr(f_starttime,12) <='19:00:00' then '(18,19]'
		when substr(f_starttime,12) >'19:00:00' and substr(f_starttime,12) <='20:00:00' then '(19,20]'
		when substr(f_starttime,12) >'20:00:00' and substr(f_starttime,12) <='21:00:00' then '(20,21]'
		when substr(f_starttime,12) >'21:00:00' and substr(f_starttime,12) <='22:00:00'then '(21,22]'
		when substr(f_starttime,12) >'22:00:00' and substr(f_starttime,12) <='23:00:00' then '(22,23]'
		else '(23,24]' end shijian
		FROM dw_log.dw_apppagelog
		where day>='20180703' 
		and day<'20180710' 
		and (current_page='BuyFragment' or current_page ='FindGoodsViewController')
	)a
group by a.shijian

#我要买 用户访问时间（页面停留时间）
select a.shijian `逗留时间区间`, count(a.userid) `人数`
from 
	(SELECT  userid,
		case 
		when cast(du_time as int)/(1000*60)>0 and cast(du_time as int)/(1000*60)<=1 then '(0,1]'
		when cast(du_time as int)/(1000*60)>1 and cast(du_time as int)/(1000*60)<=2 then '(1,2]'
		when cast(du_time as int)/(1000*60)>2 and cast(du_time as int)/(1000*60)<=3 then '(2,3]'
		when cast(du_time as int)/(1000*60)>3 and cast(du_time as int)/(1000*60)<=4 then '(3,4]'
		when cast(du_time as int)/(1000*60)>4 and cast(du_time as int)/(1000*60)<=5 then '(4,5]'
		when cast(du_time as int)/(1000*60)>5 and cast(du_time as int)/(1000*60)<=6 then '(5,6]'
		when cast(du_time as int)/(1000*60)>6 and cast(du_time as int)/(1000*60)<=7 then '(6,7]'
		when cast(du_time as int)/(1000*60)>7 and cast(du_time as int)/(1000*60)<=8 then '(7,8]'
		when cast(du_time as int)/(1000*60)>8 and cast(du_time as int)/(1000*60)<=9 then '(8,9]'
		when cast(du_time as int)/(1000*60)>9 and cast(du_time as int)/(1000*60)<=10 then '(9,10]'
		else '(10,]' end shijian 
	FROM dw_log.dw_apppagelog
	where day >= '2018-07-03' 
	and day < '2018-07-10' 
	and (current_page='BuyFragment' or current_page ='FindGoodsViewController')
	) a
group by a.shijian



#其他

SELECT   
	 case 
	when length(b.card_no)=18 and substring(b.card_no,17,1) in (1,3,5,7,9) then '男'
	 when length(b.card_no)=15 and substring(b.card_no,15 ,1) in (1,3,5,7,9) then '男'
	 when length(b.card_no)=18 and substring(b.card_no,17,1) in (2,4,6,8) then '女'
	 when length(b.card_no)=15 and substring(b.card_no,15 ,1) in (2,4,6,8) then '女'
	 when length(b.card_no)！=18 and  length(c.cardno)=18 and substring(c.cardno,17 ,1) in (1,3,5,7,9) then '男'
	 when length(b.card_no)！=18 and  length(c.cardno)=15 and substring(c.cardno,15 ,1) in (1,3,5,7,9) then '男'
	 when length(b.card_no)！=15 and length(c.cardno)=18 and substring(c.cardno,17 ,1) in (2,4,6,8) then '女'
	 when length(b.card_no)！=15 and length(c.cardno)=15 and substring(c.cardno,15 ,1) in (2,4,6,8) then '女' 
	 else '未知' END `性别`,count(a.userid) `人数`
 from
    (SELECT DISTINCT userid
    from dw_log.dw_apppagelog
     where day>='20180703' 
    	and day<'20180710' 
    	and (current_page='BuyFragment' or current_page ='FindGoodsViewController')
    )a
    left join
    (SELECT hn_user_id,card_no
    from dw_public.dim_hnuser_risk_verified_info
    where day='20180709'
    )b on a.userid=b.hn_user_id 
    left join
    (select hnuserid,cardno
    from ods_public.hnuser_personalcertification_full
    where day='20180709'
    )c on a.userid=c.hnuserid

group by ( case 
	 when length(b.card_no)=18 and substring(b.card_no,17,1) in (1,3,5,7,9) then '男'
	 when length(b.card_no)=15 and substring(b.card_no,15 ,1) in (1,3,5,7,9) then '男'
	 when length(b.card_no)=18 and substring(b.card_no,17,1) in (2,4,6,8) then '女'
	 when length(b.card_no)=15 and substring(b.card_no,15 ,1) in (2,4,6,8) then '女'
	 when length(b.card_no)！=18 and  length(c.cardno)=18 and substring(c.cardno,17 ,1) in (1,3,5,7,9) then '男'
	 when length(b.card_no)！=18 and  length(c.cardno)=15 and substring(c.cardno,15 ,1) in (1,3,5,7,9) then '男'
	 when length(b.card_no)！=15 and length(c.cardno)=18 and substring(c.cardno,17 ,1) in (2,4,6,8) then '女'
	 when length(b.card_no)！=15 and length(c.cardno)=15 and substring(c.cardno,15 ,1) in (2,4,6,8) then '女' 
	 else '未知' END
		 )