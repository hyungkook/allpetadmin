package kr.co.petmd.utils.admin;

import java.io.File;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import kr.co.petmd.dao.SqlDao;

public class ImageDeleter extends Thread{
	
	private static ImageDeleter instance = null;
	
	public static void startInstance(){
		
		if(instance==null){
			instance=new ImageDeleter();
			instance.setDaemon(true);
			instance.start();
		}
	}
	
	private long lastTime = 0;
	private long term = 60000; // db조회 간격, 단위 msec
	private String delTerm = "3600"; // 삭제할 파일의 현재 시간에 대하여 떨어진 거리, 단위 sec
	
	private ImageDeleter(){}

	@Override
	public void run(){
		
		try{
			while(true){
				long newTime = System.currentTimeMillis();
				if(newTime > lastTime + term){
					lastTime = newTime;
					act();
				}
				sleep(1000);
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			instance=null;
		}
	}
	
	private void act(){
		
		int cnt = 0;
		int del_cnt = 0;
		// 임시 이미지 전부 삭제
		@SuppressWarnings("rawtypes")
		List<Map> imgList = SqlDao.getList("Admin.Hospital.Common.getTempImages", delTerm);
		if(imgList != null){
			@SuppressWarnings("rawtypes")
			Iterator<Map> iter = imgList.iterator();
			while(iter.hasNext()){
				@SuppressWarnings("rawtypes")
				Map map = iter.next();
				cnt++;
				
				// 이미지를 실제로 삭제
				String path = Config.IMAGE_PATH_ROOT + map.get("s_image_path");
						
				File f = new File(path);
				//System.out.println("1:"+path);
				// 파일이 없거나 삭제에 성공했을 경우
				if(!f.exists() || f.delete()){
					//System.out.println("1:"+path);
					path = Config.IMAGE_PATH_ROOT + map.get("s_thum_img_path");
					
					f = new File(path);
					if(!f.exists() || f.delete()){
						//System.out.println("thum:"+path);
						// 삭제 성공시 DB에서 삭제
						SqlDao.delete("Admin.Hospital.Common.deleteImage", map.get("s_iid"));
						//System.out.println("success");
						del_cnt++;
					}
				}
			}
		}
		if(cnt > 0 || del_cnt > 0){
			// getTime( 2014-3-5 0:0:0 ) = 1393945200
			System.out.println("Execute temp image deleter... count : "+cnt+", deleted : "+del_cnt+", time : "+System.currentTimeMillis());
		}
	}
	
	public static void setTerm(long msec){
		
		if(instance!=null){
			instance.term = msec;
		}
	}
	
	public static void setDelTerm(int sec){
		
		if(instance!=null){
			instance.delTerm = sec+"";
		}
	}
}
