-- 三级类目

select a.cate_name3,a.supplyid,b.title,a.uv,a.num
from 
(
select t.cate_name3,t.supplyid,t.uv,t.num,
row_number() over(partition by t.cate_name3 order by t.num desc) as row_rank
from 
(
SELECT cate_name3,supplyid,count(distinct deviceid) uv,count(DISTINCT reviewer_hnuserid) num 
from dw_supply_inquiry
where cate_name3 in ('猪','羊','鸡','鸭','蜂蜜','牛','核桃') and day>=20180615 and day<=20180915
group BY cate_name3,supplyid
)t
) a
left join
(
SELECT  DISTINCT supplyid,title
FROM dw_trade.dw_b2b_product_supply
where day=20180917
)b on a.supplyid=b.supplyid
where row_rank<=100

-- 二级类目
select a.cate_name2,a.supplyid,b.title,a.uv,a.num
from 
(
select t.cate_name2,t.supplyid,t.uv,t.num,
row_number() over(partition by t.cate_name2 order by t.num desc) as row_rank
from 
(
SELECT cate_name2,supplyid,count(distinct deviceid) uv,count(DISTINCT reviewer_hnuserid) num 
from dw_supply_inquiry
where cate_name2 in ('肉蛋奶') and day>=20180615 and day<=20180915
group BY cate_name2,supplyid
)t
) a
left join
(
SELECT  DISTINCT supplyid,title
FROM dw_trade.dw_b2b_product_supply
where day=20180917
)b on a.supplyid=b.supplyid
where row_rank<=100