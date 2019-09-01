select count(a.userid) `全部发供应按钮`,count(b.current_page ) `选择页`,
        count(c.current_page ) `编辑页`,count(d.current_page) `类目`,
        count(e.current_page) `规格`,count(f.current_page) `单价`,
        count(g.current_page) `描述`,count(h.eventid) `发布成功`
from (
    select distinct userid,day
    from dw_log.dw_appeventlog
    where eventid='supply_click' and appversion='4.7.3.1'  -- 全部发供应
    and day>=20180825 and day<=20180831
    )a  
    left join
    (select distinct userid,current_page,day
    from dw_log.dw_apppagelog
    where current_page='ChooseSupplyTypeActivity'-- 选择页面
    and day>=20180825 and day<=20180831
    )b on a.userid=b.userid and a.day=b.day
    left join
    (select distinct userid,current_page,day
    from dw_log.dw_apppagelog
    where current_page='SupplyEditActivity'-- 编辑页面
    and day>=20180825 and day<=20180831
    )c on b.userid=c.userid and b.day=c.day
    left join
    (select distinct userid,current_page,day
    from dw_log.dw_apppagelog
    where current_page='CategorysActivity'-- 类目品种
    and day>=20180825 and day<=20180831
    )d on c.userid=d.userid and c.day=d.day
    left join
    (select distinct userid,current_page,day
    from dw_log.dw_apppagelog
    where current_page='ChooseSpecActivity'-- 规格
    and day>=20180825 and day<=20180831
    )e on d.userid=e.userid and  d.day=e.day
    left join
    (select distinct userid,current_page,day
    from dw_log.dw_apppagelog
    where current_page='PublishSellPriceActivity'-- 单价
    and day>=20180825 and day<=20180831
    )f on e.userid=f.userid and e.day=f.day
    left join
    (select distinct userid,current_page,day
    from dw_log.dw_apppagelog
    where current_page='ProductDescriptionActivity'-- 描述
    and day>=20180825 and day<=20180831
    )g on f.userid=g.userid and f.day=g.day
    left join
    (select distinct userid,eventid,day
    from dw_log.dw_appeventlog
    where eventid='supply_confirm'-- 发布成功
    and day>=20180825 and day<=20180831
    )h on g.userid=h.userid and g.day=h.day
    ---带状态
select a.day `日期`,count(a.userid) `全部发供应按钮`,count(b.current_page is not null) `选择页`,
        count(c.current_page is not null) `编辑页`,count(d.current_page) `类目`,
        count(e.current_page) `规格`,count(f.current_page) `单价`,
        count(g.current_page) `描述`,count(h.eventid) `发布成功`,
        count(ii.up)`销售中`,count(ii.down)`下架`
from (
    select distinct userid,day
    from dw_log.dw_appeventlog
    where eventid='supply_click' and appversion like '4.7.4%'  -- 全部发供应
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
    left join
    (
    select distinct hnuserid, case when state=0 then hnuserid end up,
    case when state=1 then hnuserid end down,day
    from dw_trade.dw_b2b_product_supply
    where day=20181012 and createtime>='2018-09-24' and createtime <'2018-10-01'
    and state in (0,1)
    ) ii on h.userid=ii.hnuserid 
group by a.day