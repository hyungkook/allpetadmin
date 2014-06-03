package kr.co.petmd.utils.common;

import java.util.HashMap;
import java.util.Map;

public class SequenceUtil {
	
	private static Map<String, SequenceUtil> map = new HashMap<String, SequenceUtil>();
	
	public synchronized static void init(){
		
		if(map.isEmpty()){
			map.put("default", new SequenceUtil());
		}
	}
	
	public synchronized static SequenceUtil getSequenceUtil(String name){
		
		return map.get(name);
	}
	
	public synchronized static int getSeq(String name) throws NullPointerException{
		
		return map.get(name).getSeq();
	}
	
	private int seq = 0;

	public synchronized int getSeq(){

		seq++;
		return seq;
	}
	
	public synchronized void reset(){
		
		seq = 0;
	}
}
