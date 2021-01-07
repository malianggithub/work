-- 个人保单表
SELECT  DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
'' AS TTBDH,
	   -- 团体保单号
       IFNULL(a.ContNo,a.ProposalContNo) AS GRBDH,
	   -- 个人保单号
       '个人'  AS BDTGXZ,
	   -- 保单团个性质
       '自然人' AS JTDBZ,
	   -- 家庭单标志
       a.ManageCom AS GLJGDM,
	   -- 管理机构代码
       a.ManageCom AS GLJGMC,
	   -- 管理机构名称
       a.managecom  AS JGXQDM,
	   -- 监管辖区代码
       a.managecom AS CBDQ, 
	   -- 承保地区
	(CASE WHEN a.salechnl='11' THEN (CASE com.AngencyType  WHEN '0' THEN '300' WHEN '1' THEN '230' WHEN '3' THEN '122'  WHEN '4' THEN '272' END)
     WHEN a.salechnl='33' THEN (CASE com.AngencyType  WHEN '0' THEN '300' WHEN '1' THEN '230' WHEN '2' THEN '230' END) 
     WHEN a.salechnl='09' THEN (CASE (SELECT agentkind FROM laagent  WHERE AGENTCODE = a.AGENTCODE) WHEN '1' THEN '111' when '2' then '210' ELSE NULL END) ELSE a.salechnl END) AS XSQD,
	   -- 销售渠道	   
       a.AgentCom AS DLJGBM,
	   -- 代理机构编码
       (SELECT t.Name FROM LACom t WHERE t.AgentCom = a.AgentCom) AS DLJGMC,
	   -- 代理机构名称
       a.AppntNo AS TBRKHBH,
	   -- 投保人客户编号
       (case when a.payintv='0' then '趸交' when a.payintv='1' then '月交' when a.payintv='3' then '季交' when a.payintv='6' then '半年交'  when  a.payintv='12' then '年交' when a.payintv='-1' then '不定期交费' else '其他' end) AS JFJG,
	   -- 交费间隔
       a.PayMode AS JFFS,
	   -- 交费方式
       a.SignDate AS QDRQ,
	   -- 签单日期
       (IF(a.Currency = '01','CNY', a.Currency)) AS HBDM,
	   -- 货币代码
       (SELECT SUM(Prem) FROM LCPol WHERE ContNo = a.ContNo AND AppFlag IN (1,4)) AS BF,
	   -- 保费
       (SELECT SUM(Amnt) FROM LCPol WHERE ContNo = a.ContNo AND AppFlag IN (1,4)) AS BE,
	   -- 保额
       (SELECT SUM(SumActuPayMoney) FROM LJAPayPerson WHERE ContNo = a.ContNo) AS LJBF,
	   -- 累计保费
       (CASE WHEN b.PayIntv = 0 THEN b.FirstPayDate
           WHEN (b.PayIntv = 12 AND b.RiskCode = 'HT1008') THEN b.FirstPayDate
           WHEN (b.PayIntv = 12 AND EXISTS(SELECT 1 FROM LMRiskApp WHERE RiskCode = b.RiskCode AND RiskPeriod IN ('M','S'))) THEN b.FirstPayDate
               WHEN b.PayIntv <> '0' AND b.PaytoDate = b.PayEndDate THEN DATE_SUB(b.PaytoDate, INTERVAL b.PayIntv MONTH)
               WHEN b.PayIntv <> '0' AND b.PaytoDate < b.PayEndDate THEN b.PaytoDate END) AS JZRQ,
		-- 交至日期
        a.FirstPayDate AS SQJFRQ,
	   -- 首期交费日期
       a.CValiDate AS BDSXRQ,
	   -- 保单生效日期
       (CASE (SELECT AutoUWFlag FROM LCCUWMaster WHERE ContNo = a.ContNo LIMIT 1) WHEN '1' THEN '自动核保' WHEN '2' THEN '人工核保' END) AS HBLX,
	   -- 核保类型
       a.PolApplyDate AS TBDSQRQ,
	   -- 投保单申请日期
       (CASE b.AppFlag
            WHEN '0' THEN '未生效'
            WHEN '1' THEN (IF(EXISTS(SELECT 1 FROM LCContState t WHERE t.StateType = 'Available' AND t.State = '0' AND t.EndDate IS NULL AND t.PolNo = b.PolNo),
                              '有效','中止'))
            WHEN '4' THEN '终止' ELSE '其他' END) AS BDZT,
		-- 保单状态
       (CASE a.ContPrintFlag WHEN '0' THEN '纸质保单' WHEN '1' THEN '电子保单' WHEN '2' THEN '纸质保单+电子保单' ELSE '000000' END) AS BDXS,
	   -- 保单形式
       (IF(b.InsuYear = '106' AND b.InsuYearFlag = 'A','9999-12-31',DATE_SUB(b.EndDate,INTERVAL 1 DAY))) AS BDMQRQ,
	   -- 保单满期日期
	   (case when 
			b.AppFlag ='4' then (CASE (SELECT StateReason FROM LCContState WHERE StateType = 'Terminate' AND State = '1' AND PolNo = b.PolNo)
                               WHEN '01' THEN DATE_SUB(b.EndDate,INTERVAL 1 DAY)
							   else (SELECT StartDate FROM LCContState WHERE StateType = 'Terminate' AND State = '1' AND PolNo = b.PolNo) end)
	   else
			'' 
	   end)  AS BDZZRQ1, 
	   -- 保单终止日期
       (IF(b.AppFlag = '1',(SELECT StartDate FROM LCContState WHERE StateType = 'Available' AND State = '1' AND EndDate IS NULL AND PolNo = b.PolNo),'')) AS BDZZRQ2,
	   -- 保单中止日期
       (SELECT MAX(EdorValiDate) FROM LPEdorItem WHERE ContNo = a.ContNo AND EdorType = 'RE') AS BDXLHFRQ,
	   -- 保单效力恢复日期
		(CASE a.AppFlag
           WHEN '0' and a.UWFlag = 'a' THEN '当日撤单'
           WHEN '4' THEN (CASE (SELECT StateReason FROM LCContState WHERE StateType = 'Terminate' AND State = '1' AND PolNo = b.PolNo)
                               WHEN '01' THEN '满期终止'
                               WHEN '02' THEN '退保终止'
                               WHEN '03' THEN '解约终止'
                               WHEN '04' THEN '理赔终止'
                               WHEN '05' THEN '协退终止'
                               WHEN '06' THEN '犹退终止'
                               WHEN '07' THEN '失效终止'
                               WHEN '08' THEN '其他终止' END )
           END ) AS BDZZYY,
     -- 保单终止原因
		 -- 保单终止原因
       (IF(a.ContSource = 'S','是','否')) AS HLWBXYWBZ,
	   -- 互联网保险业务标志
       '' AS SMRZTGBZ,
	   -- 实名认证通过标志
       '' AS SMRZFS,
	   -- 实名认证方式
       '否' AS FZCTBBZ,
	   -- 非正常退保标志
       '否' AS FZCGFBZ,
	   -- 非正常给付标志
       '否' AS JBYWBZ,
	   -- 经办业务标志
       '' AS JBGLF,
	   -- 经办管理费
       '否' AS YBGRZHGMBZ
	   -- 医保个人账户购买标志
FROM LCCont a left join (select agentcom,AngencyType,name from lacom)com on com.agentcom=a.agentcom,
     LCPol b
WHERE a.GrpContNo = '00000000000000000000'
and b.UWFlag not IN ('1','2')
  AND a.ContNO = b.ContNo
  AND b.PolNo = b.MainPolNo
  AND a.InsuredNo = b.InsuredNo
  AND b.AppFlag IN ('1','4')
  AND (1 = 2
      -- IO-职业类别变更 AE-投保人变更 CM-客户重要资料变更(客户层) IC-客户重要资料变更(保单层)
      OR EXISTS(SELECT 1 FROM LPEdorItem  WHERE ContNo = a.ContNo AND EdorType IN ('IO','AE','CM','IC') AND EdorState = '0' AND DATEDIFF('${data_date}', EdorValiDate) = 1
                AND EXISTS(SELECT 1 FROM LJAGet WHERE OtherNo = EdorAcceptNo AND OtherNoType = '10'))
      -- PT-减保 PM-交费间隔变更 PC-交费方式及交费账号变更 NS-新增附加险 FM-交费期间变更
      OR EXISTS(SELECT 1 FROM LPEdorItem WHERE ContNo = a.ContNo AND EdorType IN ('PT','XS','PM','PC','NS','FM') AND EdorState = '0' AND DATEDIFF('${data_date}', EdorValiDate) = 1)
      -- 前一天保单状态有变更(生效、失效、终止)
      OR EXISTS(SELECT 1 FROM LCContState WHERE ContNo = a.ContNo AND StateType IN ('Available','Terminate') AND DATEDIFF('${data_date}', MakeDate) = 1)
      -- 保单在前一天有收费(首期、续期、续保、复效、新增附加险)
      OR EXISTS(SELECT 1 FROM LJAPayPerson WHERE ContNo = a.ContNo AND DATEDIFF('${data_date}', MakeDate) = 1 )
      )