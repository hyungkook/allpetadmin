<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!-- <ul data-role="listview" data-split-icon="gear" data-split-theme="d" style="overflow:hidden; padding:0; margin:0;"> -->
<p data-param-name="result" data-result-pagecount="${params.pageCount}"/>
<c:forEach var="item" items="${userTodoList}">

<li class="li_slist" data-icon="false">
	<c:set var="ymdhms" value="${fn:split(item.d_todo_date,' ')}"/>
	<c:set var="ymd" value="${fn:split(ymdhms[0],'-')}"/>
	<c:set var="hms" value="${fn:split(ymdhms[1],':')}"/>
<%-- 	<a onclick="goPage('manageScheduleEdit.latte?date=${item.d_todo_date}&usid=${item.s_rownumber}')" class="list_info" style="overflow:hidden; position:relative;"> --%>
	<a onclick="goPage('manageScheduleEdit_v2.latte?date=${item.d_todo_date}&usid=${item.s_sgid}')" class="list_info" style="overflow:hidden; position:relative;">
		<p>${item.s_name} (<span id="phone">${item.s_cphone_number}</span>)</p><!-- s_cphone_number -->
		<h3 class="h3_tt01">${item.s_comment}</h3>
		<p class="data">[${ymd[0]}-${ymd[1]}-${ymd[2]} ${hms[0]}:${hms[1]}]</p>
		<c:if test="${not empty item.s_confirmer}">
		<p class="t_thum_end">완료</p>
		<p class="bu"><img src="${con.IMGPATH}/common/bu_end.png" alt="" width="17" height="17"/></p>
		</c:if>
		<c:if test="${empty item.s_confirmer}">
		<c:if test="${item.date_diff < 0}">
		<p class="t_thum_end">만료</p>
		<p class="bu"><img src="${con.IMGPATH}/common/bu_end.png" alt="" width="17" height="17"/></p>
		</c:if>
		<c:if test="${item.date_diff >= 0}">
		<p class="t_thum"><label>D-Day</label>${item.date_diff}</p>
		</c:if>
		</c:if>
	</a>  
</li>

</c:forEach>
<!-- </ul> -->