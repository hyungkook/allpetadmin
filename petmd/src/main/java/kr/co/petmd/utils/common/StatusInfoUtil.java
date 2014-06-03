package kr.co.petmd.utils.common;

import java.util.Iterator;
import java.util.List;
import java.util.Map;


public class StatusInfoUtil {
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static Map raw_merge(List<Map> srcList, Map dest, boolean ignore_status){
		
		if(dest != null && srcList != null){
			Iterator<Map> iter = srcList.iterator();
			
			String codeName = "";
			String typeName = "";
			int lv = 0;
			
			while(iter.hasNext()){
				Map src = iter.next();
				
				if(ignore_status || Common.strEqual((String) src.get("s_status"),"Y")){
					
					lv = Common.toInt(src.get("n_lv"));
					switch(lv){
					case 0:
						codeName = "";
						break;
					case 1:
						codeName = "s_group";
						break;
					case 2:
						codeName = "s_lcode";
						break;
					case 3:
						codeName = "s_mcode";
						break;
					}
					
					String type = (String) src.get("s_type");
					if(Common.strEqual(type, "SVAL")){
						typeName = "s_sval";
					}
					else if(Common.strEqual(type, "LVAL")){
						typeName = "s_lval";
					}
					else if(Common.strEqual(type, "NVAL")){
						typeName = "s_nval";
					}
					else if(Common.strEqual(type, "STAT")){
						typeName = "s_status";
					}

					if(src.get(typeName)!=null){
						dest.put((String) src.get(codeName), Common.toString(src.get(typeName)));
						dest.put((String)src.get(codeName)+"_status", Common.toString(src.get("s_status")));
					}
				}
			}
		}
		
		return dest;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static Map merge(List<Map> srcList, Map dest, boolean ignore_status){
		
		if(dest != null && srcList != null){
			Iterator<Map> iter = srcList.iterator();
			
			while(iter.hasNext()){
				Map src = iter.next();
				
				if(ignore_status || Common.strEqual((String) src.get("s_status"),"Y")){

					dest.put((String)src.get("s_name"), Common.toString(src.get("s_val")));
					dest.put((String)src.get("s_name")+"_status", Common.toString(src.get("s_status")));
				}
			}
		}
		
		return dest;
	}
}
