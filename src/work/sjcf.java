package work;

public class sjcf {

	public static void main(String[] args) {
		String sjcf="ZJJGXXBmaliang"
				+ "XSRYXXBmaliang"
				+ "ZZKJQKMBmaliang"
				+ "CWPZXXBmaliang"
				+ "YWJGLFFKMMXZBmaliang"
				+ "SXFJYJFKMMXZBmaliang"
				+ "KHBDDZBmaliang"
				+ "GRBDBmaliang"
				+ "GRXZBmaliang"
				+ "BBXRBmaliang"
				+ "TTBDBmaliang"
				+ "TTXZBmaliang"
				+ "KHHFBmaliang"
				+ "BDXSRYGLBmaliang"
				+ "BFMXBmaliang"
				+ "FFMXBmaliang"
				+ "TTBFBmaliang"
				+ "CXRXXBmaliang"
				+ "LPBDMXB";
		//cfnum(sjcf);
		
		String ruihua="EASTIC_YWXTCPBMmaliang"
				+ "EASTIC_YWXTCPBMmaliang"
				+ "EASTIC_YWXTCPBMmaliang"
				+ "EASTIC_YWXTCPBMmaliang"
				+ "EASTIC_YWXTCPBMmaliang"
				+ "EASTIC_YWXTCPBMmaliang"
				+ "EASTIC_YWXTCPBMmaliang"
				+ "EASTIC_YWXTCPBMmaliang"
				+ "EASTIC_YWXTCPBMmaliang"
				+ "EASTIC_YWXTCPBMmaliang"
				+ "EASTIC_YWXTCPBMmaliang"
				+ "EASTIC_TJFXZmaliang"
				+ "EASTIC_TJFXZmaliang"
				+ "EASTIC_TJFXZmaliang"
				+ "EASTIC_TJFXZmaliang"
				+ "EASTIC_TJFXZmaliang"
				+ "EASTIC_TJFXZmaliang"
				+ "EASTIC_TJFXZmaliang"
				+ "EASTIC_TJFXZmaliang"
				+ "EASTIC_TJFXZmaliang"
				+ "EASTIC_TJFXZmaliang"
				+ "EASTIC_TJCPSJLXmaliang"
				+ "EASTIC_TJCPSJLXmaliang"
				+ "EASTIC_TJCPSJLXmaliang"
				+ "EASTIC_TJCPSJLXmaliang"
				+ "EASTIC_TJCPSJLXmaliang"
				+ "EASTIC_TJCPSJLXmaliang"
				+ "EASTIC_TJCPSJLXmaliang"
				+ "EASTIC_TJCPSJLXmaliang"
				+ "EASTIC_TJCPSJLXmaliang"
				+ "EASTIC_TJCPSJLXmaliang"
				+ "EASTIC_TJCPSJLXmaliang"
				+ "EASTIC_TJCPSJLX";
		String rui="P11122100008maliang"
				+ "P12130100001maliang"
				+ "P22110000001maliang"
				+ "P99999999999maliang"
				+ "V0220101maliang"
				+ "V0220201maliang"
				+ "V0220301maliang"
				+ "V0220401maliang"
				+ "V0400000maliang"
				+ "V0500000maliang"
				+ "V9900000maliang"
				+ "P11122100008maliang"
				+ "P12130100001maliang"
				+ "P22110000001maliang"
				+ "P99999999999maliang"
				+ "V0220101maliang"
				+ "V0220201maliang"
				+ "V0220301maliang"
				+ "V0220401maliang"
				+ "V0400000maliang"
				+ "V0500000maliang"
				+ "V9900000maliang"
				+ "P11122100008maliang"
				+ "P12130100001maliang"
				+ "P22110000001maliang"
				+ "P99999999999maliang"
				+ "V0220101maliang"
				+ "V0220201maliang"
				+ "V0220301maliang"
				+ "V0220401maliang"
				+ "V0400000maliang"
				+ "V0500000maliang"
				+ "V9900000";
		insert(ruihua,rui);
	}
	public static void cfnum(String tables) {
		String sql="";
		String[] table=tables.toLowerCase().split("maliang");
		for(int i = 0;i<table.length;i++) {
			sql=sql+"select '"+table[i]+"',DIS_STEP_ID,COUNT(*) from eastic_"+table[i]+" group by DIS_STEP_ID union all\r";
		}
		System.out.print(sql);
	}
	public static void insert(String arg1,String arg2) {
		String sql="";
		String[] type=arg1.split("maliang");
		String[] key=arg2.split("maliang");
		for(int i = 0;i<type.length;i++) {
			sql=sql+"insert into east_ruihua_dictionary(DICT_TYPE,DICT_KEY) values('"+type[i]+"','"+key[i]+"');\r";
		}
		System.out.print(sql);
	}
}
