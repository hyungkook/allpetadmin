package kr.co.petmd.utils.admin;

import java.net.URLEncoder;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.common.Common;
import kr.co.petmd.utils.common.LogUtil;

import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

@Service
public class TotalAdminIntercepter extends HandlerInterceptorAdapter {
	
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
		
		// 세션이 있음
		if(request.getSession(false)!=null){
			
			SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
			
			if(sessionContext.isAuth(Config.AUTH_TOTAL)){
		
				Map<String, Map<String, String>> permissionMap = PermissionUtil.getInstance().getPermission(sessionContext.getDataMap(Config.AUTH_TOTAL));
				request.setAttribute("permission", permissionMap);
				//					System.out.println("권한체크 시작");
				String filename = Common.getServletName(request);
				//					System.out.println(filename);
				String pageChk = Common.isNull(SqlDao.getString("totalLogin.selectAdminPermissionPage", filename), "0");
				
				if(Integer.parseInt(pageChk) > 0){
					if(PermissionUtil.getInstance().getPermissionToUrlPath(permissionMap, filename) == false){
//						String msg = URLEncoder.encode("You not have permission", "utf-8");
//						response.sendRedirect("home.latte?msg="+msg);
//						if(Config.DEBUG){
//							System.out.println("not failed admin permission.. "+filename);
//						}
						request.removeAttribute(Config.PERMISSION_KEY_TOTAL);
					}
					else
						request.setAttribute(Config.PERMISSION_KEY_TOTAL, true);
				}
				else{
					request.setAttribute(Config.PERMISSION_KEY_TOTAL, true);
				}
			}
		}
		
		return true;
	}
}
