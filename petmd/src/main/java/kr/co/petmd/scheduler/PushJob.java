package kr.co.petmd.scheduler;

import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.gcm.GCMServerSide;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.StatefulJob;

public class PushJob implements StatefulJob{

	@Override
	public void execute(JobExecutionContext context) throws JobExecutionException {
		// TODO Auto-generated method stub
		
		List<Map> list = SqlDao.getList("Admin.Push.Schedule.getAllSchedule", null);
		
		Calendar now = Calendar.getInstance();
		
		Iterator<Map> iter = list.iterator();
		GCMServerSide gcm = new GCMServerSide();
		while(iter.hasNext()){
			Map map = iter.next();
			Date pushDate = (Date)map.get("s_push_date");
			if (!(pushDate.getTime() <= now.getTimeInMillis())) {
				continue;
			}
			int idx = (Integer)map.get("s_idx");
			String phone_regId = (String) map.get("s_phone_regId");
			
			String sgid = (String) map.get("s_sgid");
			String comment = (String) map.get("s_message");
			
			String pushMessage = sgid + ";" + comment;
			
			if( phone_regId != null ) {
				// push 발송
				try{
					gcm.sendMessage(phone_regId, pushMessage);
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			
			// 해당 메세지 삭제
			deleteJob(idx);
			
		}
	}
	
	public int deleteJob( int idx ){
		return SqlDao.delete("Admin.Push.Schedule.deleteSchedule", idx);
	}

}
