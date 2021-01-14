package work;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

public class dis_data_date {

	public static void main(String[] args) throws IOException {
		bjg();

	}
	public static void bjg() throws IOException {
		Map<Integer, String> map=new HashMap<>();
		int i=0;
		String sqls="";
		String result="";
		String[] table=null;
		String[] sql=new String[269];
		String[] sqltable=new String[269];
		BufferedReader read = new BufferedReader(new FileReader(new File("C:\\Users\\16603\\Desktop\\添加的索引检核工具-20201230.txt")));
		while(true) {
			result=read.readLine();
			
			if(result!=null&&result.trim().isEmpty()) {
				continue;
			}
			
			
			if(result==null) {
				break;
			}
			table=result.split(" ");
			sql[i]=result;
			sqltable[i]=table[2];
			if(i>0) {
				if(!sqltable[i-1].equals(sqltable[i])) {
					sqls=sqls+"ALTER TABLE "+sqltable[i-1]+" ADD INDEX  "+sqltable[i-1]+"_ (DIS_DATA_DATE);\r\n\r\n";
				}
			}
			sqls=sqls+result+"\r\n";
			
			i++;
		}
		System.out.print(sqls);
		read.close();
	}
}
