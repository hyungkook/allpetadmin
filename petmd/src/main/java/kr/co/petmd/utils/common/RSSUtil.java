package kr.co.petmd.utils.common;

import java.util.ArrayList;
import java.util.Map;

public class RSSUtil {

	public static ArrayList<Map> search(ArrayList<Map> list, String type, String text){
		
		if(!Common.isValid(type))
			return list;
		
		int len = list.size();
		ArrayList l = null;
		String s = null;
		
		ArrayList<Map> newList = new ArrayList<Map>();
		
		for(int i = 0; i < len; i++){
			
			if(type.equals("subjectcontents")){
				l = XMLParserUtil.getValue(list.get(i), "title");
				if(l != null && !l.isEmpty() && l.get(0) instanceof String){
					s = (String) l.get(0);
					if(s.indexOf(text)!=-1){
						newList.add(list.get(i));
						continue;
					}
				}
				l = XMLParserUtil.getValue(list.get(i), "description");
				if(l != null && !l.isEmpty() && l.get(0) instanceof String){
					s = (String) l.get(0);
					if(s.indexOf(text)!=-1){
						newList.add(list.get(i));
						continue;
					}
				}
			}
		}
		
		return newList;
	}
}
