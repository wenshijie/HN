SELECT b.title,
SUM(a.`status`=1)'未核实' ,SUM(a.`status`=2)'举报属实',
SUM(a.`status`=3)'举报不属实',SUM(a.`status`=4)'待观察'
from 
hnuser.tipoffdetail a
JOIN
hnuser.tipoff b ON a.tipId=b.id AND b.`status`=1
WHERE a.createTime>='2018-01-01' 
GROUP BY b.title