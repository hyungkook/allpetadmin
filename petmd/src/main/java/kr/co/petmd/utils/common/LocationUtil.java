package kr.co.petmd.utils.common;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;


import kr.co.petmd.utils.admin.Config;
import kr.co.petmd.utils.common.Common;

public class LocationUtil {
	public static Map<String, String> getLocation(Map<String, String> map, String address){
		String Search = ""; 

	    int pre_len = 0 ;        
	    String Lng = ""; 
	    String nLat = ""; 

		Search = address;
	 
		try {
			if( Search == null || Search .equals("") || Search .equals("null") ){
				Search = "강남구 역삼동 823-30 라인빌딩"; 
			}
		     //Search = Search.replaceAll(" ", "");  
			Search  = java.net.URLEncoder.encode(Search,"KSC5601"); 

		    int c; 
		    URL mapXmlUrl = new URL("http://openapi.map.naver.com/api/geocode.php?key="+Config.NAVER_MAP_KEY+"&encoding=euc-kr&coord=LatLng&query="+Search );     // URL 객체 mapXmlUrl을 생성 
		    URLConnection mapCon = mapXmlUrl.openConnection();	// openConnection() 메소드를 이용하여 URLConnection 객체 mapCon을 생성 

		    int len = mapCon.getContentLength(); 
		    String inputSt = ""; 
		 
			if (len > 0) 
		    { 
				InputStream input = mapCon.getInputStream(); 
		        InputStreamReader inputst = new InputStreamReader(input, "euc-kr"); 
				
		        int i = len; 
		        while (((c = inputst.read()) != -1) && (--i > 0))
				{ 
		            inputSt = inputSt + (char)c; 
		        } 
		        input.close(); 
		    } 
			else 
			{
		        //System.out.println("내용이 없음"); 
		    } 
		    // 여기서부터 xml에서 필요한 정보 파싱 
			
		    while( inputSt.indexOf("</item>") > -1 )
			{
				int first = 1; 
		        Lng = inputSt.substring( inputSt.indexOf("<x>")+3, inputSt.indexOf("</x>") ) ; //위도
		        nLat = inputSt.substring( inputSt.indexOf("<y>")+3, inputSt.indexOf("</y>") ) ; //경도
		        //System.out.println(resultAddress);
		        inputSt = inputSt.substring( inputSt.indexOf("</item>")+7, inputSt.length() ) ; 
		        
		        if ( pre_len == inputSt.length()) 
		            break; 
		        pre_len=inputSt.length(); 
					if ( first == 1)  // 처음 검색된 주소만 사용. 
		            break; 
		    } 
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

		if (nLat.equals("")) nLat = null;
		if (Lng.equals("")) Lng = null;
		
		map.put("n_latitude", nLat);
		map.put("n_longitude", Lng);
		
		return map;
	}

	public static Map<String, String> getLocationDaum(Map<String, String> map, String address, String daumMapKey) {
		String Search = ""; 
	    int pre_len = 0 ;        
	    String Lng = ""; 
	    String nLat = ""; 
		Search = address;
	 
		try {
			if( Search == null || Search .equals("") || Search .equals("null") ){
				Search = "강남구 역삼동 823-30 라인빌딩"; 
			}
			Search  = java.net.URLEncoder.encode(Search,"UTF-8"); 

		    int c; 
		    URL mapXmlUrl = new URL("http://apis.daum.net/local/geo/addr2coord?apikey="+daumMapKey+"&q="+Search+"&output=xml");     // URL 객체 mapXmlUrl을 생성 
		    URLConnection mapCon = mapXmlUrl.openConnection();	// openConnection() 메소드를 이용하여 URLConnection 객체 mapCon을 생성 

		    int len = mapCon.getContentLength(); 
		    String inputSt = ""; 
		 
			if (len > 0) 
		    { 
				InputStream input = mapCon.getInputStream(); 
		        InputStreamReader inputst = new InputStreamReader(input, "UTF-8"); 
				
		        int i = len; 
		        while (((c = inputst.read()) != -1) && (--i > 0))
				{ 
		            inputSt = inputSt + (char)c; 
		        } 
		        input.close(); 
		    }
			else 
			{
		        System.out.println("No Contents"); 
		    } 
		    // 여기서부터 xml에서 필요한 정보 파싱 
			
		    while( inputSt.indexOf("</item>") > -1 )
			{
				int first = 1; 
		        Lng = inputSt.substring( inputSt.indexOf("<lng>")+5, inputSt.indexOf("</lng>") ) ; //위도
		        nLat = inputSt.substring( inputSt.indexOf("<lat>")+5, inputSt.indexOf("</lat>") ) ; //경도
		        inputSt = inputSt.substring( inputSt.indexOf("</item>")+7, inputSt.length() ) ; 
		        
		        if ( pre_len == inputSt.length()) 
		            break; 
		        pre_len=inputSt.length(); 

					if ( first == 1)  // 처음 검색된 주소만 사용. 
		            break; 
		    } 
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		
		if (Lng.equals("")) Lng = null;
		if (nLat.equals("")) nLat = null;
		
		map.put("n_latitude", nLat);
		map.put("n_longitude", Lng);
		
	    return map;
	}
	
	public static Map<String, String> getLocation(Map<String, String> map, String... strs) {
		
		StringBuffer sb = new StringBuffer();
		for(String str : strs){
			sb.append(Common.isNull(map.get(str)));
		}
		//String addr_sido = Common.isNull(map.get("old_addr_sido"));
		//String addr_gugun = Common.isNull(map.get("old_addr_sigungu"));
		//String addr_dong = Common.isNull(map.get("old_addr_extra"));
		//String addr_ri = Common.isNull(map.get("old_addr_etc"));
		//String addr_detail = Common.isNull(map.get("s_addr_etc"));
		return getLocation(map, sb.toString());//addr_sido + " "+ addr_gugun + " "+ addr_dong + " "+ addr_ri, "");
	}
	
	/**
	 * 주소값을 인자로 나눠 받아 네이버 api로 위성 좌표 검색에 실패했다면
	 * 다음Map api로 재시도 합니다.
	 * 다시 또 실패하였다면 address2 주소를 번지만 뽑아내서  
	 * @param address1
	 * @param address2
	 * @param naverMapKey
	 * @return
	 */
	public static Map<String, String> getLocation(Map<String, String> map, String address1, String address2) {
		map = getLocation(map, address1 + " " + address2);
		if (Common.isValid(map.get("n_latitude")) == false) {
			System.out.println("[MAP API] Address corresponding to the Naver Map data do not have the satellite coordinates.");
			System.out.println("[MAP API] Daum maps, try a search");
			map = getLocationDaum(map, address1 + " " + address2, Config.DAUM_MAP_KEY);
			if (Common.isValid(map.get("n_latitude")) == false) {
				System.out.println("[MAP API] Wrong address2, the search failed.");
				System.out.println("[MAP API] To change the address2 and retry.");
				map = getLocationDaum(map, address1 + " " + getBungi(address2), Config.DAUM_MAP_KEY);
			}
			System.out.println("[MAP API] gpsVo.getN_latitude() : " + map.get("n_latitude"));
			System.out.println("[MAP API] gpsVo.getN_longitude() : " + map.get("n_longitude"));
		}
		return map;
	}
	
	/**
	 * 번지만 분류하기.
	 * 단, 숫자와 '-' 기호 아닌 경우 검색을 종류하고 검색된 내용을 리턴.ㄴ
	 * @param address2
	 * @return
	 */
	private static String getBungi(String address2) {
		String bungiString = null;
		if (address2 == null || address2.equals("")) {
			return "";
		}
		String rex = "^([0-9-])*$";
		String str = address2.trim();
		for (int i = 0; i < str.length(); i++) {
			if (i < str.length()-1) { 
				boolean bool = Pattern.matches(rex, str.substring(i, i+1));
				if (bool == false) {
					bungiString = str.substring(0, i);
					break;
				}
			}
		}
		return bungiString;
	}
	
//	public static void main(String[] args) {
//		GetLocation gl = new GetLocation();
////		Date date = new Date();
////		SimpleDateFormat sdf = new SimpleDateFormat("yyMM");
////		System.out.println(sdf.format(date));
//		Map<String, String> map = new HashMap<String, String>();
//		
//		String addr_sido = map.put("s_addr_sido", "서울");
//		String addr_gugun = map.put("s_addr_gugun", "서초구");
//		String addr_dong = map.put("s_addr_dong", "서초동");
//		//String addr_ri = map.put("s_addr_ri", "");
//		String addr_detail = map.put("s_addr_etc", "1327-27  한화오벨리스크 610호");
//			Map<String, String> gpsvo = gl.getLocation(map);
//			System.out.println(gpsvo);
////			GPSVO gpsvo = gl.getLocation("서울 강남구 역삼동 837번지", AppStatus.NAVER_MAP_KEY);
////			GPSVO gpsvo = gl.getLocationDaum("서울 강남구 역삼동 837", AppStatus.NAVER_MAP_KEY);
////			System.out.println(gl.getBungi("837-1번지"));
////			System.out.println(gpsvo.getN_latitude());
////			System.out.println(gpsvo.getN_longitude());
//			// TODO Auto-generated catch block
//	}
}
