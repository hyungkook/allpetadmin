package kr.co.petmd.controller.admin.hospital;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.petmd.HomeController;
import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.admin.Codes;
import kr.co.petmd.utils.admin.SQLNamespace;
import kr.co.petmd.utils.admin.SessionContext;
import kr.co.petmd.utils.common.Common;
import kr.co.petmd.utils.common.JSONSimpleBuilder;
import kr.co.petmd.utils.common.LocationUtil;
import kr.co.petmd.utils.common.StatusInfoSet;
import kr.co.petmd.utils.common.StatusInfoUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
public class MapAction extends AbstractAction{

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@RequestMapping(value = "/mapHome.latte")
	public String mapHome(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("mapHome.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		// 메인 메뉴
		putMainMenuToModel(model, sid, Codes.CUSTOM_CATEGORY_MAIN_MENU_5);
		model.addAttribute("hospitalInfo", SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getSimpleHospitalInfo", sid));
		
		Map<String, String> info = SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getAddressInfo", sid);
		
		params.put("id", sid);
		params.put("group", Codes.STATUS_INFO_GROUP_HOSPITAL);
		params.put("lcode", Codes.STATUS_INFO_LCODE_ADDRESS);
		List<Map> infoList = SqlDao.getList("Common.StatusInfo.getInfo", params);
		
		// info에 infoList의 값들을 집어넣음
		model.addAttribute("hospitalInfo", StatusInfoUtil.merge(infoList, info, false));

		//return "admin/hospital/map/home";
		
		// 자세히보기 detail 값이 파라미터로 넘어왔을 경우 파라미터를 붙인 jsp 호출
		return "admin/hospital/map/home"+(Common.isValid(params.get("p"))?"_"+params.get("p"):"");
	}
	
	@RequestMapping(value = "/addressInfoEdit.latte")
	public String addressInfoEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("addressInfoEdit.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte?rePage=mapHome.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		// 메인 메뉴
		putMainMenuToModel(model, sid, Codes.CUSTOM_CATEGORY_MAIN_MENU_5);
		model.addAttribute("hospitalInfo", SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getSimpleHospitalInfo", sid));
		
		Map<String, String> info = SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getAddressInfo", sid);
		
		params.put("id", sid);
		params.put("group", Codes.STATUS_INFO_GROUP_HOSPITAL);
		params.put("lcode", Codes.STATUS_INFO_LCODE_ADDRESS);
		List<Map> infoList = SqlDao.getList("Common.StatusInfo.getInfo", params);
		
		// info에 infoList의 값들을 집어넣음
		model.addAttribute("addressInfo", StatusInfoUtil.merge(infoList, info, true));

		return "admin/hospital/map/address_edit";
	}
	
	@RequestMapping(value = "/ajaxSaveAddressInfo.latte")
	public @ResponseBody String ajaxSaveAddressInfo(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam Map<String, String> params) throws Exception {
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		String fail_list = "";
		int error = 0;
		
		String sid = sessionContext.getData("s_sid");
		params.put("id", sid);
		params.put("sid", sid);
		
		// 자가용 정보
		StatusInfoSet.setFields(Codes.STATUS_INFO_HOSPITAL_PATH_CAR, params);
		params.put("val", params.get("car"));
		params.put("status", params.get("car_check"));
		
		if(SqlDao.insert("Common.StatusInfo.insertOrUpdate", params)<=0){
			fail_list += (Common.isValid(fail_list)?", ":"")+"자가용 정보 입력 실패";
			error++;
		}
		
		// 버스 정보
		StatusInfoSet.setFields(Codes.STATUS_INFO_HOSPITAL_PATH_BUS, params);
		params.put("val", params.get("bus"));
		params.put("status", params.get("bus_check"));
		
		if(SqlDao.insert("Common.StatusInfo.insertOrUpdate", params)<=0){
			fail_list += (Common.isValid(fail_list)?", ":"")+"버스 정보 입력 실패";
			error++;
		}
		
		// 지하철 정보
		StatusInfoSet.setFields(Codes.STATUS_INFO_HOSPITAL_PATH_SUBWAY, params);
		params.put("val", params.get("subway"));
		params.put("status", params.get("subway_check"));
		
		if(SqlDao.insert("Common.StatusInfo.insertOrUpdate", params)<=0){
			fail_list += (Common.isValid(fail_list)?", ":"")+"지하철 정보 입력 실패";
			error++;
		}
		
		// 위도 경도 값을 받아옴
		params = LocationUtil.getLocation(params, "old_addr_sido", "old_addr_sigungu", "old_addr_dong", "old_addr_etc");
		
		if(SqlDao.update("Admin.Hospital.updateAddressInfo", params)<=0)
			error++;
		
		b.add("error_cnt", error+"");
		
		if(error > 0)
			b.add("result", Codes.ERROR_QUERY_EXCEPTION);
		else
			b.add("result", Codes.SUCCESS_CODE);
		
		return b.build();
	}
}
