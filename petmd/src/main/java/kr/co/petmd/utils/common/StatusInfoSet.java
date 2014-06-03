package kr.co.petmd.utils.common;

import java.util.Map;

public class StatusInfoSet {

	public String group;
	public String lcode;
	public String mcode;
	public String scode;
	public String type;
	public String field;
	public int lv;
	
	public StatusInfoSet(String group, String lcode, String mcode, String scode, String type, String field){
		
		this.group = group;
		this.lcode = lcode;
		this.mcode = mcode;
		this.scode = scode;
		if(scode!=null&&!scode.equals("")) lv = 4;
		if(scode==null||scode.equals("")) lv = 3;
		if(mcode==null||mcode.equals("")) lv = 2;
		if(lcode==null||lcode.equals("")) lv = 1;
		if(group==null||group.equals("")) lv = 0;
		this.type = type;
		this.field = field;
	}
	
	public static void setFields(StatusInfoSet infoSet, Map<String, String> map){
		
		map.put("field_name", infoSet.field);
		map.put("type", infoSet.type);
		map.put("group", infoSet.group);
		map.put("lcode", infoSet.lcode);
		map.put("mcode", infoSet.mcode);
		map.put("scode", infoSet.scode);
		map.put("lv", infoSet.lv+"");
	}
}
