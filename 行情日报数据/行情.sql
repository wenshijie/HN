SELECT DATE(create_time) daydate,cate_name name3,COUNT(DISTINCT hn_user_id) num
FROM b2b_market.hn_market_care
WHERE create_time>='2018-08-01' AND create_time<'2018-08-21'
GROUP BY DATE(create_time),cate_name
ORDER BY daydate,num DESC


--hive
SELECT day,count(DISTINCT deviceid),count(deviceid)
from dw_log.dw_apppagelog
WHERE day>=20180801 and day<=20180820 and (current_page like '%/html/market/%'  or current_page like '%market.cnhnb.com/%')
GROUP BY day