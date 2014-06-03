package kr.co.petmd.utils.admin;

import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.common.Common;

public class PermissionUtil {
	private PermissionUtil() {}
	private static PermissionUtil permissionUtil;
	
	public static PermissionUtil getInstance(){
		if(permissionUtil == null){
			permissionUtil = new PermissionUtil();
		}
		return permissionUtil;
	}
	
	public void setPermissionToSession(Map<String, String> adminVo, HttpSession session){
//		String id = adminVo.get("s_userid");
//		Map<String, Map<String,String>> permissionMap = null;
//		if (id.equals(Config.TOTAL_SUPER_ADMIN_ID)) {
//			permissionMap = SqlDao.getMapInMap("totalLogin.selectFullPermission", "", "s_sub_menu");
//		} else {
//			String aid = adminVo.get("s_aid");
//			permissionMap = SqlDao.getMapInMap("totalLogin.selectAdminIdToPermission", aid, "s_sub_menu");
//		}
//		
//		session.setAttribute(Config.SESSION_PERMISSION_KEY, permissionMap);
	}
	
	
	public Map<String, Map<String,String>> getPermission(Map<String, String> dataMap) {
		Map<String, Map<String,String>> permissionMap = null;
		if (dataMap != null) { 
			//Map<String, String> adminVo = SqlDao.getMap("totalHome.getAdminInfoFromAid", map.get("s_aid"));
			//if (adminVo != null) {
				String id = dataMap.get("s_userid");
				if (id.equals(Config.TOTAL_SUPER_ADMIN_ID)) {
					permissionMap = SqlDao.getMapInMap("totalLogin.selectFullPermission", "", "s_sub_menu");
				} else {
					String aid = dataMap.get("s_aid");
					permissionMap = SqlDao.getMapInMap("totalLogin.selectAdminIdToPermission", aid, "s_sub_menu");
				}
			//}
		}
		return permissionMap;
	}
	
	
	public void setPermissionToSession(Map<String, String> adminVo, HttpServletRequest request){
		setPermissionToSession(adminVo, request.getSession());
	}
	
	public boolean getPermissionToUrlPath(Map<String, Map<String,String>> permissionMap, String urlName){
		@SuppressWarnings("unchecked")
//		Map<String, Map<String,String>> permissionMap = (Map<String, Map<String,String>>)session.getAttribute(Config.SESSION_PERMISSION_KEY);
		
		Iterator<String> ite =  permissionMap.keySet().iterator();
		while(ite.hasNext()){
			String key = ite.next();
			Map<String,String> permissionVO = (Map<String,String>)permissionMap.get(key);
			if(permissionVO != null){
				String url = Common.isNull(permissionVO.get("s_url"));
				//System.out.println(permissionVO);
				//System.out.println(urlName);
				if(url.equals(urlName)){
					return true;
				}
			}
		}
		
		return false;
	}
}
