SELECT DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
'' AS TTBDH,
-- 团体保单号
       '个人' AS BDTGXZ,
	   -- 保单团个性质
       a.ContNo AS GRBDH,
	   -- 个人保单号
       b.InsuredNo AS BBRKHBH,
	   -- 被保人客户编号
       a.ManageCom AS GLJGDM,
	   -- 管理机构代码
       (SELECT t.Name FROM LDCom t WHERE t.ComCode = a.ManageCom) AS GLJGMC,
	   -- 管理机构名称
       (SELECT t.Code FROM LDCode t WHERE t.CodeType ='Relation' AND t.Code = b.RelationToMainInsured) AS YZBBRGX,
	   -- 与主被保人关系
       a.InsuredNo AS ZBBRKHH,
	   -- 主被保人客户号
       (SELECT t.Code FROM LDCode t WHERE t.CodeType ='Relation' AND t.Code = b.RelationToAppnt) AS YTBRGX,
	   -- 与投保人关系
       b.OccupationCode AS ZY,
	   -- 职业
       (IF(b.RelationToMainInsured = '00','主被保险人','连带被保人')) AS BBXRLX,
	   -- 被保险人类型
       '1' AS BBXRZT
	   -- 被保险人状态
FROM LCCont a,
     LCInsured b
WHERE a.GrpContNo = '00000000000000000000'
  AND a.ContNO = b.ContNo
  AND a.AppFlag IN ('1', '4','0')
  AND (1 = 2
    -- IO-职业类别变更 AE-投保人变更
    OR EXISTS(SELECT 1 FROM LPEdorItem  WHERE ContNo = a.ContNo AND EdorType IN ('IO','AE') AND EdorState = '0' AND DATEDIFF('${data_date}', EdorValiDate) = 1)
    )