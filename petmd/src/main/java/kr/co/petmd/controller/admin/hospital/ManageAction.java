package kr.co.petmd.controller.admin.hospital;

import java.io.File;
import java.io.IOException;
import java.sql.SQLData;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.petmd.HomeController;
import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.admin.Codes;
import kr.co.petmd.utils.admin.Config;
import kr.co.petmd.utils.admin.SQLNamespace;
import kr.co.petmd.utils.admin.SessionContext;
import kr.co.petmd.utils.common.Common;
import kr.co.petmd.utils.common.CustomizeUtil;
import kr.co.petmd.utils.common.EncodingUtil;
import kr.co.petmd.utils.common.FileUtil;
import kr.co.petmd.utils.common.JSONSimpleBuilder;
import kr.co.petmd.utils.common.JSONUtil;
import kr.co.petmd.utils.common.PageUtil;
import kr.co.petmd.utils.common.StatusInfoUtil;

import org.apache.commons.io.FilenameUtils;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;


@Controller
public class ManageAction extends AbstractAction{

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/manageHome.latte")
	public String manageHome(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("manageHome.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		// 메인 메뉴
		
		Map<String, String> info = SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getHomeInfo", sid);
		model.addAttribute("hospitalInfo", info);
		
		Map s = new HashMap<String, Object>();
		s.put("parent", "MAIN_MENU");
		s.put("id", sid);
		List<Map> mlist = SqlDao.getList("COMMON.getByParent", s);
		
		Iterator<Map> iter = mlist.iterator();
		while(iter.hasNext()){
			Map map = iter.next();
			s.put("group", map.get("s_group"));
			
			Map m1 = CustomizeUtil.putAllToMap(SqlDao.getList("COMMON.getCustomAttr", s), map, true);
			m1.put("sid", sid);
			m1.put("group", map.get("s_group"));
		}
		model.addAttribute("mainMenu", mlist);
		
		
		
		params.put("sid", sid);
		// 병원 헤더, 로고 이미지
		params.put("keys", "('"+Codes.IMAGE_TYPE_HOSPITAL_HEADER+"','"+Codes.IMAGE_TYPE_HOSPITAL_LOGO+"')");
		List<Map> imgList = SqlDao.getList(SQLNamespace.CLIENT_HOSPITAL+"getImageInKey", params);
		iter = imgList.iterator();
		while(iter.hasNext()){
			Map m = iter.next();
			if(Common.strEqual((String) m.get("S_LKEY"),Codes.IMAGE_TYPE_HOSPITAL_HEADER))
				model.addAttribute("header_img",m);
			else if(Common.strEqual((String) m.get("S_LKEY"),Codes.IMAGE_TYPE_HOSPITAL_LOGO))
				model.addAttribute("logo_img",m);
		}

		return "admin/hospital/manage/main_menu";
	}
	
	@RequestMapping(value = "/ajaxSaveManageMainInfo.latte")
	public @ResponseBody String ajaxSaveManageMainInfo(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam Map<String, String> params) throws Exception {
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		String fail_list = "";
		int error = 0;
		
		String sid = sessionContext.getData("s_sid");
		
		List l = Common.convertToMapArray(request, "cmid", "name", "status");
		
		Iterator<Map> iter = l.iterator();
		int index = 0;
		while(iter.hasNext()){
			Map<String,String> map = iter.next();
			
			map.put("idx", sid);
			map.put("index", (index+1)+"");
			index++;
			SqlDao.update("COMMON.updateCustomizeItem", map);
			
			//map.put("attr", "NAME");
			//map.put("value", map.get("name"));
			//System.out.println("!"+SqlDao.update("COMMON.updateCustomStatus", map));
			//System.out.println(""+SqlDao.insert("COMMON.insertCustomInfo", map));
		}
		
		params.put("sid", sid);
		params.put("fax", Common.getSumString(request.getParameterValues("fax"), "-"));
		SqlDao.update("Admin.Hospital.updatePresidentInfo", params);
		SqlDao.update("Admin.Hospital.updateFaxEmail", params);
		
		
		
		// 이미지 저장
		
		Map<String,String> logo_map = null;
		Map<String,String> header_map = null;
		
		params.put("sid", sid);
		// 병원 헤더, 로고 이미지
		params.put("keys", "('"+Codes.IMAGE_TYPE_HOSPITAL_HEADER+"','"+Codes.IMAGE_TYPE_HOSPITAL_LOGO+"')");
		List<Map> imgList = SqlDao.getList(SQLNamespace.CLIENT_HOSPITAL+"getImageInKey", params);
		iter = imgList.iterator();
		while(iter.hasNext()){
			Map m = iter.next();
			if(Common.strEqual((String) m.get("S_LKEY"),Codes.IMAGE_TYPE_HOSPITAL_HEADER))
				header_map=m;
			else if(Common.strEqual((String) m.get("S_LKEY"),Codes.IMAGE_TYPE_HOSPITAL_LOGO))
				logo_map=m;
		}
				
		params.put("sid", sessionContext.getData("s_sid"));
		
		// 로고 이미지 적용
		
		params.put("key", Codes.IMAGE_TYPE_HOSPITAL_LOGO);
		String logo_iid = params.get("logo_id");
		
		// 이전 이미지가 있는가
		if(logo_map != null && !logo_map.isEmpty()){
			String old_image_id = logo_map.get("s_iid");
			String old_image_path = Config.IMAGE_PATH_ROOT+logo_map.get("s_image_path");
			
			if(Common.isValid(old_image_id)){
				
				// 이전 이미지와 새 이미지가 다름
				if(!Common.isValid(logo_iid)){
					deleteImageAndDBUpdate(old_image_path, null, old_image_id);
					
				}
				else if(!Common.strEqual(logo_iid, old_image_id)){
					
					activateTempImage(logo_iid, Config.PATH_HOSPITAL_IMAGE, Codes.IMAGE_TYPE_HOSPITAL_LOGO);
					deleteImageAndDBUpdate(old_image_path, null, old_image_id);
				}
			}
			else{
				if(Common.isValid(logo_iid)){
					activateTempImage(logo_iid, Config.PATH_HOSPITAL_IMAGE, Codes.IMAGE_TYPE_HOSPITAL_LOGO);
				}
			}
		}
		// 이미지가 있음.
		else if(Common.isValid(logo_iid)){
			activateTempImage(logo_iid, Config.PATH_HOSPITAL_IMAGE, Codes.IMAGE_TYPE_HOSPITAL_LOGO);
		}
		
		// 헤더 이미지 적용
		
		params.put("key", Codes.IMAGE_TYPE_HOSPITAL_HEADER);
		String header_iid = params.get("header_id");
		
		String old_image_id = null;
		String old_image_path = null;
		
		// 이전 이미지가 있는가
		if(header_map != null && !header_map.isEmpty()){
			old_image_id = header_map.get("s_iid");
			old_image_path = Config.IMAGE_PATH_ROOT+header_map.get("s_image_path");
		}
		
		// 이전 이미지가 있음
		if(Common.isValid(old_image_id)){
			
			if(!Common.isValid(header_iid)){
				
				// 잘라내어 temp 디렉토리에 임시 저장된 이미지를 실사용 디렉토리로 이동하고 db 갱신
				deleteImageAndDBUpdate(old_image_path, null, old_image_id);
			}
			// 이전 이미지와 새 이미지가 다름
			else if(!Common.strEqual(header_iid, old_image_id)){
				
				activateTempImage(header_iid, Config.PATH_HOSPITAL_IMAGE, Codes.IMAGE_TYPE_HOSPITAL_HEADER);
				deleteImageAndDBUpdate(old_image_path, null, old_image_id);
			}
		}
		else{
			if(Common.isValid(header_iid)){
				activateTempImage(header_iid, Config.PATH_HOSPITAL_IMAGE, Codes.IMAGE_TYPE_HOSPITAL_HEADER);
			}
		}
		
		b.add("result", Codes.SUCCESS_CODE);
		
		return b.build();
	}
	
	@RequestMapping(value = "/managePoint.latte")
	public String managePoint(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("managePoint.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		model.addAttribute("hospital_name", sessionContext.getData("s_hospital_name"));
		model.addAttribute("params", params);
		
		return "admin/hospital/manage/manage_point";
	}
	
	@RequestMapping(value = "/manageVaccine.latte")
	public String manageVaccine(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("manageVaccine.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		model.addAttribute("sid", sessionContext.getData("s_sid"));
		model.addAttribute("hospital_name", sessionContext.getData("s_hospital_name"));
		model.addAttribute("params", params);
		
		return "admin/hospital/manage/manage_vaccine";
	}
	
	@RequestMapping(value = "/ajaxUserPoint.latte")
	public @ResponseBody String ajaxUserPoint(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) throws Exception {
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		if(!Common.isValid(params.get("uid"))){
			b.add("result", Codes.ERROR_MISSING_PARAMETER);
			return b.build();
		}
		
		String sid = sessionContext.getData("s_sid");
		
		params.put("row", Common.makeRownumber("hupid", sid));
		params.put("sid", sid);
		
		String sum = SqlDao.getString("Admin.Point.Hospital.getSumUserPoint", params);
		
		// 포인트 타입을 코드로 변환하고, 유효하지 않을 경우 null 로 만들어 오류 발생시킴.
		if(Common.strEqual(params.get("type"), "pay"))
			params.put("type", Codes.USER_POINT_TYPE_HOSPI_TO_USER);
		else if(Common.strEqual(params.get("type"), "return")){
			params.put("type", Codes.USER_POINT_TYPE_USER_TO_HOSPI);
			if(Common.isValid(params.get("point"))){
				params.put("point", (-Common.parseInt(params.get("point")))+"");
				if(Common.toInt(sum)+Common.parseInt(params.get("point")) < 0){
					b.add("result", Codes.ERROR_POINT_LACKED);
					b.postAdd("point", sum);
					return b.build();
				}
			}
		}
		else
			params.remove("type");
		
		// uid가 유효하지 않을 경우 null 로 만들어 오류 발생시킴.
		if(!Common.isValid(params.get("uid")))
			params.remove("uid");
		
		if(SqlDao.insert("Admin.Point.Hospital.insertUserPoint", params)>0)
			b.add("result", Codes.SUCCESS_CODE);
		else
			b.add("result", Codes.ERROR_MISSING_PARAMETER);
		
		return b.build();
	}
	
	@RequestMapping(value = "/ajaxSearchUser.latte")
	public @ResponseBody String ajaxSearchUser(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) throws Exception {
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		//String uid = params.get("uid");
		
		params.put("sid", sessionContext.getData("s_sid"));
			
		Map mem = new HashMap<String, String>();
		
		List<Map> list = SqlDao.getList("Admin.Point.Hospital.getTotalPointAndUserInfoByPhone", params);
		
		if(Common.lengthOf(list)==0){
			b.add("result", Codes.ERROR_QUERY_PROCESSED);
			return b.build();
		}
		
		Iterator<Map> iter = list.iterator();
		
		if(iter.hasNext())
			mem = iter.next();
		
		mem = EncodingUtil.URLEncode(mem, new String[]{"s_"});

		mem.put("result", Codes.SUCCESS_CODE);
		
		return JSONObject.toJSONString(mem);
	}
	
	@RequestMapping(value = "/ajaxInnerPetList.latte")
	public String ajaxInnerPetList(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) throws Exception {
		
		SessionContext sessionContext = getSessionContext();
		
		String resultPage = "admin/hospital/manage/pet_inner";
		
		if(!sessionContext.isAuth()){
			model.addAttribute("result", Codes.ERROR_UNAUTHORIZED);
			return resultPage;
		}
		
		String uid = params.get("pagingSendValue");
		
		if(!Common.isValid(uid)){
			model.addAttribute("result", Codes.ERROR_MISSING_PARAMETER);
			return resultPage;
		}
		
		// 펫리스트 가져옴
		params.put("totalCount", SqlDao.getString("Client.MyPage.getPetCntByUID", uid));
		//PageUtil.getInstance().pageSetting(params, 4);
		params.put("uid", uid);
		List<Map> petList = SqlDao.getList("Client.MyPage.getPetInfoByUID", params);
		
		model.addAttribute("params", params);
		model.addAttribute("petList", petList);
		model.addAttribute("result", Codes.SUCCESS_CODE);
		
		return resultPage;
	}
	
	@RequestMapping(value = "/pointHistory.latte")
	public String pointHistory(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("pointHistory.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		params.put("sid", sid);
		
		Map<String, String> map = SqlDao.getMap("Admin.Point.Hospital.getTotalUserPoint", params);
		params.put("totalCount", Common.toString(map.get("cnt")));
		PageUtil.getInstance().pageSetting(params, 10);
		List list = SqlDao.getList("Admin.Point.Hospital.getUserPoint", params);
		model.addAttribute("userList", list);
		
		model.addAttribute("hospital_name", sessionContext.getData("s_hospital_name"));
		model.addAttribute("params", params);

		if(Common.strEqual(params.get("pageNumber"),"1"))
				return "admin/hospital/manage/point_history";
		else
			return "admin/hospital/manage/user_inner"; 
	}
	
	
	
	@RequestMapping(value = "/manageStatistics.latte")
	public String manageStatistics(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("manageStatistics.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		return "admin/hospital/manage/statistics";
	}
	
	@RequestMapping(value = "/passwordEdit.latte")
	public String passwordEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("passwordEdit.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		model.addAttribute("hospital_name", sessionContext.getData("s_hospital_name"));
		
		return "admin/hospital/manage/password_edit";
	}
	
	@RequestMapping(value = "/ajaxPwChange.latte")
	public @ResponseBody String ajaxPwChange(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("ajaxPwChange.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		String sid = sessionContext.getData("s_sid");
		// 새 암호의 상태를 확인
		if(!Common.isValid(params.get("new_pw")) || !Common.strEqual(params.get("new_pw"), params.get("new_re_pw"))){
			b.add("result", Codes.ERROR_INVALID_PARAMETER);
			return b.build();
		}
		
		// 이전 암호 확인
		params.put("sid", sid);
		params.put("pw", Common.isValid(params.get("old_pw"))?params.get("old_pw").substring(1):"");
		Map<String, String> map = SqlDao.getMap("Admin.Hospital.Common.getInfoWithPw", params);
		if(map==null || map.isEmpty()){
			b.add("result", Codes.ERROR_QUERY_PROCESSED);
			return b.build();
		}
		
		// 암호 변경
		params.put("pw", Common.isValid(params.get("new_pw"))?params.get("new_pw").substring(1):"");
		if(SqlDao.update("Admin.Hospital.Common.updatePassword", params)>0)
			b.add("result", Codes.SUCCESS_CODE);
		else
			b.add("result", Codes.ERROR_QUERY_EXCEPTION);
		
		return b.build();
	}
	
	@RequestMapping(value = "/manageVaccination.latte")
	public String manageVaccination(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("manageVaccination.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		params.put("sid", sid);
		
		Map<String, Map> m = new HashMap<String, Map>();
		;
		//params.put("group_type", Codes.VACCINATION_DIROFILARIA);
		params.put("group_type", "BASIC_DOG");
		m.put("BASIC_DOG", Common.splitListGroupBy(SqlDao.getList("Admin.Hospital.Vaccine.getVaccineList", params), "t"));
		params.put("group_type", "BASIC_CAT");
		m.put("BASIC_CAT", Common.splitListGroupBy(SqlDao.getList("Admin.Hospital.Vaccine.getVaccineList", params), "t"));
		
		model.addAttribute("m", m);
		
		return "admin/hospital/manage/vaccination_setting";
	}
	
	@RequestMapping(value = "/ajaxSaveVaccination.latte")
	public @ResponseBody String ajaxSaveVaccination(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		String sid = sessionContext.getData("s_sid");
		params.put("sid", sid);
		
		List list = null;
		
		params.put("group_type", "BASIC_DOG");
		list = SqlDao.getList("Admin.Hospital.Vaccine.getHospitalVaccine", params);
		
		int result_dog = 0;
		
		if(Common.isValid(list)){
			
			params.put("term", ""+Common.toInt(params.get("dog_term")));
			params.put("len", ""+Common.toInt(params.get("dog_len")));
			
			result_dog = SqlDao.update("Admin.Hospital.Vaccine.updateVaccineDetail", params);
		}
		else{
			
			params.put("vcd_row", Common.makeRownumber("vcd", sid));
			params.put("vcid", "");
			params.put("index", "1");
			params.put("term", ""+Common.toInt(params.get("dog_term")));
			params.put("term_type", "WEEK");
			params.put("type", "BASIC");
			params.put("length", ""+Common.toInt(params.get("dog_len")));
			params.put("species", Codes.PET_DOG_SPECIES);
			
			result_dog = SqlDao.insert("Admin.Hospital.Vaccine.insertVaccineDetail", params);
		}
		
		params.put("group_type", "BASIC_CAT");
		list = SqlDao.getList("Admin.Hospital.Vaccine.getHospitalVaccine", params);
		
		int result_cat = 0;
		
		if(Common.isValid(list)){
			
			params.put("term", ""+Common.toInt(params.get("cat_term")));
			params.put("len", ""+Common.toInt(params.get("cat_len")));
			
			result_cat = SqlDao.update("Admin.Hospital.Vaccine.updateVaccineDetail", params);
		}
		else{
			
			params.put("vcd_row", Common.makeRownumber("vcd", sid));
			params.put("vcid", "");
			params.put("index", "1");
			params.put("term", ""+Common.toInt(params.get("cat_term")));
			params.put("term_type", "WEEK");
			params.put("type", "BASIC");
			params.put("length", ""+Common.toInt(params.get("cat_len")));
			params.put("species", Codes.PET_CAT_SPECIES);
			
			result_cat = SqlDao.insert("Admin.Hospital.Vaccine.insertVaccineDetail", params);
		}
		
//		#{vcd_row},
//		#{vcid},
//		${index},
//		${term},
//		#{term_type},
//		#{type},
//		#{sid},
//		#{group_type},
//		${length},
//		#{species}
		
		return b.add("result", Codes.SUCCESS_CODE).build();
	}
}

