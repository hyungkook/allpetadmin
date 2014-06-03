package kr.co.petmd.utils.common;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import kr.co.petmd.dao.SqlDao;


public class CustomizeUtil {
	
	private static CustomizeUtil instance = null;
	
	public static CustomizeUtil getInstance(){
		
		if(instance==null){
			instance = new CustomizeUtil();
		}
		
		return instance;
	}
	
	private CustomizeUtil(){}
	
	/**
	 * id > sid 등의 id 병원이나 스탭 등의 고유 아이디
	 * parent > subinfo를 구하고자 하는 개체의 cmid
	 */
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static Map putAllToMap(List<Map> srcList, Map dest, boolean ignore_status){
		
		Map<String, String> map = null;
		if(dest==null)
			map = new HashMap<String, String>();
		else
			map = dest;
		
		if(map != null && srcList != null){
			Iterator<Map> iter = srcList.iterator();
			
			while(iter.hasNext()){
				Map src = iter.next();
				String key = (String)src.get("s_key");
				map.put("attr_"+key.toLowerCase(), Common.toString(src.get("s_value")));
			}
		}
		
		return map;
	}

	/**
	 * getAttributesByParent 으로 변경됨.
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List<Map> getAttributesByParentForEach(Map<String,String> params){
		
		List<Map> list = SqlDao.getList("COMMON.getByParent", params);
				
		// 각 메뉴의 정보를 가져와 합친다.
		Iterator<Map> iter = list.iterator();
		while(iter.hasNext()){
			Map map = iter.next();
			if(map != null){
				Map m = SqlDao.getMap("COMMON.getCustomAttrById", map.get("s_cmid"), "s_key");
				map.putAll(m);
			}
		}
		
		return list;
	}
	
	/**
	 * parent 값으로 커스터마이징 값 리스트를 가져옴.
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List<Map> getAttributesByParent(Map<String,String> params){
		
		List<Map> list = SqlDao.getList("COMMON.getByParent", params);
		
		// 카테고리 정보 리스트
		List cateList = SqlDao.getList("COMMON.getCustomCategoryByParent", params);
		// 개별 정보 리스트
		List infoList = SqlDao.getList("COMMON.getCustomInfoByParent", params);
		
		// 리스트 맵 추출
		Map cateMap = Common.listToGroupByListMap(cateList, "s_group");
		Map infoMap = Common.listToGroupByListMap(infoList, "s_cmid");
		
		// 각 항목에 대하여
		for(Map listMap:list){
			// 카테고리 정보 삽입
			String group = (String) listMap.get("s_group");
			List<Map> cateMapList = (List<Map>) cateMap.get(group);
			if(cateMapList!=null){
				for(Map lmm:cateMapList){
					listMap.put(lmm.get("s_key"), lmm.get("s_value"));
				}
			}
			// 개별 정보 삽입. (카테고리랑 충돌시 덮어씀)
			String id = (String) listMap.get("s_cmid");
			List<Map> infoMapList = (List<Map>) infoMap.get(id);
			if(infoMapList!=null){
				for(Map lmm:infoMapList){
					listMap.put(lmm.get("s_key"), lmm.get("s_value"));
				}
			}
		}
		
		return list;
	}
}
