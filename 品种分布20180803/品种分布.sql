SELECT a.num,COUNT(a.hnUserId)
FROM(
SELECT hnUserId,breedId,COUNT(DISTINCT supplyId) num 
FROM b2b_product.supply
WHERE state=0 AND isCollect=0 AND isTest=0 AND breedId is not NULL
GROUP BY hnUserId, breedId
) a 
GROUP BY a.num