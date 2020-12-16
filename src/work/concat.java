package work;

public class concat {
	
	public static void main(String[] args) {
		updateconcat();
	}
	public static String updateconcat() {
		String sql;
		sql="";
		String name="s_core_bbxrbmaliang" + 
				"s_core_bdxsryglbmaliang" + 
				"s_core_bfmxbmaliang" + 
				"s_core_cxrxxbmaliang" + 
				"s_core_ffmxbmaliang" + 
				"s_core_grbdbmaliang" + 
				"s_core_grkhxxbmaliang" + 
				"s_core_grxzbmaliang" + 
				"s_core_khbddzbmaliang" + 
				"s_core_khhfbmaliang" + 
				"s_core_lpbdmxbmaliang" + 
				"s_core_ttbdbmaliang" + 
				"s_core_ttbfbmaliang" + 
				"s_core_ttkhxxbmaliang" + 
				"s_core_ttxzbmaliang" + 
				"s_fin_cwpzxxbmaliang" + 
				"s_fin_nbkmdzbmaliang" + 
				"s_fin_sxfjyjfkmmxzbmaliang" + 
				"s_fin_ywjglffkmmxzbmaliang" + 
				"s_fin_zzkjqkmbmaliang" + 
				"s_inv_wttzqkbmaliang" + 
				"s_inv_zztzjylsbmaliang" + 
				"s_inv_zztzzhccmxbmaliang" + 
				"s_inv_zztzzhxxhzbmaliang" + 
				"s_sales_xsryxxbmaliang" + 
				"s_sales_zjjgxxb";
		String[] tablename=name.toLowerCase().split("maliang");
		for(int i=0;i<tablename.length;i++) {
			sql=sql+"update "+tablename[i]+" set DIS_DATA_DATE = LAST_DAY(CURDATE()) WHERE DIS_DATA_DATE IS NULL;\r\n";
		}
		System.out.print(sql);
		return sql;
	}
	public static String proconcat() {
		String sql;
		sql="";
		String name="ZZKJQKMB,NBKMDZB,CWPZXXB,YWJGLFFKMMXZB,SXFJYJFKMMXZB";
		String zw="总账会计全科目表,内部科目对照表,财务凭证信息表,业务及管理费分科目明细账表,手续费及佣金分科目明细账表,";
		String[] tablename=name.toLowerCase().split(",");
		String[] tablenamez=zw.split(",") ;
		for(int i=0;i<tablename.length;i++) {
			sql=sql+"drop TRIGGER if exists `"+tablenamez[i]+"流水号修改`;," + 
					"CREATE  TRIGGER `"+tablenamez[i]+"流水号修改` BEFORE INSERT ON eastic_"+tablename[i]+" FOR EACH ," + 
					"ROW," + 
					"BEGIN," + 
					"	DECLARE maxlsh VARCHAR(50);," + 
					"	DECLARE oldtime varchar(10);," + 
					"	set oldtime=CAST(DATE_FORMAT(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH)),'%Y%m%d') AS CHAR);," + 
					"	SELECT IFNULL(MAX(CAST(SUBSTR(LSH,15,10) AS UNSIGNED)),0)," + 
					"	into  maxlsh," + 
					"	from eastic_"+tablename[i]+"," + 
					"	where SUBSTR(LSH,7,8)=oldtime;," + 
					"	SET maxlsh=CONCAT('000235',oldtime,LPAD(IFNULL(maxlsh+1,1),10,0));," + 
					"	SET NEW.LSH=maxlsh;," + 
					"END;,";
		}
		System.out.print(sql);
		return sql;
	}
	
}
