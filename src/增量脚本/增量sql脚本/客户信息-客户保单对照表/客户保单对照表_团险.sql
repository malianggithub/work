select DISTINCT  DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
a.insuredno AS KHBH,
-- 客户编号
'个人客户' AS KHLB,
-- 客户类别
'被保人' AS KHSX,
-- 客户属性
a.grpcontno AS TTBDH,
-- 团体保单号
'000000' AS GRBDH,
-- 个人保单号
'团体' AS BDTGXZ,
-- 保单团个性质
(case when c.APPFLAG='0' then '未生效' when c.APPFLAG='1' then '有效' when c.APPFLAG='4' then '终止' else '其他' end) AS BDZT
-- 保单状态
from lcinsured a,lccont c where a.grpcontno=c.grpcontno and a.contno=c.contno 
and a.grpcontno!='00000000000000000000'
and ((c.contno in (select DISTINCT  contno  from lpedoritem where   edortype in ('ZT','CT') and edorstate='0' and modifydate=DATE_SUB('${data_date}',INTERVAL 1 day)))
or  ( c.contno in (select DISTINCT contno from lccontstate where   statetype='Terminate'  and makedate=DATE_SUB('${data_date}',INTERVAL 1 day))))
UNION ALL
select DISTINCT  DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
a.customerno AS KHBH,
-- 客户编号
(case when a.GrpNature in ('04') then '个人客户' when a.GrpNature in ('06','08') then '非企业组织客户'  else '企业客户' end) AS KHLB,
-- 客户类别
'投保人' AS KHSX,
-- 客户属性
a.grpcontno AS TTBDH,
-- 团体保单号
'000000' AS GRBDH,
-- 个人保单号
'团体' AS BDTGXZ,
-- 保单团个性质
(case when b.APPFLAG='0' then '未生效' when b.APPFLAG='1' then '有效' when b.APPFLAG='4' then '终止' else '其他' end) AS BDZT
-- 保单状态
from lcgrpappnt a,lcgrpcont b
where a.grpcontno=b.grpcontno
and (EXISTS(select  1 from lpedoritem where grpcontno=a.grpcontno and edortype in ('CT') and edorstate='0' and modifydate=DATE_SUB('${data_date}',INTERVAL 1 day))
or (b.state='30' and b.enddate=DATE_SUB('${data_date}',INTERVAL 1 day)))
