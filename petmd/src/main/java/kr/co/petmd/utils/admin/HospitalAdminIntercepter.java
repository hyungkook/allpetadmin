package kr.co.petmd.utils.admin;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.petmd.utils.common.Common;
import kr.co.petmd.utils.common.LogUtil;

import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

@Service
public class HospitalAdminIntercepter extends HandlerInterceptorAdapter {
	
	@Resource(name="sessionContextFactory")
	ObjectFactory<SessionContext> sessionContextFactory;
	
	private String appPath;
	
	public String getAppPath() {
		return appPath;
	}

	public void setAppPath(String appPath) {
		this.appPath = appPath;
	}
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
		response.setHeader("Cache-Control","no-cache");
		response.setHeader("Pragma","no-cache"); 
		response.setDateHeader("Expires",0);
		response.setCharacterEncoding("UTF-8");
		response.setHeader("P3P","CP='CAO PSA CONi OTR OUR DEM ONL'");
		
		request.setAttribute("con", Config.getConfig().getConfigMap());
		request.setAttribute("codes", Codes.getCodes().getCodesMap());
		
		String appType = Common.isNull(request.getParameter("appType"));
		
		String agent = request.getHeader("User-Agent");
		
		if(appType.length() > 0){
			request.getSession().setAttribute("appType", appType);
		} else if(agent.equals("AndroidWebView")){
			request.getSession().setAttribute("appType", agent);
		} else if(agent.equals("IOSWebView")){
			request.getSession().setAttribute("appType", agent);
		} else{
			request.getSession().setAttribute("appType", "");
		}
		
		if(FilenameUtils.getBaseName(request.getServletPath()).indexOf("ajax")==-1){
			
			SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
			
			// URL REQUEST 정보 남기기
			if (Config.DEBUG) {
				//LogUtil.LogInfo(request, sessionContext, Config.LOG_PATH_DEV, "pet_request_url", "|", "", "REQUEST");
			} else {
				//LogUtil.LogInfo(request, sessionContext, Config.LOG_PATH_REQUEST_URL, "pet_request_url", "|", "", "REQUEST");
			}
		}
		else{
			//System.out.println("Request is ajax");
		}
		
		return true;
	}
}
