package kr.co.petmd.utils.common;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Map;

import kr.co.petmd.utils.admin.Config;

public class EncodingUtil {

	public static String toKorean(String str) {
		String convStr = null;
		try {
			if (str == null)
				return null;

			convStr = new String(str.getBytes("UTF8"), "8859_1");
		} catch (UnsupportedEncodingException e) {
		}
		return convStr;
	}

	public static String fromKorean(String str) {
		String convStr = null;
		try {
			if (str == null)
				return null;

			convStr = new String(str.getBytes("8859_1"), "UTF8");
		} catch (UnsupportedEncodingException e) {
		}
		return convStr;
	}
	
	public static String fromKorean(String str, String enc) {
		String convStr = null;
		try {
			if (str == null)
				return null;

			convStr = new String(str.getBytes("8859_1"), enc);
		} catch (UnsupportedEncodingException e) {
		}
		return convStr;
	}
	
	public static void testEncoding(String str) {
		try {
			String charSet[] = { "utf-8", "euc-kr", "8859_1" };
			String fileName = str;
			for (int i = 0; i < charSet.length; i++) {
				for (int j = 0; j < charSet.length; j++) {
					System.out.println(charSet[i] + " to " + charSet[j] + " = " + new String(fileName.getBytes(charSet[i]), charSet[j]));
				}
			}
		} catch (Exception ex) {

		}
	}
	
	public static String fromKoreaURL(String url) {
		
		if (url != null) {
			
			try {
				url = URLDecoder.decode(url, "UTF8");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			
		}
		
		
		return url; 
		
	}
	
	/** 
	 * 한글 인코딩
	 * @author 나유철
	 * */

	public static Map<String, String> mapFromKorean(Map<String, String> params){
		if(params == null){
			return null;
		}
		
		Iterator<String> i =params.keySet().iterator();
		
		while(i.hasNext()){
			String key = (String)i.next();
			String value = (String)params.get(key);
			
			if(value != null){
				params.put(key, fromKorean(value));
			}
		}
		
		return params;
	}
	
	public static Map<String, String> mapToKorean(Map<String, String> params){
		if(params == null){
			return null;
		}
		
		Iterator<String> i =params.keySet().iterator();
		
		while(i.hasNext()){
			String key = (String)i.next();
			String value = (String)params.get(key);
			
			if(value != null){
				params.put(key, toKorean(value));
			}
		}
		
		return params;
	}
	
	public static Map<String, String> URLDecode(Map<String, String> params){
		return URLDecode(params, Config.DEFAULT_CHARSET);
	}
	
	public static Map<String, String> URLDecode(Map<String, String> params, String encoding){
		if(params == null){
			return null;
		}
		
		Iterator<String> i =params.keySet().iterator();
		
		while(i.hasNext()){
			String key = (String)i.next();
			String value = (String)params.get(key);
			
			if(value != null){
				params.put(key, URLDecode(value, encoding));
			}
		}
		
		return params;
	}
	
	public static Map<String, String> URLEncode(Map<String, String> params, String[] removeKeyHeaders){
		return URLEncode(params, removeKeyHeaders, Config.DEFAULT_CHARSET);
	}
	
	/**
	 * params의 각 요소에 대하여 URLEncode를 수행, 키값에 removeKeyHeaders가 존재할 경우 제거
	 * 
	 * @author 박주엽
	 * @date 2013. 12. 30.
	 */
	
	public static Map<String, String> URLEncode(Map<String, String> params, String[] removeKeyHeaders, String encoding){
		if(params == null){
			return null;
		}
		
		Map<String, String> m = new HashMap<String, String>();
		LinkedList<String> keys = new LinkedList<String>();
		
		Iterator<String> i =params.keySet().iterator();
		
		while(i.hasNext()){
			String key = (String)i.next();
			String value = ((Object)params.get(key))+"";
			
			if(removeKeyHeaders!=null){
				for(String header : removeKeyHeaders){
					if(key.indexOf(header)==0){
						//m.put(key.substring(header.length()), value);
						if(value != null){
							m.put(key.substring(header.length()), URLEncode(value, encoding));
						}
						keys.addLast(key);
						break;
						//key=key.substring(header.length());
					}
				}
			}
			if(value != null){
				params.put(key, URLEncode(value, encoding));
			}
		}
		
		while(!keys.isEmpty()){
			params.remove(keys.pollFirst());
		}
		
		params.putAll(m);
		
		return params;
	}
	
	public static String URLEncode(String str){
		
		try {
			return URLEncoder.encode(str, Config.DEFAULT_CHARSET);
		} catch (Exception e) {
			return str;
		}
	}
	
	public static String URLEncode(String str, String encoding){
		
		try {
			return URLEncoder.encode(str, encoding);
		} catch (Exception e) {
			return str;
		}
	}
	
	public static String URLDecode(String str){
		
		try {
			return URLDecoder.decode(str, Config.DEFAULT_CHARSET);
		} catch (Exception e) {
			return str;
		}
	}
	
	public static String URLDecode(String str, String encoding){
		
		try {
			return URLDecoder.decode(str, encoding);
		} catch (Exception e) {
			return str;
		}
	}
	
	// [출처] blog.naver.com/0131v/110179186929
	public static String escape(String src){
		
		int i;
		char j;
		
		StringBuffer tmp = new StringBuffer();
		tmp.ensureCapacity(src.length() * 6);
		
		for (i = 0; i < src.length(); i++){
			
			j = src.charAt(i);
			
			if (Character.isDigit(j) || Character.isLowerCase(j) || Character.isUpperCase(j))
				
				tmp.append(j);
			
			else if (j < 256){
				
				tmp.append("%");
				
				if (j < 16)
					tmp.append("0");
				
				tmp.append(Integer.toString(j, 16));
			}
			else{
				
				tmp.append("%u");
				tmp.append(Integer.toString(j, 16));
			}
		}
		
		return tmp.toString();
	}
	
	public static String unescape(String src){
		
		StringBuffer tmp = new StringBuffer();
		
		tmp.ensureCapacity(src.length());
		
		int lastPos = 0, pos = 0;
		
		char ch;
		while(lastPos < src.length()){
			pos = src.indexOf("%", lastPos);
			
			if(pos == lastPos){
				if (src.charAt(pos + 1) == 'u'){
					
					ch = (char) Integer.parseInt(src.substring(pos + 2, pos + 6), 16);
					tmp.append(ch);
					
					lastPos = pos + 6;
				}
				else{
				
					ch = (char) Integer.parseInt(src.substring(pos + 1, pos + 3), 16);
					tmp.append(ch);
					
					lastPos = pos + 3;
				}
			}
			else{
				
				if(pos == -1){
					
					tmp.append(src.substring(lastPos));
					lastPos = src.length();
				}
				else{
					
					tmp.append(src.substring(lastPos, pos));
					lastPos = pos;
				}
			}
		}
		return tmp.toString();   
	}
}
