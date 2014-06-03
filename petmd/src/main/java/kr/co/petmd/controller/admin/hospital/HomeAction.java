package kr.co.petmd.controller.admin.hospital;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.admin.Codes;
import kr.co.petmd.utils.admin.Config;
import kr.co.petmd.utils.admin.ImageDeleter;
import kr.co.petmd.utils.admin.SQLNamespace;
import kr.co.petmd.utils.admin.SessionContext;
import kr.co.petmd.utils.common.Common;
import kr.co.petmd.utils.common.EncodingUtil;
import kr.co.petmd.utils.common.JSONSimpleBuilder;
import kr.co.petmd.utils.common.StatusInfoSet;
import kr.co.petmd.utils.common.StatusInfoUtil;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
public class HomeAction extends AbstractAction {

	@RequestMapping(value="/hospitalHome.latte")
	public String hospitalHome(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		ImageDeleter.startInstance();
		ImageDeleter.setTerm(600000);
		ImageDeleter.setDelTerm(3600);
		
		String sid = sessionContext.getData("s_sid");
		
		// 임시 파일 삭제
		// removeTempImages(sid);
		
		putMainMenuToModel(model, sid, Codes.CUSTOM_CATEGORY_MAIN_MENU_1);
		Map<String, String> info = SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getHomeInfo", sid);
		
		// 병원의 Status Info를 가져옴
		StatusInfoSet.setFields(Codes.STATUS_INFO_HOSPI_INFO, params);
		params.put("id", sid);
		List<Map> flexList = SqlDao.getList("Common.StatusInfo.getInfo", params);
		// info에 flexList의 값들을 집어넣음
		info = StatusInfoUtil.merge(flexList, info, false);
		
		model.addAttribute("hospitalInfo", info);
		model.addAttribute("workingTimeList", SqlDao.getList(SQLNamespace.CLIENT_HOSPITAL+"getWorkingTime", sid));
		
		// 병원 소개 이미지
		params.put("sid", sid);
		params.put("key", Codes.IMAGE_TYPE_HOSPITAL_INTRO);
		model.addAttribute("introImageList", SqlDao.getList(SQLNamespace.CLIENT_HOSPITAL+"getImageByKey", params));
		
		// 병원 헤더, 로고 이미지
		params.put("keys", "('"+Codes.IMAGE_TYPE_HOSPITAL_HEADER+"','"+Codes.IMAGE_TYPE_HOSPITAL_LOGO+"')");
		List<Map> imgList = SqlDao.getList(SQLNamespace.CLIENT_HOSPITAL+"getImageInKey", params);
		Iterator<Map> iter = imgList.iterator();
		while(iter.hasNext()){
			Map m = iter.next();
			if(Common.strEqual((String) m.get("S_LKEY"),Codes.IMAGE_TYPE_HOSPITAL_HEADER))
				model.addAttribute("header_img",m);
			else if(Common.strEqual((String) m.get("S_LKEY"),Codes.IMAGE_TYPE_HOSPITAL_LOGO))
				model.addAttribute("logo_img",m);
		}
		
		model.addAttribute("siteList", SqlDao.getList(SQLNamespace.CLIENT_HOSPITAL+"getSite", sid));
		
		// 중요 공지사항 리스트
		params.put("type", Codes.ELEMENT_BOARD_TYPE_IMPORTANT);
		params.put("visible", "Y");
		model.addAttribute("importantBoardList", SqlDao.getList("Hospital.Board.getAllImportantList", params));
		
		model.addAttribute("params", params);
		
		return "admin/hospital/home/home";
	}
	
	@RequestMapping(value="/introduceImgEdit.latte")
	public String introduceImgEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		// 메인 메뉴 세팅
		putMainMenuToModel(model, sid, Codes.CUSTOM_CATEGORY_MAIN_MENU_1);
		
		// 병원 소개 이미지
		params.put("sid", sid);
		params.put("key", Codes.IMAGE_TYPE_HOSPITAL_INTRO);
		model.addAttribute("introImageList", SqlDao.getList(SQLNamespace.CLIENT_HOSPITAL+"getImageByKey", params));
		
		model.addAttribute("hospitalInfo", SqlDao.getMap("Admin.Hospital.getCopyrightInfo", sid));
		
		model.addAttribute("hospital_name", sessionContext.getData("s_hospital_name"));
		model.addAttribute("params", params);
		
		return "admin/hospital/home/intro_img_edit";
	}
	
	@RequestMapping(value = "/ajaxSaveIntroduceImg.latte")
	public @ResponseBody String ajaxSaveIntroduceImg(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam Map<String, String> params) throws Exception {
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		// 변경 전 이미지 리스트
		params.put("sid", sessionContext.getData("s_sid"));
		params.put("key", Codes.IMAGE_TYPE_HOSPITAL_INTRO);
		List<Map> imgList = SqlDao.getList(SQLNamespace.CLIENT_HOSPITAL+"getImageByKey", params);
		
		// 변경 후 이미지 리스트
		String[] newList = request.getParameterValues("iid");
		
		// 기존 리스트에서 newList에 있는것과 없는 것으로 나누어 받아와
		ArrayList<Map> existList = new ArrayList<Map>();
		ArrayList<Map> nonexistList = new ArrayList<Map>();
		Common.divideOnExist(imgList, "s_iid", newList, existList, nonexistList);
		
		for(Map map:nonexistList){
			deleteImageAndDBUpdate(Config.IMAGE_PATH_ROOT + map.get("s_image_path"), null, (String) map.get("s_iid"));
		}
		
		Map searchMap = Common.createSearchMap(existList, "s_iid");
		Map<String,String> updateMap = new HashMap<String, String>();
		
		for(int i = 0; i < newList.length; i++){
			
			// 이미 있는 이미지 인덱스 업데이트
			if(searchMap.get(newList[i])!=null){
				
				updateMap.put("index", i+"");
				updateMap.put("iid", newList[i]);
				SqlDao.update("Admin.Hospital.Common.updateImageIndex", updateMap);	
			}
			else{
				// 편집한 임시 파일을 실사용경로로 옮김
				activateTempImage(newList[i], Config.PATH_HOSPITAL_IMAGE, Codes.IMAGE_TYPE_HOSPITAL_INTRO, i+"");
			}
		}
		
		b.add("result", Codes.SUCCESS_CODE);

		return b.build();
	}
	
	@RequestMapping(value="/callInfoEdit.latte")
	public String callInfoEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		// 메인 메뉴 세팅
		putMainMenuToModel(model, sid, Codes.CUSTOM_CATEGORY_MAIN_MENU_1);
		
		Map info = SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getHomeInfo", sid);
		
		// 병원의 Status Info를 가져옴
		StatusInfoSet.setFields(Codes.STATUS_INFO_SNS_ID, params);
		params.put("id", sid);
		List<Map> flexList = SqlDao.getList("Common.StatusInfo.getInfo", params);
		
		// info에 flexList의 값들을 집어넣음
		info = StatusInfoUtil.merge(flexList, info, true);
		model.addAttribute("hospitalInfo", info);
		
		model.addAttribute("params", params);
		
		return "admin/hospital/home/call_info_edit";
	}

	@RequestMapping(value="/ajaxSaveCallInfo.latte")
	public @ResponseBody String ajaxSaveCallInfo(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		StatusInfoSet.setFields(Codes.STATUS_INFO_SNS_ID, params);
		params.put("val", params.get("sns_id"));
		params.put("status", params.get("sns_id_check"));
		params.put("id", sessionContext.getData("s_sid"));
		
		int result1 = SqlDao.insert("Common.StatusInfo.insertOrUpdate", params);
		
		params.put("sid", sessionContext.getData("s_sid"));
		int result2 = SqlDao.update("Admin.Hospital.updateTelInfo", params);
		
		if(result1 > 0 && result2 > 0)
			b.add("result", Codes.SUCCESS_CODE);
		else
			b.add("result", Codes.ERROR_QUERY_EXCEPTION);
		
		return b.build();
	}
			
	@RequestMapping(value="/introInfoEdit.latte")
	public String introInfoEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		// 메인 메뉴 세팅
		putMainMenuToModel(model, sid, Codes.CUSTOM_CATEGORY_MAIN_MENU_1);
		
		Map info = SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getHomeInfo", sid);
		model.addAttribute("hospitalInfo", info);
		
		// 병원 소개 이미지
		params.put("sid", sid);
		params.put("key", Codes.IMAGE_TYPE_HOSPITAL_INTRO);
		model.addAttribute("introImageList", SqlDao.getList(SQLNamespace.CLIENT_HOSPITAL+"getImageByKey", params));
		
		params.put("idx", sid);
		model.addAttribute("staffList", SqlDao.getList("Hospital.Staff.getStaffList", params));
		
		model.addAttribute("params", params);
		
		return "admin/hospital/home/intro_info_edit";
	}
	
	@RequestMapping(value="/ajaxSaveIntroInfo.latte")
	public @ResponseBody String ajaxSaveIntroInfo(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		params.put("sid", sessionContext.getData("s_sid"));
		if(SqlDao.update("Admin.Hospital.updateIntroInfo", params)>0)
			b.add("result", Codes.SUCCESS_CODE);
		else
			b.add("result", Codes.ERROR_QUERY_EXCEPTION);
		
		return b.build();
	}
	
	@RequestMapping(value="/equipmentEdit.latte")
	public String equipmentEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		// 메인 메뉴 세팅
		putMainMenuToModel(model, sid, Codes.CUSTOM_CATEGORY_MAIN_MENU_1);
		
		Map info = SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getHomeInfo", sid);
		
		// 병원의 Status Info를 가져옴
		StatusInfoSet.setFields(Codes.STATUS_INFO_EQUIPMENT, params);
		params.put("id", sid);
		List<Map> flexList = SqlDao.getList("Common.StatusInfo.getInfo", params);
		
		// info에 flexList의 값들을 집어넣음
		info = StatusInfoUtil.merge(flexList, info, true);
		
		model.addAttribute("hospitalInfo", info);
		
		model.addAttribute("params", params);
		
		return "admin/hospital/home/equipment_edit";
	}

	@RequestMapping(value="/ajaxSaveEquipment.latte")
	public @ResponseBody String ajaxSaveEquipment(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		StatusInfoSet.setFields(Codes.STATUS_INFO_EQUIPMENT, params);
		params.put("val", params.get("equipment"));
		params.put("status", params.get("equipment_check"));
		params.put("id", sessionContext.getData("s_sid"));
		
		if(SqlDao.insert("Common.StatusInfo.insertOrUpdate", params)>0)
			b.add("result", Codes.SUCCESS_CODE);
		else
			b.add("result", Codes.ERROR_QUERY_EXCEPTION);
		
		return b.build();
	}
	
	@RequestMapping(value="/extraInfoEdit.latte")
	public String extraInfoEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		// 메인 메뉴 세팅
		putMainMenuToModel(model, sid, Codes.CUSTOM_CATEGORY_MAIN_MENU_1);
		
		Map info = SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getHomeInfo", sid);
		model.addAttribute("hospitalInfo", info);
				
		model.addAttribute("params", params);
		
		return "admin/hospital/home/extra_info_edit";
	}
	
	@RequestMapping(value="/ajaxSaveExtraInfo.latte")
	public @ResponseBody String ajaxSaveExtraInfo(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		params.put("sid", sessionContext.getData("s_sid"));
		if(SqlDao.update("Admin.Hospital.updateExtraInfo", params)>0)
			b.add("result", Codes.SUCCESS_CODE);
		else
			b.add("result", Codes.ERROR_QUERY_EXCEPTION);
		
		return b.build();
	}
	
	@RequestMapping(value="/siteInfoEdit.latte")
	public String siteInfoEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		// 메인 메뉴 세팅
		putMainMenuToModel(model, sid, Codes.CUSTOM_CATEGORY_MAIN_MENU_1);
		
		Map info = SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getHomeInfo", sid);
		model.addAttribute("hospitalInfo", info);
		
		// 병원 소개 이미지
		params.put("sid", sid);
		params.put("key", Codes.IMAGE_TYPE_HOSPITAL_INTRO);
		model.addAttribute("introImageList", SqlDao.getList(SQLNamespace.CLIENT_HOSPITAL+"getImageByKey", params));
		
		model.addAttribute("siteSelectList", SqlDao.getList("COMMON.getElementList", Codes.HOSPITAL_SITE));
		
		model.addAttribute("siteList", SqlDao.getList(SQLNamespace.CLIENT_HOSPITAL+"getSite", sid));
		
		model.addAttribute("hospitalInfo", SqlDao.getMap("Admin.Hospital.getCopyrightInfo", sid));
		
		model.addAttribute("params", params);
		
		return "admin/hospital/home/site_info_edit";
	}
	
	@RequestMapping(value="/ajaxSaveSiteInfo.latte")
	public @ResponseBody String ajaxSaveSiteInfo(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		String sid = sessionContext.getData("s_sid");
		
		// 기존 사이트 정보 전부 삭제
		int del = SqlDao.delete("Admin.Hospital.deleteSites", sid);
		
		// 추가할 배열들을 리스트로 합성
		List<Map<String, String>> list = Common.convertToMapArray(request, "type", "url");
		
		StringBuffer buf = new StringBuffer();
		
		// 리스트로 여러줄 insert 쿼리 생성
		Iterator<Map<String, String>> iter = list.iterator();
		int size = list.size();
		int index = 1;
		while(iter.hasNext()){
			Map map = iter.next();
			
			buf.append("('"+sid+"','"+index+"','"+map.get("type")+"','"+map.get("url")+"','Y')");
			if(size>index)
				buf.append(',');
			
			index++;
		}
		
		if(SqlDao.update("Admin.Hospital.insertSites", buf.toString())>0)
			b.add("result", Codes.SUCCESS_CODE);
		else
			b.add("result", Codes.ERROR_QUERY_EXCEPTION);
		
		return b.build();
	}
	
	@RequestMapping(value="/workingTimeEdit.latte")
	public String workingTimeEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		// 메인 메뉴 세팅
		putMainMenuToModel(model, sid, Codes.CUSTOM_CATEGORY_MAIN_MENU_1);
		
		model.addAttribute("hospitalInfo", SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getHomeInfo", sid));
		
		// 영업 시간 정보
		model.addAttribute("workingTimeList", SqlDao.getList(SQLNamespace.CLIENT_HOSPITAL+"getWorkingTime", sid));
		
		// copyright
		model.addAttribute("hospitalInfo", SqlDao.getMap("Admin.Hospital.getCopyrightInfo", sid));
		
		model.addAttribute("params", params);
		
		return "admin/hospital/home/working_time_edit";
	}
	
	@RequestMapping(value="/ajaxSaveWorkingTime.latte")
	public @ResponseBody String ajaxSaveWorkingTime(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		String sid = sessionContext.getData("s_sid");
		
		// 기존 시간 정보 삭제
		int del = SqlDao.delete("Admin.Hospital.deleteWorkingTime", sid);
		
		// 추가할 배열들을 리스트로 합성
		List<Map<String, String>> list = Common.convertToMapArray(request, "name", "start_time", "end_time", "comment", "alltime", "dayoff");
		
		StringBuffer buf = new StringBuffer();
		
		// 리스트로 여러줄 insert 쿼리 생성
		Iterator<Map<String, String>> iter = list.iterator();
		int size = list.size();
		int index = 1;
		
		while(iter.hasNext()){
			Map map = iter.next();
			
			buf.append("('");
			buf.append(sid);
			buf.append("','");
			buf.append(index);
			buf.append("','");
			buf.append(map.get("name"));
			buf.append("','");
			buf.append(map.get("start_time"));
			buf.append("','");
			buf.append(map.get("end_time"));
			buf.append("','");
			buf.append(map.get("alltime"));
			buf.append("','");
			buf.append(map.get("dayoff"));
			buf.append("','");
			buf.append(map.get("comment"));
			buf.append("')");
			
			if(size>index)
				buf.append(',');
			
			index++;
		}
		
		if(SqlDao.update("Admin.Hospital.insertWorkingTimes", buf.toString())>0)
			b.add("result", Codes.SUCCESS_CODE);
		else
			b.add("result", Codes.ERROR_QUERY_EXCEPTION);
		
		return b.build();
	}
	
	@RequestMapping(value="/ajaxsingleprivatetest123.latte")
	public @ResponseBody String ajaxsingleprivatetest123(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
	
		String s = params.get("p");
		String e = params.get("e");
		if(!Common.isValid(s)){s="123abc안녕";}
		else if(s.equals("1")){s="12345";}
		else if(s.equals("2")){s="abcde";}
		else if(s.equals("3")){s="안녕하세요";}
		if(!Common.isValid(e)){}
		else if(e.equals("url")){s=EncodingUtil.URLEncode(s);}
		else if(e.equals("esc")){s=EncodingUtil.escape(s);}
		return s;
	}
}
