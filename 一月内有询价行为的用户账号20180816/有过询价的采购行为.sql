SELECT a.reviewer_hnuserid,b.useraccount
from 
(
SELECT DISTINCT reviewer_hnuserid
from dw_log.dw_supply_inquiry
where day>=20180714 and day<20180815
)a 
join
(
SELECT DISTINCT hnuserid,useraccount
from ods_public.hnuser_hnuseraccount_full
where day=20180815
)b on a.reviewer_hnuserid=b.hnuserid