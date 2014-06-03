package kr.co.petmd.utils.common;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.xml.crypto.URIDereferencer;

/**
 * string 값으로만 json 구성 가능
 * 
 * @author 박주엽
 * @date 2013. 11. 28.
 *
 */

public class JSONSimpleBuilder {

	public static JSONSimpleBuilder getInstance(){
		
		return new JSONSimpleBuilder();
	}
	
	StringBuffer str_buf = null;
	
	public JSONSimpleBuilder(){
		
		str_buf = new StringBuffer();
	}
	
	public int size(){
		
		return str_buf.length();
	}
	
	boolean encode = false;
	String encoding;
	
	public void setEncoding(String encoding){
		
		encode = true;
		this.encoding = encoding;
	}
	
	/**
	 * 최초 사용에만 권장.
	 * 매번 길이를 계산하여 입력된 값이 있을 경우 구분자 ( , ) 를 추가한다.
	 * 
	 * @author 박주엽
	 * @date 2013. 11. 28.
	 * 
	 * @param key
	 * @param value
	 * @return
	 */
	
	public JSONSimpleBuilder add(String key, String value){
		
		if(str_buf.length()>0)			
			str_buf.append(',');
		str_buf.append('\"');
		try {
			str_buf.append(encode?URLEncoder.encode(key,encoding):key);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			str_buf.append(key);
		}
		str_buf.append('\"');
		str_buf.append(':');
		str_buf.append('\"');
		try {
			str_buf.append(encode?URLEncoder.encode(value,encoding):value);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			str_buf.append(value);
		}
		str_buf.append('\"');
		
		return this;
	}
	
	/**
	 * 무조건 구분자 ( , )를 앞에 붙인후 내용물을 추가함.
	 * 
	 * @author 박주엽
	 * @date 2013. 11. 28.
	 * 
	 * @param key
	 * @param value
	 * @return
	 */
	
	public JSONSimpleBuilder postAdd(String key, String value){
		
		str_buf.append(",\"");
		try {
			str_buf.append(encode?URLEncoder.encode(key,encoding):key);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			str_buf.append(key);
		}
		str_buf.append('\"');
		str_buf.append(':');
		str_buf.append('\"');
		try {
			str_buf.append(encode?URLEncoder.encode(value,encoding):value);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			str_buf.append(value);
		}
		str_buf.append('\"');
		
		return this;
	}
	
	public String build(){
		
		return "{"+str_buf.toString()+"}";
	}
}
