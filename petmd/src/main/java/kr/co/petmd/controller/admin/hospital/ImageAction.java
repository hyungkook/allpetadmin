package kr.co.petmd.controller.admin.hospital;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.petmd.HomeController;
import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.admin.Codes;
import kr.co.petmd.utils.admin.Config;
import kr.co.petmd.utils.admin.SessionContext;
import kr.co.petmd.utils.common.Common;
import kr.co.petmd.utils.common.JSONSimpleBuilder;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Controller
public class ImageAction extends AbstractAction{

	private static final Logger logger = LoggerFactory.getLogger(ImageAction.class);
	
	@Resource(name="sessionContextFactory")
	ObjectFactory<SessionContext> sessionContextFactory;
	
	protected SessionContext getSessionContext(){
		
		return (SessionContext) sessionContextFactory.getObject();
	}
	
	private class ImageCropData{
		public String tag_id;
		public String crop_url;
		public int img_width;
		public int img_height;
		public int thum_size;
		
		public ImageCropData(String tag_id, String crop_url, int img_width, int img_height, int thum_size){
			this.tag_id = tag_id;
			this.crop_url = crop_url;
			this.img_width = img_width;
			this.img_height = img_height;
			this.thum_size = thum_size;
		}
	}
	
	private Map<String,ImageCropData> setvletDataMap = new HashMap<String, ImageAction.ImageCropData>();
	
	private ImageCropData getImageCropData(String servletName){
		
		ImageCropData set = setvletDataMap.get(servletName);
		
		// 데이터가 없으면 생성
		if(set==null){
			
			setvletDataMap.clear();
			ImageCropData tmp = null;
			// 병원 소개 이미지 처리
			tmp = new ImageCropData("image","ajaxCropIntroduceImg.latte",
					Config.IMAGE_HOSPITAL_INTRODUCE_WIDTH, Config.IMAGE_HOSPITAL_INTRODUCE_HEIGHT, 640);
			setvletDataMap.put("ajaxIntroduceImgUpload",tmp);
			setvletDataMap.put("ajaxCropIntroduceImg",tmp);
			// 병원 로고 이미지 처리
			tmp = new ImageCropData("image","ajaxCropLogoImg.latte",
					Config.IMAGE_HOSPITAL_LOGO_WIDTH, Config.IMAGE_HOSPITAL_LOGO_HEIGHT, 640);
			setvletDataMap.put("ajaxLogoImgUpload",tmp);
			setvletDataMap.put("ajaxCropLogoImg",tmp);
			// 병원 메인 상단 이미지 처리
			tmp = new ImageCropData("image","ajaxCropHeaderImg.latte",
					Config.IMAGE_HOSPITAL_HEADER_WIDTH, Config.IMAGE_HOSPITAL_HEADER_HEIGHT, 640);
			setvletDataMap.put("ajaxHeaderImgUpload",tmp);
			setvletDataMap.put("ajaxCropHeaderImg",tmp);
			// 스태프 이미지 처리
			tmp = new ImageCropData("image","ajaxCropStaffImg.latte",
					Config.IMAGE_STAFF_WIDTH, Config.IMAGE_STAFF_HEIGHT, 640);
			setvletDataMap.put("ajaxStaffImgUpload",tmp);
			setvletDataMap.put("ajaxCropStaffImg",tmp);
			//
		}
		
		set = setvletDataMap.get(servletName);
		
		return set;
	}
	
	@RequestMapping(value = {
			"/ajaxLogoImgUpload.latte",
			"/ajaxHeaderImgUpload.latte",
			"/ajaxStaffImgUpload.latte",
			"/ajaxIntroduceImgUpload.latte"
	})
	public @ResponseBody String ajaxImageUpload(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam Map<String, String> params) throws Exception {
		
		String servletName = Common.getServletBaseName(request);
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - "+servletName+".latte");
		
		JSONSimpleBuilder builder = new JSONSimpleBuilder();
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth()){
			builder.add("result", Codes.ERROR_UNAUTHORIZED);
			return builder.build();
		}
		
		// 서블릿에 해당하는 데이터 가져옴
		ImageCropData set = getImageCropData(servletName);
		
		// 작업
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		
		MultipartFile file = multipartRequest.getFile(set.tag_id);
		
		params.put("crop_url", set.crop_url);
		
		String s = cropPreProcess(model, file, params,
				set.img_width, set.img_height, set.thum_size);
		
		builder.add("result", Codes.SUCCESS_CODE);
		
		// ajax form으로 업로드 후, 아래가 없으면 ie 9미만 버전에서 응답이 없음
		try {
			response.flushBuffer();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return s;
	}
	
	@RequestMapping(value = {
			"/ajaxCropLogoImg.latte",
			"/ajaxCropHeaderImg.latte",
			"/ajaxCropStaffImg.latte",
			"/ajaxCropIntroduceImg.latte"
	})
	public @ResponseBody String ajaxCropLogoImg(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam Map<String, String> params) throws Exception {
		
		String servletName = Common.getServletBaseName(request);
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - "+servletName+".latte");
		
		JSONSimpleBuilder builder = new JSONSimpleBuilder();
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth()){
			builder.add("result", Codes.ERROR_UNAUTHORIZED);
			return builder.build();
		}
		
		// 서블릿에 해당하는 데이터 가져옴
		ImageCropData set = getImageCropData(servletName);

		String destImgPath = Config.PATH_TEMP_IMAGE + /*Common.todayPath() + */"";//"/";
		String destImgName = System.nanoTime() + Common.getRandomNumber(10) + ".jpg";
		
		// params에 받아온 파라미터로 원본 파일 경로를 접근,
		// dest 파일에 편집한 이미지를 저장
		//String cropImgData = cropImage(params, destImgPath, destImgName,
		Map<String, String> returnMap = cropImage(params, destImgPath, destImgName,
				set.img_width, set.img_height, sessionContext.getData("s_sid"));

		//Map<String, String> returnMap = new HashMap<String, String>();
		returnMap.put("iid", params.get("iid"));
		returnMap.put("targetId", params.get("targetId"));
		//returnMap.put("imgData", cropImgData);

		return org.json.simple.JSONObject.toJSONString(returnMap);
	}
	
	@RequestMapping(value = "/cancelImgUpload.latte")
	public String cancelImgUpload(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam Map<String, String> params) throws Exception {
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		removeTempImages(sessionContext.getData("s_sid"));

		return "redirect:"+(Common.isValid(params.get("redirectPage"))?params.get("redirectPage"):"home.latte");
	}
}
