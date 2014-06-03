package kr.co.petmd.utils.common;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import kr.co.petmd.utils.admin.Config;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class JSONUtil {
	
	public static String toEncodedJSONString(Object obj){
		
		return toEncodedJSONString(obj, Config.DEFAULT_CHARSET);
	}

	@SuppressWarnings("rawtypes")
	public static String toEncodedJSONString(Object obj, String encoding){
		
		try {
			if(obj instanceof Map){
				
				return URLEncoder.encode(JSONObject.toJSONString((Map) obj),encoding);
			}
			else if(obj instanceof List){
				
				return URLEncoder.encode(JSONArray.toJSONString((List) obj),encoding);
			}
			else if(obj instanceof String){
				
				return URLEncoder.encode("{value:"+(String)obj+"}",encoding);
			}
			else
				return null;
		} catch (UnsupportedEncodingException e) {

			e.printStackTrace();
			return null;
		}
	}
	
	@SuppressWarnings("rawtypes")
	public static String toJSONString(Object obj){
		
		if(obj instanceof Map){
				
			return JSONObject.toJSONString((Map) obj);
		}
		else if(obj instanceof List){
			
			return JSONArray.toJSONString((List) obj);
		}
		else if(obj instanceof String){
			
			return "{value:"+(String)obj+"}";
		}
		else
			return null;
	}
}
