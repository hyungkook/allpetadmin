package kr.co.petmd.utils.common;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import kr.co.petmd.utils.admin.SessionContext;





/**
 * Created on 2013. 04. 24
 * ADVentures CO., LTD.
 * 
 * Developer - Na Yu Cheol
 * 
 * LogUtil.
 * 
 **/


public class LogUtil {
	
	public static synchronized void LogInfo (
													HttpServletRequest request, 
													SessionContext session,
													String log_path, String file_name, String separator,
													String datetime_pattern,
													String ...info
												) {
		try {
			
			// URL 정보
			/*
			@SuppressWarnings("rawtypes")
			Enumeration param = request.getParameterNames();
			String strParam = ""; 
			
			while(param.hasMoreElements()) { 
				String name = (String)param.nextElement(); 
				String value = request.getParameter(name); 
				
				if (!name.equals("id") && !name.equals("pw")) {
					if (!name.equals("s_user_id") && !name.equals("s_password")) {
						strParam += name + "=" + value + "&"; 
					}
				}
				
			}*/
			
			
			// 기본 정보
			if (Common.isNull(datetime_pattern).equals("")) {
				datetime_pattern = "yyyy-MM-dd";
			}
			
			/** url 파라미터 제거 */
			String url = request.getServletPath().toString();
			if (url != null && url.length() > 0) {
				url = url.split("\\?")[0]; 
			}
			
			SimpleDateFormat formatter1 = new SimpleDateFormat(datetime_pattern);
			SimpleDateFormat formatter2 = new SimpleDateFormat("HH:mm:ss");
			
	        String LOG_DATE = formatter1.format(new Date()) + " " + formatter2.format(new Date());
			String CON_URL 	= Common.isNull(url);
			
			String REF_URL 	= Common.isNull(request.getHeader("REFERER"));
			String CON_IP	= Common.isNull(request.getHeader("X-FORWARDED-FOR"),"NO_IP");
			
			if(CON_IP.equals("NO_IP")){
				CON_IP = Common.isNull(request.getRemoteAddr(), "NO_IP");
			}
			
			String USER_SUID	= "UID";
			String USER_GENDER 	= "GEN";
			String USER_AGE		= "AGE";
			
			if (session.getUserMap() != null) {
				USER_SUID	 = Common.isNull(session.getUserMap().get("s_uid"), "UID");
				USER_GENDER  = Common.isNull(session.getUserMap().get("s_gender"), "GEN");
				USER_AGE 	 = Common.isNull(String.valueOf(session.getUserMap().get("s_age")), "AGE");	
	        }
			
			String AGENT = Common.isNull(request.getSession().getAttribute("appType").toString(), "PC");
			
			// LOG 파일명 생성
			StringBuffer bufLogPath  = new StringBuffer();       
            bufLogPath.append(file_name);
            bufLogPath.append("_");
            bufLogPath.append(formatter1.format(new Date()));
            bufLogPath.append(".log") ;

            // LOG 저장
            StringBuffer bufLogMsg = new StringBuffer(); 
            bufLogMsg.append(LOG_DATE);
            bufLogMsg.append(separator);
            bufLogMsg.append(CON_IP);
            bufLogMsg.append(separator);
            
            bufLogMsg.append(USER_SUID);
            bufLogMsg.append(separator);
        	bufLogMsg.append(USER_GENDER);
            bufLogMsg.append(separator);
            bufLogMsg.append(USER_AGE);
            bufLogMsg.append(separator);
            
            bufLogMsg.append(AGENT);
            bufLogMsg.append(separator);
            
            // info array
            for (int i = 0; i < info.length; i++) {
            	bufLogMsg.append(info[i]).append(separator);
            }
            
            bufLogMsg.append(CON_URL);
            bufLogMsg.append(separator);
            bufLogMsg.append(REF_URL);
            
            BufferedWriter file = null;
	        try {
	        	
	        	
				
				File f = new File(log_path + File.separator + bufLogPath.toString());
				File dir = new File(log_path);
				if(dir.exists() == false){
					dir.mkdirs();
				}
				
				file = 	new BufferedWriter(new OutputStreamWriter(new FileOutputStream(f,true), "utf-8"));
				
				
				file.write(bufLogMsg.toString(), 0, bufLogMsg.length()); 
			    file.newLine();
			    file.flush(); 
	      
	        } catch(IOException e) {
             
	        } finally {
	        	
	        	try {
	        		file.close();
	        	} catch(Exception e1){
            	 
	        	}
	        	
	        }
			
			
		} catch (Exception e) {
			
			System.out.println("Log File Insert Error.");
			e.printStackTrace();
			
		}
        
	}
	
}
