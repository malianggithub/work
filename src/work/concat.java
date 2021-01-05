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
			sql=sql+"DELETE from  "+tablename[i]+" WHERE DIS_DATA_DATE='2020-12-29'\r\n";
		}
		System.out.print(sql);
		return sql;
	}
	public static String proconcat() {
		String sql;
		sql="";
		String name="ZZKJQKMB,NBKMDZB,CWPZXXB,YWJGLFFKMMXZB,SXFJYJFKMMXZB";
		String zw="���˻��ȫ��Ŀ��,�ڲ���Ŀ���ձ�,����ƾ֤��Ϣ��,ҵ�񼰹���ѷֿ�Ŀ��ϸ�˱�,�����Ѽ�Ӷ��ֿ�Ŀ��ϸ�˱�,";
		String[] tablename=name.toLowerCase().split(",");
		String[] tablenamez=zw.split(",") ;
		for(int i=0;i<tablename.length;i++) {
			sql=sql+"select distinct dis_data_date from ";
		}
		System.out.print(sql);
		return sql;
	}
	
}
