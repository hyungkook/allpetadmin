package kr.co.petmd.controller.admin.hospital;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.admin.SessionContext;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
public class LoginAction extends AbstractAction{

	@RequestMapping(value="/login.latte")
	public String login(Model model, HttpServletRequest request){
		
		SessionContext sessionContext = getSessionContext();
		
		if(sessionContext.isAuth())
			return "redirect:home.latte";
		
		return "admin/hospital/login/login";
	}
	
	@RequestMapping(value="/tryLogin.latte")
	public String tryLogin(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth()){
			Map<String, String> map = SqlDao.getMap("Admin.Hospital.Common.getInfoWithLogin", params);
			
			if(map != null && !map.isEmpty()){
				
				sessionContext.setAuth(true);
				sessionContext.setUserMap(map);
				
				return "redirect:hospitalHome.latte";
			}
			
			return "redirect:login.latte";
		}
		else{
			
			return "redirect:hospitalHome.latte";
		}
	}
	
	@RequestMapping(value="/logout.latte")
	public String logout(Model model, HttpServletRequest request){
		
		SessionContext sessionContext = getSessionContext();
		
		if(sessionContext.isAuth()){
			
			if(sessionContext.getUserMap()!=null)
				sessionContext.getUserMap().clear();
			sessionContext.setUserMap(null);
			
			sessionContext.setAuth(false);
			request.getSession().invalidate();
		}
		
		return "redirect:login.latte";
	}
}
