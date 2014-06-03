package kr.co.petmd.controller.admin;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.petmd.HomeController;
import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.admin.Config;
import kr.co.petmd.utils.admin.SQLNamespace;
import kr.co.petmd.utils.admin.SessionContext;
import kr.co.petmd.utils.common.Common;

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
public class CommonAction {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@Resource(name="sessionContextFactory")
	ObjectFactory<SessionContext> sessionContextFactory;
	
	protected SessionContext getSessionContext(){
		
		return (SessionContext) sessionContextFactory.getObject();
	}
	
	@RequestMapping(value = {"/hospital/zipcodeSearch.latte","/admin/zipcodeSearch.latte"})
	public @ResponseBody String zipcodeSearch(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam Map<String, String> params) throws Exception {
		
		if (Config.DEBUG) logger.info("[Develop Mode] Method - zipcodeSearch");
		
		String JSONchartList ="";
		String search_text = params.get("search_text");
		if(search_text != null && search_text.length() > 0){
			params.put("search_text", search_text);
			@SuppressWarnings("rawtypes")
			List<Map> list = SqlDao.getList("COMMON.getZipcode", params);
			JSONchartList = JSONArray.toJSONString(list);
		}
		
		return URLEncoder.encode(JSONchartList,"UTF-8");
	}
}
