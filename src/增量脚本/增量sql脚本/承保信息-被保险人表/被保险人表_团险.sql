select  DATE_SUB('${data_date}',INTERVAL 1 day) DIS_DATA_DATE,
a.grpcontno AS TTBDH,
-- 团体保单号
'团体' AS BDTGXZ,
-- 保单团个性质
contno AS GRBDH,
-- 个人保单号
insuredno AS BBRKHBH,
-- 被保人客户编号
managecom AS GLJGDM,
-- 管理机构代码
managecom AS GLJGMC,
-- 管理机构名称
(SELECT t.Code FROM LDCode t WHERE t.CodeType ='Relation' AND t.Code = a.RelationToMainInsured) AS YZBBRGX,
-- 与主被保人关系
ifnull(maincustomerno,insuredno) AS ZBBRKHH,
-- 主被保人客户号
#团险投保人为公司
'09' AS YTBRGX,
-- 与投保人关系
occupationcode AS ZY,
-- 职业
(case when relationtomaininsured='00' then '主被保险人' else '连带被保人' end ) AS BBXRLX,
-- 被保险人类型
 (select appflag from lcpol where contno=a.contno and insuredno=a.insuredno limit 1 ) AS BBXRZT
-- 被保险人状态
from lcinsured a
where a.grpcontno != '00000000000000000000'
and a.contno=(select  max(b.contno) from lcinsured b where  b.insuredno=a.insuredno and grpcontno!='00000000000000000000')
and  not EXISTS(select 1 from lcinsured where insuredno=a.insuredno and grpcontno='00000000000000000000')
and (EXISTS(select 1 from lpedoritem where grpcontno=a.grpcontno and insuredno=a.insuredno and contno=a.contno  and edortype in ('NI','RR') and edorstate='0' and modifydate=DATE_SUB('${data_date}',INTERVAL 1 day))
or ( EXISTS(select 1 from lobinsured d where a.contno=d.contno and d.insuredno=a.insuredno and a.occupationcode!=d.occupationcode) and EXISTS (select 1 from lpedoritem where edortype='IC' and contno=a.contno and insuredno=a.insuredno and edortype='0' and modifydate=DATE_SUB('${data_date}',INTERVAL 1 day))))
