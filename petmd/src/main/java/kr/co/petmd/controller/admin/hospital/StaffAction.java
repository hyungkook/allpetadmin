package kr.co.petmd.controller.admin.hospital;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.admin.Codes;
import kr.co.petmd.utils.admin.Config;
import kr.co.petmd.utils.admin.SQLNamespace;
import kr.co.petmd.utils.admin.SessionContext;
import kr.co.petmd.utils.common.Common;
import kr.co.petmd.utils.common.FileUtil;
import kr.co.petmd.utils.common.JSONSimpleBuilder;
import kr.co.petmd.utils.common.PageUtil;
import kr.co.petmd.utils.common.StatusInfoSet;
import kr.co.petmd.utils.common.StatusInfoUtil;

import org.apache.commons.io.FilenameUtils;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;


@Controller
public class StaffAction extends AbstractAction {

	@RequestMapping(value="/staffHome.latte")
	public String staffHome(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		// 메인 메뉴
		putMainMenuToModel(model, sid, Codes.CUSTOM_CATEGORY_MAIN_MENU_2);
		
		// 최소한의 병원 정보 (병원명 출력 등)
		model.addAttribute("hospitalInfo", SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getSimpleHospitalInfo", sid));
		
		// 스태프 카테고리 리스트
		Map<String, String> s = new HashMap<String, String>();
		s.put("id", sid);
		s.put("parent", Codes.CUSTOM_PARENT_STAFF);
		s.put("status", "Y");
		List<Map> staffMenuList = SqlDao.getList("COMMON.getByParent", s);
		model.addAttribute("staffMenu", staffMenuList);
		
		String parent = "";
		
		Map<String, String> categoryInfo = null;

		// request로 요청한 스태프 카테고리 id(cmid)
		if(Common.isValid(params.get("cmid")))
			parent = params.get("cmid");
		
		// 위에서 cmid가 없으면 첫번째 카테고리 id를 가져옴
		if(!Common.isValid(parent)){
			Iterator<Map> iter = staffMenuList.iterator();
			if(iter.hasNext()){
				
				Map map = iter.next();
				parent =  (String) map.get("s_cmid");
			}
		}
		
		// 카테고리 정보를 가져옴
		if(Common.isValid(parent))
			categoryInfo = SqlDao.getMap("COMMON.getCustomItem", parent);
		model.addAttribute("categoryInfo", categoryInfo);
		
		// 스태프 정보 가져올 파라미터 세팅
		Map<String, String> staffCntParam = new HashMap<String, String>();
		params.put("idx", sid);
		params.put("category", parent);
		params.put("state", "Y");
		
		params.put("totalCount", SqlDao.getString("Hospital.Staff.getStaffListCnt", params));
		PageUtil.getInstance().pageSetting(params, 5);
		
		// 스태프 정보 가져옴
		List<Map> staffInfo = SqlDao.getList("Hospital.Staff.getStaffList", params);
		model.addAttribute("staffList", staffInfo);
		
		//copyright
		model.addAttribute("hospitalInfo", SqlDao.getMap("Admin.Hospital.getCopyrightInfo", sid));
		
		model.addAttribute("params", params);
		
		return "admin/hospital/staff/home";
	}
	

	@RequestMapping(value="/staffCategoryEdit.latte")
	public String staffCategoryEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		// 메인 메뉴
		putMainMenuToModel(model, sid, Codes.CUSTOM_CATEGORY_MAIN_MENU_2);
		
		// 최소한의 병원 정보 (병원명 출력 등)
		model.addAttribute("hospitalInfo", SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getSimpleHospitalInfo", sid));
		
		// 스태프 카테고리 리스트
		Map<String, String> s = new HashMap<String, String>();
		s.put("id", sid);
		s.put("parent", Codes.CUSTOM_PARENT_STAFF);
		s.put("status", "Y");
		// 소식 게시판의 하위 게시판 리스트를 가져옴
		List<Map> staffMenuList = SqlDao.getList("COMMON.getByParent", s);
		
		// 스태프 메뉴 하위 모든 스태프 카테고리 리스트 생성
		List pl = new ArrayList<String>();
		Iterator<Map> iter = staffMenuList.iterator();
		while(iter.hasNext()){
			Map m = iter.next();
			pl.add(m.get("s_cmid"));
		}
		// 위의 리스트로 스태프 메뉴 하위에 등록된 모든 스태프 수 구함
		List l= SqlDao.getList("Admin.Hospital.Staff.getSubContentsCnt", pl);
		// 리스트를 그룹을 기준으로 나눔
		Map<String,List> listMap = Common.splitListGroupBy(l, "s_cmid");
		iter = staffMenuList.iterator();
		while(iter.hasNext()){
			Map m = iter.next();
			// 각 스태프 카테고리 정보에 스태프 수를 할당.
			List list = listMap.get(m.get("s_cmid"));
			if(list != null && !list.isEmpty())
				m.put("staff_cnt", ((Map)list.get(0)).get("staff_cnt"));
		}

		model.addAttribute("staffMenu", staffMenuList);
		
		// copyright
		model.addAttribute("hospitalInfo", SqlDao.getMap("Admin.Hospital.getCopyrightInfo", sid));
		
		return "admin/hospital/staff/category_edit";
	}
	
	@RequestMapping(value="/ajaxSaveStaffCategory.latte")
	public @ResponseBody String ajaxSaveStaffCategory(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		String sid = sessionContext.getData("s_sid");
		
		boolean existError = false;
		
		// 스태프 카테고리 리스트
		
		Map<String, String> s = new HashMap<String, String>();
		s.put("id", sid);
		s.put("parent", Codes.CUSTOM_PARENT_STAFF);
		s.put("status", "Y");
		// 소식 게시판의 하위 게시판 리스트를 가져옴
		List<Map> staffMenuList = SqlDao.getList("COMMON.getByParent", s);
		
		Map<String, Map> searchMap = Common.createSearchMap(staffMenuList, "s_cmid");
		
		// 스태프 카테고리 리스트
		// request로 전달된 리스트와 기존 리스트를 비교하여 있으면 업데이트 없으면 새로 삽입
		ArrayList<Map<String, String>> newList = Common.convertToMapArray(request, "cmid", "name");
		for(int i = 0; i < newList.size(); i++){
			@SuppressWarnings("unchecked")
			Map<String, String> map = searchMap.get(newList.get(i).get("cmid"));
			if(map!=null){
				//update
				map = newList.get(i);
				map.put("index", i+"");
				map.put("val", map.get("_name"));
				System.out.println("update : "+map);
				if(SqlDao.update("COMMON.updateCustomizeItem", map) <= 0)
//					if(SqlDao.update("COMMON.updateCustomizeItem", map) <= 0)
					existError = true;
				// 업데이트 후 search맵에서 삭제
				searchMap.remove(newList.get(i).get("cmid"));
			}
			else{
				//insert
				map = newList.get(i);
				map.put("cmid", Common.makeRownumber("cmid", System.currentTimeMillis()+""));
				map.put("idx", sid);
				map.put("parent", Codes.CUSTOM_PARENT_STAFF);
				map.put("index", i+"");
				map.put("status", "Y");
				map.put("visible", "Y");
				map.put("val", map.get("_name"));
				map.put("lv", "1");
				
				System.out.println("insert : "+map);
				if(SqlDao.update("COMMON.insertCustomizeItem", map) <= 0)
					existError = true;
			}
		}
		
		// 기존 리스트에서 업데이트 되지 않고 남은 것들(위에서 업데이트 후 search맵에서 삭제됨)
		// 제거 (status = N)
		Set<String> set = searchMap.keySet();
		
		StringBuffer sb = new StringBuffer();
		sb.append("('");
		Iterator<String> iter = set.iterator();
		while(iter.hasNext()){
			sb.append(iter.next()+"','");
		}
		int sblen = sb.length();
		if(sblen > 2){
			sb.delete(sblen-2, sblen);
			sb.append(")");
			
			System.out.println("delete : "+sb.toString());
			if(SqlDao.update("COMMON.removeCustomItems", sb.toString()) <= 0)
				existError = true;
		}
		
		if(existError)
			b.add("result", Codes.ERROR_QUERY_EXCEPTION);
		else
			b.add("result", Codes.SUCCESS_CODE);
		
		return b.build();
	}

	@RequestMapping(value="/staffEdit.latte")
	public String staffEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		// 메인 메뉴
		putMainMenuToModel(model, sid, Codes.CUSTOM_CATEGORY_MAIN_MENU_2);
		
		// 최소한의 병원 정보 (병원명 출력 등)
		model.addAttribute("hospitalInfo", SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getSimpleHospitalInfo", sid));
		
		// 스태프 카테고리 리스트
		Map<String, String> s = new HashMap<String, String>();
		s.put("id", sid);
		s.put("parent", Codes.CUSTOM_PARENT_STAFF);
		s.put("status", "Y");
		List<Map> staffMenuList = SqlDao.getList("COMMON.getByParent", s);
		model.addAttribute("staffMenu", staffMenuList);
		
		String stid = params.get("stid");
		
		if(Common.isValid(stid)){
			
			// 스태프 정보 가져옴
			Map<String, String> staffInfo = SqlDao.getMap("Hospital.Staff.getStaffInfo", stid);
			
			if(Common.strEqual("Y", staffInfo.get("s_state"))){
				model.addAttribute("staffInfo", staffInfo);
				
				params.put("id", stid);
				params.put("group", Codes.STATUS_INFO_GROUP_STAFF);
				List l = SqlDao.getList("Common.StatusInfo.getInfo", params);
				StatusInfoUtil.merge(l, staffInfo, true);
				model.addAttribute("status", l);
				
				// 스태프 이력사항, 학술활동, 저서 정보를 가져옴
				if(staffInfo != null){
					Map<String, String> pparam = new HashMap<String, String>();
					pparam.put("stid", staffInfo.get("s_stid"));
					pparam.put("type", Codes.STAFF_PAST_HISTORY);
					model.addAttribute("staffHistory", SqlDao.getList("Hospital.Staff.getStaffPastList", pparam));
					pparam.put("type", Codes.STAFF_PAST_CAREER);
					model.addAttribute("staffCareer", SqlDao.getList("Hospital.Staff.getStaffPastList", pparam));
					pparam.put("type", Codes.STAFF_PAST_BOOKS);
					model.addAttribute("staffBooks", SqlDao.getList("Hospital.Staff.getStaffPastList", pparam));
				}
			}
		}
		
		// copyright
		model.addAttribute("hospitalInfo", SqlDao.getMap("Admin.Hospital.getCopyrightInfo", sid));
		
		model.addAttribute("params", params);
		
		return "admin/hospital/staff/reg";
	}
	
	@RequestMapping(value="/ajaxSaveStaffInfo.latte")
	public @ResponseBody String ajaxSaveStaffInfo(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		String old_image_id = "";
		String old_image_path ="";
		
		// 스탭 id가 없을 경우 새로 생성
		String stid = params.get("stid");
		if(Common.isValid(stid)){
			// 히스토리,학술정보,저서 정보 삭제
			SqlDao.delete("Admin.Hospital.Staff.deleteAllPastInfo", stid);
			@SuppressWarnings("rawtypes")
			Map map = SqlDao.getMap("Hospital.Staff.getStaffInfo", stid);
			if(map != null){
				old_image_id = (String) map.get("s_iid");
				old_image_path = Config.IMAGE_PATH_ROOT+(String) map.get("image_path");
			}
		}
		else{
			
			stid = Common.makeRownumber("stid", System.currentTimeMillis()*12+"");
		}
		
		String iid = params.get("iid");
		
		// 이전 이미지와 새 이미지가 다름
		if(!Common.strEqual(iid, old_image_id)){
			
			// 잘라내어 temp 디렉토리에 임시 저장된 이미지를 실사용 디렉토리로 이동하고 db 갱신
			if(Common.isValid(iid)){
				
				activateTempImage(iid, Config.PATH_STAFF_IMAGE, Codes.IMAGE_TYPE_STAFF);
			}
			
			// 이전 이미지가 있었을 경우 제거
			if(Common.isValid(old_image_id)){
				
				deleteImageAndDBUpdate(old_image_path, null, old_image_id);
			}
		}
		
		// 스탭 정보 insert or update
		params.put("sid", sessionContext.getData("s_sid"));
		params.put("stid", stid);
		SqlDao.insert("Admin.Hospital.Staff.insertInfo", params);
		
		String s = "";
		// 진료일정 출력여부 저장
		StatusInfoSet.setFields(Codes.STATUS_INFO_TIMETABLE_STATUS, params);
		s = params.get("timetable_status");
		s = Common.isValid(s)?s:"N";
		params.put("val", s);
		params.put("status", s);
		params.put("id", stid);
		SqlDao.insert("Common.StatusInfo.insertOrUpdate", params);
		
		// 저서 출력여부 저장
		StatusInfoSet.setFields(Codes.STATUS_INFO_BOOKS_STATUS, params);
		s = params.get("books_status");
		s = Common.isValid(s)?s:"N";
		params.put("val", s);
		params.put("status", s);
		params.put("id", stid);
		SqlDao.insert("Common.StatusInfo.insertOrUpdate", params);
		
		// 학술활동 출력여부 저장
		StatusInfoSet.setFields(Codes.STATUS_INFO_CAREER_STATUS, params);
		s = params.get("career_status");
		s = Common.isValid(s)?s:"N";
		params.put("val", s);
		params.put("status", s);
		params.put("id", stid);
		SqlDao.insert("Common.StatusInfo.insertOrUpdate", params);
		
		// 이력사항 출력여부 저장
		StatusInfoSet.setFields(Codes.STATUS_INFO_HISTORY_STATUS, params);
		s = params.get("history_status");
		s = Common.isValid(s)?s:"N";
		params.put("val", s);
		params.put("status", s);
		params.put("id", stid);
		SqlDao.insert("Common.StatusInfo.insertOrUpdate", params);
		
		// 이력사항 학술활동 저서

		// 파라미터를 가져옴
		ArrayList<Map<String, String>> pastList = Common.convertToMapArray(request, "type", "start_date", "end_date", "desc");
		int pastListSize = Common.lengthOf(pastList);
		StringBuffer sb = new StringBuffer();
		
		Map<String, Integer> typeIndexMap = new HashMap<String, Integer>();
		// insert 쿼리 문자열 생성
		for(int i = 0; i < pastListSize; i++){
			
			Map<String, String> map = pastList.get(i);
			String type = map.get("type");
			
			int index = 1;
			if(typeIndexMap.get(type)==null)
				typeIndexMap.put(type, 2);
			else{
				index = typeIndexMap.get(type);
				typeIndexMap.put(type, index+1);
			}
			
			String start_date = map.get("start_date");
			if(Common.isValid(start_date) && start_date.length()==4)
				start_date += "-01-01";
			else
				start_date = null;
			
			String end_date = map.get("end_date");
			if(Common.isValid(end_date) && end_date.length()==4)
				end_date += "-01-01";
			else
				end_date = null;
			
			sb.append("('");
			sb.append(stid);
			sb.append("','");
			sb.append(type);
			sb.append("',");
			sb.append(index+"");
			sb.append(",");
			sb.append(start_date==null?"NULL":"'"+start_date+"'");
			sb.append(",");
			sb.append(end_date==null?"NULL":"'"+end_date+"'");
			sb.append(",'");
			sb.append(Common.isValid(map.get("desc"))?map.get("desc").replaceAll("\'", "\\\\'"):"");
			sb.append("')");
			
			if(i < pastListSize-1)
				sb.append(",");
		}
		
		// 이력사항 학술활동 저서 insert
		if(pastListSize > 0)
			SqlDao.insert("Admin.Hospital.Staff.insertPastInfoes", sb.toString());
		
		b.add("result", Codes.SUCCESS_CODE);
		
		return b.build();
	}
	
	@RequestMapping(value="/ajaxRemoveStaffInfo.latte")
	public @ResponseBody String ajaxRemoveStaffInfo(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		SqlDao.update("Admin.Hospital.Staff.removeInfo", params.get("stid"));
		
		b.add("result", Codes.SUCCESS_CODE);
		return b.build();
	}
	
	@RequestMapping(value = "/ajaxStaffSwitching.latte")
	public String ajaxStaffSwitching(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam Map<String, String> params) throws Exception {
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth()){
			
			params.put("result", Codes.ERROR_UNAUTHORIZED);
		}
		else{
			params.put("state", "Y");
		
			Map<String, String> map = null;
			// 앞의 스태프
			if(Common.strEqual(params.get("type"), "previous")){
				map = SqlDao.getMap("Admin.Hospital.Staff.getPreviousStaff", params);
				
			}
			// 뒤의 스태프 
			else if(Common.strEqual(params.get("type"), "next")){
				map = SqlDao.getMap("Admin.Hospital.Staff.getNextStaff", params);
			}
			
			if(map!=null){
				map.put("type", params.get("type"));
				Map<String, String> switchingMap = new HashMap<String, String>();
				switchingMap.put("frontId", params.get("stid"));
				switchingMap.put("backId", map.get("s_stid"));
				
				// 인덱스 교환
				SqlDao.update("Admin.Hospital.Staff.indexSwitching", switchingMap);
				
				params.put("result", Codes.SUCCESS_CODE);
			}
			else{
				
				params.put("result", Codes.ERROR_QUERY_PROCESSED);
			}
			
			model.addAttribute("staffInfo", map);
		}
		
		model.addAttribute("params", params);
		
		return "admin/hospital/staff/list_item";
	}
}
