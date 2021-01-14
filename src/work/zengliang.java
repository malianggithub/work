package work;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Map.Entry;
import java.util.Properties;

public class zengliang {

	public static void main(String[] args) throws IOException {
		everyzl();

	}
	public static void everyzl() throws IOException {
		Properties pro=new Properties();
		pro.load(new BufferedReader(new FileReader(new File("C:\\Users\\16603\\git\\work\\file\\file\\每日增量表名.properties"))));
		
		
		Iterator<Entry<Object, Object>> its=pro.entrySet().iterator();
		
		String sql="";
		Entry<Object, Object> ent=null;
		while(its.hasNext()) {
			ent=its.next();
			sql=sql+"select '','"+ent.getValue().toString()+"',count(*) "+"FROM s_core_"+ent.getKey().toString().substring(8).toLowerCase()+" where DIS_DATA_DATE = date_sub(curdate(),interval 1 day) union all  \r\n";
			
		}
		sql=sql.substring(0,sql.length()-13);
		System.out.print(sql);
	}
}
