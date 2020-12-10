package work;

public class concat {
	
	public static void main(String[] args) {
		updateconcat();
	}
	public static String updateconcat() {
		String sql;
		sql="";
		String name="s_core_bbxrb," + 
				"s_core_bbxrb_copy1," + 
				"s_core_bdxsryglb," + 
				"s_core_bfmxb," + 
				"s_core_cxrxxb," + 
				"s_core_ffmxb," + 
				"s_core_grbdb," + 
				"s_core_grbdb_copy1," + 
				"s_core_grkhxxb," + 
				"s_core_grkhxxb_copy," + 
				"s_core_grxzb," + 
				"s_core_khbddzb," + 
				"s_core_khhfb," + 
				"s_core_lpbdmxb," + 
				"s_core_ttbdb," + 
				"s_core_ttbfb," + 
				"s_core_ttkhxxb," + 
				"s_core_ttxzb," + 
				"s_fin_cwpzxxb," + 
				"s_fin_nbkmdzb," + 
				"s_fin_sxfjyjfkmmxzb," + 
				"s_fin_ywjglffkmmxzb," + 
				"s_fin_zzkjqkmb," + 
				"s_inv_wttzqkb," + 
				"s_inv_zztzjylsb," + 
				"s_inv_zztzzhccmxb," + 
				"s_inv_zztzzhxxhzb";
		String[] tablename=name.toLowerCase().split(",");
		for(int i=0;i<tablename.length;i++) {
			sql=sql+"delete from "+tablename[i]+";\r\n";
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
