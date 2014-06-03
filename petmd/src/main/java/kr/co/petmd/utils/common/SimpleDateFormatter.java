package kr.co.petmd.utils.common;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

public class SimpleDateFormatter {

	private static HashMap<String, SimpleDateFormat> map = new HashMap<String, SimpleDateFormat>();
	
	private static SimpleDateFormat addAndGet(String pattern){
		
		/*
		 * SimpleDateFormat is not thread-safe. Users should create a separate instance for each thread.
		 */
		
		/*SimpleDateFormat f = map.get(pattern);
		if(f == null){
			f = new SimpleDateFormat(pattern);
			map.put(pattern, f);
		}
		
		return f;*/
		
		return new SimpleDateFormat(pattern);
	}
	
	/**
	 * 현재 시간을 반환
	 */
	public static synchronized String toString(String pattern){
		
		return addAndGet(pattern).format(Calendar.getInstance().getTime());
	}
	
	public static synchronized String toString(String pattern, Calendar c){
		
		return addAndGet(pattern).format(c.getTime());
	}
	
	public static synchronized String toString(String pattern, Date d){
		
		return addAndGet(pattern).format(d);
	}
	
	public static synchronized String toString(String pattern, long millis){
		
		Calendar c = Calendar.getInstance();
		c.setTimeInMillis(millis);
		return addAndGet(pattern).format(c.getTime());
	}
	
	public static synchronized Date toDate(String pattern, String date){
		
		try {
			return addAndGet(pattern).parse(date);
		} catch (Exception e) {
			//e.printStackTrace();
			return null;
		}
	}

	public static synchronized Calendar toCalendar(String pattern, String date){
		
		try {
			Calendar c = Calendar.getInstance();
			c.setTime(addAndGet(pattern).parse(date));
			return c;
		} catch (Exception e) {
			//e.printStackTrace();
			return null;
		}
	}
	
	public static String convert(Object src, String src_pattern, String dest_pattern){
		
		try {
			return addAndGet(dest_pattern).format(addAndGet(src_pattern).parse(Common.toString(src)));
		} catch (Exception e) {
			//e.printStackTrace();
			return null;
		}
	}
}
