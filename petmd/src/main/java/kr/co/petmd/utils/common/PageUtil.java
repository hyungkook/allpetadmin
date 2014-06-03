package kr.co.petmd.utils.common;

import java.util.Map;



public class PageUtil {
	/* 페이지 구성에 필요한 정보들------------------------------------------- */
	int pageNumber = 1; 								// 요청 페이지 번호
	int onePageCountRow = 15;					 		// 한 페이지에 보이는 행의 수
	int totalCount = 0;									// 총 결과 수
	int pageCount = 1; 									// 페이지 수
	int groupCount = 1;									// 그룹 수
	int groupNumber = 0; 								// 현재 그룹 번호 (그룹 번호는 0부터로, 페이지 1-10까지가 그룹 0)
	int pageGroupCount = 10; 							// 한페이지당 표시될 그룹[]개수
	int startPage = 1; 									// 화면에 표시되야 하는 페이지 시작
	int endPage = 10;									// 화면에 표시되어야 하는 그룹페이지 끝
	int startRow = 0; 									// 결과 테이블의 가장 상위에 위치하는 열
//	int endRow = 0; 									// 결과 테이블의 가장 하위에 위치하는 열 (오라클용)
	int endRow = onePageCountRow;						// mysql용
	int modNum = 0;										// 페이지 나머지 수
	int listStartNumber = 1;							// 리스트 시작 번호 
	/* ---------------------------------------------------------------------- */
	/** 페이지 DAO 를 생성해줍니다 **/
	public static PageUtil getInstance() {
		
		return new PageUtil();
	}
	
	public int getStartRow() {
		return startRow;
	}

	public void setStartRow(int startRow) {
		this.startRow = startRow;
	}

	public int getEndRow() {
		return endRow;
	}

	public void setEndRow(int endRow) {
		this.endRow = endRow;
	}
	
	/** 두번째 매개변수에 페이지에 보여줄 리스트의 갯수를 적어주시면 됩니다 **/
	public Map<String, String> pageSetting(Map<String, String> pageMap,int endRow){
		this.onePageCountRow=this.endRow=endRow;
		return pageSetting(pageMap, "");
	}

	/** 세번째 매개변수에 페이지 그룹의 숫자를 넣어주시면 됩니다 **/
	public Map<String, String> pageSetting(Map<String, String> pageMap, int endRow, int pageGroupCount){
		this.pageGroupCount = pageGroupCount;
		return pageSetting(pageMap,endRow);
	}
	
	/** 두번째 매개변수에 페이지에 보여줄 리스트의 갯수를 적어주시면 됩니다
	 * prefix를 추가하면 'prefix + 기존이름 첫글자 대문자' 형태로 저장됩니다 **/
	public Map<String, String> pageSetting(Map<String, String> pageMap, int endRow, String prefix){
		this.onePageCountRow=this.endRow=endRow;
		return pageSetting(pageMap, prefix);
	}
	
	/** 기본세팅된 대로 페이징 됩니다 **/
	public Map<String, String> pageSetting(Map<String, String> pageMap, String prefix){
	
		totalCount = Common.IntConvertNvl(pageMap.get("totalCount"), 0);
		
		String pageNumberName = mergePrefix(prefix,"pageNumber");			
		
		if(Common.IntConvertNvl(pageMap.get(pageNumberName), 0) > 1) {
			pageNumber = Common.IntConvertNvl(pageMap.get(pageNumberName), 0);
		}
				
		if (totalCount == 0) {
			endPage = 1 ;
		}else{			
			
			// 총 페이지 수 재설정
			if (totalCount % onePageCountRow == 0) {
				pageCount = totalCount / onePageCountRow;
			} else {
				pageCount = (totalCount / onePageCountRow) + 1;
			}
			
			// 요청 페이지와 최종 페이지 번호 비교
			if (pageNumber > pageCount) {
				pageNumber = pageCount;
			}

			// 총 그룹 수 재설정 - set to request
			if (pageCount % endPage == 0) {
				groupCount = pageCount / endPage;

			} else {
				groupCount = (pageCount / endPage) + 1;
			}
			
			// 현재 그룹 번호 재설정
			if (pageNumber % endPage == 0) {
				groupNumber = (pageNumber / endPage) - 1;
			} else {
				groupNumber = pageNumber / endPage;
			}
			
			// 표시될 페이지 시작값 설정 - set to request
			startPage = (groupNumber) * endPage + 1;
			
			// 표시될 페이지 끝값 설정 - set to request
			endPage = (groupNumber) * endPage + endPage;
			if (pageCount < endPage) {
				endPage = pageCount;
			}
			// 표시될 결과 시작열 설정
			startRow = (pageNumber - 1) * onePageCountRow ;
			
			if(totalCount % onePageCountRow>0){
				modNum=totalCount % onePageCountRow;
			}else{
				modNum=onePageCountRow;
			}
			
			listStartNumber = (pageCount - pageNumber) * onePageCountRow + modNum;
		}
		
		pageMap.put(pageNumberName, pageNumber + "");
		pageMap.put(mergePrefix(prefix,"onePageCountRow"), onePageCountRow + "");
		pageMap.put(mergePrefix(prefix,"totalCount"), totalCount + "");
		pageMap.put(mergePrefix(prefix,"pageCount"), pageCount + "");
		pageMap.put(mergePrefix(prefix,"groupCount"), groupCount + "");
		pageMap.put(mergePrefix(prefix,"groupNumber"), groupNumber + "");
		pageMap.put(mergePrefix(prefix,"pageGroupCount"), pageGroupCount + "");
		pageMap.put(mergePrefix(prefix,"startPage"), startPage + "");
		pageMap.put(mergePrefix(prefix,"endPage"), endPage + "");
		pageMap.put(mergePrefix(prefix,"startRow"), startRow + "");
		pageMap.put(mergePrefix(prefix,"endRow"), endRow + "");
		pageMap.put(mergePrefix(prefix,"modNum"), modNum + "");
		pageMap.put(mergePrefix(prefix,"listStartNumber"), listStartNumber + "");
		
		return pageMap;
	}

	private String mergePrefix(String prefix, String origin){
		
		if(Common.isValid(prefix))
			return prefix+Common.capitalize(origin);
		else
			return origin;
	}
	
	public String createJSONString(){
		
		StringBuilder sb = new StringBuilder();
		
		sb.append("{\"pageNumber\":\"");	sb.append(pageNumber);		sb.append("\",");
		sb.append("\"onePageCountRow\":\"");sb.append(onePageCountRow);	sb.append("\",");
		sb.append("\"totalCount\":\"");		sb.append(totalCount);		sb.append("\",");
		sb.append("\"pageCount\":\"");		sb.append(pageCount);		sb.append("\",");
		sb.append("\"groupCount\":\"");		sb.append(groupCount);		sb.append("\",");
		sb.append("\"groupNumber\":\"");	sb.append(groupNumber);		sb.append("\",");
		sb.append("\"pageGroupCount\":\"");	sb.append(pageGroupCount);	sb.append("\",");
		sb.append("\"startPage\":\"");		sb.append(startPage);		sb.append("\",");
		sb.append("\"endPage\":\"");		sb.append(endPage);			sb.append("\",");
		sb.append("\"startRow\":\"");		sb.append(startRow);		sb.append("\",");
		sb.append("\"endRow\":\"");			sb.append(endRow);			sb.append("\",");
		sb.append("\"modNum\":\"");			sb.append(modNum);			sb.append("\",");
		sb.append("\"listStartNumber\":\"");sb.append(listStartNumber);	sb.append("\"}");
		
		return sb.toString();
	}
}
