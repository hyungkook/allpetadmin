package kr.co.petmd.controller.admin.total;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.admin.Config;
import kr.co.petmd.utils.admin.SessionContext;
import kr.co.petmd.utils.common.Common;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
public class TotalLoginAction {
	
	private static final Logger logger = LoggerFactory.getLogger(TotalLoginAction.class);
	
	@Resource(name="sessionContextFactory")
	ObjectFactory<SessionContext> sessionContextFactory;
	
	protected SessionContext getSessionContext(){
		
		return (SessionContext) sessionContextFactory.getObject();
	}
	
	/**
	 * Login
	 */
	@RequestMapping(value = "/total/login.latte")
	public String login(	Model model, 
							HttpServletRequest request, 
							@RequestParam Map<String, String> params, 
							@RequestParam(required=false) String msg	) {
	
		return "admin/total/login/login";
	}
	
	/*
	 *  통합 계정 로그인
	 */
	@RequestMapping(value = "/total/loginAccept.latte")
	public String loginAccept(Model model, HttpServletRequest request, HttpSession session, @RequestParam Map<String, String> params) {
		
		if (Config.DEBUG) logger.info("[Develop Mode] Method - loginAccept : {}", Common.isNull(params.get("type"),"1"));
		
		Map<String, String> sMap = SqlDao.getMap("totalLogin.getAdminLoginInfo", params);

		// 로그인 아이피 정보 수집
		String ipAddress  = request.getHeader("X-FORWARDED-FOR");   
		if(ipAddress == null)   
		{   
			ipAddress = request.getRemoteAddr();   
		}
		
//		if (Common.isValid(PermissionUtil.getInstance().getPermission(session)) == true) {
//			return "redirect:" + Common.isNull(params.get("rePage"), "/total/home.latte");
//		}
//		
//		/** 로그인 5회 이상 실패시 처리 */
//		String count = SqlDao.getString("totalLogin.getAdminFailCount", params);
//		if (Common.isValid(count) == true) {
//			int failCount = Integer.parseInt(count);
//			if (failCount > 5) {
//				/** 오류 메세지 */
//				model.addAttribute("msg","로그인 실패횟수가 5회 이상입니다.\\n 관리자에게 문의하시기바립니다.");
//				AcessHistory.put(ipAddress, request.getRequestURI(), "TOTAL", params.get("s_userid"));
//				return "redirect:login.latte?rePage=" + params.get("rePage");
//			}
//		}
		
		if (sMap != null) {
			/** 관리자 상태 정상 */
			if (sMap.get("s_state").equals("Y")) {
				/* 정상적으로 로그인 됐을 경우 */

//				/** IP 정보 등록..*/
//		        AcessHistory.put(ipAddress, request.getRequestURI(), "TOTAL", sMap.get("s_aid"));
//		        
//		        /**	로그인 실패 횟수 초기화 */
//		        sMap.put("n_fail_count", "0");
//		        int ipResult = SqlDao.update("totalLogin.updateAdminFailCount", params);
//		        
//		        if (ipResult < 1) {
//		        	logger.info("[ERROR] Method - loginAccept : Latest IP Address change error. (IP:{})", ipAddress);
//		        }
//		        
//		        sMap.put("service_type", "TOTAL");
//		        
//		        session.setAttribute(Config.SESSION_KEY + Config.SVC_NAME_TOTAL, sMap);
//		        
//		        String forwardPage = params.get("forwardPage");
//		        if (Common.isValid(forwardPage) == false) {
//		        	forwardPage = "combineIndex.latte";
//		        }
				
				SessionContext sessionContext = getSessionContext();
				
				sessionContext.setAuth(Config.AUTH_TOTAL, true);
				sessionContext.setDataMap(Config.AUTH_TOTAL, sMap);
				//sessionContext.setTotalAuth(true);
				//sessionContext.setUserMap(sMap);
		        
		        return "redirect:" + Common.isNull(params.get("rePage"), "/total/home.latte");//+ forwardPage);
				
			} else {
//				 AcessHistory.put(ipAddress, request.getRequestURI(), "TOTAL", sMap.get("s_aid"));
//				// 정상 회원이 아닐경우 처리
//				model.addAttribute("msg", "정상적인 회원이 아닙니다. 고객센터에 문의 바랍니다.");
//				model.addAttribute("rePage", Common.isNull(params.get("rePage")));
//				model.addAttribute("type", Common.isNull(params.get("type")));
				
				return "redirect:" + Common.isNull(params.get("rePage"), "login.latte");
			}
			
		// 아이디 비밀번호 실패..
		} else {
			
			/** IP 정보 등록..*/
//			AcessHistory.put(ipAddress, request.getRequestURI(), "TOTAL", params.get("s_userid"));
//			
//			/** 실패 카운드 등록 */
//			count = SqlDao.getString("totalLogin.getAdminFailCount", params);
//			if (Common.isValid(count) == true) {
//				params.put("n_fail_count", String.valueOf(Integer.parseInt(count) + 1));
//				SqlDao.update("totalLogin.updateAdminFailCount", params);
//			}
			
			/** 오류 메세지 */
			model.addAttribute("msg", "아이디 또는 비밀번호가 틀렸습니다.");
			
			return "redirect:login.latte?rePage=" + params.get("rePage");
			
		}
		
	}
	/*
	 *  통합 계정 로그아웃
	 */
	@RequestMapping(value = "/total/logout.latte")
	public String logout(Model model, HttpServletRequest request, HttpSession session, @RequestParam Map<String, String> params) {
		
		if (Config.DEBUG) logger.info("[Develop Mode] Method - logout");
		
//		Map map = (Map) session.getAttribute(Config.SESSION_KEY + Config.SVC_NAME_TOTAL);
//		
//		/** session data 제거 */
//		if (map != null) {
//			map.clear();
//		}
//		map = null;
		
		SessionContext sessionContext = getSessionContext();
		
		if(sessionContext.isAuth(Config.AUTH_TOTAL)){
			
			sessionContext.clear(Config.AUTH_TOTAL);
			request.getSession().invalidate();
		}
		
		return "redirect:login.latte";
	}
}
