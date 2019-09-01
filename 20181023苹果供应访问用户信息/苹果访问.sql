SELECT a.reviewer_hnuserid,c.useraccount,b.linkman
FROM 
(
SELECT DISTINCT reviewer_hnuserid
from dw_log.dw_supply_click
WHERE day>=20181017 and day <=20181023 and cate_name3='苹果' and hnuserid>0
) a 
join
ods_public.hnuser_hnuser_full b on a.reviewer_hnuserid=b.hnuserid and b.day=20181022
join
ods_public.hnuser_hnuseraccount_full c on a.reviewer_hnuserid=c.hnuserid and c.day=20181022