package kr.co.petmd.controller.admin.hospital;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.ServletException;

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

import org.apache.commons.io.FilenameUtils;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;


@Controller
@RequestMapping(value="/hospital")
public class AbstractAction {

	@Resource(name="sessionContextFactory")
	ObjectFactory<SessionContext> sessionContextFactory;
	
	protected SessionContext getSessionContext(){
		
		return (SessionContext) sessionContextFactory.getObject();
	}
	
	/**
	 * 메인 메뉴를 가져와 model에 넣음
	 */
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected void putMainMenuToModel(Model model, String sid, String curMenu){
//		{
//		// 메인메뉴 리스트를 가져옴
//		Map s1 = new HashMap<String, Object>();
//		s1.put("parent", "MAIN_MENU");
//		s1.put("id", sid);
//		s1.put("status", "Y");
//		List<Map> mainMenu = SqlDao.getList("COMMON.getByParent", s1);
//		
//		Iterator<Map> iter = mainMenu.iterator();
//		while(iter.hasNext()){
//			Map map = iter.next();
//			s1.put("cmid", map.get("s_cmid"));
//			if(Common.strEqual(map.get("s_group"), curMenu))
//				model.addAttribute("curMenuId", map.get("s_cmid"));
//			
//			Map m1 = CustomizeUtil.putAllToMap(SqlDao.getList("COMMON.getCustomAttrById", map.get("s_cmid")), map, true);
//			m1.put("sid", sid);
//			m1.put("group", map.get("s_group"));
//		}
//		model.addAttribute("mainMenu1", mainMenu);
//		}
		
		
		
		model.addAttribute("hospital_name", getSessionContext().getData("s_hospital_name"));
		
		Map s = new HashMap<String, Object>();
		s.put("parent", "MAIN_MENU");
		//s.put("parent", "s_cmid005");
		s.put("id", sid);
		s.put("status", "Y");
		List<Map> mainMenu = CustomizeUtil.getInstance().getAttributesByParent(s);
		
		model.addAttribute("mainMenu", mainMenu);
		
		// 현재 선택된 메뉴 정보를 찾음
		Map returnMap = null;
		for(Map map:mainMenu){
			if(Common.strEqual(curMenu, (String) map.get("s_group"))){
				model.addAttribute("curMenuId", map.get("s_cmid"));
				returnMap = map;
			}
		}
		
		s.clear();
		
		//model.addAttribute("mainMenu", mainMenu);
	}
	
	/**
	 * 선택된 메인 메뉴 정보를 가져옴 
	 */
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected Map<String, String> getMainMenuInfo(Model model, String sid, String curMenu){
		
		// 메인메뉴 리스트를 가져옴
		Map s = new HashMap<String, Object>();
		s.put("parent", "MAIN_MENU");
		s.put("id", sid);
		s.put("status", "Y");
		s.put("group", curMenu);
		
		// 소식 게시판 가져옴
		Map<String, String> boardMap = SqlDao.getMap("COMMON.getByParent", s);
		model.addAttribute("curMenuId", boardMap.get("s_cmid"));
		s.put("parent", boardMap.get("s_cmid"));
		
		// 소식 게시판 정보를 가져와 합침
		boardMap = CustomizeUtil.putAllToMap(SqlDao.getList("COMMON.getCustomAttr", s), boardMap, true);
		
		return boardMap;
	}
	
	protected void removeTempImages(String sid) {
		
		if(!Common.isValid(sid))
			return;
		
		Map<String, String> params = new HashMap<String, String>();
		params.put("key", "TMP");
		params.put("sid", sid);
		
		// 임시 이미지 전부 삭제
		@SuppressWarnings("rawtypes")
		List<Map> imgList = SqlDao.getList(SQLNamespace.CLIENT_HOSPITAL+"getImageByKey", params);
		@SuppressWarnings("rawtypes")
		Iterator<Map> iter = imgList.iterator();
		while(iter.hasNext()){
			@SuppressWarnings("rawtypes")
			Map map = iter.next();
			
			// 이미지를 실제로 삭제
			String path = Config.IMAGE_PATH_ROOT + map.get("s_image_path");
					
			File f = new File(path);
			// 파일이 없거나 삭제에 성공했을 경우
			if(!f.exists() || f.delete()){
				// 삭제 성공시 DB에서 삭제
				SqlDao.delete("Admin.Hospital.Common.deleteImage", map.get("s_iid"));
			}
		}
	}
	
	
	/**
	 * Temp로 저장된 이미지를 활성화시킴.
	 * 
	 * @param iid		임시 이미지 id
	 * @param newPath	이동시킬 경로
	 * @param code		새 코드값 (임시 이미지 코드 TMP)
	 */
	
	protected void activateTempImage(String iid, String newPath, String code){
		activateTempImage(iid, newPath, code, null);
	}
	
	protected void activateTempImage(String iid, String newPath, String code, String index){
		
		// 업데이트 쿼리 파라미터 맵
		Map<String,String> updateMap = new HashMap<String, String>();
		
		// Temp 이미지 정보
		Map<String,String> temp = SqlDao.getMap("Admin.Hospital.Common.getImage", iid);
		if(temp==null)
			return;
		
		String destImgPath = newPath + Common.todayPath() + "/";
		
		String destImgName = FilenameUtils.getName(temp.get("s_image_path"));
		if(!FileUtil.fileMove(Config.IMAGE_PATH_ROOT+temp.get("s_image_path"), Config.IMAGE_PATH_ROOT+destImgPath+destImgName))
			return;
		updateMap.put("image_path", destImgPath+destImgName);
		
		// 썸네일이 있으면 썸네일도
		if(Common.isValid(temp.get("s_thum_img_path"))){
			String destThumImgName = FilenameUtils.getName(temp.get("s_thum_img_path"));
			if(!FileUtil.fileMove(Config.IMAGE_PATH_ROOT+temp.get("s_thum_img_path"), Config.IMAGE_PATH_ROOT+destImgPath+destThumImgName))
				return;
			updateMap.put("thum_img_path", destImgPath+destThumImgName);
		}
		
		if(Common.isValid(index))			
			updateMap.put("index", index);
		updateMap.put("lkey", code);
		updateMap.put("iid", iid);
		
		SqlDao.update("Admin.Hospital.Common.updateImage", updateMap);
	}
	
	/**
	 * 이미지를 지우고 DB 업데이트
	 * 
	 * @param img_path
	 * @param img_id
	 */
	protected boolean deleteImageAndDBUpdate(String img_path, String thum_img_path, String img_id){
		
		boolean allowDelete = false;
		if(Common.isValid(img_path)){
			File old_file = new File(img_path);
			if(old_file.exists()){
				// 파일 삭제에 성공하면 db 갱신
				if(old_file.delete()){
					allowDelete = true;
				}
			}
			// 파일이 없을 경우 db 갱신
			else{
				allowDelete = true;
			}
		}
		
		if(allowDelete && Common.isValid(thum_img_path)){
			File old_file = new File(thum_img_path);
			if(old_file.exists()){
				// 파일 삭제에 성공하면 db 갱신
				if(old_file.delete()){
					allowDelete = true;
				}
				else{
					allowDelete = false;
				}
			}
			// 파일이 없을 경우 db 갱신
			else{
				allowDelete = true;
			}
		}
		
		if(allowDelete){
			
			if(SqlDao.delete("Admin.Hospital.Common.deleteImage", img_id) > 0)
				return true;
		}
		
		return false;
	}
	
	/**
	 * 편집하기 위해서 이미지 업로드 후 편집용 썸네일 생성
	 * 
	 * @param model
	 * @param file
	 * @param params
	 * @param imgWidth
	 * @param imgHeight
	 * @param thumSize
	 * @return
	 * @throws Exception
	 */
	
	protected String cropPreProcess(Model model, MultipartFile file,
			Map<String, String> params,
			int imgWidth, int imgHeight, int thumSize) throws Exception {
		
		SessionContext sessionContext = getSessionContext();
		
		params.put("image_name", file.getOriginalFilename());
		//params.put("s_sid", params.get("idx"));
		
//		byte[] stream = new byte[12];
//		InputStream is = file.getInputStream();
//		is.read(stream, 0, 10);
//		System.out.println(Common.signatureMatch(stream, "89504E470D0A1A0A"));
//		System.out.println(Common.signatureMatch(stream, "FFD8FFE0XXXX4A464946"));
//		System.out.println(Common.signatureMatch(stream, "FFD8FFE1XXXX45786966"));
//		System.out.println(Common.signatureMatch(stream, "FFD8FFE8XXXX535049464600"));
//		is.close();
		
		//System.out.println(Common.checkImageSignature(stream));

		//String fileName = imagePathTemp + Common.getNanoSecRandomString(4) + "_" + params.get("index") + "." + FilenameUtils.getExtension(file.getOriginalFilename());
		String fileName = Config.PATH_TEMP_IMAGE + System.nanoTime() + Common.getRandomNumber(10) + "." + FilenameUtils.getExtension(file.getOriginalFilename());
		
		try {
			
			// 받아온 파일을 이미지로 변환
			BufferedImage bufferedImage = ImageIO.read(file.getInputStream());
			
			// 이미지 가로 세로 값을 가져옴
			int w = 0;
			int h = 0;
			
			if (bufferedImage != null) {
				w = bufferedImage.getWidth(null);
				h = bufferedImage.getHeight(null);
			}
			else{
				// null 이면 지원하지 않는 이미지 에러
				params.put("result", Codes.ERROR_UNSUPPORTED_IMAGE);
				return JSONObject.toJSONString(params);
			}
			
			params.put("width", w+"");
			params.put("height", h+"");
			
			params.put("base_w", w+"");
			params.put("base_h", h+"");
			
			
			
			params.put("id", sessionContext.getData("s_sid"));
			params.put("lkey", "TMP");
			
			params.put("iid", Common.makeRownumber("iid", System.nanoTime()+""));
			params.put("image_path", fileName);
			params.put("index", SqlDao.getString("Admin.Hospital.Common.getNextImageIndex", params));
			params.put("type", FilenameUtils.getExtension(file.getOriginalFilename()));
			
			// 원본 이미지 저장
			boolean writeSuccess = FileUtil.write(Config.IMAGE_PATH_ROOT + fileName, file);
			//System.out.println(writeSuccess);
			
			if(writeSuccess){
				SqlDao.insert("Admin.Hospital.Common.insertImage", params);
			}
			
			// 크기변환
			
			if(w > h){
				if(w > thumSize){
					double rate = (double)h / (double)w;
					w = thumSize;
					h = (int) (w * rate);
				}
			}
			else{
				if(h > thumSize){
					double rate = (double)w / (double)h;
					h = thumSize;
					w = (int) (h * rate);
				}
			}
			
			params.put("thum_w", w+"");
			params.put("thum_h", h+"");
			
			//if(h > imgHeight)
			//	h = imgHeight;
			
			//** 이미지를 리사이즈한 후 BASE64 코드로 받음 (파일 저장 X)
			bufferedImage = ImageResizer.resize(bufferedImage, w, h, true, true);
			params.put("imgsrc", ImageUtil.getBase64String(bufferedImage, 100));
			
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		}
		
		params.put("crop_w", imgWidth+"");
		params.put("crop_h", imgHeight+"");

		params.put("result", Codes.SUCCESS_CODE);
				
		return JSONObject.toJSONString(params);
	}
	
	@SuppressWarnings("unchecked")
	protected Map<String,String> cropImage(Map<String, String> params,
			String destImgPath, String destImgName, int imgWidth, int imgHeight, String sid)
					throws IOException, ServletException{
		
		Map<String,String> result = new HashMap<String, String>();
		
		// 원본 파일 경로를 가져옴
		Map img = SqlDao.getMap("Admin.Hospital.Common.getImage", params.get("iid"));
		if(img==null){
			result.put("result", Codes.ERROR_NOT_FOUND_IMAGE);
			return result;
		}
		String ori_name = Config.IMAGE_PATH_ROOT + img.get("s_image_path");
		
		String destFullPath = Config.IMAGE_PATH_ROOT + destImgPath;
		
		// 원본 파일 이미지를 불러온다.
		BufferedImage bufferedImage = ImageUtil.getImageInstance(ori_name);
		if(bufferedImage ==null){
			result.put("result", Codes.ERROR_NOT_FOUND_IMAGE);
			return result;
		}
		
		// 이미지를 잘라내고 강제로 비율 조정(잘라내는 x y w h 값은 params에 들어있어야 됨)
		BufferedImage image = cropImageCore(params, bufferedImage);
		// 크기를 강제로 맞춤
		image = ImageResizer.resize(image, imgWidth, imgHeight, true, true);
		// 이미지를 디스크에 씀
		ImageUtil.writeImage(image, destFullPath, destImgName, 100);
		
		// 원본(임시) 파일 삭제(업데이트)
		File ori = new File(ori_name);
		if(ori.delete()){
			//SqlDao.delete("Admin.Hospital.Common.deleteImage", params.get("iid"));
			
			img.put("iid", params.get("iid"));
			img.put("id", sid);
			img.put("lkey", "TMP");
			
			img.put("index", SqlDao.getString("Admin.Hospital.Common.getNextImageIndex", params));
			
			img.put("type", "JPG");
			img.put("image_name", img.get("s_image_name"));
			img.put("image_path", destImgPath+destImgName);
			SqlDao.insert("Admin.Hospital.Common.insertImage", img);
		}
		
		result.put("result", Codes.SUCCESS_CODE);
		result.put("imgData", ImageUtil.getBase64String(image, 100));
		return result;
		
		// 자른 이미지를 클라이언트에 보내기 위해 base64인코딩
		//return ImageUtil.getBase64String(image, 100);
	}
	
	protected BufferedImage cropImageCore(Map<String, String> params, BufferedImage image){
		
		int full_w = image.getWidth(null);
		int full_h = image.getHeight(null);
		
		// 자를 좌표
		int x1 = Common.parseInt(params.get("x1"));
		int y1 = Common.parseInt(params.get("y1"));
		int x2 = Common.parseInt(params.get("x2"));
		int y2 = Common.parseInt(params.get("y2"));
		
		// 자를 영역의 너비 높이 계산
		int width = x2 - x1;
		int height = y2 - y1;
		
		// html의 img태그의 가로 세로
		int plate_width = Common.parseInt(params.get("plate_width"));
		int plate_height = Common.parseInt(params.get("plate_height"));
		
		// HTML의 img 태그의 크기에 비례해서 크기 조절
		float rate_w = 1;
		float rate_h = 1;
		
		//if(plate_width != 0 && crop_w != plate_width){
		//	rate_w = (float)crop_w / (float)plate_width;
		//}
		//if(plate_height != 0 && crop_h != plate_height){
		//	rate_h = (float)crop_h / (float)plate_height;
		//}
		
		// 원본 이미지와 자를 크기의 비율 계산
		
		if(plate_width != full_w){
			rate_w = (float)full_w / (float)plate_width;
		}
		rate_h = rate_w;
		
		// 비율로 실제 이미지의 자를 좌표 계산
		width = (int) (rate_w * width);
		height = (int) (rate_h * height);
		
		if(width < 1 || height < 1)
			return null;
		
		if(width > full_w)
			width = full_w;
		
		if(height > full_h)
			height = full_h;
		
		x1 = (int) (rate_w * x1);
		y1 = (int) (rate_h * y1);
		
		// 이미지를 잘라냄
		ImageCropUtil icu = new ImageCropUtil(image);
		try{
			return icu.crop(x1, y1, width, height).getBufferedImage();
		}
		catch(Exception e){
			return null;
		}
	}
}
