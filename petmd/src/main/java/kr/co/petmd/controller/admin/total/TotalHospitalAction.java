package kr.co.petmd.controller.admin.total;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.admin.Codes;
import kr.co.petmd.utils.admin.Config;
import kr.co.petmd.utils.admin.SessionContext;
import kr.co.petmd.utils.common.Common;
import kr.co.petmd.utils.common.EncodingUtil;
import kr.co.petmd.utils.common.JSONSimpleBuilder;
import kr.co.petmd.utils.common.LocationUtil;
import kr.co.petmd.utils.common.PageUtil;

import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
public class TotalHospitalAction extends BaseAction{
	
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
	@RequestMapping(value = {"/total/hospitalSearch.latte"})
	public String hospitalSearch(Model model, HttpServletRequest request, HttpSession session, @RequestParam Map<String, String> params) {
		
		if (Config.DEBUG) logger.info("[Develop Mode] Method - hospitalSearch");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth(Config.AUTH_TOTAL)){
			return "redirect:login.latte?rePage=hospitalSearch.latte";
		}
		
//		if(request.getAttribute(Config.PERMISSION_KEY_TOTAL)==null){
//			
//			String url = request.getHeader("Referer");
//			//if(!Common.isValid(url))
//				//url = "home.latte";
//				url = "login.latte";
//			
//			return "redirect:"+url;
//		}
		
		params.put("search_value", EncodingUtil.URLDecode(params.get("search_value"), Config.DEFAULT_CHARSET));
		
		params.put("totalCount", SqlDao.getString("Admin.Total.Hospital.getListCnt", params));
		PageUtil.getInstance().pageSetting(params, 15);
		List list = SqlDao.getList("Admin.Total.Hospital.getList", params);
		model.addAttribute("hospitalList", list);
		
		model.addAttribute("statusList", SqlDao.getList("COMMON.getElementList", Codes.HOSPITAL_STATUS));
		
		List<Map> sidoList = SqlDao.getList("COMMON.getSidoList",null);
		
		String sido = params.get(EncodingUtil.URLDecode(params.get("sido"), Config.DEFAULT_CHARSET));
		if(!Common.isValid(sido)){
			sido = (String) Common.getFirstValue(sidoList, "s_sido");
		}
		
		/**	layout */
		setLayout(model, "hospital/search.jsp", null);
		model.addAttribute("msg", EncodingUtil.URLDecode(params.get("msg")));
		
		model.addAttribute("params", params);
		
		return totalViewName;
//		return "admin/total/hospital/search";//totalViewName;
	}
	
	@RequestMapping(value = {"/total/hospitalReg.latte"})
	public String hospitalReg(Model model, HttpServletRequest request, HttpSession session, @RequestParam Map<String, String> params) {
		
		if (Config.DEBUG) logger.info("[Develop Mode] Method - hospitalReg");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth(Config.AUTH_TOTAL)){
			return "redirect:login.latte";
		}
		
		if(request.getAttribute(Config.PERMISSION_KEY_TOTAL)==null){
			
			String url = request.getHeader("Referer");
			if(!Common.isValid(url))
				url = "home.latte";
			
			System.out.println(EncodingUtil.URLEncode("으윽"));
			if(url.indexOf("?")<0)
				return "redirect:"+url+"?msg=123"+EncodingUtil.escape(EncodingUtil.URLEncode("으윽"));
			else
				return "redirect:"+url+"&msg=123";
		}
		
		Map<String, String> hospitalInfo = SqlDao.getMap("Admin.Total.Hospital.getInfoForUpdate", params.get("sid"));
		model.addAttribute("hospitalInfo", hospitalInfo);
		
		model.addAttribute("bankList", SqlDao.getList("COMMON.getElementList", Codes.ELEMENT_GROUP_BANK));
		model.addAttribute("statusList", SqlDao.getList("COMMON.getElementList", Codes.HOSPITAL_STATUS));
		
		// 담당자
		Map<String, String> admin = null;
		if(hospitalInfo!=null)
			admin = SqlDao.getMap("Admin.Total.getAdmin", hospitalInfo.get("s_aid"));
		
		List<Map> admin_team = SqlDao.getList("Admin.Total.getAdminTeamList", null);
		List<Map> admin_list = null;
		if(admin==null || admin.isEmpty()){
			admin_list = SqlDao.getList("Admin.Total.getAdminList", Common.getFirstValue(admin_team, "s_team"));
		}
		else
			admin_list = SqlDao.getList("Admin.Total.getAdminList", admin.get("s_team"));
		
		model.addAttribute("adminTeamList", admin_team);
		model.addAttribute("adminList", admin_list);

		
		/**	layout */
		setLayout(model, "hospital/reg.jsp", null);
		model.addAttribute("msg", params.get("msg"));
		
		model.addAttribute("params", params);
		
		return totalViewName;
	}
	
	@RequestMapping(value = {"/total/ajaxGetAdminList.latte"})
	public String ajaxGetAdminList(Model model, HttpServletRequest request, HttpSession session, @RequestParam Map<String, String> params) {
		
		if (Config.DEBUG) logger.info("[Develop Mode] Method - ajaxGetAdminList");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth(Config.AUTH_TOTAL)){
			return "admin/total/hospital/admin_select";
		}
		
		@SuppressWarnings("rawtypes")
		List<Map> admin_list = SqlDao.getList("Admin.Total.getAdminList", params.get("team"));
		model.addAttribute("adminList", admin_list);
		
		return "admin/total/hospital/admin_select";
	}
	
	@RequestMapping(value = {"/total/getAddressZipcode.latte", "/shop/getAddressZipcode.latte"})
	public String getAddressZipcode(Model model, @RequestParam Map<String, String> params) {
		if (Config.DEBUG) logger.info("[Develop Mode] Method - getAddressZipcode");
		
		String dong = params.get("dong_Input");
		
		List<Map> zipCodeList = null;
		
		if (Common.isValid(dong) == true) {
			zipCodeList = SqlDao.getList("COMMON.selectZipCodeList", dong);
		}
		
		model.addAttribute("zipCodeList", zipCodeList);
		model.addAttribute("dong", dong);
		
		return "admin/total/popup/search_address";
	}
	
	@RequestMapping(value = {"/total/hospitalPointHistory.latte"})
	public String hospitalPointHistory(Model model, HttpServletRequest request, HttpSession session, @RequestParam Map<String, String> params) {
		
		if (Config.DEBUG) logger.info("[Develop Mode] Method - hospitalPointHistory");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth(Config.AUTH_TOTAL)){
			return "redirect:login.latte";
		}
		
		if(request.getAttribute(Config.PERMISSION_KEY_TOTAL)==null){
			
			String url = request.getHeader("Referer");
			if(!Common.isValid(url))
				url = "home.latte";
			
			return "redirect:"+url;
		}
		
		params.put("sid", params.get("sid"));
		
		if(Common.isValid(params.get("search_value")))
			params.put("search_value", EncodingUtil.URLDecode(params.get("search_value"), Config.DEFAULT_CHARSET));
		
		Map<String, String> map = SqlDao.getMap("Admin.Point.Hospital.getTotalUserPoint", params);
		model.addAttribute("total", map);
		params.put("totalCount", Common.toString(map.get("cnt")));
		PageUtil.getInstance().pageSetting(params, 10);
		List list = SqlDao.getList("Admin.Point.Hospital.getUserPoint", params);
		model.addAttribute("userList", list);
		
		model.addAttribute("params", params);
		
		/**	layout */
		setLayout(model, "hospital/point_history.jsp", null);
		model.addAttribute("msg", params.get("msg"));
		
		model.addAttribute("params", params);
		
		return totalViewName;
	}
	
	/**
	 * 병원 아이디 중복 체크
	 */
	@RequestMapping(value = "/total/ajaxHospitalIdCheck.latte")
	public @ResponseBody String ajaxHospitalIdCheck(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		if (Config.DEBUG) logger.info("[Develop Mode] Method - ajaxHospitalIdCheck");
		
		// id가 있는지 확인 (자기 자신은 제외)
		List list = SqlDao.getList("Admin.Total.Hospital.getIdDuplicated", params);
				
		// 없으면 사용 가능한 id
		if (list==null || list.isEmpty()) 
			return Codes.SUCCESS_CODE;
		else
			return Codes.ERROR_QUERY_PROCESSED;
	}
	
	@RequestMapping(value = "/total/ajaxInitHospitalPw.latte")
	public @ResponseBody String ajaxInitHospitalPw(Model model, HttpServletRequest request, String sid) {
		if (Config.DEBUG) logger.info("[Develop Mode] Method - ajaxInitHospitalPw");
		
		// 암호를 초기화 (아이디와 같게 변경)
		if(SqlDao.update("Admin.Total.Hospital.initHospitalPw", sid)>0)
			return Codes.SUCCESS_CODE;
		else
			return Codes.ERROR_QUERY_PROCESSED;
	}
	
	@RequestMapping(value = {"/total/ajaxInsertOrUpdateHospital.latte"})
	public @ResponseBody String ajaxInsertOrUpdateHospital(Model model, HttpServletRequest request, HttpSession session, @RequestParam Map<String, String> params) {
		
		if (Config.DEBUG) logger.info("[Develop Mode] Method - ajaxInsertOrUpdateHospital");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		JSONSimpleBuilder sb = new JSONSimpleBuilder();
		
		// 권한이 없음 에러
		if(!sessionContext.isAuth(Config.AUTH_TOTAL)){
			sb.add("result", Codes.ERROR_UNAUTHORIZED);
			return sb.build();
		}
		
		// 로그인한 통합관리자 키값
		params.put("reg_user", sessionContext.getData(Config.AUTH_TOTAL, "s_aid"));
		
		// 관리자 전화번호를 조합
		params.put("manage_tel", Common.getSumString(request.getParameterValues("manage_tel"),"-"));
		
		// 누락된 파라미터 체크
		if(!Common.isValid(params.get("hospital_name"))
				|| !Common.isValid(params.get("hospital_id"))
				|| !Common.isValid(params.get("status"))
				|| !Common.isValid(params.get("manage_tel"))
				|| !Common.isValid(params.get("domain"))
//				|| !Common.isValid(params.get("aid"))
				|| !Common.isValid(params.get("old_zipcode"))){
			
			sb.add("result", Codes.ERROR_MISSING_PARAMETER);
			return sb.build();
		}
				
		if(Common.isValid(params.get("sid"))){
			
			/*
			 * 업데이트 루틴
			 */
			
			// id 중복 체크
			List duplist = SqlDao.getList("Admin.Total.Hospital.getIdDuplicated", params);
			// 없으면 사용 가능한 id
			if (duplist==null || duplist.isEmpty()) 
				;
			else{
				sb.add("result", Codes.ERROR_ID_DUPLICATED);
				return sb.build();
			}
			
			int result = SqlDao.insert("Admin.Total.Hospital.updateBasicInfo", params);
			
			if(result > 0)
				;
			
			params = LocationUtil.getLocation(params, "old_addr_sido", "old_addr_sigungu", "old_addr_dong", "old_addr_etc");
			if(!Common.isValid(params.get("n_latitude")))
				params = LocationUtil.getLocation(params, "old_addr_sido", "old_addr_sigungu", "old_addr_dong");
			SqlDao.insert("Admin.Total.Hospital.insertOrUpdateOldAddressInfo", params);
			SqlDao.insert("Admin.Total.Hospital.insertOrUpdateMoreInfo", params);
		}
		else{
			
			/*
			 * 신규 삽입 루틴
			 */
			
			// sid 생성
			params.put("sid", Common.makeRownumber("sid", System.currentTimeMillis()*10+""));
			
			// id 중복 체크
			List duplist = SqlDao.getList("Admin.Total.Hospital.getIdDuplicated", params);
			// 없으면 사용 가능한 id
			if (duplist==null || duplist.isEmpty()) 
				;
			else{
				sb.add("result", Codes.ERROR_ID_DUPLICATED);
				return sb.build();
			}
			
			// s_s_sid 생성 (short sid, 32자리)
			StringBuilder ssidb = new StringBuilder();
			ssidb.append("hsp0");
			ssidb.append((new SimpleDateFormat("yyyyMMddHHmmssS")).format(new Date()).substring(1));
			ssidb.append((new Random(System.currentTimeMillis())).nextInt(9000)+1000);
			String thid = String.format("%04d", Thread.currentThread().getId());
			int thidlen = thid.length();
			if(thidlen > 4){
				thid = thid.substring(thidlen-4);
			}
			ssidb.append(thid);
			ssidb.append(params.get("sid").substring(34, 38));
			params.put("ssid", ssidb.toString());
			// 끝
			
			int result = SqlDao.insert("Admin.Total.Hospital.insertBasicInfo", params);
			
			if(result > 0)
				;
			
			//List lll = SqlDao.getList("COMMON.getDefaultCustomCategory", null);
			
			params = LocationUtil.getLocation(params, "old_addr_sido", "old_addr_sigungu", "old_addr_dong", "old_addr_etc");
			if(!Common.isValid(params.get("n_latitude")))
				params = LocationUtil.getLocation(params, "old_addr_sido", "old_addr_sigungu", "old_addr_dong");
			SqlDao.insert("Admin.Total.Hospital.insertOrUpdateOldAddressInfo", params);
			SqlDao.insert("Admin.Total.Hospital.insertOrUpdateMoreInfo", params);
			
			Map<String, String> p = new HashMap<String, String>();
			p.put("group", "MAIN_MENU");
			p.put("lcode", "CHILDREN");
			List l = SqlDao.getList("COMMON.getCustomCategory", p);
			
			ArrayList<String> childList = new ArrayList<String>();
			
			Iterator iter = l.iterator();
			while(iter.hasNext()){
				Map map = (Map) iter.next();
				if(Common.strEqual(map.get("s_group"), "MAIN_MENU") && Common.strEqual(map.get("s_lcode"), "CHILDREN"))
					childList.add((String) map.get("s_value"));
			}
			
			int i = 0;
			
			Map<String,String> param = new HashMap<String, String>();
			
			param.put("idx", params.get("sid"));
			param.put("status", "Y");
			param.put("key", "");
			param.put("value", "");
			param.put("lv", "2");
			param.put("visible", "Y");
			
			param.put("parent", "MAIN_MENU");
			
			param.put("name", "메인메뉴");
			param.put("cmid", Common.makeRownumber("cmid", System.currentTimeMillis()+""));
			param.put("group", Codes.CUSTOM_CATEGORY_MAIN_MENU_1);
			param.put("index", "1");
			
			SqlDao.insert("COMMON.insertCustomizeItem", param);
			
			param.put("name", "스태프");
			param.put("cmid", Common.makeRownumber("cmid", System.currentTimeMillis()+""));
			param.put("group", Codes.CUSTOM_CATEGORY_MAIN_MENU_2);
			param.put("index", "2");
			
			SqlDao.insert("COMMON.insertCustomizeItem", param);
			
			String cmid3 = Common.makeRownumber("cmid", System.currentTimeMillis()+"");
			param.put("name", "서비스");
			param.put("cmid", cmid3);
			param.put("group", Codes.CUSTOM_CATEGORY_MAIN_MENU_3);
			param.put("index", "3");
			
			SqlDao.insert("COMMON.insertCustomizeItem", param);
			
			String cmid4 = Common.makeRownumber("cmid", System.currentTimeMillis()+"");
			param.put("name", "소식");
			param.put("cmid", cmid4);
			param.put("group", Codes.CUSTOM_CATEGORY_MAIN_MENU_4);
			param.put("index", "4");
			
			SqlDao.insert("COMMON.insertCustomizeItem", param);
			
			param.put("name", "오시는 길");
			param.put("cmid", Common.makeRownumber("cmid", System.currentTimeMillis()+""));
			param.put("group", Codes.CUSTOM_CATEGORY_MAIN_MENU_5);
			param.put("index", "5");
			
			SqlDao.insert("COMMON.insertCustomizeItem", param);
			
			param.put("parent", cmid3);
			
			param.put("name", "기본");
			param.put("cmid", Common.makeRownumber("cmid", System.currentTimeMillis()+""));
			param.put("group", Codes.CUSTOM_BOARD_TYPE_IMAGE);
			param.put("index", "1");
			
			SqlDao.insert("COMMON.insertCustomizeItem", param);
			
			param.put("parent", cmid4);
			
			param.put("name", "공지사항");
			param.put("cmid", Common.makeRownumber("cmid", System.currentTimeMillis()+""));
			param.put("group", Codes.CUSTOM_BOARD_TYPE_NOTICE);
			param.put("index", "1");
			
			SqlDao.insert("COMMON.insertCustomizeItem", param);
			//SqlDao.
		}
		
		// 메인메뉴 리스트를 가져옴
		
		// customize에 메인메뉴 5개 삽입
		
		// 진료서비스 메뉴에 기본 메뉴 추가
		
		// 소식 메뉴에 기본 게시판 추가
		
		sb.add("result", Codes.SUCCESS_CODE);
		sb.postAdd("sid", params.get("sid"));
		return sb.build();
	}
	
	@RequestMapping(value = {"/total/hospitalMobile.latte"})
	public String hospitalMobile(Model model, HttpServletRequest request, HttpSession session, @RequestParam Map<String, String> params) {
		
		if (Config.DEBUG) logger.info("[Develop Mode] Method - hospitalMobile");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth(Config.AUTH_TOTAL)){
			return "redirect:login.latte";
		}
		
		if(request.getAttribute(Config.PERMISSION_KEY_TOTAL)==null){
			
			String url = request.getHeader("Referer");
			if(!Common.isValid(url))
				url = "home.latte";
			
			return "redirect:"+url;
		}
		
		/**	layout */
		setLayout(model, "hospital/mobile.jsp", null);
		model.addAttribute("msg", params.get("msg"));
		
		model.addAttribute("params", params);
		
		return totalViewName;
	}
	

	@RequestMapping(value = {"/total/list.latte"})
	public String list(Model model, HttpServletRequest request, HttpSession session, @RequestParam Map<String, String> params) {
		
		List<Map> list =SqlDao.getList("Admin.Total.Hospital.getUserCountList", params);
		model.addAttribute("hospitalList", list);
		
		return "admin/total/hospital/hospitalList";
	}
}