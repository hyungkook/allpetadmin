package kr.co.petmd.controller.admin.hospital;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sound.midi.Sequence;

import kr.co.petmd.HomeController;
import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.admin.Codes;
import kr.co.petmd.utils.admin.Config;
import kr.co.petmd.utils.admin.SQLNamespace;
import kr.co.petmd.utils.admin.SessionContext;
import kr.co.petmd.utils.common.Common;
import kr.co.petmd.utils.common.CustomizeUtil;
import kr.co.petmd.utils.common.FileUtil;
import kr.co.petmd.utils.common.ImageCropUtil;
import kr.co.petmd.utils.common.ImageResizer;
import kr.co.petmd.utils.common.ImageUtil;
import kr.co.petmd.utils.common.JSONSimpleBuilder;
import kr.co.petmd.utils.common.SequenceUtil;
import kr.co.petmd.utils.common.StatusInfoSet;

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
public class ServiceAction extends AbstractAction{

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/serviceHome.latte")
	public String serviceHome(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("serviceHome.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		// 메인 메뉴를 세팅하고 서비스(3번) 메뉴 정보를 가져옴
		putMainMenuToModel(model, sid, Codes.CUSTOM_CATEGORY_MAIN_MENU_3);
		Map<String, String> menu = getMainMenuInfo(model, sid, Codes.CUSTOM_CATEGORY_MAIN_MENU_3);
		
		// 선택한 메뉴 id
		// ([0] = 부모, [1] = 자신) 의 id
		String[] cmids = request.getParameterValues("cmid");
		
		// 메뉴 리스트를 가져옴
		Map<String, String> s = new HashMap<String, String>();
		s.put("id", sid);
		s.put("parent", menu.get("s_cmid"));
		s.put("status", "Y");
		List<Map> boardMenuList = SqlDao.getList("COMMON.getByParent", s);
		//List<Map> boardMenuList = SqlDao.getList("Hospital.Board.getServiceMenu", sid);

		// 서브메뉴(2 depth) 리스트를 가져오기 시작
		
		if(boardMenuList != null && !boardMenuList.isEmpty()){
			// 1 depth 메뉴리스트에서 첫번째 것을 가져옴
			Map<String, String> item = boardMenuList.iterator().next();
			
			Map<String, String> param = new HashMap<String, String>();
			param.put("id", sid);
			param.put("status", "Y");
			// 부모(1depth)가 어떤것인지 할당
			if(cmids!=null && cmids.length > 0)
				param.put("parent", cmids[0]);
			else{
				param.put("parent", (String) item.get("s_cmid"));
			}
			List<Map> firstBoardList = SqlDao.getList("COMMON.getByParent", param);
			
			// 서브메뉴 리스트를 가져오기 끝
			
			// 메뉴, 서브메뉴 추가
			model.addAttribute("menuList", boardMenuList);
			model.addAttribute("subMenuList", firstBoardList);
			
			String leaf = null;
			
			// 현재 선택된 메뉴의 정보를 가져옴. 선택된 거 없으면 첫번째 것
			if(cmids!=null && cmids.length > 0){
				leaf = cmids[0];
			}
			else{
				leaf = (String) item.get("s_cmid");
			}
			model.addAttribute("boardInfo", SqlDao.getMap("COMMON.getCustomItem", leaf));
			
			// 서브메뉴가 있을 경우
			if(firstBoardList!=null && !firstBoardList.isEmpty()){
				Map<String, String> subItem = firstBoardList.iterator().next();
				
				// 현재 선택된 서브메뉴의 정보를 가져옴. 선택된 거 없으면 첫번째 것
				if(cmids!=null && cmids.length == 2){
					leaf = cmids[1];
				}
				else{
					leaf = (String) subItem.get("s_cmid");
				}
				model.addAttribute("subBoardInfo", SqlDao.getMap("COMMON.getCustomItem", leaf));
			}
			
			Map<String, String> bparam = new HashMap<String, String>();
			bparam.put("cmid", leaf);
			List<Map> list = SqlDao.getList("Hospital.Board.getServiceBoardList", bparam);
			
			if(Common.isValid(list)){
				HashMap<String, Object> subinfo = new HashMap<String, Object>();
				subinfo.put("list", list);
				subinfo.put("type", Codes.ELEMENT_BOARD_CONTENTS_TYPE_VIDEO_LINK);
				List l = SqlDao.getList("Hospital.Board.getContentsInBid", subinfo);
				
				if(Common.isValid(l)){
					Map videoListMap = Common.splitListGroupBy(l, "s_bid");
					
					Iterator<Map> iter2 = list.iterator();
					while(iter2.hasNext()){
						Map m = iter2.next();
						m.put("videoList", videoListMap.get(m.get("s_bid")));
					}
				}
			}
			
			model.addAttribute("boardList",list);
		}
		
		model.addAttribute("hospitalInfo", SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getSimpleHospitalInfo", sid));
		
		model.addAttribute("params", params);
		
		return "admin/hospital/service/home";
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/serviceMenuEdit.latte")
	public String serviceMenuEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("serviceMenuEdit.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		// 메인 메뉴
//		Map s = new HashMap<String, Object>();
//		s.put("parent", "MAIN_MENU");
//		s.put("id", sid);
//		model.addAttribute("mainMenu", SqlDao.getList("COMMON.getByParent", s));
		putMainMenuToModel(model, sid, "MAIN_MENU_3");
		Map<String, String> menu = getMainMenuInfo(model, sid, "MAIN_MENU_3");
		
		model.addAttribute("hospitalInfo", SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getSimpleHospitalInfo", sid));
		
		String cmid = params.get("cmid");
		
		Map<String, String> s = new HashMap<String, String>();
		s.put("id", sid);
		s.put("status", "Y");
		
		// 2차 메뉴
		if(Common.isValid(cmid))
			s.put("parent", cmid);
		// 1차 메뉴
		else
			s.put("parent", menu.get("s_cmid"));
		
		model.addAttribute("parent", s.get("parent"));
		
		
		List<Map> boardMenuList = SqlDao.getList("COMMON.getByParent", s);
		
		
		// 하위 메뉴 리스트 생성
		List pl = new ArrayList<String>();
		Iterator<Map> iter = boardMenuList.iterator();
		while(iter.hasNext()){
			Map m = iter.next();
			pl.add(m.get("s_cmid"));
		}
		// 위의 리스트로 메뉴에 등록된 모든 하위 메뉴와 등록된 글 수를 구함
		List l= SqlDao.getList("Admin.Hospital.Board.getSubContentsCnt", pl);
		// 리스트를 그룹을 기준으로 나눔
		Map<String,List> listMap = Common.splitListGroupBy(l, "s_cmid");
		
		iter = boardMenuList.iterator();
		while(iter.hasNext()){
			Map m = iter.next();
			// 각 메뉴 정보에 하위 메뉴, 게시글 수를 할당.
			List list = listMap.get(m.get("s_cmid"));
			if(list != null && !list.isEmpty()){
				Map lm = (Map)list.get(0);
				if(lm.get("content_cnt")!=null)
					m.put("content_cnt", lm.get("content_cnt"));
				else
					m.put("content_cnt", "0");
				if(lm.get("sub_cnt")!=null)
					m.put("sub_cnt", lm.get("sub_cnt"));
				else
					m.put("sub_cnt", "0");
			}
			else{
				m.put("content_cnt", "0");
				m.put("sub_cnt", "0");
			}
		}
		
		model.addAttribute("menuList", boardMenuList);

		model.addAttribute("params", params);
		
		return "admin/hospital/service/menu_edit";
	}
	
	@RequestMapping(value = "/ajaxServiceMenuEdit.latte")
	public @ResponseBody String ajaxServiceMenuEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("serviceMenuEdit.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		String sid = sessionContext.getData("s_sid");
		
		// 서브메뉴 리스트를 가져옴
		Map<String, String> param = new HashMap<String, String>();
		param.put("id", sid);
		param.put("parent", params.get("parent"));

		List<Map> firstBoardList = SqlDao.getList("COMMON.getChildCustom", param);
		
		// 원본에는 있지만 파라미터에는 없는 cmid리스트를 추출(삭제 예정 리스트)
		String[] delIds = Common.nonexistArray(firstBoardList, "s_cmid", request.getParameterValues("cmid"));
		
		int eachResult = 0;
		int deleteResult = 0;
		
		Map<String,String> resultMap = new HashMap<String, String>();
		
		if(delIds != null){
			deleteResult = delIds.length;
			for(int i = 0; i < delIds.length; i++){
				if(SqlDao.delete("COMMON.removeCustomItem", delIds[i])>0)
					eachResult++;
			}
			deleteResult -= eachResult;
		}
		
		resultMap.put("deleteFailCount", deleteResult+"");
		
		ArrayList<Map<String, String>> list = Common.convertToMapArray(request, "cmid", "index", "name", "status");
		
		if(list == null){
			b.add("result", Codes.ERROR_MISSING_PARAMETER);
			return b.build();
		}

		int failCnt = 0;
		
		for(int i = 0; i < list.size(); i++){//Map<String, String> map : list){
			
			Map<String, String> map = list.get(i);
			map.put("idx", sid);
			map.put("index", (i+1)+"");
			
			if(Common.isValid(map.get("cmid"))){
				//update

				eachResult = SqlDao.update("COMMON.updateCustomizeItem", map);
				//eachResult = SqlDao.update("Hospital.Board.updateCustomBoard", map);
			}
			else{
				
				map.put("cmid", Common.makeRownumber("cmid", map.get("parent")));
				map.put("parent", param.get("parent"));
				
				map.put("group", map.get("type"));
				map.put("key", "");
				map.put("status", "Y");
				map.put("visible", "Y");
				map.put("lv", "0");
				
				eachResult = SqlDao.insert("COMMON.insertCustomizeItem", map);
				//eachResult = SqlDao.insert("Hospital.Board.insertServiceBoard", map);
			}
			
			if(eachResult < 1)
				failCnt++;
		}
		
		resultMap.put("insertFailCount", failCnt+"");
		
		if(failCnt > 0 || deleteResult > 0){
			resultMap.put("result", Codes.ERROR_QUERY_EXCEPTION);
		}
		else{
			resultMap.put("result", Codes.SUCCESS_CODE);
		}
		
		return JSONObject.toJSONString(resultMap);
	}
	
	@RequestMapping(value = "/serviceContentEdit.latte")
	public String serviceContentEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("serviceContentEdit.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		String group = params.get("g");
		
		putMainMenuToModel(model, sid, Codes.CUSTOM_CATEGORY_MAIN_MENU_3);
		Map<String, String> menu = getMainMenuInfo(model, sid, Codes.CUSTOM_CATEGORY_MAIN_MENU_3);
		
		String bid = params.get("bid");
		// 게시판 내용을 가져옴
		if(Common.isValid(bid)){
			model.addAttribute("boardContents", SqlDao.getMap("Hospital.Board.getBoard", bid));
			
			List l = SqlDao.getList("Hospital.Board.getContentsByBid", bid);
			model.addAttribute("videoList", l);
		}
		
		// 메인 메뉴
		//model.addAttribute("mainMenu", SqlDao.getList(SQLNamespace.CLIENT_HOSPITAL+"getMainMenu", sid));
		model.addAttribute("hospitalInfo", SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getSimpleHospitalInfo", sid));
		
		model.addAttribute("params", params);
		
		return "admin/hospital/service/edit";
	}
	
	@RequestMapping(value = "/ajaxServiceSwitching.latte")
	public @ResponseBody String ajaxServiceSwitching(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam Map<String, String> params) throws Exception {
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
		}
		else{
		
			Map<String, String> map = null;
			if(Common.strEqual(params.get("type"), "previous")){
				map = SqlDao.getMap("Admin.Hospital.Board.getPreviousByIndex", params.get("bid"));
				
			}
			else if(Common.strEqual(params.get("type"), "next")){
				map = SqlDao.getMap("Admin.Hospital.Board.getNextByIndex", params.get("bid"));
			}
			
			if(map!=null){
				map.put("type", params.get("type"));
				Map<String, String> switchingMap = new HashMap<String, String>();
				switchingMap.put("frontId", params.get("bid"));
				switchingMap.put("backId", map.get("s_bid"));
				
				System.out.println(params.get("bid")+","+map.get("s_bid"));
				SqlDao.update("Admin.Hospital.Board.indexSwitching", switchingMap);
				
				b.add("result", Codes.SUCCESS_CODE);
				b.add("type", params.get("type"));
				b.add("tagId", params.get("tagId"));
			}
			else{
				
				b.add("result", Codes.ERROR_QUERY_PROCESSED);
			}
		}
		
		return b.build();
	}
	
	@RequestMapping(value="/ajaxServiceImgUpload.latte")
	public @ResponseBody String ajaxServiceImgUpload(Model model, HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> params) throws Exception{
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		MultipartFile file = multipartRequest.getFile("image");
		
		JSONSimpleBuilder builder = new JSONSimpleBuilder();
		builder.add("result", Codes.SUCCESS_CODE);
		
		params.put("crop_url", "ajaxCropServiceImg.latte");
		
		String s = cropPreProcess(model, file, params, 640, 360, 640);
		
		try {
			response.flushBuffer();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return s;
		
		//return builder.build();
	}
	
	@RequestMapping(value = "/ajaxCropServiceImg.latte")
	public @ResponseBody String ajaxCropServiceImg(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam Map<String, String> params) throws Exception {
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");

		String destImgPath = Config.PATH_TEMP_IMAGE + /*Common.todayPath() + */"";//"/";
		String destImgName = System.nanoTime() + Common.getRandomNumber(10) + ".jpg";
		
		
		//Map img = SqlDao.getMap("Admin.Hospital.Common.getImage", params.get("iid"));
		// 원본 파일 경로를 가져옴
		//String ori_name = Config.IMAGE_PATH_ROOT + img.get("s_image_path");
		
		
		// params에 받아온 파라미터로 원본 파일 경로를 접근,
		// dest 파일에 편집한 이미지를 저장
//		String cropImgData = cropImage(params, destImgPath, destImgName, 800, -1, sessionContext.getData("s_sid"));
		Map<String, String> returnMap = cropImage(params, destImgPath, destImgName, 800, -1, sessionContext.getData("s_sid"));

//		Map<String, String> returnMap = new HashMap<String, String>();
		returnMap.put("iid", params.get("iid"));
		returnMap.put("targetId", params.get("targetId"));
		//returnMap.put("imgData", cropImgData);

		return org.json.simple.JSONObject.toJSONString(returnMap);
	}
	
	@RequestMapping(value="/ajaxSaveServiceInfo.latte")
	public @ResponseBody String ajaxSaveServiceInfo(Model model, HttpServletRequest request,
			@RequestParam Map<String, String> params){
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		String bid = params.get("bid");
		
		String old_image_id = "";
		String old_image_path = "";
		String old_thum_img_path = "";
		
		if(Common.isValid(bid)){
		
			if(!Common.strEqual(params.get("title_visible"), "Y"))
				params.put("subject", "");
			
			if(!Common.strEqual(params.get("img_visible"), "Y"))
				params.put("iid", "");
			
			if(!Common.strEqual(params.get("content_visible"), "Y"))
				params.put("contents", "");
			
			@SuppressWarnings("rawtypes")
			Map map = SqlDao.getMap("Admin.Hospital.Board.getBoardImage", bid);
			if(map != null){
				old_image_id = (String) map.get("s_iid");
				old_image_path = Config.IMAGE_PATH_ROOT+(String) map.get("s_image_path");
				old_thum_img_path = Config.IMAGE_PATH_ROOT+(String) map.get("s_thum_img_path");
			}
			
		}else{
			
			bid = Common.makeRownumber("bid", "123456");
			params.put("bid", bid);
			params.put("index", SqlDao.getString("Admin.Hospital.Board.getNextIndex", params.get("group")));
		}
		
		String iid = params.get("iid");
		
		// 이전 이미지가 있음
		if(Common.isValid(old_image_id)){
			
			if(!Common.isValid(iid)){
				
				// 잘라내어 temp 디렉토리에 임시 저장된 이미지를 실사용 디렉토리로 이동하고 db 갱신
				deleteImageAndDBUpdate(old_image_path, old_thum_img_path, old_image_id);
			}
			// 이전 이미지와 새 이미지가 다름
			else if(!Common.strEqual(iid, old_image_id)){
				
				activateTempImage(iid, Config.PATH_HOSPITAL_IMAGE, Codes.IMAGE_TYPE_REF);
				deleteImageAndDBUpdate(old_image_path, old_thum_img_path, old_image_id);
			}
		}
		else{
			if(Common.isValid(iid)){
				activateTempImage(iid, Config.PATH_HOSPITAL_IMAGE, Codes.IMAGE_TYPE_REF);
			}
		}
		
		// 기존 동영상 제거
				HashMap<String, String> subinfoDeleteParams = new HashMap<String, String>();
				subinfoDeleteParams.put("bid", bid);
				subinfoDeleteParams.put("type", Codes.ELEMENT_BOARD_CONTENTS_TYPE_VIDEO_LINK);
				int r = SqlDao.delete("Admin.Hospital.Board.deleteSubinfoByType", subinfoDeleteParams);
				
				String[] video = request.getParameterValues("video_url");
				
				// 입력받은 동영상 추가
				if(video!=null && Common.strEqual(params.get("video_visible"), "Y")){
					
					StringBuffer sb = new StringBuffer();
					
					int len = video.length;
					
					// 쿼리 생성
					for(int i = 0; i < len; i++){
						
						sb.append("('");
						sb.append(Common.makeRownumber("bsiid", System.currentTimeMillis()*123+""));
						sb.append("','");
						sb.append(bid);
						sb.append("','");
						sb.append(Codes.ELEMENT_BOARD_CONTENTS_TYPE_VIDEO_LINK);
						sb.append("','");
						
						// 태그가 있으면 raw_code, 없으면 url_only
						if(Common.existTag(video[i]))
							sb.append(Codes.ELEMENT_BOARD_CONTENTS_SUBTYPE_RAW_CODE);
						else
							sb.append(Codes.ELEMENT_BOARD_CONTENTS_SUBTYPE_URL_ONLY);
						
						sb.append("','");

						// 비디오 서비스 제공자 vimeo or youtube
						if(video[i].matches("^.*(?i)(vimeo).*$"))
							sb.append(Codes.ELEMENT_VIDEO_PROVIDER_VIMEO);
						else if(video[i].matches("^.*(?i)(youtube).*$"))
							sb.append(Codes.ELEMENT_VIDEO_PROVIDER_YOUTUBE);
						else
							sb.append("none");
						
						sb.append("','");
						sb.append(video[i]);
						sb.append("',");
						sb.append(i+1);
						sb.append(")");
						
						if(i < len-1)
							sb.append(",");
					}
					
					// 동영상 입력
					if(len > 0)
						SqlDao.insert("Admin.Hospital.Board.insertSubinfo", sb.toString());
				}
		
		if(SqlDao.insert("Admin.Hospital.Board.insertBoard", params) > 0){
			
			Map m = SqlDao.getMap("COMMON.getCustomItem", params.get("group"));
			if(m != null && Common.isValid((String) m.get("s_parent"))){
				
				Map s = new HashMap<String, Object>();
				s.put("parent", "MAIN_MENU");
				s.put("id", sessionContext.getData("s_sid"));
				s.put("status", "Y");
				s.put("group", Codes.CUSTOM_CATEGORY_MAIN_MENU_3);
				
				// 소식 게시판 가져옴
				Map<String, String> boardMap = SqlDao.getMap("COMMON.getByParent", s);
				//model.addAttribute("curMenuId", boardMap.get("s_cmid"));
				
				if(boardMap == null || Common.strEqual(boardMap.get("s_cmid"), m.get("s_parent"))){
				}
				else
					b.add("ancestor", (String) m.get("s_parent"));
			}
			b.add("result", Codes.SUCCESS_CODE);
		}
		
		return b.build();
	}
}
