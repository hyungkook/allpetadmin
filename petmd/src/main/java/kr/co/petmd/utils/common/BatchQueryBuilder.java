package kr.co.petmd.utils.common;

public class BatchQueryBuilder {
	
	private StringBuilder sb = new StringBuilder();
	private boolean first = false;
	
	public void open(){
		sb.append("(");
		first = true;
	}
	
	public void close(){
		sb.append(")");
		first = false;
	}
	
	public void lf(){
		sb.append(",");
	}

	public void appendString(String str){
		if(first){
			first = false;
		}
		else{
			sb.append(",");
		}
		sb.append("'");
		sb.append(str);
		sb.append("'");
	}
	
	public void appendRaw(Object str){
		if(first){
			first = false;
		}
		else{
			sb.append(",");
		}
		sb.append(str.toString());
	}
	
	public String build(){
		
		return sb.toString();
	}
}
