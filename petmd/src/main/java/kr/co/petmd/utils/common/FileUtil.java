package kr.co.petmd.utils.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import org.apache.commons.io.FilenameUtils;
import org.springframework.web.multipart.MultipartFile;

public class FileUtil {

	/**
	 * 파일을 디스크에 씀
	 * 
	 * @param filePathName 저장 경로
	 * @param mfile 원본 파일
	 * @return
	 */
	
	public static boolean write(String filePathName, MultipartFile mfile){
		
		File downFile = new File(filePathName);
		
		if(downFile.exists() == false){
			downFile.getParentFile().mkdirs();
		}
		
		FileOutputStream os = null;
		
		try {
			
			os = new FileOutputStream(downFile);

			os.write(mfile.getBytes());
			
			os.flush();
			
			return true;
			
		} catch (IOException e) {
			
			return false;
		}
		finally{
			
			if(os != null){
				try {
					os.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	/**
	 * 파일 이동
	 * 
	 * @param inFileName
	 * @param outFileName
	 * @throws IOException 
	 */
	
	public static boolean fileMove(String inFileName, String outFileName){
		
		FileInputStream fis = null;
		FileOutputStream fos = null;
		try {
			fis = new FileInputStream(inFileName);
			File outFile = new File(FilenameUtils.getFullPath(outFileName));
			if(!outFile.exists())
				outFile.mkdirs();
			fos = new FileOutputStream(outFileName);
			
			int data = 0;
			while((data=fis.read())!=-1) {
				fos.write(data);
			}
			
			fis.close();
			fis=null;
			fos.close();
			fos=null;
			
			//복사한뒤 원본파일을 삭제함
			File f = new File(inFileName);
			f.delete();
//			System.out.println(f.delete());
		
			return true;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		} finally{
			
			if(fis!=null){
				try {
					fis.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			if(fos!=null){
				try {
					fos.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
	}
}
