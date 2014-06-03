package kr.co.petmd.utils.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.net.URLDecoder;
import java.security.MessageDigest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FilenameUtils;

import sun.misc.Compare;

import com.sun.xml.internal.bind.v2.runtime.unmarshaller.XsiNilLoader.Array;


public class Common {
	
	public static String isNull(String str) {
		if (str == null || str.equals("null")) {
			str = "";
		}
		return str;
	}

	public static String isNull(String str, String rtn) {
		if (str == null || str.equals("null")) {
			str = rtn;
		}
		
		if (str.equals("")) {
			str = rtn;
		}
		
		return str;
	}
	
	/*
	 * 문자 -> 정수형으로 변환
	 */
	public static int IntConvert(String str) {
		int cStr = Integer.parseInt(str);

		return cStr;
	}

	/*
	 * 문자 -> 정수형으로 변환 NULL 이면 숫자 reInt을 반환
	 */
	public static int IntConvertNvl(String str, int reInt) {
		if (str == null) {
			return reInt;
		}

		if (str.equals("")) {
			return reInt;
		}

		int cStr = Integer.parseInt(str);

		return cStr;
	}
	
	/**
	 * 이메일 정규식 체크
	 */
	public static boolean isValidEmail(String inputStr) {
		boolean err = true;
		String regex = "[\\w\\~\\-\\.]+@[\\w\\~\\-]+(\\.[\\w\\~\\-]+)+"; 
		
		Pattern p = Pattern.compile(regex);
		Matcher m = p.matcher(inputStr);
		if (!m.matches()) {
			err = false;
		}
		return err;
	}
	
	/**
	 * 자릿수 갯수를 넣어주면 된다
	 * @param cnt
	 * @return
	 */
	public static String getRandomNumber(int cnt){
		String value = "";
		
		for (int i = 0; i < cnt; i++) {
			value += ""+(int)(Math.random() * 10);
		}
		return value;
	}
	
	/**
	 * DB에 넣을 현재 날짜, 시간 리턴
	 * @return
	 */
	public static String today() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.KOREA);
		return sdf.format(new Date());
	}
	
	public static String getRelpaceAll(String str, String regex, String replacement) {
		String retStr = "";
		if (str == null || (str != null && str.length() < 1)) {
			return "";
		}
		if (regex == null || (regex != null && regex.length() < 1)) {
			return str;
		}
		if (str.indexOf(regex) == -1) {
			return str;
		}
		for (int i = 0, j = 0; (j = str.indexOf(regex, i)) > -1; i = j + regex.length()) {
			retStr += (str.substring(i,  j) + replacement);
		}
		return retStr + str.subSequence(str.lastIndexOf(regex) + regex.length(), str.length());
	}
	
	

	/** 
	 * 클래스 유틸
	 * @author 조원권
	 * */

	public static Map<String, String> getFieldMap(Object o){
		Map<String, String> map = new HashMap<String, String>();
		Class<? extends Object> c = o.getClass();
		 
		 
		Field f[] = c.getFields();
		
		for (Field field : f) {
			String fieldName = field.getName();
			try {
				Object resultObject = field.get(o);
				if(resultObject != null){
					map.put(fieldName, resultObject.toString());
				}
			} catch (Exception e) {
				map.put(fieldName, "isEmpty");
			}
		}
		
		return map;
	}
	
	/**
	 * MD5 암호화
	 * @param str
	 * @return
	 */
	public static String encryptDataMD5(String str) {
		StringBuilder sb = new StringBuilder();
		try{
			MessageDigest md5 = MessageDigest.getInstance("MD5");
			md5.update(str.getBytes());
			byte[] md5encrypt = md5.digest(); 

			for(int i = 0 ; i < md5encrypt.length ; i++){
				sb.append(Integer.toString((md5encrypt[i]&0xff) + 0x100, 16).substring(1));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sb.toString();
	}
	
	public static String encryptDataMD5(int n) {
		return encryptDataMD5(String.valueOf(n));
	}
	
	public static String encryptDataMD5(long n) {
		return encryptDataMD5(String.valueOf(n));
	}
	
	/**
	 * 쿠키 이름으로 값을 가져오는 메소드
	 * @param cookieName
	 * @param request
	 * @return cookieValue
	 */
	public static String getCookieValue(String cookieName, HttpServletRequest request) {
		String value = "";
		Cookie[] cookies = request.getCookies();
		if (cookies == null) {
			return null;
		}

		for (int i = 0; i < cookies.length; i++) {
			if (cookieName.equals(cookies[i].getName())) {
				try {
					value = java.net.URLDecoder.decode(cookies[i].getValue(),"UTF-8");
				} catch (UnsupportedEncodingException e) {

					e.printStackTrace();
					value = cookies[i].getValue();
				}
				break;
			}
		}
		
		return value;
	}
	
	public static void setCookieValue(String key, String value, HttpServletResponse response){
		Cookie cookie = new Cookie(key, value);
	    cookie.setMaxAge(-1);            // 쿠키 유지 기간 - 30일
	    cookie.setPath("/");                               // 모든 경로에서 접근 가능하도록
	    
	    response.addCookie(cookie);                // 쿠키저장
	
	}
	
	public static void setCookieValue(String key, String value, HttpServletResponse response, int limit){
		Cookie cookie = new Cookie(key, value);
		cookie.setMaxAge(limit);            // 쿠키 유지 기간 - 30일
		cookie.setPath("/");                               // 모든 경로에서 접근 가능하도록
		
		response.addCookie(cookie);                // 쿠키저장
		
	}
	
	/**
	 * Rownumber 생성
	 */
	public static String makeRownumber(String head, String id) {
		
		Calendar oCalendar = Calendar.getInstance();
		
		if (!head.equals("")) {
			head = head + "_";
		}
		
		int len = lengthOf(head);
		
		// 8 = random(4) + msec(3)
		String rn = head + encryptDataMD5(id+getRandomNumber(4)).substring(len+7)
				+ ""
				+ encryptDataMD5(oCalendar.get(Calendar.YEAR)
				+ "-"
				+ (oCalendar.get(Calendar.MONTH) + 1)
				+ "-"
				+ oCalendar.get(Calendar.DAY_OF_MONTH)
				+ "-" +
				oCalendar.get(Calendar.HOUR_OF_DAY)
				+ "-" + oCalendar.get(Calendar.MINUTE)
				+ "-" + oCalendar.get(Calendar.SECOND)
				+ "-" + oCalendar.get(Calendar.MILLISECOND)
				+ "-" + getRandomNumber(4))
				+getRandomNumber(4)+""
				+String.format("%03d", oCalendar.get(Calendar.MILLISECOND));
				
		return rn;
	}
	
	/**
	 * 시스템 나노초 뒤에 8자리 + 랜덤 char 카운터 갯수 추가한 String 값
	 * 네이밍 규칙에 사용하면 됨
	 * @param cnt
	 * @return
	 */
	public static String getNanoSecRandomString(int cnt){
		String s = String.valueOf(System.nanoTime());
		s = s.substring(s.length()/2 - 1, s.length());
		return s + getRandom09azAZ(cnt);
	}
	
	/**
	 * 랜덤으로 0~9 a~Z 까지의 스트링 n개를 반환
	 * @return
	 */
	public static String getRandom09azAZ(int cnt){
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < cnt; i++) {
			sb.append(getRandom09azAZ());
		}
		String result = sb.toString();
		sb.delete(0, sb.length());
		sb = null;
		return result;
	}
	
	/**
	 * 랜덤으로 0~9 a~Z 까지의 스트링 1개를 반환
	 * @return
	 */
	public static String getRandom09azAZ(){
		int i = (int)(48 + (Math.random() * 74));
		Character c = (char)i; 
		String result = getRegular09azAZ(c.toString());
		if(result.equals("")){
			result = getRandom09azAZ();
		}
		
		return result;
	}
	
	/**
	 * 정규식변환 입력값에서 숫자와 알파벳만 리턴
	 * @param src
	 * @return
	 */
	public static String getRegular09azAZ(String src){
		/*String regex = "[0-9]";
		
		Pattern p = Pattern.compile(regex);
		return p.matcher(src).replaceAll("");*/
		
		String match = "[^\uAC00-\uD7A3xfe0-9a-zA-Z\\s]";
	      
	      return src.replaceAll(match, "");
	}
	
	/**
	 * 이미지 저장할 PATH 리턴
	 * yyyy/MM/dd
	 * @return
	 */
	public static String todayPath() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd", Locale.KOREA);
		return sdf.format(new Date());
	}
	
	public static boolean isValid(String str) {
		boolean bool = false;
		if (str != null && !str.equals("")) {
			bool = true;
		}
		return bool;
	}
	
	public static boolean isValid(List list) {
		boolean bool = false;
		if (list != null && list.size() > 0) {
			bool = true;
		}
		return bool;
	}
	
	public static boolean isValid(String[] str) {
		boolean bool = false;
		if (str != null && str.length > 0) {
			bool = true;
		}
		return bool;
	}
	
	public static boolean isValid(@SuppressWarnings("rawtypes") Map map) {
		
		if (map != null && !map.isEmpty()) {
			return true;
		}
		return false;
	}
	
	public static String getSumString(String[] inStr, String division) {
		
		if (Common.isValid(inStr)) {
			StringBuilder str = new StringBuilder();
			
			for (int i = 0; i < inStr.length; i++) {
				if(!Common.isValid(inStr[i]))
					continue;
				if (i != 0) {
					//str += division;
					str.append(division);
				}
				//str += inStr[i];
				str.append(inStr[i]);
			}
			
			return str.toString();
		} else {
			return null;
		}
	}
	
	/**
	 * 두 인자가 같은 문자열인지 확인
	 * 둘 다 null일 경우도 같다고 판단.
	 * 
	 * @author 박주엽
	 * @date 2013. 10. 18.
	 * 
	 * @param str1
	 * @param str2
	 * @return
	 */
	public static boolean strEqual(String str1, String str2){
		
		if(str1 == null && str2 == null)
			return true;
		else if(str1 == null || str2 == null)
			return false;
		
		return str1.equals(str2);
	}
	
	public static boolean strEqualNN(String str1, String str2){

		if(str1 == null || str2 == null)
			return false;
		
		return str1.equals(str2);
	}
	
	public static boolean strEqual(Object str1, Object str2){
		
		if(str1 == null && str2 == null)
			return true;
		
		else if(str1 == null || str2 == null)
			return false;
		
		return (((Object)str1)+"").equals(((Object)str2)+"");
	}
	
	public static boolean strEqualNN(Object str1, Object str2){
		
		if(str1 == null || str2 == null)
			return false;
		
		return (((Object)str1)+"").equals(((Object)str2)+"");
	}
	
	/**
	 * 인자로 받은 모든 배열들의 길이가 같을 경우 true 리턴
	 * 배열이 null 일 경우 길이를 0 으로 판단
	 * 
	 * @author 박주엽
	 * @date 2013. 10. 18.
	 * 
	 * @param arrs
	 * @return
	 */
	public static boolean allEqualLength(Object[]... arrs){
		
		int ori_len = 0;
		int eq_len = 1;
		int pre_len = 0;
		int cur_len = 0;
		
		for(Object[] arr:arrs){
			
			if(arr == null)
				cur_len = 0;
			else
				cur_len = arr.length;
			
			ori_len++;
			//System.out.println("ori_len "+ori_len+" cur_len "+cur_len);
			if(ori_len == 1){
				pre_len = cur_len;
				continue;
			}
			
			if(cur_len == pre_len)
				eq_len++;
			
			//System.out.println("ori_len "+ori_len+" cur_len "+cur_len+" pre_len "+pre_len+" eq_len "+eq_len);
			if(eq_len != ori_len)
				return false;
			
			pre_len = cur_len;
		}
		
		return true;
	}
	
	/**
	 * 두 배열의 길이가 같은지 판단
	 * null일 경우 false
	 * 
	 * @author 박주엽
	 * @date 2013. 10. 18.
	 * 
	 * @param arr1
	 * @param arr2
	 * @return
	 */
	public static boolean equalLengthNotNull(Object[] arr1, Object[] arr2){
		
		if(arr1 == null || arr2 == null)
			return false;
		
		return arr1.length == arr2.length;
	}
	
	public static String capitalize(String str){
		
		if(Common.isValid(str)){
			
			return str.substring(0, 1).toUpperCase()+str.substring(1);
		}
		else
			return str;
	}
	
	/**
	 * 문자열을 정수형으로 변환, 실수 문자열도 정수로 변환
	 * 
	 * @author 박주엽
	 * @date 2013. 10. 18.
	 * 
	 * @param str
	 * @return
	 */
	public static int parseInt(String str){
		
		try{
			return (int)Float.parseFloat(str);
			//if(!str.equals(""))
				//return Integer.parseInt(str);
		}
		catch(Exception e){
			return 0;
		}
	}
	
	public static int parseInt(String str, int fail_value){
		
		try{
			return (int)Float.parseFloat(str);
			//if(!str.equals(""))
				//return Integer.parseInt(str);
		}
		catch(Exception e){
			return fail_value;
		}
	}
	
	public static int lengthOf(String str){
		
		if(str == null)
			return 0;
		else
			return str.length();
	}
	
	public static int lengthOf(Object[] arr){
		
		if(arr == null)
			return 0;
		else
			return arr.length;
	}
	
	public static int lengthOf(List<?> list){
		
		if(list == null)
			return 0;
		else
			return list.size();
	}
	
	public static int lengthOf(Map<?,?> map){
		
		if(map == null)
			return 0;
		else
			return map.size();
	}
	
	/**
	 * List<Map>에서 Map의 특정 키값으로만 구성된 배열을 생성하여 리턴
	 * 
	 * @author 박주엽
	 * @date 2013. 10. 18.
	 * 
	 * @param original
	 * @param key
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static String[] extractArray(List<Map> original, String key){
		
		if(original == null)
			return null;
		
		String[] arr = new String[original.size()];
		int index = 0;
		int size = arr.length;
		
		Iterator<Map> iter = original.iterator();
		while(iter.hasNext()){
			Map map = iter.next();
			
			if(index < size){
				arr[index] = (String) map.get(key);
				index++;
			}
		}
		
		return arr;
	}
	
	/**
	 * original과 compares를 비교하여 compares에 없는 것들만 original에서 빼내어 배열로 반환
	 * 
	 * @author 박주엽
	 * @date 2013. 11. 27.
	 * 
	 * @param original
	 * @param originKey
	 * @param compares
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static String[] nonexistArray(List<Map> original, String originKey, String[] compares){
		
		if(original == null)
			return new String[0];
		
		int size = compares==null?0:compares.length;
		
		ArrayList<String> resultArr = new ArrayList<String>();

		Iterator<Map> iter = original.iterator();
		while(iter.hasNext()){
			Map map = iter.next();
			String val = (String) map.get(originKey);
			
			boolean exist = false;
			
			for(int i = 0; i < size; i++){
				if(Common.strEqual(compares[i],val)){
					exist = true;
					break;
				}
			}
			
			if(!exist){
				resultArr.add(val);
			}
		}
		
		return resultArr.toArray(new String[resultArr.size()]);
	}
	
	@SuppressWarnings("rawtypes")
	public static ArrayList<Map> nonexistArrayList(List<Map> original, String originKey, String[] compares){
		
		if(original == null)
			return new ArrayList<Map>();
		
		int size = compares.length;
		
		ArrayList<Map> resultArr = new ArrayList<Map>();

		Iterator<Map> iter = original.iterator();
		while(iter.hasNext()){
			Map map = iter.next();
			String val = (String) map.get(originKey);
			
			boolean exist = false;
			
			for(int i = 0; i < size; i++){
				if(Common.strEqual(compares[i],val)){
					exist = true;
					break;
				}
			}
			
			if(!exist){
				resultArr.add(map);
			}
		}
		
		return resultArr;
	}
	
	@SuppressWarnings("rawtypes")
	public static void divideOnExist(List<Map> original, String originKey, String[] compares, ArrayList<Map> existList, ArrayList<Map> nonexistList){
		
		int size = compares.length;

		Iterator<Map> iter = original.iterator();
		while(iter.hasNext()){
			Map map = iter.next();
			String val = (String) map.get(originKey);
			
			boolean exist = false;
			
			for(int i = 0; i < size; i++){
				if(Common.strEqual(compares[i],val)){
					exist = true;
					existList.add(map);
					break;
				}
			}
			
			if(!exist){
				nonexistList.add(map);
			}
		}
	}
	
	/**
	 * List<Map>에서 지정된 키의 값으로 이루어진 맵을 생성하여 리턴
	 * 
	 * @author 박주엽
	 * @date 2013. 11. 12.
	 * 
	 * @param list
	 * @param key_key
	 * @param value_key
	 * @return
	 */
	public static Map<String, String> listToMap(List list, String key_key, String value_key){
		
		Map<String, String> resultMap = new HashMap<String, String>();
		
		if(list==null)
			return resultMap;
		
		Iterator iter = list.iterator();
		while(iter.hasNext()){
			Map map = (Map) iter.next();
			// int 값이 올 경우 Object로 캐스팅을 거치지 않으면 캐스팅에러 발생
			Object keyobj = map.get(key_key);
			Object valueobj = map.get(value_key);
			resultMap.put(keyobj+"", valueobj+"");
		}
				
		return resultMap;
	}
	
	
	/**
	 * String[] request.getParameters(key) 를 여러개 사용할 경우
	 * key1 key2... 로 이루어진 Map의 배열로 변환
	 * 
	 * @author 박주엽
	 * @date 2013. 11. 14.
	 * 
	 * @param request
	 * @param keys
	 * @return
	 */
	public static ArrayList<Map<String, String>> convertToMapArray(HttpServletRequest request, String... keys){
		
		ArrayList<Map<String, String>> arr = new ArrayList<Map<String, String>>();
		
		Map<String,String[]> requestMap = new HashMap<String,String[]>();
		int len = -1;
		
		// key 값에 해당하는 배열을 request에서 빼내어
		// map 에 key 값으로 넣음
		// 각 배열의 길이를 재어 len에 저장, 길이가 다른 배열이 있을 경우 null
		for(String key:keys){
			if(Common.isValid(key)){
				int new_len = Common.lengthOf(request.getParameterValues(key));
				if(len == -1)
					len = new_len;
				else if(len != new_len)
					return null;
				requestMap.put(key,request.getParameterValues(key));
			}
		}
		
		// map에 저장된 각 배열을 참조하여 map list를 생성
		for(int i = 0; i < len; i++){
			
			Map<String,String> map = new HashMap<String,String>();
			
			for(String key:keys){
				
				map.put(key, requestMap.get(key)[i]);
			}
			
			arr.add(map);
		}
		
		return arr;
	}
	
	/**
	 * list<map>에서 key - value가 매칭되는 map이 존재하는가.
	 * 
	 * @author 박주엽
	 * @date 2013. 11. 18.
	 * 
	 * @param list
	 * @param key
	 * @return
	 */
	public static boolean isExist(List<Map> list, String key, String value){
		
		Iterator<Map> iter = list.iterator();
		while(iter.hasNext()){
			Map map = iter.next();
			if(Common.strEqual((String) map.get(key),value))
				return true;
		}
		return false;
	}
	
	public static Map<String,Map> createSearchMap(List<Map> list, String key){
		
		Map<String, Map> resultMap = new HashMap<String, Map>();
		
		if(list==null)
			return resultMap;
		
		Iterator iter = list.iterator();
		while(iter.hasNext()){
			Map map = (Map) iter.next();
			// int 값이 올 경우 Object로 캐스팅을 거치지 않으면 캐스팅에러 발생
			Object keyobj = map.get(key);
			resultMap.put(keyobj+"", map);
		}
				
		return resultMap;
	}
	
	/**
	 * Integer를 자리수 맞춰서 문자열로 변환
	 * @author 박주엽
	 * @date 2013. 11. 15.
	 * 
	 * @param origin 입력 Integer
	 * @param padding 빈자리에 넣을 문자열
	 * @param size 자리수
	 * @param overflow_cut 만약 size보다 더 클 경우 잘라낼거면 true
	 * @return
	 */
//	public static String lpad(int origin, String padding, int size, boolean overflow_cut){
//		
//		String s = origin+"";
//		
//		int len = s.length();
//		
//		if(overflow_cut && len > size){
//			
//			return s.substring(0, size);
//		}
//		
//		String pad = "";
//		
//		for(int i = 0; i < size - len; i++){
//			
//			pad += padding;
//		}
//		
//		return pad+s;
//	}
	
	public static String rpad(int origin, String padding, int size, boolean overflow_cut){
		
		String s = origin+"";
		
		int len = s.length();
		
		if(overflow_cut && len > size){
			
			return s.substring(0, size);
		}
		
		String pad = "";
		
		for(int i = 0; i < size - len; i++){
			
			pad += padding;
		}
		
		return s+pad;
	}
	
	/**
	 * 문자열을 정수형으로 변환
	 * 
	 * @author 박주엽
	 * @date 2013. 11. 15.
	 * 
	 * @param o
	 * @return
	 */
	public static int toInt(Object o){
		
		try{
			return (int)(Float.parseFloat(o+"")+0.5f);
		}
		catch(Exception e){
			return 0;
		}
	}
	
	/**
	 * SqlDao에서 받은 데이터가 숫자일 경우
	 * String s = map.get(key) 할 경우 ClassCastException 이 발생하는데
	 * 중간에 Object를 거쳐갈 경우 오류가 발생하지 않음.
	 * 그 역할을 하는 메소드
	 * 
	 * @author 박주엽
	 * @date 2013. 12. 2.
	 * 
	 * @param o
	 * @return
	 */
	public static String toString(Object o){
		
		try{
			return o+"";
		}
		catch(Exception e){
			return null;
		}
	}
	
	public static String getString(@SuppressWarnings("rawtypes") Map map, String key){
		
		try{
			Object o = map.get(key);
			return o+"";
		}
		catch(Exception e){
			return null;
		}
	}
	
	/**
	 * 리스트에서 가장 처음 요소를 가져옴
	 * 
	 * @author 박주엽
	 * @date 2013. 12. 31.
	 * 
	 * @param src
	 * @return
	 */
	
	@SuppressWarnings("rawtypes")
	public static Map getFirstMap(List<Map> src){
		
		Iterator<Map> iter = src.iterator();
		while(iter.hasNext()){
			return iter.next();
		}
		
		return null;
	}
	
	/**
	 * 리스트에서 가장 처음 요소를 가져옴
	 */
	
	@SuppressWarnings("rawtypes")
	public static Object getFirstValue(List<Map> src, String key){
		
		Iterator<Map> iter = src.iterator();
		while(iter.hasNext()){
			return iter.next().get(key);
		}
		
		return null;
	}
	
	/**
	 * 서블릿 이름을 추출(확장자 제외)
	 */
	
	public static String getServletBaseName(HttpServletRequest request){
		
		try{
			return FilenameUtils.getBaseName(request.getServletPath());
		}
		catch(Exception e){
			return null;
		}
	}
	
	/**
	 * 서블릿 이름을 추출(확장자 포함)
	 */
	
	public static String getServletName(HttpServletRequest request){
		
		try{
			return FilenameUtils.getName(request.getServletPath());
		}
		catch(Exception e){
			return null;
		}
	}
	
	/**
	 * 그룹이 A인 리스트, 그룹이 B인 리스트... 등이 하나의 리스트로 합쳐져 있을 경우
	 * key값을 그룹으로 하여 리스트를 쪼개어 Map에 담아 반환.
	 * 
	 * @param list		원본 리스트
	 * @param key		구분 키의 컬럼
	 * @param keys		구분 키의 값과 결과 Map에 담을 키의 쌍
	 */
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static Map<String, List> splitList(List<Map> list, String key, String[] keys){
		
		Map<String, List> map = new HashMap<String, List>();
		
		try{
			for(Map m:list){
				
				for(int i = 0; i < keys.length; i+=2){
					
					String k = keys[i];
					
					if(Common.strEqual((String) m.get(key),k)){
						
						List l = map.get(keys[i+1]);
						if(l == null){
							l = new ArrayList<Map>();
							l.add(m);
							map.put(keys[i+1], l);
						}
						else{
							l.add(m);
						}
					}
				}
			}
		}
		catch(Exception e){
		}
		
		return map;
	}
	
	/**
	 * 그룹이 A인 리스트, 그룹이 B인 리스트... 등이 하나의 리스트로 합쳐져 있을 경우
	 * key값을 그룹으로 하여 리스트를 쪼개어 Map에 담아 반환.
	 * 
	 * @param list		원본 리스트
	 * @param key		구분 키의 컬럼
	 * @param keys		구분 키의 값과 결과 Map에 담을 키의 쌍
	 */
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static Map<String, List> splitListGroupBy(List<Map> list, String key){
		
		if(list==null)
			return null;
		
		Map<String, List> map = new HashMap<String, List>();
		
		try{
			for(Map m:list){
				
				String k = (String) m.get(key);
						
				List l = map.get(k);
				if(l == null){
					l = new ArrayList<Map>();
					l.add(m);
					map.put(k, l);
				}
				else{
					l.add(m);
				}
			}
		}
		catch(Exception e){
		}
		
		return map;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static Map<String, List> listToGroupByListMap(List<Map> list, String key){
		
		if(list==null)
			return null;
		
		Map<String, List> map = new HashMap<String, List>();
		
		try{
			for(Map m:list){
				
				String k = (String) m.get(key);
				
				List<Map> listmap = map.get(k);
				if(listmap == null){
					listmap = new ArrayList<Map>();
					map.put(k, listmap);
					
					listmap.add(m);
				}
				else{
					
					listmap.add(m);
				}
			}
		}
		catch(Exception e){
		}
		
		return map;
	}
	
	public static boolean existTag(String str){
		
		int start_index = str.indexOf("<");
		int index = start_index;
		int end_index = 0;
		if(index > -1){
			index = str.indexOf("/>", index);
			if(index < 0){
				end_index = str.indexOf(">", index);
				String name = str.substring(start_index+1, end_index).split(" ")[0];
				index = end_index;
				if(index > -1){
					index = str.indexOf("</"+name+">", index);
					if(index > -1){
						end_index = str.indexOf(">", index);
						return true;
					}
				}
			}
			else
				return true;
		}
		return false;
	}
	
	/**
	 * 쿼리스트링 조작
	 * 
	 * @param origin 원본 url 쿼리스트링 포함
	 * @param key 쿼리스트링 키
	 * @param value 쿼리스트링 값
	 * @return
	 */
	public static String addOrReplaceQueryString(String origin, String key, String value){
		
		int index = origin.indexOf("?");
		if(index > 0){
			
			String url = origin.substring(0, index);
			String qstr = origin.substring(index+1);
			
			// ? 만 붙어있는 경우
			if(qstr.isEmpty()){
				
				return origin+"?"+key+"="+value;
			}
			else{
				
				StringBuilder sb = new StringBuilder();
				sb.append(url);
				
				String[] arr = qstr.split("&");
				boolean first = true;
				
				// key 에 해당하는 파라미터와 비어있는 파라미터를 제외
				for(int i = 0; i < arr.length; i++){
					String one = arr[i];
					
					String[] pair = one.split("=");
					
					if((pair[0].equals(key) || pair[0].isEmpty() || pair.length<2)){
						
					}
					else{
						sb.append((first?"?":"&")+one);
						first=false;
					}
				}
				
				sb.append((first?"?":"&")+key+"="+value);
				
				return sb.toString();
			}
		}
		else{
			
			return origin+"?"+key+"="+value;
		}
	}
	
	public static String toHex(String dec_str){
		
		if(dec_str == null)
			return null;
		int len = dec_str.length();
		StringBuilder sb = new StringBuilder();
		for(int i = 0; i < len; i+=2){
			if(dec_str.charAt(i)=='0' && (dec_str.charAt(i+1)>='0' && dec_str.charAt(i+1)<='9')){
				sb.append(dec_str.charAt(i+1));
			}
			else if(dec_str.charAt(i)=='1' && (dec_str.charAt(i+1)>='0' && dec_str.charAt(i+1)<'6')){
				sb.append(dec_str.charAt(i+1)-'0'+'A');
			}
		}
		return sb.toString();
	}
	
	public static boolean checkImageSignature(byte[] file){
		
		// png
		if(extractHexCode(file[0]).equals("89")
				&& extractHexCode(file[1]).equals("50")
				&& extractHexCode(file[2]).equals("4E")
				&& extractHexCode(file[3]).equals("47")
				&& extractHexCode(file[4]).equals("0D")
				&& extractHexCode(file[5]).equals("0A")
				&& extractHexCode(file[6]).equals("1A")
				&& extractHexCode(file[7]).equals("0A"))
			return true;
		
		return false;
	}
	
	public static boolean signatureMatch(byte[] file, String signature){
		
		int sig_len = signature.length();
		for(int i=0;i<sig_len;i++){
			char c = signature.charAt(i);
			if(c=='X')
				continue;
			if(i%2==0){
				int f = (file[i/2] & 0xf0) >>> 4;
				if(f > 9){if((char)((f-10) + (int)'A')!=c){return false;}}
				else{if((char)(f+'0')!=c){return false;}}
			}
			else{
				int f = (file[i/2] & 0x0f);
				if(f > 9){if((char)((f-10) + (int)'A')!=c){return false;}}
				else{if((char)(f+'0')!=c){return false;}}
			}
		}
		return true;
	}
	
	private static String extractHexCode(byte b){
		
		String s = "";
		int f = (b & 0xf0) >>> 4;
		if(f > 9) s += (char)((f-10) + (int)'A');
		else s += f;
		f = (b & 0x0f);
		if(f > 9) s += (char)((f-10) + (int)'A');
		else s += f;
		return s;
	}
}
