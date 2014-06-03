package kr.co.petmd.utils.admin;

import java.io.File;
import java.util.Map;

import kr.co.petmd.utils.common.Common;


public class Config {
	
	/* 
	 * Develop : YCNa (ADVentures)
	 *
	 * BeautyLatte : Application Setup Config
	 * 
	 */
	
	private static Config config = null;	
	private static Map<String, String> configMap = null;
	
//	private static String PROJECT_NAME = "allpet";
	private static String PROJECT_NAME = "petmd";
	private static String CONTEXT_ROOT = "petmdadmin";
	
	public static String REFERER = "ALLPET";			// 유저 회원가입시 가입 경로 
	
	public static String DEFAULT_CHARSET = "UTF-8";
	public static String DEFAULT_CHARSET_L = "utf-8";
	
	// DOMAIN
	
	// live
	
	// test

	public static String dns 		= "http://h.allpethome.co.kr/";
//	public static String img_dns 	= "http://h.allpethome.co.kr/";
	public static String img_dns 	= File.separator + CONTEXT_ROOT + "/getImages/";
	
	// Develop - true/false
	public static boolean DEBUG = false;

	// Template Path (Client)
	public static String JSPATH 	= "../common/template/js";
	public static String CSSPATH 	= "../common/template/css";
	public static String FONTPATH	= "common/template/font";
	//public static String IMGPATH	= img_dns + "/common/template/images";
	//public static String IMGPATH	= dns + "/common/template/images";
	public static String IMGPATH	= "../common/template/images";
	public static String IMGPATH_OLD	= "../common/template/images/old";

	// SMS Info
	public static String ADV_ID		= "ADV_00000000000000000000000000000";
	public static String ADV_SMS_ID	= "adventures";
	public static String ADV_TELNO		= "16661609";
	
	// Page Count Info
	public static int SHOP_PAGE_COUNT 		= 15;
	public static int BOARD_PAGE_COUNT 	= 10;
	
	// Page Setting
	public static int PAGE_END_ROW = 30;
		
	// Common split char
	public static String SPLIT_CHAR = "!#@_ADV_&^%()!";
		
	public static String PATH_MAIL_LAYOUT = "/WEB-INF/views/client/common/mail_layout/default.txt";
	
	public static String IMAGE_PATH_ROOT = "/resource/";
	
	public static String IMAGE_ROOT = "/resource/"+PROJECT_NAME;
	public static String PATH_TEMP_IMAGE = IMAGE_ROOT+"/temp/";
	public static String PATH_HOSPITAL_IMAGE = IMAGE_ROOT+"/hospital/";
	public static String PATH_STAFF_IMAGE = IMAGE_ROOT+"/staff/";
	
	
	public static String TOTAL_SUPER_ADMIN_ID = "admin";
	
	// Check Text
	public static String []validateNickNames = {
													"뷰띠라떼",
													"뷰티라떼",
													"BEAUTYLATTE",
													"beautylatte",
													"BeautyLatte",
													"메디라떼",
													"medilatte",
													"MediLatte",
													"admin",
													"administrator",
													"관리자",
													"뚜",
													"운영자",
													"관리인",
													""
												};
	
	// API
	public static String NAVER_SEARCH_KEY = "e5c7e6345fde45b560a5e0b7e99ab82e";
	
	/** 지도 user key */
	public static String NAVER_MAP_KEY = "3655d60adc511e2fa3586d78a2ec289d";
	public static String DAUM_MAP_KEY = "70e6396f64364d307d16899c5a90cb9811e02ffa";
	
	// LOG PATH
	public static String LOG_PATH_ROOT 		= "/mnt/SERVICE_LOG/petmd";
	public static String LOG_PATH_DEV 			= "d:/log";
	public static String LOG_PATH_LOGIN 		= LOG_PATH_ROOT+"/login";
	public static String LOG_PATH_REQUEST_URL 	= LOG_PATH_ROOT+"/request_url";
	public static String LOG_PATH_ERROR	 	= LOG_PATH_ROOT+"/error";

	
	public static String AUTH_HOSPITAL = "HOSPITAL";
	public static String AUTH_TOTAL = "TOTAL";
	
	public static String PERMISSION_KEY_TOTAL = "admin_permission";
	
	public static int IMAGE_HOSPITAL_HEADER_WIDTH = 800;
	public static int IMAGE_HOSPITAL_HEADER_HEIGHT = 450;
	public static int IMAGE_HOSPITAL_LOGO_WIDTH = 130;
	public static int IMAGE_HOSPITAL_LOGO_HEIGHT = 130;
	public static int IMAGE_HOSPITAL_INTRODUCE_WIDTH = 718;
	public static int IMAGE_HOSPITAL_INTRODUCE_HEIGHT = 430;
	public static int IMAGE_STAFF_WIDTH = 150;
	public static int IMAGE_STAFF_HEIGHT = 200;
	public static int IMAGE_IMAGE_BOARD_THUM_WIDTH = 450;
	public static int IMAGE_IMAGE_BOARD_THUM_HEIGHT = 450;
	
	public Config() {
		config = this;
	}
	
	public static Config getConfig(){
		return new Config();
	}
	
	public Map<String, String> getConfigMap(){
		if(configMap == null){
			configMap = Common.getFieldMap(config);	
		}
		
		return configMap;
	}
}
