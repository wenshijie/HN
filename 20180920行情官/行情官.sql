SELECT DATE(create_time) ,COUNT(DISTINCT hn_user_id)
FROM b2b_market.hn_officer
WHERE `status`=0 AND `name` NOT LIKE '%测试%'
GROUP BY DATE(create_time)
--
SELECT DISTINCT hn_user_id,user_account,`name`,CASE WHEN type=0 THEN '产地行情官' ELSE '市场行情官'END '行情官类型'
FROM b2b_market.hn_officer
WHERE `status`=0 AND `name` NOT LIKE '%测试%' AND audit_status in (0,1)