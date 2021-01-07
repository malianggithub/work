select  DISTINCT  DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
 insuredno AS KHBH,
-- 	客户编号
name AS XM,
	   -- 姓名
(case when sex='1' then '女性' when sex='0' then '男性' else '未说明的性别' end ) AS XB,
	   -- 性别
birthday AS CSRQ,
	   -- 出生日期
(select code from ldcode where codetype='idtype' and code=a.idtype) AS ZJLX,
	   -- 证件类型
idno AS ZJHM,
	   -- 证件号码
'' AS ZJYXQQ,
	   -- 证件有效起期
(case when a.IsLongValid  is not null then '9999-12-31' else a.IDExpDate end) AS ZJYXZQ,
	   -- 证件有效止期
(select  occupationcode  from ldoccupation where occupationcode=a.occupationcode) AS ZY,
	   -- 职业
(select code from ldcode where codetype='nativeplace' and  code=a.nativeplace) AS GJ,
	   -- 国籍
#团险被保人客户系统不录
'' AS HYZK,
	   -- 婚姻状况
(select b.Mobile1 from  LCCustomerContactInfo b where b.policyno=a.grpcontno and b.CustomerNo=a.insuredno limit 1) AS YDDH,
	   -- 移动电话
(select b.Phone from  LCCustomerContactInfo b where b.policyno=a.grpcontno and b.CustomerNo=a.insuredno limit 1) AS GDDH,
	   -- 固定电话
(select b.EMail1 from LCCustomerContactInfo b where b.policyno=a.grpcontno and b.CustomerNo=a.insuredno limit 1) AS DZYX,
	   -- 电子邮箱
#团险客户系统不录学历
'' AS XL,
	   -- 学历
ifnull(Salary*12,'') AS GRNSR,
	   -- 个人年收入
(select b.province from LCCustomerContactInfo b where  b.policyno=a.grpcontno and b.CustomerNo=a.insuredno limit 1) AS DZSZS,
	   -- 地址所在省
(select b.city from LCCustomerContactInfo b where  b.policyno=a.grpcontno and b.CustomerNo=a.insuredno limit 1) AS DZSZDS,
	   -- 地址所在地市
(select b.county from LCCustomerContactInfo b where   b.policyno=a.grpcontno and b.CustomerNo=a.insuredno limit 1) AS DZSZQX,
	   -- 地址所在区县
(select PostalAddress from   LCCustomerContactInfo where policyno=a.grpcontno and CustomerNo=a.insuredno limit 1) AS JD
	   -- 街道
from lcinsured a where a.grpcontno != '00000000000000000000'
and a.makedate<'2021-01-01'
and a.contno=(select  max(b.contno) from lcinsured b where  b.insuredno=a.insuredno and grpcontno!='00000000000000000000')
and  not EXISTS(select 1 from lcinsured where insuredno=a.insuredno and grpcontno='00000000000000000000')
and EXISTS(select 1 from lpedoritem where grpcontno=a.grpcontno and insuredno=a.insuredno and contno=a.contno and  edortype in ('NI','RR','BB','IC') and edorstate='0' and modifydate=DATE_SUB('${data_date}',INTERVAL 1 day))

