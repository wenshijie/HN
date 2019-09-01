SELECT day,count(DISTINCT deviceid),count(DISTINCT userid)
from dw_log.dw_apppagelog
where   day>=20181025 and day <=20181031 and userid>0
and (current_page like '%/html/market/%' or current_page like '%market.cnhnb.com/%')
GROUP BY day

---
SELECT b.num,count(a.userid)
from  
(
SELECT DISTINCT userid
from dw_log.dw_apppagelog
where   day=20181025 and userid>0
and (current_page like '%/html/market/%' or current_page like '%market.cnhnb.com/%')
)a
LEFT JOIN
(
SELECT  userid,count(DISTINCT day) num
from dw_log.dw_apppagelog
where   day<=20181025 and day>=20180924 and userid>0
and (current_page like '%/html/market/%' or current_page like '%market.cnhnb.com/%')
GROUP BY userid
) b on a.userid=b.userid
GROUP BY b.num