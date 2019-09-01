SELECT a.day,a.cate_name1,a.num inquiry,b.num dau
FROM 
(
SELECT cate_name1,count(DISTINCT deviceid) num,day
from dw_log.dw_supply_inquiry
where day>=20180714 and day<20180815
GROUP BY day,cate_name1
)a
join
(
SELECT cate_name1,count(DISTINCT deviceid) num,day
from dw_log.dw_supply_click
where day>=20180714 and day<20180815
GROUP BY day,cate_name1
) b  on  a.cate_name1=b.cate_name1 and a.day=b.day