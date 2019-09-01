

#发布农友圈卖货话题动态，且当天没有发布供应的人。 
SELECT 
FROM 
    (
        SELECT  DISTINCT UserId
        FROM hn_circle.posts
        WHERE TopicId='5aafb928e919725e647d7899'-- 动态未卖的农友圈
        and PublishedDate >= '2018-07-10' and PublishedDate < '2018-07-11'
    ) a 
    LEFT JOIN
    (
        SELECT DISTINCT hnUserId,supplyId
        FROM b2b_product.supply
        WHERE createTime >= '2018-07-10' AND    createTime< '2018-07-11'
    ) b ON a.UserId=b.hnUserId
WHERE b.supplyId is NULL -- 没有发布供应
--具体人信息
SELECT DISTINCT a.UserId,c.linkMan,d.userAccount
FROM 
    (
        SELECT  DISTINCT UserId
        FROM hn_circle.posts
        WHERE TopicId='5aafb928e919725e647d7899'-- 动态未卖的农友圈
        and PublishedDate >= '2018-07-10' and PublishedDate < '2018-07-11'
    ) a 
    LEFT JOIN
    (
        SELECT DISTINCT hnUserId,supplyId
        FROM b2b_product.supply
        WHERE createTime >= '2018-07-10' AND    createTime< '2018-07-11'
    ) b ON a.UserId=b.hnUserId
        LEFT JOIN
        (
                SELECT hnUserId,linkMan
                FROM hnuser.hnuser
        )c ON a.UserId=c.hnUserId
        LEFT JOIN
        (
                SELECT hnUserId,userAccount
                FROM hnuser.hnuseraccount
        )d ON a.UserId=d.hnuserid
WHERE b.supplyId is NULL -- 没有发布供应
#当天发布供应，且没有发布农友圈动态的人。
SELECT count(DISTINCT hnUserId)
FROM b2b_product.supply
WHERE DATE_FORMAT(createTime,'%Y%m%d')=20180710
AND hnUserId NOT IN (SELECT DISTINCT UserId
                    FROM hn_circle.posts
                    WHERE TopicId='5aafb928e919725e647d7899'-- 动态未卖的农友圈
                    AND DATE_FORMAT(PublishedDate,'%Y%m%d')=20180710
                    )
--具体人信息
SELECT DISTINCT a.hnUserId,c.linkMan,d.userAccount
FROM
        (SELECT DISTINCT hnUserId
        FROM b2b_product.supply
        WHERE createTime >= '2018-07-10' AND    createTime< '2018-07-11'
        ) a 
        LEFT JOIN
        (SELECT DISTINCT UserId,TopicId
        FROM hn_circle.posts
        WHERE TopicId='5aafb928e919725e647d7899'-- 动态未卖的农友圈
        AND PublishedDate >= '2018-07-10' and PublishedDate < '2018-07-11'
        ) b ON a.hnUserId=b.UserId
        LEFT JOIN
        (SELECT hnUserId,linkMan
        FROM hnuser.hnuser
        ) c ON a.hnUserId=c.hnUserId
        LEFT JOIN
        (
        SELECT hnUserId,userAccount
        FROM hnuser.hnuseraccount
        )d ON a.hnUserId=d.hnuserid
WHERE b.TopicId IS NULL
