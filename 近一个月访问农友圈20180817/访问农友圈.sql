select distinct a.userid,b.useraccount,a.channels
from 
(
select distinct userid ,case when channel='AppStore' then 'ios'
 else 'Android' end  channels
from log_edw_hn_source_new.appeventlog
where  id in ('buy_head', 'sell_head') and (kv like '农友圈' or kv like '%farmersCircle%')
and day>=20180716 and day<20180817 and userid>0
) a
join
(
select hnuserid,useraccount
from ods_public.hnuser_hnuseraccount_full
where day=20180816
) b on a.userid=b.hnuserid