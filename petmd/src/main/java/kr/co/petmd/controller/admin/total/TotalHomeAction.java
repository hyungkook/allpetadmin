package kr.co.petmd.controller.admin.total;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.admin.Config;
import kr.co.petmd.utils.admin.SessionContext;
import kr.co.petmd.utils.common.Common;

import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
public class TotalHomeAction extends BaseAction{
	
	@Resource(name="sessionContextFactory")
	ObjectFactory<SessionContext> sessionContextFactory;
	
	/**
	 * 화면 레이아웃 기본 셋팅
	 * @param model
	 * @param body
	 * @param containerName
	 */
	private void setLayout(Model model, String body, String containerName) {
		setLayout(model, "include/topMenu.jsp", "include/subMenu_hospital.jsp", body, containerName);
		//setLayout(model, "hospital/search.jsp", null, body, containerName);
	}

//	/**
//	 * 강제 링크
//	 */
//	@RequestMapping(value = {"/total","/total/login.latte"})
//	public String total(Model model, HttpServletRequest request, HttpSession session, @RequestParam Map<String, String> params) {
//		
//		if (Config.DEBUG) logger.info("[Develop Mode] Method - total");
//		
//		return "redirect:" + Common.isNull(params.get("rePage"), "home.latte");
//	}
	
	/**
	 * main
	 */
	@RequestMapping(value = {"/total/home.latte"})
	public String home(Model model, HttpServletRequest request, HttpSession session, @RequestParam Map<String, String> params) {
		
		if (Config.DEBUG) logger.info("[Develop Mode] Method - home");
		
		//SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		//if(!sessionContext.isAuth("TOTAL")){
		//	return "redirect:login.latte";
		//}
		
		//String s = request.getHeader("Referer");
		//if(!Common.isValid(s))
		//	s = "home.latte";
		
		//if(request.getAttribute("admin_permission")==null)
		//	return "redirect:"+s;
		
		//List list = SqlDao.getList("Admin.Total.Hospital.getList", params);
		//model.addAttribute("hospitalList", list);
		
		/**	layout */
		//setLayout(model, "hospital/search.jsp", null);
		//model.addAttribute("msg", params.get("msg"));
		
		return "admin/total/home/home";
//		return "admin/total/hospital/search";//totalViewName;
	}
	
}