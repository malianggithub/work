package work;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import javax.swing.JFileChooser;
import javax.swing.filechooser.FileSystemView;

public class choosFile {

	public static void main(String[] args) throws IOException {
		choosefile();

	}
	public static void choosefile() throws IOException {
		int result = 0;
		File file = null;
		String path = null;
		File[] listfile = null;
		
		String sql = "";
		JFileChooser fileChooser = new JFileChooser();
		FileSystemView fsv = FileSystemView.getFileSystemView();  
		fileChooser.setCurrentDirectory(fsv.getHomeDirectory());
		fileChooser.setDialogTitle("请选择要上传的文件...");
		fileChooser.setApproveButtonText("确定");
		fileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
		result = fileChooser.showOpenDialog(fileChooser);
		if (JFileChooser.APPROVE_OPTION == result) {
		    	   path=fileChooser.getSelectedFile().getParent();
		    	   file  =  new File(path); 
		    	   listfile = file.listFiles();
		}
		BufferedReader read =null;
		for(int i=0;i<listfile.length;i++) {
			read=new BufferedReader(new FileReader(listfile[i].getPath()));
			while(read.readLine()!=null) {
				sql=sql+read.readLine()+"\r\n";
			}
			System.out.println(sql+" union all ");
		}
	}
}
