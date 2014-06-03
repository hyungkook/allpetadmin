<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>

<script>

$(document).ready(function(){
	selectTopMenu("topmenu_hospital");
	selectSubMenu("submenu_hospital_search");
});

function pageChange(pageNumber){
	
	location.href='hospitalSearch.latte?search_type='+$('#search_type').val()
	+'&search_value='+escape(encodeURIComponent($('#search_value').val()))
	+'&pageNumber='+pageNumber;
}

</script>

<div class="search_area">
	<div class="box_l">
		<!-- 병원 검색 -->
		<select class="searchsel" id="search_type" style="width:80px;">
			<option value="name" <c:if test="${params.search_type eq 'name'}">selected="selected"</c:if>>병원명</option>
		</select><input class="input_search" style="width:170px;" type="text" id="search_value" value="${params.search_value}" onkeydown="if(window.event.keyCode==13) pageChange('1');"/>
		<a style="cursor:pointer;" onclick="pageChange(1);" class="black01">검색</a>
	</div>
</div>

<div class="box1200 mt30">
	<p class="s_data">샵 총 수<span><fmt:formatNumber value="${params.totalCount}" pattern="#,###" /></span> 개</p>
	<table cellpadding="0" border="0" cellspacing="0" class="table_list">
		<colgroup>
			<col width="40" />		<!--	<th class="bgn">번호</th>	-->
			<col width="75" />		<!--	<th>등록일</th>				-->
			<col width="75" />		<!--	<th>담당팀</th>				-->
			<col width="75" />		<!--	<th>담당자</th>				-->
			<col width="*" />		<!--	<th>샵</th>					-->
			<col width="*" />		<!--	<th>아이디</th>				-->
			<col width="120" />		<!--	<th>시</th>					-->
			<col width="120" />		<!--	<th>구</th>					-->
			<col width="120" />		<!--	<th>동</th>					-->
			<col width="120" />		<!--	<th>동</th>					-->
			<col width="120" />		<!--	<th>동</th>					-->
			<col width="75" />		<!--	<th>상태</th>				-->
		</colgroup>
		<tr>
			<th class="bgn">번호</th>
			<th>등록일</th>
			<th>담당팀</th>
			<th>담당자</th>
			<th>샵</th>
			<th>아이디</th>
			<th>시</th>
			<th>구</th>
			<th>동</th>
			<th>포인트 불출횟수</th>
			<th>현재 부채포인트</th>
			<th>상태</th>
		</tr>
		<c:forEach items="${hospitalList}" var="list" varStatus="c">
		<tr>
			<td class="bgn">${params.listStartNumber - (c.count -1) }</td>
			<td class="bgn">${list.d_reg_date}</td>
			<td class="bgn">${list.s_team}</td>
			<td class="bgn">${list.s_name}</td>
			<td class="bgn"><a href="hospitalReg.latte?sid=${list.s_sid}">${list.s_hospital_name}</a></td>
			<td class="bgn">${list.s_hospital_id}</td>
			<td class="bgn">${list.s_old_addr_sido}</td>
			<td class="bgn">${list.s_old_addr_sigungu}</td>
			<td class="bgn">${list.s_old_addr_dong}</td>
			<td class="bgn">${list.pay_count}</td>
			<td class="bgn">${list.minus_sum}</td>
			<td class="bgn"><c:choose>
			<c:when test="${list.s_status eq codes.HOSPITAL_STATUS_NORMAL}">정상</c:when>
			<c:when test="${list.s_status eq codes.HOSPITAL_STATUS_ABANDONED}">폐업</c:when>
			</c:choose></td>
		</tr>
		</c:forEach>
	</table>
	<jsp:include page="/WEB-INF/views/admin/total/include/paging.jsp"/>
</div>