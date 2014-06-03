package kr.co.petmd.utils.common;

import java.util.HashMap;
import java.util.Map;

import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.admin.Config;

public class SMSUtil {

	private static SMSUtil smsUtil;
	
	public static SMSUtil getInstance(){
		if(smsUtil == null){
			smsUtil = new SMSUtil();
		}
		return smsUtil;
	}
	
	private HashMap<String,String> defaultMap = new HashMap<String, String>();
	
	private void init(){
		
		defaultMap.put("callback", Config.ADV_TELNO);
		defaultMap.put("user_id",  Config.ADV_SMS_ID);
		defaultMap.put("cdr_id",  Config.ADV_SMS_ID);
	}
	
	public boolean sendSmsMessage(Map<String,String> smsMap){
		int result = SqlDao.insert("SMS.insertSmsData", smsMap);
		
		if(result > 0){
			return true;
		}else{
			return false;
		}
	}
	
	public boolean sendSMS(String phoneNum,String msg,String subject){
		return sendSMS(phoneNum, msg, subject, "", "");
	}
	
	
	public boolean sendSMS(String phoneNum,String msg,String subject, String reserve1, String reserve2){
		
		HashMap<String,String> smsMap = new HashMap<String, String>();
		
		smsMap.put("callback", Config.ADV_TELNO);
		smsMap.put("subject", subject);
		smsMap.put("user_id",  Config.ADV_SMS_ID);
		smsMap.put("sms_msg", msg);
		//smsMap.put("callback_url",  Config.ADV_SMS_ID);
		smsMap.put("dest_info",  phoneNum + "^" + phoneNum);
		smsMap.put("reserved1", reserve1);
		smsMap.put("reserved2", reserve2);
		smsMap.put("cdr_id",  Config.ADV_SMS_ID);
		smsMap.put("dest_count", "1");
		
		return sendSmsMessage(smsMap);
	}
	
	public boolean sendSMS(String phoneNum, String subject, String msg, String ssid){
		
		HashMap<String,String> smsMap = new HashMap<String, String>();
		
		smsMap.put("callback", Config.ADV_TELNO);
		smsMap.put("subject", subject);
		smsMap.put("user_id",  Config.ADV_SMS_ID);
		smsMap.put("sms_msg", msg);
		//smsMap.put("callback_url",  Config.ADV_SMS_ID);
		smsMap.put("dest_info",  phoneNum + "^" + phoneNum);
		smsMap.put("reserved1", "ALLPET");
		smsMap.put("reserved2", ssid);
		smsMap.put("cdr_id",  Config.ADV_SMS_ID);
		smsMap.put("dest_count", "1");
		
		return sendSmsMessage(smsMap);
	}
	
	public boolean sendSMSReserve(String phoneNum, String subject, String msg, String ssid, String reserve_date){
		
		HashMap<String,String> smsMap = new HashMap<String, String>();
		
		smsMap.put("callback", Config.ADV_TELNO);
		smsMap.put("subject", subject);
		smsMap.put("user_id",  Config.ADV_SMS_ID);
		smsMap.put("sms_msg", msg);
		//smsMap.put("callback_url",  Config.ADV_SMS_ID);
		smsMap.put("dest_info",  phoneNum + "^" + phoneNum);
		smsMap.put("reserved1", "ALLPET");
		smsMap.put("reserved2", ssid);
		smsMap.put("cdr_id",  Config.ADV_SMS_ID);
		smsMap.put("dest_count", "1");
		
		smsMap.put("reserve_date", reserve_date);
		
		int result = SqlDao.insert("SMS.insertSmsReserve", smsMap);
		
		if(result > 0){
			return true;
		}else{
			return false;
		}
	}
	
	/**
	 * 최대 100명에게 SMS 발송
	 * 
	 * add yongil. (2012.10.30)
	 * 
	 * @param phoneNum	전화번호 배열
	 * @param msg		메세지 내용
	 * @param subject	메세지 제목
	 * @param userID	보내는 사람 sid
	 * @param sendUser	구분자 (사용자 MEMBER, 병원 HOSPITAL, 관리자, ADMIN)
	 * @param callBack	보내는 사용자 번호(병원이면 병원 번호)
	 * @return
	 */
	public boolean sendSMS(String[] phoneNum, String msg, String subject, String userKey, String sendUser, String callBack) {
		String phoneNumStr = "";
		int length = 0;
		boolean first = true;
		
		if (phoneNum != null) {
			if (phoneNum.length > 0) {
				length = phoneNum.length;
				for (int i = 0; i < length; i++) {
					if (phoneNum[i] != null && !phoneNum[i].equals("")) {
						if(first){
							phoneNumStr += phoneNum[i];
							first = false;
						}
						else
							phoneNumStr += Config.ADV_SMS_ID + "^" + phoneNum[i];
						if (i < length-1) {
							phoneNumStr += "|";
						}
					}
				}
				//System.out.println(phoneNumStr);
			} else {
				phoneNumStr = null;
			}
		}
		
		return sendSMS(phoneNumStr, msg, subject, userKey, sendUser, callBack, length);
	}
	
	public boolean sendSMS(String[] phoneNum, int arrLimit, String msg, String subject, String userKey, String sendUser, String callBack) {
		String phoneNumStr = "";
		int length = 0;
		boolean first = true;
		
		if (phoneNum != null) {
			if (phoneNum.length > 0) {
				length = phoneNum.length;
				if(arrLimit >= 0 && length >= arrLimit){
					length = arrLimit;
				}
				for (int i = 0; i < length; i++) {
					if (phoneNum[i] != null && !phoneNum[i].equals("")) {
						if(first){
							phoneNumStr += phoneNum[i];
							first = false;
						}
						else
							phoneNumStr += Config.ADV_SMS_ID + "^" + phoneNum[i];
						if (i < length-1) {
							phoneNumStr += "|";
						}
					}
				}
				//System.out.println(phoneNumStr);
			} else {
				phoneNumStr = null;
			}
		}
		
		return sendSMS(phoneNumStr, msg, subject, userKey, sendUser, callBack, length);
	}
	
	/**
	 * 1명에게 SMS 발송
	 * @param phoneNum
	 * @param msg
	 * @param subject
	 * @param userID
	 * @param sendUser
	 * @param callBack
	 * @return
	 */
	
	public boolean sendSMS(String phoneNum, String msg, String subject, String userKey, String sendUser, String callBack, int destCount) {
		if (phoneNum == null) {
			System.out.println("PhoneNum is NULL.");
			return false;
		}
		
		HashMap<String,String> smsMap = new HashMap<String, String>();
		
		smsMap.put("callback", callBack);
		smsMap.put("subject", subject);
		smsMap.put("user_id",  Config.ADV_SMS_ID);
		smsMap.put("sms_msg", msg);
		//smsMap.put("callback_url",  Config.ADV_SMS_ID);
		smsMap.put("dest_info",  Config.ADV_SMS_ID + "^" + phoneNum);
		smsMap.put("reserved1", userKey);
		smsMap.put("reserved2", sendUser);
		smsMap.put("cdr_id",  Config.ADV_SMS_ID);
		smsMap.put("dest_count", destCount+"");
		
		return sendSmsMessage(smsMap);
		
		//return sendSmsMassage(sendVo);
	}
	
	public boolean sendSMS(String phoneNum, String msg, String subject, String userKey, String sendUser, String callBack) {
		if (phoneNum == null) {
			System.out.println("PhoneNum is NULL.");
			return false;
		}
		
		return sendSMS(phoneNum, msg, subject, userKey, sendUser, callBack, 1);
	}

	/**
	 * MMS 발송
	 * 
	 * add yongil(2012.10.30)
	 * 
	 * @param phoneNum	이름^번호|이름^번호|......100개까지 가능
	 * @param msg		보낼 메세지
	 * @param subject	보낼 메세지 제목
	 * @param userID	보내는 병원 아이디
	 * @param sendUser	보내는 구분자(사용자 MEMBER, 병원 HOSPITAL, 관리자 ADMIN)
	 * @param callBack	보내는 사용자 번호(병원이면 병원 번호)
	 * @return	성공 여부
	 */
	public boolean sendMMS(String phoneNum, String msg, String subject, String userID, String sendUser, String callBack, int destCount) {
		//USER_ID, SCHEDULE_TYPE, SUBJECT, NOW_DATE, SEND_DATE , CALLBACK, DEST_COUNT, DEST_INFO, MSG_TYPE, MMS_MSG , CONTENT_COUNT, CONTENT_DATA
		//'test_sp', 0, 'MMS Test', DATE_FORMAT(NOW(), '%Y%m%d%H%i%s'), DATE_FORMAT(NOW(), '%Y%m%d%H%i%s') , '01190772447', 1, 'mjkim^01197893244', 0, 'MMS 테스트입니다.' , 0, ''
		if (phoneNum == null) {
			System.out.println("PhoneNum is NULL.");
			return false;
		}
//		String[] sendNumber = phoneNum.split("\\|");
//		String dest_count = "0";
//		if (sendNumber != null && sendNumber.length > 0) {
//			dest_count = String.valueOf(sendNumber.length);
//		}
		
		HashMap<String,String> mmsMap = new HashMap<String, String>();
		
		mmsMap.put("user_id",  Config.ADV_SMS_ID);
		mmsMap.put("schedule_type",  "0"); // 즉시 발송
		mmsMap.put("subject", subject);
		mmsMap.put("callback", callBack);
		
		mmsMap.put("dest_count", destCount+"");
		mmsMap.put("dest_info",  Config.ADV_SMS_ID + "^" + phoneNum);
		mmsMap.put("msg_type",  "0"); // 텍스트 타입
		mmsMap.put("mms_msg", msg);
		
		mmsMap.put("content_count", "0");
		mmsMap.put("content_data", "");
		
		
		//smsMap.put("callback_url",  Config.ADV_SMS_ID);
		
		mmsMap.put("reserved1", userID);
		mmsMap.put("reserved2", sendUser);
		//smsMap.put("cdr_id",  Config.ADV_SMS_ID);
		
		return sendMMSMessage(mmsMap);
	}
	
	public boolean sendMMS(String phoneNum, String msg, String subject, String userID, String sendUser, String callBack) {
		
		return sendMMS(phoneNum, msg, subject, userID, sendUser, callBack, 1);
	}
	
	public boolean sendMMSMessage(Map<String,String> smsMap){
		
		int result = SqlDao.insert("SMS.insertMmsData", smsMap);
		
		if(result > 0){
			return true;
		}else{
			return false;
		}
	}
	
	public int getMsgLength(String msg){
		
		// 80바이트가 넘으면 MMS 아니면 SMS
		/*try {
			return msg.getBytes("EUC-KR").length;
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return 0;
		}*/
		if(msg==null)
			return 0;
		
		int len = msg.length();
		int cnt = 0;
		for(int i = 0; i < len; i++){
			if(msg.charAt(i) < 256){
				cnt += 1;
			}
			else{
				cnt += 2;
			}
		}
		return cnt;
	}
	
	/**
	 * 최대 100개까지 한번에 DB에 insert
	 * @param phoneNum 전화번호 배열
	 * @param msg
	 * @param subject
	 * @param userKey
	 * @param sendUser
	 * @param callBack
	 * @return
	 */
	public boolean sendMMS(String[] phoneNum, String msg, String subject, String userID, String sendUser, String callBack) {
		
		String phoneNumStr = "";
		int length = 0;
		boolean first = true;
		
		if (phoneNum != null) {
			if (phoneNum.length > 0) {
				length = phoneNum.length;
				for (int i = 0; i < length; i++) {
					if (phoneNum[i] != null && !phoneNum[i].equals("")) {
						if(first){
							phoneNumStr += phoneNum[i];
							first = false;
						}
						else
							phoneNumStr += Config.ADV_SMS_ID + "^" + phoneNum[i];
						if (i < length-1) {
							phoneNumStr += "|";
						}
					}
				}
				//				System.out.println(phoneNumStr);
			} else {
				phoneNumStr = null;
			}
		}
		
		return sendMMS(phoneNumStr, msg, subject, userID, sendUser, callBack);

//		try
//		{
//			int length = msg.getBytes("EUC-KR").length;	// 80바이트가 넘으면 MMS 아니면 SMS
//			if (length > 80) {
//				return sendMMS(phoneNumStr, msg, subject, userID, sendUser, callBack);
//			} else {
//				return sendSMS(phoneNumStr, msg, subject, userID, sendUser, callBack);
//			}
//		}
//		catch(UnsupportedEncodingException e)
//		{
//			e.printStackTrace();
//		}
//		return false;
	}
	
	public boolean sendMMS(String[] phoneNum, int arrLimit, String msg, String subject, String userID, String sendUser, String callBack) {
		
		String phoneNumStr = "";
		int length = 0;
		boolean first = true;
		
		if (phoneNum != null) {
			if (phoneNum.length > 0) {
				length = phoneNum.length;
				if(arrLimit >= 0 && length >= arrLimit){
					length = arrLimit;
				}
				for (int i = 0; i < length; i++) {
					if (phoneNum[i] != null && !phoneNum[i].equals("")) {
						if(first){
							phoneNumStr += phoneNum[i];
							first = false;
						}
						else
							phoneNumStr += Config.ADV_SMS_ID + "^" + phoneNum[i];
						if (i < length-1) {
							phoneNumStr += "|";
						}
					}
				}
				//				System.out.println(phoneNumStr);
			} else {
				phoneNumStr = null;
			}
		}
		
		return sendMMS(phoneNumStr, msg, subject, userID, sendUser, callBack);

//		try
//		{
//			int length = msg.getBytes("EUC-KR").length;	// 80바이트가 넘으면 MMS 아니면 SMS
//			if (length > 80) {
//				return sendMMS(phoneNumStr, msg, subject, userID, sendUser, callBack);
//			} else {
//				return sendSMS(phoneNumStr, msg, subject, userID, sendUser, callBack);
//			}
//		}
//		catch(UnsupportedEncodingException e)
//		{
//			e.printStackTrace();
//		}
//		return false;
	}
	
	public int sendSMSDividedBatch(String[] phoneNum, int arrLimit, String msg, String subject, String callBack,
			String reserved1, String reserved2, String[] reserved3, String reserved4){
		
		if(phoneNum == null)
			return 0;
		
		StringBuffer strBuffer = new StringBuffer();
		
		// 배열에서 길이제한(arrLimit)
		// arrLimit이 배열 길이보다 작게 설정될 경우 arrLimit 만큼만 SMS
		int length = 0;
		length = phoneNum.length;
		if(arrLimit >= 0 && length >= arrLimit){
			length = arrLimit;
		}
				
		// 배치 쿼리 생성
		for(int i = 0; i < length; i++){
			
			strBuffer.append("('"+Config.ADV_SMS_ID+"',");
			strBuffer.append("'"+subject+"',");
			strBuffer.append("'"+msg+"',");
			//strBuffer.append("'"+Config.ADV_SMS_ID+"',");
			strBuffer.append("DATE_FORMAT(NOW(),'%Y%m%d%H%i%s'),");
			strBuffer.append("DATE_FORMAT(NOW(),'%Y%m%d%H%i%s'),");
			strBuffer.append("'"+callBack+"',");
			strBuffer.append("'"+Config.ADV_SMS_ID + "^" + phoneNum[i]+"',");
			strBuffer.append("'"+reserved1+"',");
			strBuffer.append("'"+reserved2+"',");
			strBuffer.append("'"+reserved3[i]+"',");
			strBuffer.append("'"+reserved4+"',");
			strBuffer.append("'"+Config.ADV_SMS_ID+"',");
			strBuffer.append("'1'),");
		}

		String query = strBuffer.toString();
		if (query != null && query.length()>0) {
			if (query.substring(query.length()-1, query.length()).equals(",")) {
				query = query.substring(0, query.length()-1);	
			}
			return SqlDao.insert("SMS.insertSmsDataBatch", query);
		}
		
		return 0;
	}
	
	public int sendMMSDividedBatch(String[] phoneNum, int arrLimit, String msg, String subject, String callBack,
			String reserved1, String reserved2, String[] reserved3, String reserved4){
		
		if(phoneNum == null)
			return 0;
		
		StringBuffer strBuffer = new StringBuffer();
		
		// 배열에서 길이제한(arrLimit)
		// arrLimit이 배열 길이보다 작게 설정될 경우 arrLimit 만큼만 SMS
		int length = 0;
		length = phoneNum.length;
		if(arrLimit >= 0 && length >= arrLimit){
			length = arrLimit;
		}
		
		// 배치 쿼리 생성
		for(int i = 0; i < length; i++){
			
			strBuffer.append("('"+Config.ADV_SMS_ID+"',");
			strBuffer.append("'0',");
			strBuffer.append("'"+subject+"',");
			strBuffer.append("DATE_FORMAT(NOW(),'%Y%m%d%H%i%s'),");
			strBuffer.append("DATE_FORMAT(NOW(),'%Y%m%d%H%i%s'),");
			strBuffer.append("'"+callBack+"',");
			strBuffer.append("'1',");
			strBuffer.append("'"+Config.ADV_SMS_ID + "^" + phoneNum[i]+"',");
			strBuffer.append("'0',");
			strBuffer.append("'"+msg+"',");
			strBuffer.append("'0',");
			strBuffer.append("'',");
			strBuffer.append("'"+reserved1+"',");
			strBuffer.append("'"+reserved2+"',");
			strBuffer.append("'"+reserved3[i]+"',");
			strBuffer.append("'"+reserved4+"'),");
			
		}
		
		String query = strBuffer.toString();
		if (query != null && query.length()>0) {
			if (query.substring(query.length()-1, query.length()).equals(",")) {
				query = query.substring(0, query.length()-1);	
			}
			return SqlDao.insert("SMS.insertMmsDataBatch", query);
		}
		
		return 0;
	}
	
	public boolean cancelSMS(String key){
		
		if(Common.isValid(key) && !Common.strEqualNN(key,"0")){
			int r = SqlDao.delete("SMS.deleteSMS",key);
			if(r > 0){
				return true;
			}
		}
		return false;
	}
}