package work;

public class update {
	
	public static void main(String[] args) {
		String sql;
		sql="";
		String column="LSH,"+
				"BXJGDM,"+
				"BXJGMC,"+
				"BXZTBM,"+
				"BXZTMC,"+
				"FZJGDM,"+
				"GSQJ,"+
				"JZRQ,"+
				"JZPZH,"+
				"ZZKJKMBH,"+
				"ZZKJKMMC,"+
				"PZLY,"+
				"ZY,"+
				"HBDM,"+
				"JYBJF,"+
				"JYBDF,"+
				"BWBJF,"+
				"BWBDF,"+
				"YWXTCPBM,"+
				"CWXTCPBM,"+
				"JFFSMC,"+
				"QDMC,"+
				"TJFXZ,"+
				"TJCPSJLX,"+
				"TJJFFS,"+
				"TJQD,"+
				"PCH,"+
				"DIS_USER,"+
				"DIS_OPERATE_FLAG,"+
				"DIS_DATA_FROM,"+
				"DIS_EDIT_LOCK,"+
				"DIS_VERIFY_STATUS,"+
				"DIS_DATA_DATE,"+
				"DIS_BANK_ID,"+
				"DIS_STEP_ID,"+
				"QFJGH";
		String[] columnname=column.split(",") ;
		for(int i=0;i<columnname.length;i++) {
			sql=sql+"update eastic_cwpzxxb_s set "+columnname[i]+
					"='' where "+columnname[i]+" is null;\r\n";
			
		}
		System.out.print(sql);
	}
	
	
}
