package work;

public class concat {
	
	public static void main(String[] args) {
		String sql;
		sql="";
		String name="ZZKJQKMB,NBKMDZB,CWPZXXB,YWJGLFFKMMXZB,SXFJYJFKMMXZB";
		String zw="���˻��ȫ��Ŀ��,�ڲ���Ŀ���ձ�,����ƾ֤��Ϣ��,ҵ�񼰹���ѷֿ�Ŀ��ϸ�˱�,�����Ѽ�Ӷ��ֿ�Ŀ��ϸ�˱�,";
		String[] tablename=name.toLowerCase().split(",");
		String[] tablenamez=zw.split(",") ;
		for(int i=0;i<tablename.length;i++) {
			sql=sql+"drop TRIGGER if exists `"+tablenamez[i]+"��ˮ���޸�`;\r\n" + 
					"CREATE  TRIGGER `"+tablenamez[i]+"��ˮ���޸�` BEFORE INSERT ON eastic_"+tablename[i]+"_s FOR EACH \r\n" + 
					"ROW\r\n" + 
					"BEGIN\r\n" + 
					"	DECLARE maxlsh VARCHAR(50);\r\n" + 
					"	DECLARE oldtime varchar(10);\r\n" + 
					"	set oldtime=CAST(DATE_FORMAT(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH)),'%Y%m%d') AS CHAR);\r\n" + 
					"	SELECT IFNULL(MAX(CAST(SUBSTR(LSH,15,10) AS UNSIGNED)),0)\r\n" + 
					"	into  maxlsh\r\n" + 
					"	from eastic_"+tablename[i]+"_s\r\n" + 
					"	where SUBSTR(LSH,7,8)=oldtime;\r\n" + 
					"	SET maxlsh=CONCAT('000235',oldtime,LPAD(IFNULL(maxlsh+1,1),10,0));\r\n" + 
					"	SET NEW.LSH=maxlsh;\r\n" + 
					"END;\r\n";
		}
		System.out.print(sql);
	}
	
	
}
