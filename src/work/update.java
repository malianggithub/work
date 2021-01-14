package work;

public class update {
	
	public static void main(String[] args) {
		String sql;
		sql="";
		String column="HXCS_ZL_GRBDBmaliang"
				+ "HXCS_ZL_GRKHXXBmaliang"
				+ "HXCS_ZL_GRXZBmaliang"
				+ "HXCS_ZL_KHBDDZBmaliang"
				+ "HXCS_ZL_TTBDBmaliang"
				+ "HXCS_ZL_TTKHXXBmaliang"
				+ "HXCS_ZL_TTXZB";
		String[] columnname=column.toLowerCase().split("maliang") ;
		for(int i=0;i<columnname.length;i++) {
			sql=sql+"select distinct dis_data_date,'"+columnname[i].substring(8)+"' from s_core_"+columnname[i].substring(8)+
					" union all\t\n";
			
		}
		System.out.print(sql);
	}
	
	
}
