package kr.co.petmd.controller.admin.hospital;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.petmd.HomeController;
import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.admin.Codes;
import kr.co.petmd.utils.admin.SessionContext;
import kr.co.petmd.utils.common.BatchQueryBuilder;
import kr.co.petmd.utils.common.CalendarSub;
import kr.co.petmd.utils.common.Common;
import kr.co.petmd.utils.common.JSONSimpleBuilder;
import kr.co.petmd.utils.common.JSONUtil;
import kr.co.petmd.utils.common.PageUtil;
import kr.co.petmd.utils.common.SMSSender;
import kr.co.petmd.utils.common.SMSUtil;
import kr.co.petmd.utils.common.SimpleDateFormatter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
public class ManageScheduleAction extends AbstractAction{
	
	private String SMS_3D = "sms_3d";
	private String SMS_2D = "sms_2d";
	private String SMS_1D = "sms_1d";
	private String SMS_3H = "sms_3h";
	private String SMS_1H = "sms_1h";
	private String SMS_NOW = "sms_now";
	
	private String SMS_3D_TERM = "259200";
	private String SMS_2D_TERM = "172800";
	private String SMS_1D_TERM = "86400";
	private String SMS_3H_TERM = "10800";
	private String SMS_1H_TERM = "3600";
	private String SMS_NOW_TERM = "0";
	
	private int SMS_TYPE_3D = 0x00000001;
	private int SMS_TYPE_2D = 0x00000002;
	private int SMS_TYPE_1D = 0x00000004;
	private int SMS_TYPE_3H = 0x00000008;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	@RequestMapping(value = "/manageSchedule.latte")
	public String manageSchedule(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("manageSchedule.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
				
		String sid = sessionContext.getData("s_sid");
		
		params.put("registrant", sid);
		params.put("type", Codes.REGISTRANT_TYPE_HOSPITAL);
		
		if(!Common.isValid(params.get("date"))){
			params.put("view_type", "month");
			params.put("date", (new SimpleDateFormat("yyyy-MM")).format(Calendar.getInstance().getTime()));
		}

		//params.put("totalCount", SqlDao.getString("Admin.Hospital.Schedule.getListCnt", params));
		//PageUtil.getInstance().pageSetting(params, 10);
		//List userTodoList = SqlDao.getList("Admin.Hospital.Schedule.getGroupList", params);
		//List userTodoList = SqlDao.getList("Admin.Hospital.Schedule.getList", params);
		//model.addAttribute("userTodoList", userTodoList);
		
		Calendar c = Calendar.getInstance();
		
		params.put("year", c.get(Calendar.YEAR)+"");
		params.put("month", (c.get(Calendar.MONTH)+1)+"");
		params.put("day", (c.get(Calendar.DAY_OF_MONTH))+"");
		params.put("hour", (c.get(Calendar.HOUR_OF_DAY))+"");
		params.put("minute", (c.get(Calendar.MINUTE))+"");
		
		model.addAttribute("params", params);
		
		return "admin/hospital/manage/manage_schedule";
	}
	
	// 스케줄 리스트에서 날짜 변경시 호출
		@RequestMapping(value="/ajaxMyPageSchedule.latte")
		public String ajaxMyPageSchedule(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
			//logger.info("ajaxMyPageSchedule.latte");
			
			SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
			
			if(!sessionContext.isAuth())
				return "redirect:login.latte?rePage=myPageSchedule.latte";
			
			params.put("registrant", sessionContext.getUserMap().get("s_sid"));
			params.put("type", Codes.REGISTRANT_TYPE_HOSPITAL);
			
			params.put("totalCount",SqlDao.getString("Admin.Hospital.Schedule.v2.getListCnt", params));
			PageUtil.getInstance().pageSetting(params, 10);
			List userTodoList = SqlDao.getList("Admin.Hospital.Schedule.v2.getList", params);
			model.addAttribute("userTodoList", userTodoList);
			//model.addAttribute("ef_nearest", SqlDao.getMap("Admin.Hospital.Schedule.getEffectiveNearset", params.get("uid")));
			model.addAttribute("selectedDate", params.get("date"));
			
			model.addAttribute("params", params);
			
			return "admin/hospital/manage/schedule_list_item";
		}
	
	@RequestMapping(value = "/ajaxManageScheduleList.latte")
	public String ajaxManageScheduleList(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("ajaxManageScheduleList.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "";
		
		String sid = sessionContext.getData("s_sid");
		
		params.put("registrant", sid);
		params.put("type", Codes.REGISTRANT_TYPE_HOSPITAL);
		
		params.put("totalCount",SqlDao.getString("Admin.Hospital.Schedule.getListCnt", params));
		PageUtil.getInstance().pageSetting(params, 10);
		List userTodoList = SqlDao.getList("Admin.Hospital.Schedule.getList", params);
		model.addAttribute("userTodoList", userTodoList);
		
		return "admin/hospital/manage/schedule_list_item";
	}
	
	@RequestMapping(value = "/manageScheduleEdit.latte")
	public String manageScheduleEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("manageScheduleEdit.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
				
		String sid = sessionContext.getData("s_sid");
		
		// 스케줄 메인에서 항목을 선택하여 옴
		if(Common.isValid(params.get("date"))){
			
			// 스케줄 리스트를 가져옴
			String dd = params.get("date");
			String[] s = dd.split("\\.");
			params.put("date", s[0]);
			params.put("registrant", sid);
			params.put("sid", sid);
			params.put("rownum", params.get("usid"));
			params.put("type", Codes.REGISTRANT_TYPE_HOSPITAL);
//			List<Map> map = SqlDao.getList("Admin.Hospital.Schedule.getListByDate", params);
			List<Map> map = SqlDao.getList("Admin.Hospital.Schedule.getComplexSchedule", params);
			model.addAttribute("userList", map);
			
			// 스케줄 리스트가 있으면
			if(map!=null){
				Iterator<Map> iter = map.iterator();
				while(iter.hasNext()){
					Map m = iter.next();
					
					// 맵에 이름을 바꾸어 다시 삽입
					params.put("year", (String) m.get("d_todo_year"));
					params.put("month", (String) m.get("d_todo_month"));
					params.put("day", (String) m.get("d_todo_day"));
					params.put("hour", (String) m.get("d_todo_hour"));
					params.put("minute", (String) m.get("d_todo_minute"));
					
					// sms 발송 예약 내역이 있는가 살핌
					params.put("msg_id", (String) m.get("s_sms_key"));
//					params.put("send_date", Common.convertDate(m.get("d_sms_time"), "yyyy-MM-dd HH:mm:ss", "yyyyMMddHHmmss"));
					params.put("send_date", SimpleDateFormatter.convert(m.get("d_sms_time"), "yyyy-MM-dd HH:mm:ss", "yyyyMMddHHmmss"));
					params.put("ssid", sessionContext.getData("s_s_sid"));
					
					List smsList = SqlDao.getList("SMS.getSMSByDateKey", params);
					// 없으면 이미 발송됨
					if(smsList == null || smsList.isEmpty()){
						model.addAttribute("sms_sended", "Y");
					}
					
					model.addAttribute("schedule", m);
				}
			}
		}
		
		// 회원관리에서 스케줄 등록으로 옴
		if(Common.isValid(params.get("ids"))){
			
			Map<String, Object> m = new HashMap<String, Object>();
			m.put("list", params.get("ids").split("&"));
			m.put("sid", sid);
			List list = SqlDao.getList("Admin.Point.Hospital.getUserPointWithIn", m);
			model.addAttribute("userList", list);
		}
		
		if(!Common.isValid(params.get("year"))){
			
			Calendar c = Calendar.getInstance();
			
			params.put("year", c.get(Calendar.YEAR)+"");
			params.put("month", (c.get(Calendar.MONTH)+1)+"");
			params.put("day", (c.get(Calendar.DAY_OF_MONTH))+"");
			params.put("hour", (c.get(Calendar.HOUR_OF_DAY))+"");
			params.put("minute", (c.get(Calendar.MINUTE))+"");
			
			params.put("type", "new");
		}
		else
			params.put("type", "modify");
		
		params.put("hospital_name", sessionContext.getData("s_hospital_name"));
		
		model.addAttribute("params", params);
		
		return "admin/hospital/manage/schedule_edit";
	}
	
	@RequestMapping(value = "/manageScheduleEdit_v2.latte")
	public String manageScheduleEditVer2(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("manageScheduleEdit.latte");
		
		SessionContext sessionContext = getSessionContext();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte";
		
		String sid = sessionContext.getData("s_sid");
		
		// 스케줄 메인에서 항목을 선택하여 옴
		if(Common.isValid(params.get("date"))){
			
			// 스케줄 리스트를 가져옴
			String dd = params.get("date");
			String[] s = dd.split("\\.");
			params.put("date", s[0]);
			params.put("registrant", sid);
			params.put("sid", sid);
			params.put("rownum", params.get("usid"));
			params.put("type", Codes.REGISTRANT_TYPE_HOSPITAL);
//			List<Map> map = SqlDao.getList("Admin.Hospital.Schedule.getListByDate", params);
			//List<Map> map = SqlDao.getList("Admin.Hospital.Schedule.getComplexSchedule", params);
			
			List<Map> detail = SqlDao.getList("Admin.Hospital.Schedule.v2.getScheduleDetail", params.get("usid"));
			model.addAttribute("userList", detail);
			
			Map<String, String> schedule = SqlDao.getMap("Admin.Hospital.Schedule.v2.getSchedule", params.get("usid"));
			if(Common.isValid(schedule)){
				
				params.put("year", (String) schedule.get("d_todo_year"));
				params.put("month", (String) schedule.get("d_todo_month"));
				params.put("day", (String) schedule.get("d_todo_day"));
				params.put("hour", (String) schedule.get("d_todo_hour"));
				params.put("minute", (String) schedule.get("d_todo_minute"));
				
				// sms 발송 예약 내역이 있는가 살핌
				params.put("msg_id", (String) schedule.get("s_sms_key"));
//				params.put("send_date", Common.convertDate(m.get("d_sms_time"), "yyyy-MM-dd HH:mm:ss", "yyyyMMddHHmmss"));
				params.put("send_date", SimpleDateFormatter.convert(schedule.get("d_sms_time"), "yyyy-MM-dd HH:mm:ss", "yyyyMMddHHmmss"));
				params.put("ssid", sessionContext.getData("s_s_sid"));
				
				model.addAttribute("schedule", schedule);
			}
			
			List<Map> msgs = SqlDao.getList("Admin.Hospital.Schedule.v2.getScheduleMsg", params.get("usid"));
			model.addAttribute("msgs", msgs);
		}
		
		if(!Common.isValid(params.get("year"))){
			
			Calendar c = Calendar.getInstance();
			
			params.put("year", c.get(Calendar.YEAR)+"");
			params.put("month", (c.get(Calendar.MONTH)+1)+"");
			params.put("day", (c.get(Calendar.DAY_OF_MONTH))+"");
			params.put("hour", (c.get(Calendar.HOUR_OF_DAY))+"");
			params.put("minute", (c.get(Calendar.MINUTE))+"");
			
			params.put("type", "new");
		}
		else
			params.put("type", "modify");
		
		params.put("hospital_name", sessionContext.getData("s_hospital_name"));
		
		model.addAttribute("params", params);
		
		return "admin/hospital/manage/schedule_edit";
	}
	
	private int createSMSType(String splittable){
		
		int result = 0;
		
		if(!Common.isValid(splittable)){
			return result;
		}
		String[] sms_type = splittable.split(";");
		
		for(String str : sms_type){
			if(str.equals(SMS_3D)){
				result |= SMS_TYPE_3D;
			}
			else if(str.equals(SMS_2D)){
				result |= SMS_TYPE_2D;
			}
			else if(str.equals(SMS_1D)){
				result |= SMS_TYPE_1D;
			}
			else if(str.equals(SMS_3H)){
				result |= SMS_TYPE_3H;
			}
		}
		return result;
	}
	
	private int createSMSTypeByTerm(String splittable){
		
		int result = 0;
		
		if(!Common.isValid(splittable)){
			return result;
		}
		String[] sms_type = splittable.split(";");
		
		for(String str : sms_type){
			if(str.equals(SMS_3D_TERM)){
				result |= SMS_TYPE_3D;
			}
			else if(str.equals(SMS_2D_TERM)){
				result |= SMS_TYPE_2D;
			}
			else if(str.equals(SMS_1D_TERM)){
				result |= SMS_TYPE_1D;
			}
			else if(str.equals(SMS_3H_TERM)){
				result |= SMS_TYPE_3H;
			}
		}
		return result;
	}
	
	@RequestMapping(value="/ajaxRegScheduleVer2.latte")
	public @ResponseBody String ajaxRegSchedule_2(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		//logger.info("ajaxRegSchedule.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		JSONSimpleBuilder builder = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth())
			return builder.add("result", Codes.ERROR_UNAUTHORIZED).build();
		
		String sid = sessionContext.getData("s_sid");
		String todo_date = params.get("year")+"-"+params.get("month")+"-"+params.get("day")+" "+params.get("hour")+":"+params.get("minute")+":"+"00";
		
		StringBuffer sb = new StringBuffer();
		
		// 유저 uid 리스트
		String[] ids = Common.isValid(params.get("uid"))?params.get("uid").split(";"):null;
		
		// 유저 폰번호 리스트
		String[] phones = Common.isValid(params.get("phone"))?params.get("phone").split(";"):null;
		
		Calendar calendar = null;
		
		//String[] sms_type = params.get("sms_rsv").split(";");
		//
		int sms_type = createSMSType(params.get("sms_rsv"));
		
		BatchQueryBuilder scheduleMsgQuery = new BatchQueryBuilder();
		
		//StringBuffer rowList = new StringBuffer();
		
		int len = 0;
		
		String sgid = Common.makeRownumber("sgid", System.currentTimeMillis()*123+"");
		
		if(ids!=null){
			len = ids.length;
			
			// SMS 예약 및 등록
			Long seq = null;
			if(sms_type != 0){//sessionContext.getData("s_hospital_name")
				int sms_type_clone = sms_type;
				
				calendar = Calendar.getInstance();
				
				while(sms_type_clone != 0){
					
					calendar.set(Common.toInt(params.get("year")), Common.toInt(params.get("month"))-1, Common.toInt(params.get("day")),
							Common.toInt(params.get("hour")), Common.toInt(params.get("minute")), 0);
					
					String sms_term = "";
					
					// todo date 를 기준으로 sms발송 예약 날짜 계산
					if((sms_type_clone & SMS_TYPE_3D) != 0){
						calendar.add(Calendar.DAY_OF_MONTH, -3);
						sms_type_clone = (sms_type_clone & (SMS_TYPE_3D ^ 0xffffffff));
						sms_term = SMS_3D_TERM;
					}
					else if((sms_type_clone & SMS_TYPE_2D) != 0){
						calendar.add(Calendar.DAY_OF_MONTH, -2);
						sms_type_clone = (sms_type_clone & (SMS_TYPE_2D ^ 0xffffffff));
						sms_term = SMS_2D_TERM;
					}
					else if((sms_type_clone & SMS_TYPE_1D) != 0){
						calendar.add(Calendar.DAY_OF_MONTH, -1);
						sms_type_clone = (sms_type_clone & (SMS_TYPE_1D ^ 0xffffffff));
						sms_term = SMS_1D_TERM;
					}
					else if((sms_type_clone & SMS_TYPE_3H) != 0){
						calendar.add(Calendar.HOUR_OF_DAY, -3);
						sms_type_clone = (sms_type_clone & (SMS_TYPE_3H ^ 0xffffffff));
						sms_term = SMS_3H_TERM;
					}
					
					// SMS 등록
					SMSSender sender = new SMSSender(sessionContext.getData("s_tel")!=null?sessionContext.getData("s_tel").replace("-",""):null);
					sender.sendSMSReserve(phones, "동물병원 문자서비스", params.get("comment"),
							sessionContext.getData("s_s_sid"), SimpleDateFormatter.toString("yyyyMMddHHmmss", calendar));
					seq = sender.getLastKey();
					
					// schedule msg 쿼리 생성
					scheduleMsgQuery.open();
					scheduleMsgQuery.appendString(Common.makeRownumber("scm_row", System.currentTimeMillis()+""));
					scheduleMsgQuery.appendString(sgid);
					scheduleMsgQuery.appendString("SMS");
					scheduleMsgQuery.appendString(SimpleDateFormatter.toString("yyyy-MM-dd HH:mm:ss", calendar.getTime()));
					scheduleMsgQuery.appendRaw(sms_term);
					scheduleMsgQuery.appendString(seq.toString());
					scheduleMsgQuery.close();
					if(sms_type_clone != 0){
						scheduleMsgQuery.lf();
					}
				}
				
				SqlDao.insert("Admin.Hospital.Schedule.v2.insertMSG", scheduleMsgQuery.build());
			}
		}
		
		if(len==0){
			return builder.add("result", Codes.ERROR_MISSING_PARAMETER).build();
		}
		
		// 스케줄 등록
		params.put("sgid", sgid);
		//params.put("uid", ids);
		//params.put("sid", "");
		params.put("registrant", sessionContext.getUserMap().get("s_sid"));
		params.put("type", Codes.REGISTRANT_TYPE_HOSPITAL);
		params.put("todo_date", params.get("year")+"-"+params.get("month")+"-"+params.get("day")+" "+params.get("hour")+":"+params.get("minute")+":"+"00");
		
		int result = SqlDao.insert("Admin.Hospital.Schedule.v2.insertSchedule", params);
		
		// 스케줄 해당 유저/동물 입력
		
		BatchQueryBuilder detailQuery = new BatchQueryBuilder();
		
		int user_cnt = Common.lengthOf(ids);
		
		for(int i = 0; i < user_cnt; i++){
			
			detailQuery.open();
			detailQuery.appendString(Common.makeRownumber("sd_row", System.currentTimeMillis()*1234+""));
			detailQuery.appendString(sgid);
			detailQuery.appendString(ids[i]);
			detailQuery.appendString("");
			detailQuery.appendString("Y");
			detailQuery.appendRaw("NULL");
			detailQuery.close();
			if(i < user_cnt-1){
				detailQuery.lf();
			}
		}

		String sss = detailQuery.build();
		int result2 = SqlDao.insert("Admin.Hospital.Schedule.v2.insertDetails", sss);//detailQuery.build());
		
		builder.add("rownum", sgid);
		
		//int result = SqlDao.insert("Admin.Hospital.Schedule.v2.insertSchedules", query);
		
//		builder.add("rownum", rowList.toString());
		
		if(result > 0)
			return builder.postAdd("result", Codes.SUCCESS_CODE).build();
		else
			return builder.postAdd("result", Codes.ERROR_QUERY_EXCEPTION).build();
		//return ";";
	}
	@RequestMapping(value="/ajaxRegSchedule.latte")
	public @ResponseBody String ajaxRegSchedule(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		//logger.info("ajaxRegSchedule.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		JSONSimpleBuilder builder = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth())
			return builder.add("result", Codes.ERROR_UNAUTHORIZED).build();
		
		String sid = sessionContext.getData("s_sid");
		String todo_date = params.get("year")+"-"+params.get("month")+"-"+params.get("day")+" "+params.get("hour")+":"+params.get("minute")+":"+"00";
		
		StringBuffer sb = new StringBuffer();
		
		// 유저 uid 리스트
		String[] ids = Common.isValid(params.get("uid"))?params.get("uid").split(";"):null;
		
		// 유저 폰번호 리스트
		String[] phones = Common.isValid(params.get("phone"))?params.get("phone").split(";"):null;
		
		Calendar calendar = null;
		
		String sms_type = params.get("sms_rsv");
		
		if(Common.isValid(sms_type)){
			
			calendar = Calendar.getInstance();
			calendar.set(Common.toInt(params.get("year")), Common.toInt(params.get("month"))-1, Common.toInt(params.get("day")),
					Common.toInt(params.get("hour")), Common.toInt(params.get("minute")), 0);
			
			if(sms_type.equals(SMS_3D)){
				calendar.add(Calendar.DAY_OF_MONTH, -3);
			}
			else if(sms_type.equals(SMS_1D)){
				calendar.add(Calendar.DAY_OF_MONTH, -1);
			}
			else if(sms_type.equals(SMS_3H)){
				calendar.add(Calendar.HOUR_OF_DAY, -3);
			}
			else if(sms_type.equals(SMS_1H)){
				calendar.add(Calendar.HOUR_OF_DAY, -1);
			}
		}
		
		//StringBuffer rowList = new StringBuffer();
		
		int len = 0;
		
		if(ids!=null){
			len = ids.length;
			
			Long seq = null;
			if(calendar != null){//sessionContext.getData("s_hospital_name")
				SMSSender sender = new SMSSender(sessionContext.getData("s_tel")!=null?sessionContext.getData("s_tel").replace("-",""):null);
				if(sms_type.equals(SMS_NOW)){
					sender.sendSMS(phones, "동물병원 문자서비스", params.get("comment"), sessionContext.getData("s_s_sid"));
				}
				else{
					String rsv = (new SimpleDateFormat("yyyyMMddHHmmss")).format(calendar.getTime());
					sender.sendSMSReserve(phones, "동물병원 문자서비스", params.get("comment"), sessionContext.getData("s_s_sid"), rsv);
				}
				seq = sender.getLastKey();
			}
			
			String usid = Common.makeRownumber("usid", System.currentTimeMillis()*123+"");
			
			for(int i = 0; i < len; i++){
				
				//rowList.append(usid);
				sb.append("('");
				sb.append(usid);
				sb.append("','");
				sb.append(ids[i]);
				sb.append("','");
				sb.append(sid);
				sb.append("','");
				sb.append(sid);
				sb.append("','");
				sb.append(Codes.REGISTRANT_TYPE_HOSPITAL);
				sb.append("','");
				sb.append(todo_date);
				sb.append("','");
				sb.append(params.get("comment"));
				sb.append("',NOW(),'Y'");
				
				//sb.append(b)
				
				if(calendar != null){
					if(sms_type.equals(SMS_NOW)){
						sb.append(",'");
//						sb.append((new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")).format(Calendar.getInstance().getTime()));
						sb.append(SimpleDateFormatter.toString("yyyy-MM-dd HH:mm:ss"));
						sb.append("',0,");
						sb.append(seq);
					}
					else{
						sb.append(",'");
						//sb.append((new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")).format(calendar.getTime()));
						sb.append(SimpleDateFormatter.toString("yyyy-MM-dd HH:mm:ss", calendar));
//						sb.append(String.format("%04d-%02d-%02d %02d:%02d:%02d", 
//								calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH)+1, calendar.get(Calendar.DAY_OF_MONTH),
//								calendar.get(Calendar.HOUR_OF_DAY), calendar.get(Calendar.MINUTE), calendar.get(Calendar.SECOND)));
						sb.append("',");
						if(sms_type.equals(SMS_3D)){
							sb.append(SMS_3D_TERM);
						}
						else if(sms_type.equals(SMS_1D)){
							sb.append(SMS_1D_TERM);
						}
						else if(sms_type.equals(SMS_3H)){
							sb.append(SMS_3H_TERM);
						}
						else if(sms_type.equals(SMS_1H)){
							sb.append(SMS_1H_TERM);
						}
						sb.append(",");
						sb.append(seq);
					}
				}
				else{
					sb.append(",NULL,0,NULL");
				}
				
				sb.append(")");
				
				if(i < len-1){
					//rowList.append(";");
					sb.append(",");
				}
			}
			
			builder.add("rownum", usid);
		}
		String query = sb.toString();
		
		if(len==0){
			return builder.add("result", Codes.ERROR_MISSING_PARAMETER).build();
		}
		
		int result = SqlDao.insert("Admin.Hospital.Schedule.insertSchedules", query);

//		builder.add("rownum", rowList.toString());
		
		if(result > 0)
			return builder.postAdd("result", Codes.SUCCESS_CODE).build();
		else
			return builder.postAdd("result", Codes.ERROR_QUERY_EXCEPTION).build();
		//return ";";
	}
	
	@RequestMapping(value="/ajaxUpdateScheduleVer2.latte")
	public @ResponseBody String ajaxUpdateScheduleVer2(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		////logger.info("ajaxUpdateSchedule.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		JSONSimpleBuilder builder = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth())
			return builder.add("result", Codes.ERROR_UNAUTHORIZED).build();
		
		String sid = sessionContext.getData("s_sid");
		
		params.put("todo_date", params.get("year")+"-"+params.get("month")+"-"+params.get("day")+" "+params.get("hour")+":"+params.get("minute")+":"+"00");
		
		String[] phones = Common.isValid(params.get("phone"))?params.get("phone").split(";"):null;
		
		// 기존 스케줄 정보를 가져옴
		String rownum = params.get("rownum");
		//Map origin = null;
		Map origin_info = null;
		if(rownum!=null){
			//origin = SqlDao.getMap("Admin.Hospital.Schedule.getOneSchedule", rownum);
			
			origin_info = SqlDao.getMap("Admin.Hospital.Schedule.v2.getScheduleInfo", rownum);
		}
		// 기존 스케줄 정보를 가져올 수 없음
		if(origin_info==null){
			return builder.add("result", Codes.ERROR_MISSING_PARAMETER).build();
		}
		
		boolean is_different = false;
		
		// 날짜가 다른가?
		{
			Date ori_date = null;
			Date mod_date = null;
			
			ori_date = SimpleDateFormatter.toDate("yyyy-MM-dd HH:mm:ss", Common.toString(origin_info.get("d_todo_date")));
			mod_date = SimpleDateFormatter.toDate("yyyy-MM-dd HH:mm:ss", Common.toString(params.get("todo_date")));
			
			if(ori_date != null && mod_date != null){
				is_different = !ori_date.equals(mod_date);
			}
		}
		
		// 내용이 다른가?
		if(!is_different){
			is_different = !Common.strEqualNN(origin_info.get("s_comment"), params.get("comment"));
		}
		
		// 사람이 다른가?
		{
			
		}
		
		// 예약일이 변경됨?
		int sms_type = createSMSType(params.get("sms_rsv"));
		int old_sms_type = createSMSTypeByTerm((String) origin_info.get("terms"));
		
		if(sms_type != old_sms_type){
			is_different = true;
		}
		
		int result = 0;
		
		String sgid = params.get("rownum");
		params.put("sgid", sgid);
		//params.put("rownum", "('"+params.get("rownum").replaceAll(";", "','")+"')");
		
		// 업데이트가 필요함
		if(is_different){
			
			// 등록된 메세지를 삭제
			String[] msg_keys = ((String) origin_info.get("_key")).split(";");
			for(int i = 0; i < msg_keys.length; i++){
				SMSUtil.getInstance().cancelSMS(msg_keys[i]);
			}
			SqlDao.delete("Admin.Hospital.Schedule.v2.deleteMSG", sgid);
			
			// 메세지 새로 추
			BatchQueryBuilder scheduleMsgQuery = new BatchQueryBuilder();
			
			Long seq = null;
			
			Calendar calendar = null;
			//String sms_type = params.get("sms_rsv");
			
			
			
			if(sms_type != 0){//sessionContext.getData("s_hospital_name")
				int sms_type_clone = sms_type;
				
				calendar = Calendar.getInstance();
				
				while(sms_type_clone != 0){
					
					calendar.set(Common.toInt(params.get("year")), Common.toInt(params.get("month"))-1, Common.toInt(params.get("day")),
							Common.toInt(params.get("hour")), Common.toInt(params.get("minute")), 0);
					
					String sms_term = "";
					
					// todo date 를 기준으로 sms발송 예약 날짜 계산
					if((sms_type_clone & SMS_TYPE_3D) != 0){
						calendar.add(Calendar.DAY_OF_MONTH, -3);
						sms_type_clone = (sms_type_clone & (SMS_TYPE_3D ^ 0xffffffff));
						sms_term = SMS_3D_TERM;
					}
					else if((sms_type_clone & SMS_TYPE_2D) != 0){
						calendar.add(Calendar.DAY_OF_MONTH, -2);
						sms_type_clone = (sms_type_clone & (SMS_TYPE_2D ^ 0xffffffff));
						sms_term = SMS_2D_TERM;
					}
					else if((sms_type_clone & SMS_TYPE_1D) != 0){
						calendar.add(Calendar.DAY_OF_MONTH, -1);
						sms_type_clone = (sms_type_clone & (SMS_TYPE_1D ^ 0xffffffff));
						sms_term = SMS_1D_TERM;
					}
					else if((sms_type_clone & SMS_TYPE_3H) != 0){
						calendar.add(Calendar.HOUR_OF_DAY, -3);
						sms_type_clone = (sms_type_clone & (SMS_TYPE_3H ^ 0xffffffff));
						sms_term = SMS_3H_TERM;
					}
					
					// SMS 등록
					SMSSender sender = new SMSSender(sessionContext.getData("s_tel")!=null?sessionContext.getData("s_tel").replace("-",""):null);
					sender.sendSMSReserve(phones, "동물병원 문자서비스", params.get("comment"),
							sessionContext.getData("s_s_sid"), SimpleDateFormatter.toString("yyyyMMddHHmmss", calendar));
					seq = sender.getLastKey();
					
					// schedule msg 쿼리 생성
					scheduleMsgQuery.open();
					scheduleMsgQuery.appendString(Common.makeRownumber("scm_row", System.currentTimeMillis()+""));
					scheduleMsgQuery.appendString(sgid);
					scheduleMsgQuery.appendString("SMS");
					scheduleMsgQuery.appendString(SimpleDateFormatter.toString("yyyy-MM-dd HH:mm:ss", calendar.getTime()));
					scheduleMsgQuery.appendRaw(sms_term);
					scheduleMsgQuery.appendString(seq.toString());
					scheduleMsgQuery.close();
					if(sms_type_clone != 0){
						scheduleMsgQuery.lf();
					}
				}
				
				SqlDao.insert("Admin.Hospital.Schedule.v2.insertMSG", scheduleMsgQuery.build());
			}
			
			result = SqlDao.update("Admin.Hospital.Schedule.v2.updateSchedule", params);
		}
		else{
			result = 1;
		}
		
		if(result > 0)
			return builder.add("result", Codes.SUCCESS_CODE).build();
		else
			return builder.add("result", Codes.ERROR_QUERY_EXCEPTION).build();
	}
	
	@RequestMapping(value="/ajaxUpdateSchedule.latte")
	public @ResponseBody String ajaxUpdateSchedule(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		//logger.info("ajaxUpdateSchedule.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		JSONSimpleBuilder builder = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth())
			return builder.add("result", Codes.ERROR_UNAUTHORIZED).build();
		
		String sid = sessionContext.getData("s_sid");
		
		params.put("todo_date", params.get("year")+"-"+params.get("month")+"-"+params.get("day")+" "+params.get("hour")+":"+params.get("minute")+":"+"00");
		
		String[] phones = Common.isValid(params.get("phone"))?params.get("phone").split(";"):null;
		
		// 기존 스케줄 정보를 가져옴
		String rownum = params.get("rownum");
		Map origin = null;
		if(rownum!=null){
			origin = SqlDao.getMap("Admin.Hospital.Schedule.getOneSchedule", rownum);
		}
		
		// 기존 스케줄 정보를 가져올 수 없음
		if(origin==null){
			return builder.add("result", Codes.ERROR_MISSING_PARAMETER).build();
		}
		
		params.put("rownum", "('"+params.get("rownum").replaceAll(";", "','")+"')");
		
		int SMS_NO_UPDATE = 0;
		int SMS_DELETE_ONLY = 1;
		int SMS_UPDATE = 2;
		int sms_update_state = SMS_NO_UPDATE;
		
		String sms_key = params.get("sms_key");
		
		Long seq = null;
		
		Calendar calendar = null;
		String sms_type = params.get("sms_rsv");
		// sms 예약함
		if(Common.isValid(sms_type)){
			
			boolean addFlag = false;
			boolean delFlag = false;
			
			calendar = Calendar.getInstance();
			calendar.set(Common.toInt(params.get("year")), Common.toInt(params.get("month"))-1, Common.toInt(params.get("day")),
					Common.toInt(params.get("hour")), Common.toInt(params.get("minute")), 0);
			if(sms_type.equals(SMS_3D)){
				calendar.add(Calendar.DAY_OF_MONTH, -3);
			}
			else if(sms_type.equals(SMS_1D)){
				calendar.add(Calendar.DAY_OF_MONTH, -1);
			}
			else if(sms_type.equals(SMS_3H)){
				calendar.add(Calendar.HOUR_OF_DAY, -3);
			}
			else if(sms_type.equals(SMS_1H)){
				calendar.add(Calendar.HOUR_OF_DAY, -1);
			}
			
			// 삭제 후 추가
			if(Common.isValid(sms_key)){
				
				Date ori_date = null;
				Date mod_date = null;
				try {
					ori_date = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")).parse(Common.toString(origin.get("d_todo_date")));
					mod_date = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")).parse(Common.toString(params.get("todo_date")));
					
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				boolean different_date = false;
				if(ori_date != null && mod_date != null){
					different_date = !ori_date.equals(mod_date);
				}
				
				String ori_term = Common.toString(origin.get("n_sms_term"));
				boolean diff_sms_term = false;
				if((sms_type.equals(SMS_3D) && !ori_term.equals(SMS_3D_TERM))
						|| (sms_type.equals(SMS_1D) && !ori_term.equals(SMS_1D_TERM))
						|| (sms_type.equals(SMS_3H) && !ori_term.equals(SMS_3H_TERM))
						|| (sms_type.equals(SMS_1H) && !ori_term.equals(SMS_1H_TERM))
						|| (sms_type.equals(SMS_NOW) && !ori_term.equals("0"))){
					diff_sms_term = true;
				}
				
				// 기존과 다르면 추가 후 삭제
				if(different_date || diff_sms_term || !Common.strEqualNN(origin.get("s_comment"), params.get("comment"))){
					
					addFlag = true;
					delFlag = true;
				}
			}
			else{
				addFlag = true;
			}
			
			if(addFlag){
				
				if(calendar != null){
					SMSSender sender = new SMSSender(sessionContext.getData("s_tel")!=null?sessionContext.getData("s_tel").replace("-",""):null);
					if(sms_type.equals(SMS_NOW)){
						sender.sendSMS(phones, "동물병원 문자서비스", params.get("comment"), sessionContext.getData("s_s_sid"));
					}
					else{
						String rsv = (new SimpleDateFormat("yyyyMMddHHmmss")).format(calendar.getTime());
						sender.sendSMSReserve(phones, "동물병원 문자서비스", params.get("comment"), sessionContext.getData("s_s_sid"), rsv);
					}
					seq = sender.getLastKey();
				}
				sms_update_state = SMS_UPDATE;
			}
			
			if(delFlag){
				SMSUtil.getInstance().cancelSMS(sms_key);
			}
		}
		// 예약 안 함. 기존에 sms가 있었음. 삭제
		else if(Common.isValid(sms_key)){
			
			if(SMSUtil.getInstance().cancelSMS(sms_key)){
				sms_update_state = SMS_DELETE_ONLY;
			}
		}
		
		if(sms_update_state==SMS_NO_UPDATE){
			
		}
		// 문자 제거됨
		else if(sms_update_state==SMS_DELETE_ONLY){
			params.put("sms_update", "Y");
			params.put("n_sms_term", "0");
		}
		else if(sms_update_state==SMS_UPDATE){
			params.put("sms_update", "Y");
			
			// 문자 전송 예약 날짜
			if(!sms_type.equals(SMS_NOW)){
				params.put("d_sms_time", SimpleDateFormatter.toString("yyyy-MM-dd HH:mm:ss", calendar));
			}
			else{
				params.put("d_sms_time", SimpleDateFormatter.toString("yyyy-MM-dd HH:mm:ss"));
			}
			
			// 문자 전송 예약 날짜 계산용 텀
			if(sms_type.equals(SMS_3D)){
				params.put("n_sms_term", SMS_3D_TERM);
			}
			else if(sms_type.equals(SMS_1D)){
				params.put("n_sms_term", SMS_1D_TERM);
			}
			else if(sms_type.equals(SMS_3H)){
				params.put("n_sms_term", SMS_3H_TERM);
			}
			else if(sms_type.equals(SMS_1H)){
				params.put("n_sms_term", SMS_1H_TERM);
			}
			else{
				params.put("n_sms_term", "0");
			}
			
			// 문자 테이블 키
			if(seq!=null){
				params.put("s_sms_key", seq.toString());
			}
		}
		
		int result = SqlDao.update("Admin.Hospital.Schedule.updateSchedules", params);
		
		if(result > 0)
			return builder.add("result", Codes.SUCCESS_CODE).build();
		else
			return builder.add("result", Codes.ERROR_QUERY_EXCEPTION).build();
	}
	
	@RequestMapping(value="/ajaxRemoveScheduleVer2.latte")
	public @ResponseBody String ajaxRemoveSchedule_v2(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		////logger.info("ajaxRemoveSchedule.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		JSONSimpleBuilder builder = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth())
			return builder.add("result", Codes.ERROR_UNAUTHORIZED).build();
		
		//params.put("rownum", "('"+params.get("rownum").replaceAll(";", "','")+"')");
		String str = "('"+params.get("rownum").replaceAll(";", "','")+"')";
		
		// 기존 스케줄 정보를 가져옴
		String rownum = params.get("rownum");
//		Map origin = null;
//		if(rownum!=null){
//			origin = SqlDao.getMap("Admin.Hospital.Schedule.getOneSchedule", rownum);
//		}
		
		Map origin_info = null;
		if(rownum!=null){
			//origin = SqlDao.getMap("Admin.Hospital.Schedule.getOneSchedule", rownum);
			
			origin_info = SqlDao.getMap("Admin.Hospital.Schedule.v2.getScheduleInfo", rownum);
		}
		// 기존 스케줄 정보를 가져올 수 없음
		if(origin_info==null){
			return builder.add("result", Codes.ERROR_MISSING_PARAMETER).build();
		}
		else{
			String sgid = params.get("rownum");
			
			// 등록된 메세지를 삭제
			String s = (String) origin_info.get("_key");
			if(s!=null){
				String[] msg_keys = s.split(";");
				for(int i = 0; i < msg_keys.length; i++){
					SMSUtil.getInstance().cancelSMS(msg_keys[i]);
				}
			}
			SqlDao.delete("Admin.Hospital.Schedule.v2.deleteMSG", sgid);
		}
		
		int result = SqlDao.update("Admin.Hospital.Schedule.v2.removeSchedule", params.get("rownum"));
		
		//SMSUtil.getInstance().cancelSMS((String) origin.get("s_sms_key"));
//		String sms_key = params.get("sms_key");
//		if(Common.isValid(sms_key)){
//			Map m = SqlDao.getMap("SMS.getSMS", sms_key);
//			if(m != null){
//				int r = SqlDao.delete("SMS.deleteSMS", sms_key);
//			}
//		}
		
		if(result > 0)
			return builder.add("result", Codes.SUCCESS_CODE).build();
		else
			return builder.add("result", Codes.ERROR_QUERY_EXCEPTION).build();
	}
	
	@RequestMapping(value="/ajaxRemoveSchedule.latte")
	public @ResponseBody String ajaxRemoveSchedule(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		//logger.info("ajaxRemoveSchedule.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		JSONSimpleBuilder builder = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth())
			return builder.add("result", Codes.ERROR_UNAUTHORIZED).build();
		
		//params.put("rownum", "('"+params.get("rownum").replaceAll(";", "','")+"')");
		String str = "('"+params.get("rownum").replaceAll(";", "','")+"')";
		
		// 기존 스케줄 정보를 가져옴
		String rownum = params.get("rownum");
		Map origin = null;
		if(rownum!=null){
			origin = SqlDao.getMap("Admin.Hospital.Schedule.getOneSchedule", rownum);
		}
		
		int result = SqlDao.update("Admin.Hospital.Schedule.removeSchedules", str);
		
		SMSUtil.getInstance().cancelSMS((String) origin.get("s_sms_key"));
//		String sms_key = params.get("sms_key");
//		if(Common.isValid(sms_key)){
//			Map m = SqlDao.getMap("SMS.getSMS", sms_key);
//			if(m != null){
//				int r = SqlDao.delete("SMS.deleteSMS", sms_key);
//			}
//		}
		
		if(result > 0)
			return builder.add("result", Codes.SUCCESS_CODE).build();
		else
			return builder.add("result", Codes.ERROR_QUERY_EXCEPTION).build();
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ajaxRequestAnniversary.latte")
	public @ResponseBody String ajaxRequestAnniversary(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		//logger.info("ajaxRequestAnniversary.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte?rePage=myPageSchedule.latte";
		
		params.put("sid", sessionContext.getData("s_sid"));
		
		if(Common.isValid(params.get("month"))){
			
			//DateMapBuilder dmBuilder = new DateMapBuilder();
			List<Map> list = SqlDao.getList("Admin.Hospital.Schedule.getSolarAnniversaryList", params.get("month").split("-")[0]);
			//dmBuilder.insertList(list);
			
			Map<String, List<Map>> map = new HashMap<String, List<Map>>();
			
			map = insertDateMap(map, list);
//			Iterator<Map> iter = list.iterator();
//			while(iter.hasNext()){
//				Map m = iter.next();
//				
//				List<Map> l = map.get(m.get("d"));
//				if(l==null){
//					l = new ArrayList<Map>();
//					map.put((String) m.get("d"),l);
//				}
//				m.remove("d");
//				l.add(m);
//			}
			
			params.put("type", Codes.REGISTRANT_TYPE_HOSPITAL);
			list = SqlDao.getList("Admin.Hospital.Schedule.v2.getListForCalendar", params);
			map = insertDateMap(map, list);
			
//			iter = list.iterator();
//			while(iter.hasNext()){
//				Map m = iter.next();
//				
//				List<Map> l = map.get(m.get("d"));
//				if(l==null){
//					l = new ArrayList<Map>();
//					map.put((String) m.get("d"),l);
//				}
//				m.remove("d");
//				l.add(m);
//			}
			
			return JSONUtil.toEncodedJSONString(map);//dmBuilder.getMapList());
		}
		
		return "";
	}
	
//	@RequestMapping(value="/tttest.latte")
//	public @ResponseBody String tttest(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
//		//logger.info("tttest.latte");
//		
//		SMSSender sender = new SMSSender(null);
//		
//		sender.sendSMS("01024781727", "동물병원 TEST", "테스트입니다1", "test");
//		
//		Long l = sender.getLastKey();
//		
//		System.out.println(l);
//		
//		return "";
//	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private Map insertDateMap(Map map, List<Map> list){
		
		Iterator<Map> iter = list.iterator();
		while(iter.hasNext()){
			Map m = iter.next();
			
			List<Map> l = (List<Map>) map.get(m.get("d"));
			if(l==null){
				l = new ArrayList<Map>();
				map.put((String) m.get("d"),l);
			}
			m.remove("d");
			l.add(m);
		}
		return map;
	}
	

	@RequestMapping(value="/ajaxVaccineConfirm.latte")
	public @ResponseBody String ajaxVaccineConfirm(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		////logger.info("ajaxUpdateSchedule.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		JSONSimpleBuilder builder = new JSONSimpleBuilder();
		
		if(!sessionContext.isAuth())
			return builder.add("result", Codes.ERROR_UNAUTHORIZED).build();
		
		String sid = sessionContext.getData("s_sid");
		
		params.put("todo_date", params.get("year")+"-"+params.get("month")+"-"+params.get("day")+" "+params.get("hour")+":"+params.get("minute")+":"+"00");
		
		//String[] phones = Common.isValid(params.get("phone"))?params.get("phone").split(";"):null;
		
		// 기존 스케줄 정보를 가져옴
		String rownum = params.get("rownum");
		//Map origin = null;
		Map origin_info = null;
		if(rownum!=null){
			//origin = SqlDao.getMap("Admin.Hospital.Schedule.getOneSchedule", rownum);
			
			origin_info = SqlDao.getMap("Admin.Hospital.Schedule.v2.getScheduleInfo", rownum);
		}
		// 기존 스케줄 정보를 가져올 수 없음
		if(origin_info==null){
			return builder.add("result", Codes.ERROR_MISSING_PARAMETER).build();
		}
		
		int result = 0;
		
		String vaccine_group = (String) origin_info.get("s_vaccine_group");
		
		// 만약 예방접종일 경우 다음 접종 날짜를 갱신 및 예약 메세지 발송 등록
		if(Common.isValid(vaccine_group)){
			
			if(vaccine_group.equals(Codes.VACCINATION_BASIC_SET)){
			
				// 원래 todo date
				Calendar c = SimpleDateFormatter.toCalendar("yyyy-MM-dd", origin_info.get("d_todo_date").toString());
				
				// 현재 시간
				Calendar now = CalendarSub.getApproxInstance(CalendarSub.APPROX_DAY);
				
				int distance = (int) ((now.getTimeInMillis() - c.getTimeInMillis()) / 86400000);
				
				c.add(Calendar.DAY_OF_YEAR, distance);
				
				// 메세지 날짜 변경
				String c1 = (String) origin_info.get("s_comment");
				c1 = c1.replaceAll("[0-9]{4}년 [0-9]{2}월 [0-9]{2}일", SimpleDateFormatter.toString("yyyy년 MM월 dd일", c));
				
				// 인증표시
				Map<String,String> m = new HashMap<String, String>();
				m.put("index", origin_info.get("n_vaccine_index").toString());
				m.put("confirmer", sid);
				m.put("sgid", rownum);
				m.put("comment", c1);
				result = SqlDao.update("Admin.Hospital.Schedule.v2.updateSchedule", m);
				
				// 이후 접종 스케줄 날짜 일괄 수정
				m.put("complement", distance+"");
				m.put("group_id", (String) origin_info.get("s_group_id"));
				SqlDao.update("Admin.Hospital.Schedule.v2.updateNextVaccineSchedule", m);
				
				//Map next_schedule = SqlDao.getMap("Admin.Hospital.Schedule.v2.getNextVaccineSchedule",m);
				
				// 
				List<Map> next_schedules = SqlDao.getList("Admin.Hospital.Schedule.v2.getNextVaccineSchedule",m);
				int next_schedule_index = 0;
				Iterator<Map> next_schedule_iter = next_schedules.iterator();
				while(next_schedule_iter.hasNext()){
					
					Map next_schedule = next_schedule_iter.next();
					
					String comment = (String)next_schedule.get("s_comment");
					c = SimpleDateFormatter.toCalendar("yyyy-MM-dd HH:mm:ss", next_schedule.get("d_todo_date").toString());
					comment = comment.replaceAll("[0-9]{4}년 [0-9]{2}월 [0-9]{2}일", SimpleDateFormatter.toString("yyyy년 MM월 dd일", c));
					
					// 각 스케줄 날짜 수정
					m = new HashMap<String, String>();
					m.put("sgid", (String) next_schedule.get("s_sgid"));
					m.put("comment", comment);
					result = SqlDao.update("Admin.Hospital.Schedule.v2.updateSchedule", m);
					
					
					if(next_schedule_index==0){
						
						// 스케줄에 유저 리스트를 가져옴
						List<Map> detail = SqlDao.getList("Admin.Hospital.Schedule.v2.getScheduleDetail", next_schedule.get("s_sgid"));
						
						// 전화번호만 추출함(sms 파라미터로 넘김)
						Iterator<Map> iter = detail.iterator();
						int size = detail.size();
						String[] phones = new String[size];
						int p_index = 0;
						while(iter.hasNext()){
							Map m1 = iter.next();
							phones[p_index] = (String) m1.get("s_cphone_number");
							p_index++;
						}
					
						// 마지막 추가된 sms key값
						Long seq = null;
						
						BatchQueryBuilder scheduleMsgQuery = new BatchQueryBuilder();
						
						for(int day = 1; day > 0; day--){
							
							Calendar calendar = SimpleDateFormatter.toCalendar("yyyy-MM-dd HH:mm:ss", next_schedule.get("d_todo_date").toString()); 
							calendar.add(Calendar.DAY_OF_MONTH, -day);
							
							// 예약 시간이 현재 시간 이후일 경우만 등록
							if(calendar.getTimeInMillis() - System.currentTimeMillis() < 0){
								continue;
							}
							
							String sms_term = (day*86400)+"";
							
							SMSSender sender = new SMSSender(sessionContext.getData("s_tel"));
							String rsv = SimpleDateFormatter.toString("yyyyMMddHHmmss", calendar);
							sender.sendSMSReserve(phones, "동물병원 문자서비스", comment, sessionContext.getData("s_s_sid"), rsv);
							seq = sender.getLastKey();
							
							scheduleMsgQuery.open();
							scheduleMsgQuery.appendString(Common.makeRownumber("scm_row", System.currentTimeMillis()+""));
							scheduleMsgQuery.appendString((String) next_schedule.get("s_sgid"));
							scheduleMsgQuery.appendString("SMS");
							scheduleMsgQuery.appendString(SimpleDateFormatter.toString("yyyy-MM-dd HH:mm:ss", calendar));
							scheduleMsgQuery.appendRaw(sms_term);
							scheduleMsgQuery.appendString(seq+"");
							scheduleMsgQuery.close();
							if(day > 1){
								scheduleMsgQuery.lf();
							}
						}
						
						String s = scheduleMsgQuery.build();
						if(!s.isEmpty()){
							int result3 = SqlDao.insert("Admin.Hospital.Schedule.v2.insertMSG", s);
						}
					}
					else{
						
					}
					next_schedule_index++;
				}	
			}
			else if(vaccine_group.equals(Codes.VACCINATION_DIROFILARIA)){
				
				// 인증표시
				Map<String,String> m = new HashMap<String, String>();
				m.put("index", origin_info.get("n_vaccine_index").toString());
				m.put("confirmer", sid);
				m.put("sgid", rownum);
				result = SqlDao.update("Admin.Hospital.Schedule.v2.updateSchedule", m);
			}
		}
		else{
			
			// 인증표시
			Map<String,String> m = new HashMap<String, String>();
			m.put("index", origin_info.get("n_vaccine_index").toString());
			m.put("confirmer", sid);
			m.put("sgid", rownum);
			result = SqlDao.update("Admin.Hospital.Schedule.v2.updateSchedule", m);
		}
		
		if(result > 0)
			return builder.add("result", Codes.SUCCESS_CODE).build();
		else
			return builder.add("result", Codes.ERROR_QUERY_EXCEPTION).build();
	}
}
