select a.hnuserid,a.useraccount,b.createtime,b.linkman,c.deviceid,c.appver,c.f_starttime,c.`location`,c.ostype
from 
(
select hnuserid,useraccount
from ods_public.hnuser_hnuseraccount_full
where day=20180903 and useraccount in ('m13438085385',
'm18482288705',
'm18773827074',
'm15073830754',
'm18374258247',
'm19809442614',
'm13094743016',
'm18482303033',
'm17182046461',
'm15043582604',
'm13408487004',
'm14702896024',
'm13404767045',
'm18298357838',
'm15708468126',
'm18374258247',
'm13668308341',
'm15073830754')
)a
left join 
(
select hnuserid,linkman,createtime
from ods_public. hnuser_hnuser_full
where day= 20180903
) b on a.hnuserid=b.hnuserid
left join
(
select userid,f_starttime,deviceid,ostype,appver,`location`
from dw_log.dw_appstartlog
where day>=20180831 and day<=20180904
)c on a.hnuserid=c.userid