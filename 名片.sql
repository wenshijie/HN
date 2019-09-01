SELECT e.linkMan,f.createTime,f.userAccount,a.CreateTime,a.PostContent,c.ShareCount,COUNT(b.PostId)
FROM hn_circle.postsdetail a -- 内容 时间
    LEFT JOIN
    hn_circle.messages b ON a.PostId=b.PostId  AND a.PostContent LIKE '%名片%' AND a.createTime>='2018-07-25' 
        AND b.PostType=0-- 点赞
    SELECT d.linkMan,e.createTime,e.userAccount,b.CreateTime,b.PostContent,f.ShareCount,sum(c.PostType=0)
FROM hn_circle.posts a
        LEFT JOIN
        hn_circle.postsdetail b ON a.Id=b.PostId
    LEFT JOIN 
        hn_circle.messages c ON a.Id=c.PostId -- 点赞
        LEFT JOIN
        hnuser.hnuser d ON a.UserId=d.hnUserId -- 用户名字
        LEFT JOIN 
    hnuser.hnuseraccount e ON a.UserId=e.hnUserId -- 用户账户
        LEFT JOIN
    hn_circle.postsextend f ON a.Id=f.PostId  -- 分享次数
        
WHERE b.CreateTime>='2018-07-25'AND b.PostContent LIKE '%名片%' 
GROUP BY d.linkMan,e.createTime,e.userAccount,b.CreateTime,b.PostContent,f.ShareCount