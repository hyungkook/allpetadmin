package kr.co.petmd.utils.common;

import java.util.HashMap;
import java.util.Map;

import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.admin.Config;

public class SMSSender {
	
	private String callback = Config.ADV_TELNO;
	
	public SMSSender(String callback){
		
		if(callback!=null){
			this.callback = callback;
		}
	}
	
	private Long lastKey = null;
	
	/**
	 * 마지막 수행된 SMS 쿼리의 키값을 저장
	 * 
	 * @return
	 */
	public Long getLastKey(){
		
		return lastKey;
	}
	
	private String mergePhoneList(String[] name, String[] phone, int arrLimit){
		
		StringBuilder phoneNumStr = new StringBuilder();
		int length = 0;
//		boolean first = true;
		
		if (phone != null) {
			if (phone.length > 0) {
				length = phone.length;
				if(arrLimit >= 0 && length >= arrLimit){
					length = arrLimit;
				}
				for (int i = 0; i < length; i++) {
					if (phone[i] != null && !phone[i].equals("")) {
//						if(first){
//							//phoneNumStr += phone[i];
//							phoneNumStr.append(phone[i]);
//							first = false;
//						}
//						else{
							if(Common.isValid(name)){
								phoneNumStr.append(name[i]);
							}
							else{
								phoneNumStr.append(phone[i]);
							}
							phoneNumStr.append("^");
							phoneNumStr.append(phone[i]);
							//phoneNumStr += Config.ADV_SMS_ID + "^" + phone[i];
//						}
						if (i < length-1) {
							phoneNumStr.append("|");
							//phoneNumStr += "|";
						}
					}
				}
			} else {
				//phoneNumStr = null;
			}
		}
		return phoneNumStr.toString();
	}
	
	public boolean sendSmsMessage(Map<String,String> smsMap){
		
		int result = 0;
		
		String dburl = SqlDao.getDBURL();
		if(dburl!=null && dburl.indexOf("1.2")>-1){
			// 개발 DB 접근
			String id = SqlDao.getString("SMS.getNextMsgId", null);
			smsMap.put("msg_id", id);
			result = SqlDao.insert("SMS.insertSmsData_dev", smsMap);
			lastKey = new Long(((Object)id)+"");
		}
		else{
			SqlDao.insert("SMS.insertSmsData", smsMap);
			lastKey = new Long(((Object)smsMap.get("seqKey"))+"");
		}
		
		if(result > 0){
			return true;
		}else{
			return false;
		}
	}
	
	public boolean sendSmsMessageReserved(Map<String,String> smsMap){
		
		int result = 0;
		
		String dburl = SqlDao.getDBURL();
		if(dburl!=null && dburl.indexOf("1.2")>-1){
			// 개발 DB 접근
			String id = SqlDao.getString("SMS.getNextMsgId", null);
			smsMap.put("msg_id", id);
			result = SqlDao.insert("SMS.insertSmsReserve_dev", smsMap);
			lastKey = new Long(((Object)id)+"");
		}
		else{
			result = SqlDao.insert("SMS.insertSmsReserve", smsMap);
			lastKey = new Long(((Object)smsMap.get("seqKey"))+"");
		}
		
		if(result > 0){
			return true;
		}else{
			return false;
		}
	}
	
	private HashMap<String,String> createSMSMap(String subject, String msg, String phoneNum, String ssid, String dest_count){
		
		HashMap<String,String> smsMap = new HashMap<String, String>();
		
		smsMap.put("callback", callback);
		smsMap.put("subject", subject);
		smsMap.put("user_id",  Config.ADV_SMS_ID);
		smsMap.put("sms_msg", msg);
		//smsMap.put("callback_url",  Config.ADV_SMS_ID);
		smsMap.put("dest_info", phoneNum);
		smsMap.put("reserved1", "ALLPET");
		smsMap.put("reserved2", ssid);
		smsMap.put("cdr_id",  Config.ADV_SMS_ID);
		smsMap.put("dest_count", dest_count);

		return smsMap;
	}
	
	public boolean sendSMS(String phoneNum, String subject, String msg, String ssid){
		
		return sendSmsMessage(createSMSMap(subject, msg, phoneNum + "^" + phoneNum, ssid, "1"));
	}
	
	public boolean sendSMS(String[] phoneNum, String subject, String msg, String ssid){
		
		return sendSmsMessage(createSMSMap(subject, msg, mergePhoneList(null, phoneNum, -1), ssid, Common.lengthOf(phoneNum)+""));
	}
	
	public boolean sendSMSReserve(String phoneNum, String subject, String msg, String ssid, String reserve_date){
		
		HashMap<String,String> smsMap = createSMSMap(subject, msg, phoneNum + "^" + phoneNum, ssid, "1");
		
		smsMap.put("reserve_date", reserve_date);
		
		return sendSmsMessageReserved(smsMap);
	}
	
	public boolean sendSMSReserve(String[] phoneNum, String subject, String msg, String ssid, String reserve_date){
		
		HashMap<String,String> smsMap = createSMSMap(subject, msg, mergePhoneList(null, phoneNum, -1), ssid, Common.lengthOf(phoneNum)+"");
		
		smsMap.put("reserve_date", reserve_date);
		
		return sendSmsMessageReserved(smsMap);
	}
}
