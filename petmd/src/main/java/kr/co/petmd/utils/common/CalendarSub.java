package kr.co.petmd.utils.common;

import java.util.Calendar;

public class CalendarSub {
	
	public static int APPROX_YEAR = 1;
	public static int APPROX_MONTH = 2;
	public static int APPROX_DAY = 3;
	public static int APPROX_HOUR = 4;
	public static int APPROX_MINUTE = 5;
	public static int APPROX_SECOND = 6;
	public static int APPROX_MSEC = 7;
	
	public static int APPROX_FLOOR = 10; // 버림
	public static int APPROX_CEIL = 11; // 올림
	public static int APPROX_ROUND = 12; // 반올림

	/**
	 * value를 기준으로 00 으로 세팅된 calendar 인스턴스(현재시간) 획득;
	 * value = CalendarSub.APPROX_DAY 일 때, 2014-05-30 00:00:00;
	 * value = CalendarSub.APPROX_HOUR 일 때, 2014-05-30 14:00:00;
	 * 
	 * @param value
	 * @return
	 */
	
	public static Calendar getApproxInstance(int value){
		
		Calendar now = Calendar.getInstance();
		
		if(value<=APPROX_SECOND){
			now.set(Calendar.MILLISECOND, 0);
			if(value<=APPROX_MINUTE){
				now.set(Calendar.SECOND, 0);
				if(value<=APPROX_HOUR){
					now.set(Calendar.MINUTE, 0);
					if(value<=APPROX_DAY){
						now.set(Calendar.HOUR_OF_DAY, 0);
						if(value<=APPROX_MONTH){
							now.set(Calendar.DAY_OF_YEAR, 1);
							if(value<=APPROX_YEAR){
								now.set(Calendar.MONTH, 0);
							}
						}
					}
				}
			}
		}
		return now;
	}
	
	public static Calendar approx(Calendar calendar, int value){
		
		if(value<=APPROX_SECOND){
			calendar.set(Calendar.MILLISECOND, 0);
			if(value<=APPROX_MINUTE){
				calendar.set(Calendar.SECOND, 0);
				if(value<=APPROX_HOUR){
					calendar.set(Calendar.MINUTE, 0);
					if(value<=APPROX_DAY){
						calendar.set(Calendar.HOUR_OF_DAY, 0);
						if(value<=APPROX_MONTH){
							calendar.set(Calendar.DAY_OF_YEAR, 1);
							if(value<=APPROX_YEAR){
								calendar.set(Calendar.MONTH, 0);
							}
						}
					}
				}
			}
		}
		return calendar;
	}
}
