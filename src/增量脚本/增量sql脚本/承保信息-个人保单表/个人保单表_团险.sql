select  DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
 grpcontno AS TTBDH,
-- 团体保单号
contno AS GRBDH,
	   -- 个人保单号
'团体'  AS BDTGXZ,
	   -- 保单团个性质
'自然人' AS JTDBZ,
	   -- 家庭单标志
managecom AS GLJGDM,
	   -- 管理机构代码
managecom AS GLJGMC,
	   -- 管理机构名称
a.managecom AS JGXQDM, 
	   -- 监管辖区代码
managecom AS CBDQ,
	   -- 承保地区
(CASE WHEN a.salechnl='11' THEN (CASE com.AngencyType  WHEN '0' THEN '300' WHEN '1' THEN '230' WHEN '3' THEN '122'  WHEN '4' THEN '272' END)
     WHEN a.salechnl='33' THEN (CASE com.AngencyType  WHEN '0' THEN '300' WHEN '1' THEN '230' WHEN '2' THEN '230' END) 
     WHEN a.salechnl='09' THEN (CASE (SELECT agentkind FROM laagent  WHERE AGENTCODE = a.AGENTCODE) WHEN '1' THEN '111' when '2' then '210' ELSE NULL END) ELSE a.salechnl END) AS XSQD,
	   -- 销售渠道
(select agentcom from lcagentcominfo where policyno=a.grpcontno limit 1) AS DLJGBM,
	   -- 代理机构编码
(select agentcomname from lcagentcominfo where policyno=a.grpcontno limit 1) AS DLJGMC,
	   -- 代理机构名称
(select customerno from lcgrpappnt where grpcontno=a.grpcontno limit 1) AS TBRKHBH,
	   -- 投保人客户编号
(case when a.payintv='0' then '趸交' when a.payintv='1' then '月交' when a.payintv='3' then '季交' when a.payintv='6' then '半年交'  when  a.payintv='12' then '年交' when a.payintv='-1' then '不定期交费' else '其他' end) AS JFJG,
	   -- 交费间隔
(select paytype from   LCCustomerAccount where policyno=a.grpcontno LIMIT 1) AS JFFS,
	   -- 交费方式
signdate AS QDRQ,
	   -- 签单日期
'CNY' AS HBDM,
	   -- 货币代码
(case when  payintv='0' then prem else (select sum(sumactupaymoney) paymoney from ljapayperson where contno=a.contno and grpcontno=a.grpcontno and enteraccdate is not null  GROUP BY contno,paycount ORDER BY paycount desc  limit 1)   end) AS BF,
	   -- 保费
amnt AS BE,
	   -- 保额
ifnull((select sum(sumactupaymoney) from ljapayperson where contno=a.contno and enteraccdate is not null),0) + ifnull((select sum(getmoney) from lpedoritem where contno=a.contno and getmoney>0),0) AS LJBF,
	   -- 累计保费
 (case when payintv=0 then ifnull(firstpaydate,(select enteraccdate from  ljagetendorse  where contno=a.contno  and insuredno=a.insuredno and feeoperationtype='NI' LIMIT 1) ) when paytodate=enddate then DATE_SUB(enddate,INTERVAL payintv month) else paytodate end ) AS JZRQ,
		-- 交至日期
ifnull(firstpaydate,(select enteraccdate from  ljagetendorse  where contno=a.contno  and insuredno=a.insuredno and feeoperationtype='NI' LIMIT 1) ) AS SQJFRQ,
	   -- 首期交费日期
cvalidate AS BDSXRQ,
	   -- 保单生效日期
 (case when (select 1 from lcuwtrace where contno=a.contno LIMIT 1) is not null then '人工核保' else '自动核保' end) AS HBLX,
	   -- 核保类型
ifnull(PolApplyDate,ifnull((select PolApplyDate from  lobcont where contno=a.contno),(select modifydate from lpedoritem where contno=a.contno and edortype in ('NI','RR') LIMIT 1)))AS TBDSQRQ,
	   -- 投保单申请日期
 CASE appflag
            WHEN '0' THEN '未生效'
			WHEN '1' THEN '有效'
			WHEN '4' THEN '终止'
end AS BDZT,
		-- 保单状态
'000000' AS BDXS,
	   -- 保单形式
DATE_SUB(enddate,INTERVAL 1 day) AS BDMQRQ,
	   -- 保单满期日期
 (case when  state in ('20','40','30') then DATE_SUB(enddate,INTERVAL 1 day)  else '' end ) AS BDZZRQ1,
	   -- 保单终止日期
'' AS BDZZRQ2,
	   -- 保单中止日期
'' AS BDXLHFRQ,
	   -- 保单效力恢复日期
(case when state='30' then '满期终止'  when state='40' then '退保' when state='20' then '团体减人' when state='02' then '拒保终止' when state='01' then '当日撤单' else '' end) AS BDZZYY,
		 -- 保单终止原因
 (case when InterBusinessType is not null then '是' else '否' end) AS HLWBXYWBZ,
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

from lccont a
left join (select m.agentcom,m.AngencyType,m.name,f.policyno from lacom m,lcagentcominfo f where m.agentcom=f.agentcom )com  on com.policyno=a.grpcontno
where a.grpcontno!= '00000000000000000000'
and (exists (select 1 from lccontstate where contno=a.contno   and statetype='Terminate'  and makedate=DATE_SUB('${data_date}',INTERVAL 1 day))
or (a.state='11' and EXISTS(select 1 from ljapay where othernotype='02' and grpcontno=a.grpcontno and enteraccdate=DATE_SUB('${data_date}',INTERVAL 1 day)))
or (EXISTS(select 1 from ljagetendorse where contno=a.contno and   feeoperationtype='NI' and grpcontno in (select  grpcontno from ldpbalanceon where balanceonstate='0') and  enteraccdate=DATE_SUB('${data_date}',INTERVAL 1 day) ) )
)

union all
select  DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
 a.grpcontno AS TTBDH,
-- 团体保单号
a.contno AS GRBDH,
	   -- 个人保单号
'团体'  AS BDTGXZ,
	   -- 保单团个性质
'自然人' AS JTDBZ,
	   -- 家庭单标志
a.managecom AS GLJGDM,
	   -- 管理机构代码
a.managecom AS GLJGMC,
	   -- 管理机构名称
a.managecom AS JGXQDM, 
	   -- 监管辖区代码
a.managecom AS CBDQ,
	   -- 承保地区
(CASE WHEN a.salechnl='11' THEN (CASE com.AngencyType  WHEN '0' THEN '300' WHEN '1' THEN '230' WHEN '3' THEN '122'  WHEN '4' THEN '272' END)
     WHEN a.salechnl='33' THEN (CASE com.AngencyType  WHEN '0' THEN '300' WHEN '1' THEN '230' WHEN '2' THEN '230' END) 
     WHEN a.salechnl='09' THEN (CASE (SELECT agentkind FROM laagent  WHERE AGENTCODE = a.AGENTCODE) WHEN '1' THEN '111' when '2' then '210' ELSE NULL END) ELSE a.salechnl END) AS XSQD,
	   -- 销售渠道
(select agentcom from lcagentcominfo where policyno=a.grpcontno limit 1) AS DLJGBM,
	   -- 代理机构编码
(select agentcomname from lcagentcominfo where policyno=a.grpcontno limit 1) AS DLJGMC,
	   -- 代理机构名称
(select customerno from lcgrpappnt where grpcontno=a.grpcontno limit 1) AS TBRKHBH,
	   -- 投保人客户编号
(case when a.payintv='0' then '趸交' when a.payintv='1' then '月交' when a.payintv='3' then '季交' when a.payintv='6' then '半年交'  when  a.payintv='12' then '年交' when a.payintv='-1' then '不定期交费' else '其他' end) AS JFJG,
	   -- 交费间隔
(select paytype from   LCCustomerAccount where policyno=a.grpcontno LIMIT 1) AS JFFS,
	   -- 交费方式
a.signdate AS QDRQ,
	   -- 签单日期
'CNY' AS HBDM,
	   -- 货币代码
(case when  a.payintv='0' then a.prem else (select sum(sumactupaymoney) paymoney from ljapayperson where contno=a.contno and grpcontno=a.grpcontno and enteraccdate is not null  GROUP BY contno,paycount ORDER BY paycount desc  limit 1)   end) AS BF,
	   -- 保费
a.amnt AS BE,
	   -- 保额
ifnull((select sum(sumactupaymoney) from ljapayperson where contno=a.contno and enteraccdate is not null),0) + ifnull((select sum(getmoney) from lpedoritem where contno=a.contno and getmoney>0),0) AS LJBF,
	   -- 累计保费
 (case when a.payintv=0 then ifnull(a.firstpaydate,(select enteraccdate from  ljagetendorse  where contno=a.contno  and insuredno=a.insuredno and feeoperationtype='NI' LIMIT 1) ) when a.paytodate=a.enddate then DATE_SUB(a.enddate,INTERVAL a.payintv month) else a.paytodate end ) AS JZRQ,
		-- 交至日期
ifnull(a.firstpaydate,(select enteraccdate from  ljagetendorse  where contno=a.contno  and insuredno=a.insuredno and feeoperationtype='NI' LIMIT 1) ) AS SQJFRQ,
	   -- 首期交费日期
a.cvalidate AS BDSXRQ,
	   -- 保单生效日期
 (case when (select 1 from lcuwtrace where contno=a.contno LIMIT 1) is not null then '人工核保' else '自动核保' end) AS HBLX,
	   -- 核保类型
ifnull(a.PolApplyDate,ifnull((select PolApplyDate from  lobcont where contno=a.contno),(select modifydate from lpedoritem where contno=a.contno and edortype in ('NI','RR') LIMIT 1)))AS TBDSQRQ,
	   -- 投保单申请日期
 CASE b.appflag
            WHEN '0' THEN '未生效'
			WHEN '1' THEN '有效'
			WHEN '4' THEN '终止'
end AS BDZT,
		-- 保单状态
'000000' AS BDXS,
	   -- 保单形式
DATE_SUB(b.enddate,INTERVAL 1 day) AS BDMQRQ,
	   -- 保单满期日期
 (case when  b.state in ('20','40','30') then DATE_SUB(a.enddate,INTERVAL 1 day)  else '' end ) AS BDZZRQ1,
	   -- 保单终止日期
'' AS BDZZRQ2,
	   -- 保单中止日期
'' AS BDXLHFRQ,
	   -- 保单效力恢复日期
(case when b.state='30' then '满期终止'  when b.state='40' then '退保' when b.state='20' then '团体减人' when b.state='02' then '拒保终止' when b.state='01' then '当日撤单' else '' end) AS BDZZYY,
		 -- 保单终止原因
 (case when a.InterBusinessType is not null then '是' else '否' end) AS HLWBXYWBZ,
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

from lccont a left join (select m.agentcom,m.AngencyType,m.name,f.policyno from lacom m,lcagentcominfo f where m.agentcom=f.agentcom )com  on com.policyno=a.grpcontno
,lpcont b
where a.grpcontno!= '00000000000000000000'
and a.contno=b.contno 
and (EXISTS  (
select 1 from lpedoritem where edorstate='0' and b.edorno=edorno and grpcontno=b.grpcontno
and edortype in ('ZT','CT','NI','RR')
and modifydate=DATE_SUB('${data_date}',INTERVAL 1 day)
 )) 
and b.state <>'02' 




