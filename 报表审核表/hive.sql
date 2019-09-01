select a.hnuserid, b.totalSupplyNum, c.loginDays, c.supplyNum, c.supplyUpdateNum, 
d.orderNum, d.moneyNum, case when e.hn_user_id is null then 'No' else 'Yes' end from 
(
    select distinct hnuserid from ods_public.hnuser_hnuser_full
    where day = '20180726' and hnuserid in (
    )
) a
join 
(   -- 历史发布供应条数
    select hnuserid, count(distinct supplyid) totalSupplyNum 
    from dw_trade.dw_b2b_product_supply
    where day = date_format(date_sub(current_date(), 1), 'yyyyMMdd') 
    and istest = 0 and iscollect = 0 
    group by hnuserid
) b on a.hnuserid = b.hnuserid
join 
(
    -- 30天内登录、发布供应、刷新供应
    select hnuserid, 
    count(distinct case when appdenglu > 0 then day end) loginDays,
    sum(distinct case when gongyingfabu > 0 then gongyingfabu end) supplyNum, 
    sum(distinct case when gongyinggengxin > 0 then gongyinggengxin end) supplyUpdateNum
    from hn_dm.dm_all_user_active_base_time
    where day >= date_format(date_sub(current_date(), 30), 'yyyyMMdd') 
    and day <= date_format(date_sub(current_date(), 1), 'yyyyMMdd') 
    group by hnuserid
) c on a.hnuserid = c.hnuserid
left join
(
    -- 历史支付订单和金额
    select saleuserid, count(distinct mainordercode) orderNum, 
    sum(amount) moneyNum from ods_trade.b2b_sale_hn_order_full 
    where day = date_format(date_sub(current_date(), 1), 'yyyyMMdd') and payflag = 1
    group by saleuserid
) d on c.hnuserid = d.saleuserid
left join 
(
    select distinct hn_user_id from ods_public.hn_area_partner_hn_area_partner_full
    where day = date_format(date_sub(current_date(), 1), 'yyyyMMdd') 
    and partner_status = 1 and safeguard = 1
) e on c.hnuserid = e.hn_user_id