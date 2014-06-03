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
import kr.co.petmd.utils.common.ImageCropUtil;
import kr.co.petmd.utils.common.ImageResizer;
import kr.co.petmd.utils.common.ImageUtil;
import kr.co.petmd.utils.common.JSONSimpleBuilder;
import kr.co.petmd.utils.common.PageUtil;
import kr.co.petmd.utils.common.RSSUtil;
import kr.co.petmd.utils.common.StatusInfoUtil;
import kr.co.petmd.utils.common.XMLParserUtil;

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
public class BoardAction extends AbstractAction{

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/boardHome.latte")
	public String boardHome(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("boardHome.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		// 메인 메뉴
		model.addAttribute("hospitalInfo", SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getSimpleHospitalInfo", sid));
		
		//List<Map> boardMenuList = SqlDao.getList("Hospital.Board.getBoardMenu", sid);
		
		putMainMenuToModel(model, sid, "MAIN_MENU_4");
		Map<String, String> menu = getMainMenuInfo(model, sid, "MAIN_MENU_4");

		//s.remove("group");
		Map<String, String> s = new HashMap<String, String>();
		s.put("id", sid);
		s.put("parent", menu.get("s_cmid"));
		s.put("status", "Y");
		s.put("visible", "Y");
		// 소식 게시판의 하위 게시판 리스트를 가져옴
		List boardMenuList = SqlDao.getList("COMMON.getByParent", s);
		
		String parent = "";
		
		Map<String, String> boardInfo = null;
		boolean isNotFinished = true;
		
		// 요청한 cmid가 없으면 첫번째 메뉴를 선택
		if(!Common.isValid(params.get("cmid"))){
			Map map = Common.getFirstMap(boardMenuList);
			if(map != null){
				boardInfo = SqlDao.getMap("COMMON.getCustomItem", (String) map.get("s_cmid"));
				parent =  (String) map.get("s_cmid");
				isNotFinished = false;
			}
		}

		if(isNotFinished){
			boardInfo = SqlDao.getMap("COMMON.getCustomItem", params.get("cmid"));
			parent = params.get("cmid");
		}
		
		// 문자열 복호화
		params.put("search_text", EncodingUtil.URLDecode(params.get("search_text"), Config.DEFAULT_CHARSET));
		
		// 해당 게시판의 sub info 를 가져온다. (param : 게시판보유자id(ex:s_sid), 게시판id)
		//Map<String, String> m = CustomizeUtil.getSubInfo(sid, parent);
		//s.put("cmid", )
		Map<String, String> m = CustomizeUtil.putAllToMap(SqlDao.getList("COMMON.getCustomAttrById", parent), boardInfo, true);
		
		//boardInfo.put("board_type", m.get(Codes.BOARD_TYPE));
		
		if(Common.strEqual(m.get("s_group"),Codes.CUSTOM_BOARD_TYPE_RSS)){
			
			// RSS 처리
			XMLParserUtil xml = new XMLParserUtil();
			
			ArrayList<String> keyTree = new ArrayList<String>();
			keyTree.add("rss");
			keyTree.add("channel");
			keyTree.add("item");
			
			ArrayList<Object> list = xml.parseByDOM("URL", m.get("attr_url"), keyTree);
			
			if(list!=null&&!list.isEmpty()){
				
				if(Common.strEqual(params.get("search_type"),"subjectcontents")){
					
					xml.search(list, new String[]{"title","description"},
							params.get("search_text"), Common.toInt(params.get("pageNumber")), 10);
				}
				else{
					xml.search(list, null, null, Common.toInt(params.get("pageNumber")), 10);
				}
				params.put("totalCount", xml.getSearchTotal()+"");
				params.put("pageNumber", xml.getPageNumber()+"");
				params.put("pageCount", xml.getPageCount()+"");
				
				model.addAttribute("rssList", xml.getSearchResultList());
			}
			
			// RSS 처리
//			XMLParserUtil xml = new XMLParserUtil();
//			
//			Map<String,Object> m1 = xml.parseByDOM("URL",(String) m.get("attr_url"));
//			
//			if(m1 != null){
//				ArrayList<Map> arr = (ArrayList) XMLParserUtil.getValue(m1, "channel");
//				
//				ArrayList arr1 = (ArrayList) XMLParserUtil.getValue(arr.get(0), "item");
//				
//				ArrayList<HashMap> subList = new ArrayList<HashMap>();
//				
//				// rss 리스트에서 search_text를 포함하는 리스트를 재생성하여 반환
//				arr1 = RSSUtil.search(arr1, params.get("search_type"), params.get("search_text"));
//				
//				// 페이징
//				int length = arr1.size();
//				
//				PageUtil pu = PageUtil.getInstance();
//				
//				params.put("totalCount", length+"");
//				pu.pageSetting(params, 10);
//				
//				int startRow = pu.getStartRow();
//				int endRow = startRow+pu.getEndRow();
//				if(endRow > length)
//					endRow = length;
//
//				subList.addAll(arr1.subList(startRow, endRow));
//				
//				model.addAttribute("rssList", subList);
//			}
//			model.addAttribute("inner_layout", "hospital_rss_board_inner.jsp");
		}
		else if(boardInfo != null && !boardInfo.isEmpty()){
			
//			// 쿼리 파라미터 세팅
//			Map<String, String> bparam = new HashMap<String, String>();
//			bparam.put("cmid", boardInfo.get("s_cmid"));
//			bparam.put("search_type", params.get("search_type"));
//			bparam.put("search_text", params.get("search_text"));
//			
//			// 이미지 게시판
//			if(Common.strEqual(m.get("s_group"),Codes.CUSTOM_BOARD_TYPE_IMAGE)){
//			
//				bparam.put("totalCount", SqlDao.getString("Hospital.Board.getBoardListCnt", bparam));
//				bparam.put("pageNumber", params.get("pageNumber"));
//				
//				PageUtil.getInstance().pageSetting(bparam, 10);
//				params.putAll(bparam);
//				
//				model.addAttribute("imgBoardList",SqlDao.getList("Hospital.Board.getBoardList", bparam));
//				model.addAttribute("inner_layout", "hospital_img_board_inner.jsp");
//			}
//			// 공지사항 게시판
//			else if(Common.strEqual(m.get("s_group"),Codes.CUSTOM_BOARD_TYPE_NOTICE)){
//				
//				bparam.put("type", Codes.ELEMENT_BOARD_TYPE_IMPORTANT);
//				
//				model.addAttribute("importantBoardList", SqlDao.getList("Hospital.Board.getBoardList", bparam));
//				
//				bparam.remove("type");
//				
//				bparam.put("totalCount", SqlDao.getString("Hospital.Board.getBoardListCnt", bparam));
//				bparam.put("pageNumber", params.get("pageNumber"));
//				
//				PageUtil.getInstance().pageSetting(bparam, 10);
//				params.putAll(bparam);
//				
//				model.addAttribute("boardList", SqlDao.getList("Hospital.Board.getBoardList", bparam));
//				
//				model.addAttribute("inner_layout", "hospital_notice_board_inner.jsp");
//			}
//			// FAQ 게시판
//			else if(Common.strEqual(m.get("s_group"),Codes.CUSTOM_BOARD_TYPE_FAQ)){
//				
//				bparam.put("totalCount", SqlDao.getString("Hospital.Board.getBoardListCnt", bparam));
//				bparam.put("pageNumber", params.get("pageNumber"));
//				
//				PageUtil.getInstance().pageSetting(bparam, 10);
//				params.putAll(bparam);
//				
//				model.addAttribute("faqBoardList",SqlDao.getList("Hospital.Board.getBoardList", bparam));
//				model.addAttribute("inner_layout", "hospital_faq_board_inner.jsp");
//			}
			
			// 게시물 리스트 가져오기
			Map<String, String> bparam = new HashMap<String, String>();
			bparam.put("cmid", (String) boardInfo.get("s_cmid"));
			bparam.put("search_type", params.get("search_type"));
			bparam.put("search_text", params.get("search_text"));
			bparam.put("visible", "Y");
			
			bparam.put("totalCount", SqlDao.getString("Hospital.Board.getBoardListCnt", bparam));
			bparam.put("pageNumber", params.get("pageNumber"));
			
			PageUtil.getInstance().pageSetting(bparam, 10);
			params.putAll(bparam);
			
			model.addAttribute("boardList", SqlDao.getList("Hospital.Board.getBoardList", bparam));
			
			// 일반 게시판
			if(Common.strEqual(m.get("s_group"),Codes.CUSTOM_BOARD_TYPE_NOTICE)){
				
				bparam.put("type", Codes.ELEMENT_BOARD_TYPE_IMPORTANT);
				
				model.addAttribute("importantBoardList", SqlDao.getList("Hospital.Board.getBoardList", bparam));
			}
		}
		
		model.addAttribute("boardInfo", boardInfo);
		
		model.addAttribute("menuList", boardMenuList);
		
		params.put("pagingGroupSize", "5");
		model.addAttribute("params", params);
		
		return "admin/hospital/board/home";
	}
	
	@SuppressWarnings("unused")
	private int outline___menu_edit = 0;
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/boardMenuEdit.latte")
	public String boardMenuEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("boardMenuEdit.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		// 메인 메뉴 세팅 후 main_menu_4 정보 가져옴
		putMainMenuToModel(model, sid, "MAIN_MENU_4");
		Map<String, String> menu = getMainMenuInfo(model, sid, "MAIN_MENU_4");

		model.addAttribute("hospitalInfo", SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getSimpleHospitalInfo", sid));
		
		//s.remove("group");
		Map<String, String> s = new HashMap<String, String>();
		s.put("id", sid);
		s.put("parent", menu.get("s_cmid"));
		s.put("status", "Y");
		// 소식 게시판의 하위 게시판 리스트를 가져옴
		List boardMenuList = SqlDao.getList("COMMON.getByParent", s);
		
		// 각 하위 게시판의 정보를 가져옴
		Iterator<Map> iter = boardMenuList.iterator();
		while(iter.hasNext()){
			Map map = iter.next();
			s.put("cmid", (String) map.get("s_cmid"));
			
			Map m1 = CustomizeUtil.putAllToMap(SqlDao.getList("COMMON.getCustomAttrById", (String) map.get("s_cmid")), map, true);
			m1.put("sid", sid);
			m1.put("group", map.get("s_group"));
			//map.putAll(CustomizeUtil.getSubInfo(sid, (String) map.get("s_cmid")));
		}
		
		// 하위 메뉴 리스트 생성
		List pl = new ArrayList<String>();
		iter = boardMenuList.iterator();
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
		
		// 메뉴, 서브메뉴 추가
		model.addAttribute("menuList", boardMenuList);
		
		//model.addAttribute("board_type", SqlDao.getList("COMMON.getElementList", Codes.BOARD_TYPE));
		model.addAttribute("board_type", SqlDao.getList("COMMON.getCustomChild", "BOARD"));
		
		model.addAttribute("params", params);
		
		return "admin/hospital/board/menu_edit";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ajaxBoardMenuEdit.latte")
	public @ResponseBody String ajaxBoardMenuEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("ajaxBoardMenuEdit.latte");
		
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
		
		Map<String, String> attrMap = new HashMap<String, String>();
		attrMap.put("parent", "MAIN_MENU");
		attrMap.put("group", "MAIN_MENU_4");
		attrMap.put("id", sid);
		// 소식 메뉴 가져옴
		Map<String, String> boardMap = SqlDao.getMap("COMMON.getByParent", attrMap);
		
		attrMap.put("parent", boardMap.get("s_cmid"));
		// 소식 메뉴 정보를 가져와 합침
		boardMap = CustomizeUtil.putAllToMap(SqlDao.getList("COMMON.getCustomAttr", attrMap), boardMap, true);
		
		attrMap.remove("group");
		// 소식 메뉴의 하위 게시판 리스트를 가져옴
		List boardMenuList = SqlDao.getList("COMMON.getByParent", attrMap);
		
		
		
		
		
		param.put("parent", (String) boardMap.get("s_cmid"));

		List<Map> firstBoardList = boardMenuList;//SqlDao.getList("COMMON.getChildCustom", param);
		
		// 원본에는 있지만 파라미터에는 없는 cmid리스트를 추출(삭제 예정 리스트)
		String[] delIds = Common.nonexistArray(firstBoardList, "s_cmid", request.getParameterValues("cmid"));
		
		int eachResult = 0;
		int deleteResult = 0;
		
		//Map<String,String> resultMap = new HashMap<String, String>();
		
		// 삭제
		if(delIds != null){
			deleteResult = delIds.length;
			for(int i = 0; i < delIds.length; i++){
				if(SqlDao.delete("COMMON.removeCustomItem", delIds[i])>0){
					eachResult++;
				}
			}
			deleteResult -= eachResult;
		}
		
		b.add("deleteFailCount", deleteResult+"");
		//resultMap.put("deleteFailCount", deleteResult+"");
		
		//
		
		ArrayList<Map<String, String>> list = Common.convertToMapArray(request, "cmid", "group", "name", "status", "visible");
		
		if(list == null){
			b.add("result", Codes.ERROR_MISSING_PARAMETER);
			return b.build();
		}

		int failCnt = 0;
		
		String[] rss = request.getParameterValues("rssurl");
		
		for(int i = 0; i < list.size(); i++){
			
			Map<String, String> map = list.get(i);
			map.put("idx", sid);
			map.put("index", (i+1)+"");
			
			if(Common.isValid(map.get("cmid"))){
				//update
				eachResult = SqlDao.update("COMMON.updateCustomizeItem", map);
			}
			else{
				
				map.put("cmid", Common.makeRownumber("cmid", param.get("parent")));
				map.put("parent", param.get("parent"));
				map.put("group", map.get("group"));
				map.put("key", "");
				map.put("status", "Y");
				map.put("visible", "Y");
				map.put("lv", "0");
				
				eachResult = SqlDao.insert("COMMON.insertCustomizeItem", map);
			}
			
			Map<String, String> info = new HashMap<String, String>();
			info.put("cmid", map.get("cmid"));

			//info.put("attr", "NAME");
			//info.put("value", map.get("value"));
			//SqlDao.insert("COMMON.insertCustomInfo", info);
			
			if(Common.strEqual(map.get("group"), Codes.CUSTOM_BOARD_TYPE_RSS)){
				info.put("attr", "URL");
				info.put("value", rss[i]);
				
				SqlDao.insert("COMMON.insertCustomInfo", info);
			}
			
			if(eachResult < 1)
				failCnt++;
		}
		
		//resultMap.put("insertFailCount", failCnt+"");
		b.postAdd("insertFailCount", failCnt+"");
		
		if(failCnt > 0 || deleteResult > 0){
			//resultMap.put("result", "1001");
			b.postAdd("result", Codes.ERROR_QUERY_PROCESSED);
		}
		else{
			//resultMap.put("result", "success");
			b.postAdd("result", Codes.SUCCESS_CODE);
		}
		
		return b.build();//JSONObject.toJSONString(resultMap);
	}
	
	@SuppressWarnings("unused")
	private int outline___board_content_edit = 0;
	
	@RequestMapping(value = "/boardContentEdit.latte")
	public String boardContentEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("boardContentEdit.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		String group = params.get("g");
		
		String bid = params.get("bid");
		
		// 메인 메뉴
		putMainMenuToModel(model, sid, "MAIN_MENU_4");
		Map<String, String> menu = getMainMenuInfo(model, sid, "MAIN_MENU_4");
		
		model.addAttribute("hospitalInfo", SqlDao.getMap(SQLNamespace.CLIENT_HOSPITAL+"getSimpleHospitalInfo", sid));
		
		//s.remove("group");
		Map<String, String> s = new HashMap<String, String>();
		s.put("id", sid);
		s.put("parent", menu.get("s_cmid"));
		s.put("status", "Y");
		// 소식 게시판의 하위 게시판 리스트를 가져옴
		List boardMenuList = SqlDao.getList("COMMON.getByParent", s);
		
		//List<Map> boardMenuList = SqlDao.getList("Hospital.Board.getBoardMenu", sid);
		model.addAttribute("menuList", boardMenuList);
		
		// 현재 게시글에 해당하는 게시판0
		String parent = params.get("cmid");
		Map<String, String> boardInfo = SqlDao.getMap("COMMON.getCustomItem", parent);
		
		// 현재 선택된 메뉴의 속성값(list)들을 가져와서 map 으로 변환
		Map<String, String> m = CustomizeUtil.putAllToMap(SqlDao.getList("COMMON.getCustomAttrById", parent), boardInfo, true);
		//Map<String, String> m = CustomizeUtil.getSubInfo(sid, parent);
		
		// 레이아웃을 가져옴
//		String layout = "";
//		if(Common.strEqual(m.get("s_group"),Codes.CUSTOM_BOARD_TYPE_IMAGE)){
//			
//			layout = "hospital_img_board_edit";
//		}
//		else if(Common.strEqual(m.get("s_group"),Codes.CUSTOM_BOARD_TYPE_NOTICE)){
//			
//			//layout = "hospital_notice_board_edit";
//			layout = "hospital_img_board_edit";
//		}
//		else if(Common.strEqual(m.get("s_group"),Codes.CUSTOM_BOARD_TYPE_FAQ)){
//			
//			layout = "hospital_faq_board_edit";
//			//layout = "hospital_img_board_edit";
//		}
		
		// 게시판 내용을 가져옴
		if(Common.isValid(params.get("bid"))){
			Map<String, String> boardContents= SqlDao.getMap("Hospital.Board.getBoard", params.get("bid"));
//			if(Common.strEqual((Object)boardContents.get("s_priority"),m.get(Codes.IMPORTANT_PRIORITY))){
//				boardContents.put("priority", "Y");
//			}
			model.addAttribute("boardContents", boardContents);
			
			List l = SqlDao.getList("Hospital.Board.getContentsByBid", params.get("bid"));
			model.addAttribute("videoList", l);
		}
		else{
			params.put("view_type", "new");
		}
		
		model.addAttribute("boardInfo", boardInfo);
		
		
		
		//SqlDao.getList("COMMON.getElementList", )
		
		model.addAttribute("params", params);
		
		//return "client/hospital/board/"+layout;
	
		return "admin/hospital/board/edit";//board/"+layout;
	}
	
	@RequestMapping(value = "/ajaxBoardContentEdit.latte")
	public @ResponseBody String ajaxBoardContentEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("ajaxBoardMenuEdit.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		// 권한 체크
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		String sid = sessionContext.getData("s_sid");
		String bid = params.get("bid");
		
		// 게시판 타입 설정
		if(Common.strEqual(params.get("important"), "Y")){
			params.put("type", Codes.ELEMENT_BOARD_TYPE_IMPORTANT);
		}
		else{
			params.put("type", Codes.ELEMENT_BOARD_TYPE_NORMAL);
		}
		
		// 새 게시물일 경우 id 생성
		if(!Common.isValid(bid)){
			
			bid = Common.makeRownumber("bid", sid);
			params.put("bid", bid);
		}
		
		// insert or update
		if(SqlDao.insert("Admin.Hospital.Board.insertBoard", params)>0){
			b.add("result", Codes.SUCCESS_CODE);
			b.postAdd("bid", bid);
		}
		else
			b.add("result", Codes.ERROR_QUERY_EXCEPTION);
		
		return b.build();
	}
	
	@RequestMapping(value="/ajaxBoardImgUpload.latte")
	public @ResponseBody String ajaxBoardImgUpload(Model model, HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> params) throws Exception{
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		MultipartFile file = multipartRequest.getFile("image");
		
		JSONSimpleBuilder builder = new JSONSimpleBuilder();
		builder.add("result", Codes.SUCCESS_CODE);
		
		params.put("crop_url", "ajaxCropBoardImg.latte");
		
		String s = cropPreProcess(model, file, params, 640, 360, 640);
		
		try {
			response.flushBuffer();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return s;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ajaxCropBoardImg.latte")
	public @ResponseBody String ajaxCropBoardImg(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam Map<String, String> params) throws Exception {
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");

		String destImgPath = Config.PATH_TEMP_IMAGE + /*Common.todayPath() + */"";//"/";
		String destImgName = System.nanoTime() + Common.getRandomNumber(10) + ".jpg";
		
		// params에 받아온 파라미터로 원본 파일 경로를 접근,
		// dest 파일에 편집한 이미지를 저장
		//String cropImgData = cropImage(params, destImgPath, destImgName, 698, 430, sessionContext.getData("s_sid"));
		
		Map<String, String> returnMap = new HashMap<String, String>();
		
		// 원본 파일 경로를 가져옴
		Map img = SqlDao.getMap("Admin.Hospital.Common.getImage", params.get("iid"));
		if(img==null){
			returnMap.put("result", Codes.ERROR_NOT_FOUND_IMAGE);
			return JSONObject.toJSONString(returnMap);
		}
			
		String ori_name = Config.IMAGE_PATH_ROOT + img.get("s_image_path");
		
		String destFullPath = Config.IMAGE_PATH_ROOT + destImgPath;
		
		// 원본 파일 이미지를 불러온다.
		BufferedImage bufferedImage = ImageUtil.getImageInstance(ori_name);
		if(bufferedImage==null){
			returnMap.put("result", Codes.ERROR_NOT_FOUND_IMAGE);
			return JSONObject.toJSONString(returnMap);
		}
		
		// 이미지를 잘라냄(잘라내는 x y w h 값은 params에 들어있어야 됨)
		BufferedImage image = cropImageCore(params, bufferedImage);
		
		// 썸네일 이미지 생성
		int crop_image_width = image.getWidth();
		int crop_image_height = image.getHeight();
		int crop_size = crop_image_width;
		int crop_x = 0;
		int crop_y = 0;
		if(crop_image_height < crop_size){
			crop_size = crop_image_height;
			crop_x = (crop_image_width - crop_size) / 2;
		}
		else{
			crop_y = (crop_image_height - crop_size) / 2;
		}
		
		BufferedImage thumImage = null;//cropImageCore(params, bufferedImage);
		ImageCropUtil icu = new ImageCropUtil(image);
		try{
			thumImage = icu.crop(crop_x, crop_y, crop_size, crop_size).getBufferedImage();
		}
		catch(Exception e){
			thumImage = null;
		}
		
		// 크기를 강제로 맞춤
		image = ImageResizer.resize(image, 800, -1, true, true);
		// 이미지를 디스크에 씀
		ImageUtil.writeImage(image, destFullPath, destImgName, 100);
		
		if(thumImage != null){
			// 크기를 강제로 맞춤
			thumImage = ImageResizer.resize(thumImage, 130, 130, true, true);
			// 이미지를 디스크에 씀
			ImageUtil.writeImage(thumImage, destFullPath, "thum"+destImgName, 100);
		}
		
		// 원본(임시) 파일 업데이트
		File ori = new File(ori_name);
		if(!ori.exists() || ori.delete()){
			//SqlDao.delete("Admin.Hospital.Common.deleteImage", params.get("iid"));
			
			img.put("iid", params.get("iid"));
			img.put("id", sid);
			img.put("lkey", "TMP");
			
			img.put("index", SqlDao.getString("Admin.Hospital.Common.getNextImageIndex", params));
			
			img.put("type", "JPG");
			img.put("image_name", img.get("s_image_name"));
			img.put("image_path", destImgPath+destImgName);
			img.put("thum_img_path", destImgPath+"thum"+destImgName);
			SqlDao.insert("Admin.Hospital.Common.insertImage", img);
		}

		returnMap.put("result", Codes.SUCCESS_CODE);
		returnMap.put("iid", params.get("iid"));
		returnMap.put("targetId", params.get("targetId"));
		returnMap.put("imgData", ImageUtil.getBase64String(image, 100));

		return org.json.simple.JSONObject.toJSONString(returnMap);
	}
	
	@RequestMapping(value = "/ajaxSaveImgBoard.latte")
	public @ResponseBody String ajaxSaveImgBoard(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam Map<String, String> params) throws Exception {
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		String old_image_id = "";
		String old_image_path ="";
		String old_thum_img_path = "";
		
		// 게시글 id가 없을 경우 새로 생성
		String bid = params.get("bid");
		
		if(!Common.isValid(bid)){
			
			bid = Common.makeRownumber("bid", "123456");
			params.put("bid", bid);
		}
		
		if(Common.isValid(bid)){
			@SuppressWarnings("rawtypes")
			Map map = SqlDao.getMap("Admin.Hospital.Board.getBoardImage", bid);
			if(map != null){
				old_image_id = (String) map.get("s_iid");
				old_image_path = Config.IMAGE_PATH_ROOT+(String) map.get("s_image_path");
				old_thum_img_path = Config.IMAGE_PATH_ROOT+(String) map.get("s_thum_img_path");
			}
		}
		else{
			
			bid = Common.makeRownumber("bid", System.currentTimeMillis()*12+"");
		}
		
		// 게시판 타입 설정
		if(Common.strEqual(params.get("important"), "Y")){
			params.put("type", Codes.ELEMENT_BOARD_TYPE_IMPORTANT);
		}
		else{
			params.put("type", Codes.ELEMENT_BOARD_TYPE_NORMAL);
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
		if(video!=null){
			
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
		
		// 게시판 정보 insert or update
		if(SqlDao.insert("Admin.Hospital.Board.insertBoard", params)>0){
			b.add("result", Codes.SUCCESS_CODE);
			b.postAdd("bid", bid);
		}
		else
			b.add("result", Codes.ERROR_QUERY_EXCEPTION);
		
		return b.build();
	}
	
	@RequestMapping(value = "/ajaxDeleteBoardContent.latte")
	public @ResponseBody String ajaxDeleteBoardContent(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("ajaxDeleteBoardContent.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		if(SqlDao.update("Admin.Hospital.Board.removeBoard", params.get("bid"))>0){
			b.add("result", Codes.SUCCESS_CODE);
		}
		else
			b.add("result", Codes.ERROR_QUERY_EXCEPTION);
		
		return b.build();
	}
	
	@RequestMapping(value = "/ajaxDeleteImgBoardContent.latte")
	public @ResponseBody String ajaxDeleteImgBoardContent(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("ajaxDeleteImgBoardContent.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth()){
			b.add("result", Codes.ERROR_UNAUTHORIZED);
			return b.build();
		}
		
		String bid = params.get("bid");
		
		if(!Common.isValid(bid)){
			
			b.add("result", Codes.ERROR_MISSING_PARAMETER);
			return b.build();
		}
		
		@SuppressWarnings("rawtypes")
		Map map = SqlDao.getMap("Hospital.Board.getBoardImage", bid);
		if(map != null){
			String old_image_id = (String) map.get("s_iid");
			String old_image_path = Config.IMAGE_PATH_ROOT+(String) map.get("s_image_path");
			String old_thum_img_path = Config.IMAGE_PATH_ROOT+(String) map.get("s_thum_img_path");
			
			deleteImageAndDBUpdate(old_image_path, old_thum_img_path, old_image_id);
		}
		
		if(SqlDao.update("Admin.Hospital.Board.removeBoard", params.get("bid"))>0){
			b.add("result", Codes.SUCCESS_CODE);
		}
		else
			b.add("result", Codes.ERROR_QUERY_EXCEPTION);
		
		return b.build();
	}
}
