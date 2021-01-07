SELECT DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
 b.AppntNo AS KHBH,
-- 客户编号
       '个人客户' AS KHLB,
-- 客户类别
       '投保人' AS KHSX,
-- 客户属性
       '000000' AS TTBDH,
-- 团体保单号
       a.ContNo AS GRBDH,
-- 个人保单号
       '个人' AS BDTGXZ,
-- 保单团个性质
       (CASE a.AppFlag
            WHEN '0' THEN '未生效'
            WHEN '1' THEN (IF(EXISTS(SELECT 1 FROM LCContState t WHERE t.StateType = 'Available' AND t.State = '0' AND t.EndDate IS NULL AND t.ContNo = a.ContNo),
                              '有效','中止'))
            WHEN '4' THEN '终止' ELSE '其他' END) AS BDZT
-- 保单状态
FROM LCCont a,LCAppnt b
WHERE a.GrpContNo = '00000000000000000000'
  AND a.ContNo = b.ContNo
  AND (1 = 2
    OR DATEDIFF('${data_date}', b.MakeDate) = 1
    -- 前一天保单状态有变更(生效、失效、终止)
    OR EXISTS(SELECT 1 FROM LCContState WHERE ContNo = a.ContNo AND StateType IN ('Available','Terminate') AND DATEDIFF('${data_date}', MakeDate) = 1)
    )
UNION
SELECT
DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
 b.InsuredNo AS KHBH,
-- 客户编号
       '个人客户' AS KHLB,
-- 客户类别
       '被保人' AS KHSX,
-- 客户属性
       '000000' AS TTBDH,
-- 团体保单号
       a.ContNo AS GRBDH,
-- 个人保单号
       '个人' AS BDTGXZ,
-- 保单团个性质
       (CASE a.AppFlag
            WHEN '0' THEN '未生效'
            WHEN '1' THEN (IF(EXISTS(SELECT 1 FROM LCContState t WHERE t.StateType = 'Available' AND t.State = '0' AND t.EndDate IS NULL AND t.PolNo = b.PolNo),
                              '有效','中止'))
            WHEN '4' THEN '终止' ELSE '其他' END) AS BDZT
-- 保单状态
FROM LCCont a,LCPol b,LCInsured c
WHERE a.GrpContNo = '00000000000000000000'
  AND a.ContNo = b.ContNo
  AND c.ContNo = b.ContNo AND c.InsuredNo = b.InsuredNo
  AND (1 = 2
    OR DATEDIFF('${data_date}', c.MakeDate) = 1
    -- 前一天保单状态有变更(生效、失效、终止)
    OR EXISTS(SELECT 1 FROM LCContState WHERE ContNo = a.ContNo AND StateType IN ('Available','Terminate') AND DATEDIFF('${data_date}', MakeDate) = 1)
    )