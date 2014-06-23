package kr.co.petmd.dao;

import java.util.List;
import java.util.Map;

import kr.co.petmd.utils.common.Common;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;


public class SqlDao {
	@Autowired
	private static SqlSessionTemplate sqlSession;
	
	@SuppressWarnings("static-access")
	public void setSqlSession(SqlSessionTemplate sqlSession) {
		this.sqlSession = sqlSession;
	}
	
	public static String getDBURL(){
		
		try {
			return sqlSession.getConfiguration().getEnvironment().getDataSource().getConnection().getMetaData().getURL();
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			return null;
		}
	}
	
	@SuppressWarnings("rawtypes")
	public static List<Map> getList(String sqlName, Object param){
		List<Map> list = null;
		try {
			list = sqlSession.selectList(sqlName, param);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	public static Map<String, String> getMap(String sqlName, Object param){
		Map<String, String> map = null;
		try {
			map = sqlSession.selectOne(sqlName, param);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return map;
	}
	
	public static String getString(String sqlName, Object param){
		String result = null;
		try {
			result = sqlSession.selectOne(sqlName, param);
		} catch (Exception e) {
				e.printStackTrace();
		}
		
		return result;
	}
	
	public static int getInt(String sqlName, Object param){
		int result = -1;
		try {
			result = sqlSession.selectOne(sqlName, param);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	public static int insert(String sqlName, Object param){
		int result = -1;
		try {
			result = sqlSession.insert(sqlName, param);
		} catch (Exception e) {
				e.printStackTrace();
		}
		return result;
	}
	
	public static String insertReturnString(String sqlName, Object param){
		String result = "";
		try {
			result = Common.isNull(String.valueOf(sqlSession.insert(sqlName, param)));
		} catch (Exception e) {
				e.printStackTrace();
		}
		return result;
	}
	
	public static int update(String sqlName, Object param){
		int result = -1;
		try {
			result = sqlSession.update(sqlName, param);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public static int delete(String sqlName, Object param){
		int result = -1;
		try {
			result = sqlSession.delete(sqlName, param);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public static Map<String, Map<String,String>> getMapInMap(String sqlName, Object param, String mapKey){
		Map<String, Map<String,String>> map = null;
		try {
			map = sqlSession.selectMap(sqlName, param, mapKey);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return map;
	}
	
	public static Map<String, Map<String,String>> getMap(String sqlName, Object param, String mapKey){
		Map<String, Map<String,String>> map = null;
		try {
			map = sqlSession.selectMap(sqlName, param, mapKey);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return map;
	}
}
