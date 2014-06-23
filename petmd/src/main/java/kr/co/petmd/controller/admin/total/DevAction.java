package kr.co.petmd.controller.admin.total;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;

import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.admin.Codes;
import kr.co.petmd.utils.common.Common;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class DevAction {

	private static final Logger logger = LoggerFactory.getLogger(DevAction.class);
	
	@RequestMapping(value = "/dev_1.latte")
	public String dev_1(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		logger.info("dev_1.latte");
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		String date = sdf.format(new Date());
		
		int max = 100;
		
		String[] descs = new String[]{"예방접종 1차","사료 구매시 사용","예방접종-광견병 예방 주사 접종",
				"일반 진료"};
		
		Random r = new Random();
		
		StringBuffer sb = new StringBuffer();
		
		for(int i = 0; i < max; i++){
			
			sb.append("(");
			
			String id = date+String.format("%03d", i+1);
			
			Map<String, String> map = new HashMap<String, String>();
			
			if(i%10==0)
				r.setSeed(System.currentTimeMillis());
			
			int pe = r.nextInt(max);
			int po = r.nextInt(max);
			int dd = r.nextInt(86400 * 150);
			
//			map.put("s_hupid", id);
//			map.put("s_uid", "uid_f810f2499916ff676e52b5cd0e8b35add03b563e52bf88accdfa267c4cf6d9b6");
//			map.put("s_sid", id);
//			map.put("s_type", p<70?Codes.USER_POINT_PAY:Codes.USER_POINT_RETURN);
//			map.put("n_point", p+"");
//			map.put("s_desc", p+id+p+System.currentTimeMillis());
			sb.append("'"+id+"',");
			sb.append("'uid_71582431d35792f525df2cf605adeb6571364415f1937a6090cf125457e0f89b',");
			sb.append("'s_sid001',");
			sb.append("'"+(pe<70?Codes.USER_POINT_TYPE_HOSPI_TO_USER:Codes.USER_POINT_TYPE_USER_TO_HOSPI)+"',");
			sb.append("'"+(pe<70?po:-po)+"',");
			sb.append("'"+(descs[r.nextInt(descs.length)])+"',");
			
			sb.append("FROM_UNIXTIME(UNIX_TIMESTAMP(NOW())-"+(dd)+"))");
			if(i<max-1)
				sb.append(",");
		}
		SqlDao.insert("Dev.insertUserPoint", sb.toString());
		
		Map<String,Object> map = new HashMap<String, Object>();
		List<String> list = new ArrayList<String>();
		list.add("s_cmid002");
		list.add("s_cmid004");
		map.put("ids", list);
		
		List rl = SqlDao.getList("Dev.inTest", map);
		
		return "client/hospital/hospital_service_admin";
	}
	
	@RequestMapping(value = "/editCustomCategory.latte")
	public String editCustomCategory(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		logger.info("editCustomCategory.latte");
		
		return "client/hospital/hospital_service_admin";
	}
	
	@RequestMapping(value = "/qtest1.latte")
	public String qtest1(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		logger.info("qtest1.latte");
		
		SqlDao.update("Dev.updatetest1", "1");
		
		return "";
	}
	
}
