package kr.co.petmd.controller.admin;

import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.petmd.HomeController;
import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.admin.Config;
import kr.co.petmd.utils.admin.SessionContext;

import org.json.simple.JSONArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class GCMAction {

private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@Resource(name="sessionContextFactory")
	ObjectFactory<SessionContext> sessionContextFactory;
	
	protected SessionContext getSessionContext(){
		
		return (SessionContext) sessionContextFactory.getObject();
	}
	
	@RequestMapping(value = {"/userDeviceCheck.latte"})
	public @ResponseBody String userCheck(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam Map<String, String> params) throws Exception {
		
		String JSONchartList ="";
		
		List<Map> list = SqlDao.getList("Admin.Member.getMemberByDevice", params);
		JSONchartList = JSONArray.toJSONString(list);
		
		return URLEncoder.encode(JSONchartList,"UTF-8");
	}
	
	@RequestMapping(value = {"/userDeviceUpdate.latte"})
	public @ResponseBody String userDeviceInsert(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam Map<String, String> params) throws Exception {
		int result = SqlDao.insert("Admin.Member.updateDeviceRegID", params);
		return result+"";
	}
}
