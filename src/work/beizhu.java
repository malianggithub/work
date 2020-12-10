package work;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.Scanner;

public class beizhu {

	public static void main(String[] args) {
		
		String sql="-- 个人保单表\r\n" + 
				"SELECT '' AS '团体保单号',\r\n" + 
				"       (IF(a.AppFlag = 0, a.ProposalContNo, a.ContNo)) AS '个人保单号',\r\n" + 
				"       '个人' AS '保单团个性质',\r\n" + 
				"       '自然人' AS '家庭单标志',\r\n" + 
				"       a.ManageCom AS '管理机构代码',\r\n" + 
				"       (SELECT t.Name FROM LDCom t WHERE t.ComCode = a.ManageCom) AS '管理机构名称',\r\n" + 
				"       '' AS '监管辖区代码',\r\n" + 
				"       '' AS '承保地区',\r\n" + 
				"       (SELECT CodeName FROM LDCode WHERE CodeType = 'SaleChnl' AND Code = a.SaleChnl) AS '销售渠道',\r\n" + 
				"       a.AgentCom AS '代理机构编码',\r\n" + 
				"       (SELECT t.Name FROM LACom t WHERE t.AgentCom = a.AgentCom) AS '代理机构名称',\r\n" + 
				"       a.AppntNo AS '投保人客户编号',\r\n" + 
				"       (SELECT CodeName FROM LDCode WHERE CodeType = 'PayIntv' AND Code = a.PayIntv) AS '交费间隔',\r\n" + 
				"       (SELECT CodeName FROM LDCode WHERE CodeType = 'PayMode' AND Code = a.PayMode) AS '交费方式',\r\n" + 
				"       IF(b.UWFlag IN ('1','2'), '1900-01-01', a.SignDate) AS '签单日期',\r\n" + 
				"       (IF(a.Currency = '01','CNY', a.Currency)) AS '货币代码',\r\n" + 
				"       (SELECT SUM(Prem) FROM LCPol WHERE ContNo = a.ContNo AND AppFlag IN (1,4)) AS '保费',\r\n" + 
				"       (SELECT SUM(Amnt) FROM LCPol WHERE ContNo = a.ContNo AND AppFlag IN (1,4)) AS '保额',\r\n" + 
				"       (SELECT SUM(SumActuPayMoney) FROM LJAPayPerson WHERE ContNo = a.ContNo) AS '累计保费',\r\n" + 
				"       IF(b.UWFlag IN ('1','2'), '1900-01-01',\r\n" + 
				"           (CASE WHEN b.PayIntv = 0 THEN b.FirstPayDate\r\n" + 
				"               WHEN b.PayIntv <> '0' AND b.PaytoDate = b.PayEndDate THEN DATE_SUB(b.PaytoDate, INTERVAL b.PayIntv MONTH)\r\n" + 
				"               WHEN b.PayIntv <> '0' AND b.PaytoDate = b.PayEndDate THEN b.PaytoDate END)) AS '交至日期',\r\n" + 
				"       IF(b.UWFlag IN ('1','2'), '1900-01-01', a.FirstPayDate) AS '首期交费日期',\r\n" + 
				"       IF(b.UWFlag IN ('1','2'), '1900-01-01', a.CValiDate) AS '保单生效日期',\r\n" + 
				"       (CASE (SELECT AutoUWFlag FROM LCCUWMaster WHERE ContNo = a.ContNo LIMIT 1) WHEN '1' THEN '自动核保' WHEN '2' THEN '人工核保' END) AS '核保类型',\r\n" + 
				"       a.PolApplyDate AS '投保单申请日期',\r\n" + 
				"       (CASE b.AppFlag\r\n" + 
				"            WHEN '0' THEN '未生效'\r\n" + 
				"            WHEN '1' THEN (IF(EXISTS(SELECT 1 FROM LCContState t WHERE t.StateType = 'Available' AND t.State = '0' AND t.EndDate IS NULL AND t.PolNo = b.PolNo),\r\n" + 
				"                              '有效','中止'))\r\n" + 
				"            WHEN '4' THEN '终止' ELSE '其他' END) AS '保单状态',\r\n" + 
				"       (CASE a.ContPrintFlag WHEN '0' THEN '纸质保单' WHEN '1' THEN '电子保单' WHEN '2' THEN '纸质保单+电子保单' ELSE '000000' END) AS '保单形式',\r\n" + 
				"       (IF(b.InsuYear = '106' AND b.InsuYearFlag = 'A','9999-12-31',DATE_SUB(b.EndDate,INTERVAL 1 DAY))) AS '保单满期日期',\r\n" + 
				"       (IF(b.AppFlag = '4',(SELECT StartDate FROM LCContState WHERE StateType = 'Terminate' AND State = '1' AND PolNo = b.PolNo),'')) AS '保单终止日期',\r\n" + 
				"       (IF(b.AppFlag = '1',(SELECT StartDate FROM LCContState WHERE StateType = 'Available' AND State = '1' AND EndDate IS NULL AND PolNo = b.PolNo),'')) AS '保单中止日期',\r\n" + 
				"       (SELECT MAX(EdorValiDate) FROM LPEdorItem WHERE ContNo = a.ContNo AND EdorType = 'RE') AS '保单效力恢复日期',\r\n" + 
				"       (CASE a.AppFlag\r\n" + 
				"           WHEN '0' THEN (SELECT CodeName FROM LDCode WHERE CodeType = 'UWState1' AND Code = a.UWFlag)\r\n" + 
				"           WHEN '4' THEN (CASE (SELECT StateReason FROM LCContState WHERE StateType = 'Terminate' AND State = '1' AND PolNo = b.PolNo)\r\n" + 
				"                               WHEN '01' THEN '满期终止'\r\n" + 
				"                               WHEN '02' THEN '退保终止'\r\n" + 
				"                               WHEN '03' THEN '解约终止'\r\n" + 
				"                               WHEN '04' THEN '理赔终止'\r\n" + 
				"                               WHEN '05' THEN '协退终止'\r\n" + 
				"                               WHEN '06' THEN '犹退终止'\r\n" + 
				"                               WHEN '07' THEN '失效终止'\r\n" + 
				"                               WHEN '08' THEN '其他终止' END )\r\n" + 
				"           END ) AS '保单终止原因',\r\n" + 
				"       (IF(a.ContSource = 'S','是','否')) AS '互联网保险业务标志',\r\n" + 
				"       '' AS '实名认证通过标志',\r\n" + 
				"       '' AS '实名认证方式',\r\n" + 
				"       '否' AS '非正常退保标志',\r\n" + 
				"       '否' AS '非正常给付标志',\r\n" + 
				"       '否' AS '经办业务标志',\r\n" + 
				"       '' AS '经办管理费',\r\n" + 
				"       '否' AS '医保个人账户购买标志'\r\n" + 
				"FROM LCCont a,LCPol b\r\n" + 
				"WHERE a.GrpContNo = '00000000000000000000'\r\n" + 
				"  AND a.ContNO = b.ContNo\r\n" + 
				"  AND b.PolNo = b.MainPolNo\r\n" + 
				"  AND a.InsuredNo = b.InsuredNo\r\n" + 
				"  AND ((a.CValiDate > '2016-12-31' AND a.CValiDate < '2021-01-01')\r\n" + 
				"      OR (a.CValiDate < '2017-01-01'\r\n" + 
				"              AND (EXISTS(SELECT 1 FROM LCContState t WHERE t.PolNO = b.PolNo AND t.StateType = 'Available' AND t.State = '0' AND t.EndDate IS NULL)\r\n" + 
				"                  OR EXISTS(SELECT 1 FROM LCContState t WHERE t.PolNO = b.PolNo AND t.StateType IN ('Available','Terminate') AND t.State = '1' AND t.StartDate > '2017-01-01')))\r\n" + 
				"      OR (EXISTS(SELECT 1 FROM LLCase a,LLRegister b,LLClaimDetail c\r\n" + 
				"                 WHERE a.CaseNo = b.RgtNo AND a.CaseNo = c.ClmNo AND c.ContNo = a.ContNo\r\n" + 
				"                   AND b.RgtDate > '2016-12-31'\r\n" + 
				"                   AND a.EndCaseDate < '2021-01-01')))\r\n" + 
				"AND a.MakeDate < '2021-01-01';\r\n" + 
				"\r\n" + 
				"\r\n" + 
				"\r\n" + 
				"\r\n" + 
				"\r\n" + 
				"\r\n" + 
				"\r\n" + 
				"";
		
		String columnname="流水号	LSH\r\n" + 
				"保险机构代码	BXJGDM\r\n" + 
				"保险机构名称	BXJGMC\r\n" + 
				"团体保单号		TTBDH\r\n" + 
				"个人保单号		GRBDH\r\n" + 
				"保单团个性质	BDTGXZ\r\n" + 
				"家庭单标志		JTDBZ\r\n" + 
				"管理机构代码	GLJGDM\r\n" + 
				"管理机构名称	GLJGMC\r\n" + 
				"监管辖区代码	JGXQDM\r\n" + 
				"承保地区		CBDQ\r\n" + 
				"销售渠道	XSQD\r\n" + 
				"代理机构编码	DLJGBM\r\n" + 
				"代理机构名称	DLJGMC\r\n" + 
				"投保人客户编号	TBRKHBH\r\n" + 
				"交费间隔	JFJG\r\n" + 
				"交费方式	JFFS\r\n" + 
				"签单日期	QDRQ\r\n" + 
				"货币代码	HBDM\r\n" + 
				"保费		BF\r\n" + 
				"保额		BE\r\n" + 
				"累计保费	LJBF\r\n" + 
				"交至日期	JZRQ\r\n" + 
				"首期交费日期	SQJFRQ\r\n" + 
				"保单生效日期	BDSXRQ\r\n" + 
				"核保类型		HBLX\r\n" + 
				"投保单申请日期	TBDSQRQ\r\n" + 
				"保单状态	BDZT\r\n" + 
				"保单形式	BDXS\r\n" + 
				"保单满期日期	BDMQRQ\r\n" + 
				"保单终止日期	BDZZRQ1\r\n" + 
				"保单中止日期	BDZZRQ2\r\n" + 
				"保单效力恢复日期		BDXLHFRQ\r\n" + 
				"保单终止原因	BDZZYY\r\n" + 
				"互联网保险业务标志	HLWBXYWBZ\r\n" + 
				"实名认证通过标志		SMRZTGBZ\r\n" + 
				"实名认证方式	SMRZFS\r\n" + 
				"非正常退保标志	FZCTBBZ\r\n" + 
				"非正常给付标志	FZCGFBZ\r\n" + 
				"经办业务标志	JBYWBZ\r\n" + 
				"经办管理费		JBGLF\r\n" + 
				"医保个人账户购买标志	YBGRZHGMBZ\r\n";
		
		System.out.println(beizhu(sql,columnname));
	}
	
	public static String txt2String(String filepath){
	 File file = new File(filepath);
	 String result = "";
	 try{
	     BufferedReader br = new BufferedReader(new FileReader(file));
	 String s = null;
	 while((s = br.readLine())!=null){
	     result = result + "\r\n" +s;
	         }
	         br.close();    
	     }catch(Exception e){
	         e.printStackTrace();
	     }
	     return result;
	 }

	
	public static String beizhu(String sql,String columnname) {
		columnname=columnname.replace("\r\n", "\t");
		//System.out.println(sql);
		String[] columnarr=columnname.split("\t");
		//System.out.println(columnarr.length);
		int beizhuarrlength=columnarr.length/2;
		String[] beizhuarr=new String[beizhuarrlength];
		
		String zhongwei=new String();
		for(int i=0;i<columnarr.length;i++) {
			if((i+2)%2==0) {
				zhongwei="'"+columnarr[i]+"'";
				sql=sql.replace(zhongwei,"");
			}
			sql=sql.replace(columnarr[i],"");
			if((i+2)%2==0) {
				beizhuarr[i/2]=columnarr[i+1]+", --"+columnarr[i];
			}
			
		}
		sql=sql.replace("a,", "a,\t");
		String[] sqlarr=sql.split(",\r\n");
		sql="";
		//System.out.println(beizhuarrlength);
		for(int i=0;i<beizhuarrlength-1;i++) {
			sql=sql+sqlarr[i]+beizhuarr[i]+"\r\n";
		}
		sql=sql+sqlarr[sqlarr.length-1].replace("\r\nfrom", beizhuarr[beizhuarr.length-1].replace(",", "")+"\r\nfrom");
		//sql=sql+sqlarr[beizhuarrlength-1].replace("\r\nFROM", beizhuarr[beizhuarrlength-1].replace(",", "")+"\r\nFROM");
		return sql;
	}
}
