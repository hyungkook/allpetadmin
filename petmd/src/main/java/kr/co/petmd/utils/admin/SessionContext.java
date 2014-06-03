package kr.co.petmd.utils.admin;

import java.io.Serializable;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Scope(value="session")
@Component("sessionContext")
@SuppressWarnings("unused")
public class SessionContext implements Serializable  {
	
	private class SessionBlock implements Serializable{
		
		private static final long serialVersionUID = 1103189812174206438L;
		private boolean auth;
		private Map<String, String> dataMap;
		
		public SessionBlock(){
			auth = false;
			dataMap = null;
		}
		
		public boolean isAuth() {
			return auth;
		}

		public void setAuth (boolean auth) {
			this.auth = auth;
		}
		
		public Map<String, String> getUserMap() {
			return dataMap;
		}

		public void setUserMap(Map<String, String> dataMap) {
			this.dataMap = dataMap;
		}
		
		public String getData(String key){
			
			if(dataMap==null)
				return null;
			else
				return dataMap.get(key);
		}
	}
	
	private static final long serialVersionUID = -7368942518628048455L;
	
	private boolean auth;
	private boolean totalAuth;
	private Map<String, String> userMap;
	private Set<String> keySet = new HashSet<String>();
	
	Map<String, SessionBlock> blockMap = new HashMap<String, SessionContext.SessionBlock>();
	
	public void setAuth(String sessionKey, boolean auth){
		
		SessionBlock sb = blockMap.get(sessionKey);
		if(sb==null){
			sb = new SessionBlock();
			sb.setAuth(auth);
			blockMap.put(sessionKey, sb);
		}
		else{
			sb.setAuth(auth);
		}
	}
	
	public boolean isAuth(String sessionKey){
		
		if(blockMap.get(sessionKey)==null)
			return false;
		
		return blockMap.get(sessionKey).isAuth();
	}
	
	public Map<String, String> getDataMap(String sessionKey){
		
		if(blockMap.get(sessionKey)==null)
			return null;
		
		return blockMap.get(sessionKey).getUserMap();
	}
	
	public String getData(String sessionKey, String dataKey){
		
		if(blockMap.get(sessionKey)==null)
			return null;
		
		if(blockMap.get(sessionKey).getUserMap()==null)
			return null;
		
		return blockMap.get(sessionKey).getUserMap().get(dataKey);
	}
	
	public void setDataMap(String sessionKey, Map<String, String> dataMap){
		
		SessionBlock sb = blockMap.get(sessionKey);
		if(sb==null){
			sb = new SessionBlock();
			sb.setUserMap(dataMap);
			blockMap.put(sessionKey, sb);
		}
		else{
			if(sb.getUserMap()!=null){
				sb.getUserMap().clear();
			}
			sb.setUserMap(dataMap);
		}
	}
	
	public void clear(String sessionKey){
		
		SessionBlock sb = blockMap.get(sessionKey);
		if(sb!=null){
			sb.setAuth(false);
			if(sb.getUserMap()!=null){
				sb.getUserMap().clear();
				sb.setUserMap(null);
			}
		}
	}
	
	
	
	public Map<String, String> getUserMap() {
		return userMap;
	}

	public void setUserMap(Map<String, String> userMap) {
		this.userMap = userMap;
	}
	
	public String getData(String key){
		if(userMap==null)
			return null;
		else
			return userMap.get(key);
	}
	
	public boolean isAuth() {
	    return auth;
	}

	public void setAuth (boolean auth) {
		this.auth = auth;
	}
	
	public synchronized void clear(){
		
		if(userMap!=null){
			userMap.clear();
			userMap = null;
		}
		
		if(keySet!=null)
			keySet.clear();
		
		auth = false;
	}
}
