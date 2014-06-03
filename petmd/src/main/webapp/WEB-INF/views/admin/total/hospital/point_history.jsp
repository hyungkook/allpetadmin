<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>

<script>

	function pageChange(pageNumber) {

		var url = 'hospitalPointHistory.latte'
			+'?sid=${params.sid}'
			+'&pageNumber='+pageNumber;
			
		if(!isNoValue('search_value')){
			url += '&search_type='+$('#search_type').val();
			url += '&search_value='+escape(encodeURIComponent($('#search_value').val()));
		}
		
		goPage(url);
	}
	
	$(document).ready(function(){
		selectTopMenu("topmenu_hospital");
		selectSubMenu("submenu_hospital_search");
	});

</script>

<jsp:include page="tabmenu.jsp">
	<jsp:param value="tab_point" name="jsp_select_tab"/>
</jsp:include>

<!-- <form id="form" name="form" method="post" action="hospitalPointHistory.latte"> -->
	<input type="hidden" id="pageNumber" name="pageNumber" />
	<input type="hidden" id="sid" name="sid" value="${params.sid}"/>
	 <div class="box716 mt30">
     	<div class="view_box mt55">
			<P class="view_search mt25 mb20">
	            <span id="p_hasPoint">현재 부채 포인트 </span> <span id="span_hasPoint" class="txt_r20_b" style="padding:0 10px 0 40px;">
				<c:if test="${total.sum_pt > 0}">
	       			<fmt:formatNumber value="${total.sum_pt}" pattern="#,##0" />
	       		</c:if>
	       		<c:if test="${total.sum_pt < 1}"> 0 </c:if>
	       			<img src="${con.IMGPATH_OLD}/common/icon_p.gif" alt=""/></span>
	        <div id ="pointTab">
	       		<jsp:include page="point_history_list.jsp"></jsp:include>
	       </div>
       </div>
    </div>
    <div class="paging">
   		<p class="btn_r" style="padding-right:30px">
   			<a href="${params.back}" class="black01">이전 페이지</a> 
   		</p>
   	</div>
    <div class="list_search">
    	<select class="searchsel" id="search_type" style="width:80px;">
        <option value="name">고객명</option>
        </select><input id="search_value" name="s_name" type="text" class="input_search" style="width:170px;"  value="${params.search_value}" onkeydown="if(window.event.keyCode==13) pageChange(1);"/>
        <a style="cursor:pointer;" onClick="pageChange(1)" class="black01">검색</a> 
    </div>
<!-- </form> -->