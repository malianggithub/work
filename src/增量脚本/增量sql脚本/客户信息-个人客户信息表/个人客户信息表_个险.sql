-- 个人客户信息
SELECT  DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
a.AppntNo AS KHBH,
-- 客户编号
       a.AppntName AS XM,
	   -- 姓名
       (case (SELECT CodeName FROM LDCode WHERE CodeType = 'Sex' AND Code = a.AppntSex) 
				when '男' then '男性'
				when '女' then '女性'
				else '未说明的性别' end ) as XB,
	   -- 性别
       a.AppntBirthday AS CSRQ,
	   -- 出生日期
       (SELECT Code FROM LDCode WHERE CodeType = 'IdType' AND Code = a.IdType) AS ZJLX,
	   -- 证件类型
       a.IDNo AS ZJHM,
	   -- 证件号码
       '' AS ZJYXQQ,
	   -- 证件有效起期
       IF(a.ISLongValid = '1','9999-12-31',a.IDExpDate) AS ZJYXZQ,
	   -- 证件有效止期
       a.OccupationCode AS ZY,
	   -- 职业
       (SELECT Code FROM LDCode WHERE CodeType = 'NativePlace' AND Code = a.NativePlace) AS GJ,
	   -- 国籍
       (SELECT Code FROM LDCode WHERE CodeType = 'Marriage' AND Code = a.Marriage) AS HYZK,
	   -- 婚姻状况 ',
       b.Phone AS YDDH,
	   -- 移动电话
       b.Mobile AS GDDH,
	   -- 固定电话
       b.Email AS DZYX,
	   -- 电子邮箱
       '' AS XL,
	   -- 学历
       a.Pretax AS GRNSR,
	   -- 个人年收入
       IFNULL(b.Province,'000000') AS DZSZS,
	   -- 地址所在省
       IFNULL(b.City,'000000') AS DZSZDS,
	   -- 地址所在地市
       IFNULL(b.County,'000000') AS DZSZQX,
	   -- 地址所在区县
       b.PostalAddress AS JD
	   -- 街道
FROM LCAppnt a,LCAddress b
WHERE a.AppntNo = b.CustomerNo AND a.GrpContNo = '00000000000000000000'
  AND a.AddressNo = b.AddressNo
  AND (1=2
      OR DATEDIFF('${data_date}', a.MakeDate) = 1
      OR DATEDIFF('${data_date}', b.MakeDate) = 1
      OR EXISTS(SELECT 1 FROM LPEdorItem WHERE ContNo = a.ContNo AND EdorType IN ('AC','AM','CM') AND EdorState = '0' AND DATEDIFF('${data_date}', EdorValiDate) = 1)
      )
UNION
SELECT DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
a.InsuredNo AS KHBH,
-- 客户编号
       a.Name AS XM,
	   -- 姓名
       (case (SELECT CodeName FROM LDCode WHERE CodeType = 'Sex' AND Code = a.Sex) 
				when '男' then '男性'
				when '女' then '女性'
				else '未说明的性别' end ) as XB,
	   -- 性别
       a.Birthday AS CSRQ,
	   -- 出生日期
       (SELECT CodeName FROM LDCode WHERE CodeType = 'IdType' AND Code = a.IdType) AS ZJLX,
	   -- 证件类型
       a.IDNo AS ZJHM,
	   -- 证件号码
       '' AS ZJYXQQ,
	   -- 证件有效起期
       IF(a.ISLongValid = '1','9999-12-31',a.IDExpDate) AS ZJYXZQ,
	   -- 证件有效止期
       a.OccupationCode AS ZY,
	   -- 职业
       (SELECT CodeName FROM LDCode WHERE CodeType = 'NativePlace' AND Code = a.NativePlace) AS GJ,
	   -- 国籍
       IFNULL((SELECT CodeName FROM LDCode WHERE CodeType = 'Marriage' AND Code = a.Marriage),'未说明的婚姻状况') AS HYZK,
	   -- 婚姻状况
       b.Phone AS YDDH,
	   -- 移动电话
       b.Mobile AS GDDH,
	   -- 固定电话
       b.Email AS DZYX,
	   -- 电子邮箱
       '' AS XL,
	   -- 学历
       a.Pretax AS GRNSR,
	   -- 个人年收入
       IFNULL(b.Province,'000000') AS DZSZS,
	   -- 地址所在省
       IFNULL(b.City,'000000') AS DZSZDS,
	   -- 地址所在地市
       IFNULL(b.County,'000000') AS DZSZQX,
	   -- 地址所在区县
       b.PostalAddress AS JD
	   -- 街道
FROM LCInsured a,LCAddress b
WHERE a.InsuredNo = b.CustomerNo AND a.GrpContNo = '00000000000000000000'
  AND a.AddressNo = b.AddressNo
  AND (1=2
    OR DATEDIFF('${data_date}', a.MakeDate) = 1
    OR DATEDIFF('${data_date}', b.MakeDate) = 1
    OR EXISTS(SELECT 1 FROM LPEdorItem WHERE ContNo = a.ContNo AND EdorType IN ('AM','CM') AND EdorState = '0' AND DATEDIFF('${data_date}', EdorValiDate) = 1)
    )