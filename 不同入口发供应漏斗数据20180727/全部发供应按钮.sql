select a.day, count(a.userid) `全部发供应按钮`,count(b.userid) `选择页`,
        count(c.userid) `编辑页`,count(d.userid) `类目`,
        count(e.userid) `规格`,count(f.userid) `单价`,
        count(g.userid) `描述`,count(h.userid) `发布成功`
from (
    select distinct userid,day
    from dw_log.dw_appeventlog
    where eventid='supply_click' -- 全部发供应
    and day>=20180924 and day<=20180930
    )a  
    left join
    (select distinct userid,current_page,day
    from dw_log.dw_apppagelog
    where current_page='ChooseSupplyTypeActivity'-- 选择页面
    and day>=20180924 and day<=20180930
    )b on a.userid=b.userid and a.day=b.day
    left join
    (select distinct userid,current_page,day
    from dw_log.dw_apppagelog
    where current_page='SupplyEditActivity'-- 编辑页面
    and day>=20180924 and day<=20180930
    )c on b.userid=c.userid and b.day=c.day
    left join
    (select distinct userid,current_page,day
    from dw_log.dw_apppagelog
    where current_page='CategorysActivity'-- 类目品种
    and day>=20180924 and day<=20180930
    )d on c.userid=d.userid and c.day=d.day
    left join
    (select distinct userid,current_page,day
    from dw_log.dw_apppagelog
    where current_page='ChooseSpecActivity'-- 规格
    and day>=20180924 and day<=20180930
    )e on d.userid=e.userid and  d.day=e.day
    left join
    (select distinct userid,current_page,day
    from dw_log.dw_apppagelog
    where current_page='PublishSellPriceActivity'-- 单价
    and day>=20180924 and day<=20180930
    )f on e.userid=f.userid and e.day=f.day
    left join
    (select distinct userid,current_page,day
    from dw_log.dw_apppagelog
    where current_page='ProductDescriptionActivity'-- 描述
    and day>=20180924 and day<=20180930
    )g on f.userid=g.userid and f.day=g.day
    left join
    (select distinct userid,eventid,day
    from dw_log.dw_appeventlog
    where eventid='supply_confirm'-- 发布成功
    and day>=20180924 and day<=20180930
    )h on g.userid=h.userid and g.day=h.day
    
    group by a.day