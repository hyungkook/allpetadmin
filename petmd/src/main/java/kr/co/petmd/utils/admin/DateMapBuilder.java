package kr.co.petmd.utils.admin;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class DateMapBuilder {
	
	// insert 날짜 중복시 하위 리스트에 연속으로 붙이기 위한 용도
	private Map<String,Object> dateMap = null;
	
	// JSP에서 달력 생성시 사용하는 리스트
	private List<Map> listMap = null;
	
	public DateMapBuilder(){
		
		dateMap = new HashMap<String,Object>();
		
		listMap = new ArrayList<Map>();
	}
	
	/**
	 * dataMap과 listMap을 다른 DateMapBuilder에서 받아와서 공유하여 날짜 중복을 막는다.
	 */
	public DateMapBuilder(DateMapBuilder dmBuilder){
		
		this.dateMap = dmBuilder.dateMap;
		this.listMap = dmBuilder.listMap;
	}

	public DateMapBuilder(Map dateMap, List listMap){
		
		this.dateMap = dateMap;
		this.listMap = listMap;
	}
	
	public void insertList(List<Map> list){
		
		Iterator<Map> iter = list.iterator();
		while(iter.hasNext()){
			Map m = iter.next();
			insertDate((String)m.get("s_type"), (String)m.get("s_comment"), (String)m.get("solar_date"));
		}
	}
	
	public void insertDate(String type, String comment, String todo_date){
		
		Map<String, String> dm = new HashMap<String, String>();
		dm.put("type", type);
		dm.put("comment", comment);
		
		List dl = (List)dateMap.get(todo_date);
		
		if(dl == null){
			dl = new ArrayList<Map<String,String>>();
			dl.add(dm);
			dateMap.put(todo_date, dl);
			
			Map<String, Object> sm = new HashMap<String, Object>();
			sm.put("d", todo_date);
			sm.put("v", dl);
			listMap.add(sm);
		}
		else{
			dl.add(dm);
		}
	}
	
	public Map<String,Object> getDateMap(){
		
		return dateMap;
	}
	
	/**
	 * {[{"d":"20130101"},{"v",[{{"type","h"},{"comment","신정"}},{{"type","s"},{"comment","어떤날"}}]}]}
	 *	d = 날짜(양력)
	 *	v = 값 리스트
	 *	type = {h = 휴일}
	 *	comment = 설명
	 */
	public List<Map> getMapList(){
		
		return listMap;
	}
}
