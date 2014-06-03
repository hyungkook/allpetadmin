<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%-- <c:forEach var="item" items="${petList}">
	<div style="overflow:hidden; border-bottom:1px solid gray;">
		<div style="float:left;">
			<p>
				<span>${item.s_pet_name}</span>&nbsp;<span>${item._species}</span>
			</p>
			<p>
				<c:if test="${item.age_second >= 60*60*24*365}">
				<c:set var="age"><fmt:formatNumber value="${item.age_second/60/60/24/365}" pattern="0"/>년</c:set>
				</c:if>
				<c:if test="${item.age_second >= 60*60*24*30 and item.age_second < 60*60*24*365}">
				<c:set var="age"><fmt:formatNumber value="${item.age_second/60/60/24/30}" pattern="0"/>개월</c:set>
				</c:if>
				<c:if test="${item.age_second < 60*60*24*30}">
				<c:set var="age"><fmt:formatNumber value="${item.age_second/60/60/24}" pattern="0"/>일</c:set>
				</c:if>
				<span>${item._breed}</span>&nbsp;|&nbsp;<span>${age}</span>
			</p>
		</div>
		<div style="float:right;">
			<a data-role="button" onclick="goPage('petRegPage.latte?pid=${item.s_pid}');" style="padding:10px 20px; border:1px solid black;">▷</a>
		</div>
	</div>
</c:forEach>
<c:if test="${not empty petList}">
<jsp:include page="/common/admin/hospital/INC_PAGE.jsp">
	<jsp:param value="${params.pagingBlockId}" name="pagingBlockId"/>
	<jsp:param value="${params.pagingSendValue}" name="pagingSendValue"/>
</jsp:include>
</c:if>
<c:if test="${empty petList}">
<p>등록된 반려 동물이 없습니다.</p>
</c:if> --%>
<div class="a_type01">
	<h3 id="user_name">홍길동<span class="t01">님의 반려동물</span><span class="orange">(${params.totalCount})</span></h3>
	<c:forEach var="item" items="${petList}">
	<div class="a_box mt05">
		<h4><span class="orange">[${item._species}]</span> ${item.s_pet_name}</h4>
		<table class="table_type04">
			<colgroup>
				<col width="65px" /><col width="*" />
			</colgroup>
			<tr>
				<th>종류</th>
				<td>${item._species}</td>
			</tr>
			<tr>
				<th>품종</th>
				<td>${item._breed}</td>
			</tr>
			<tr>
				<th>성별</th>
				<td><c:choose><c:when test='${item.s_gender eq "F"}'>여아</c:when><c:when test='${item.s_gender eq "M"}'>남아</c:when></c:choose></td>
			</tr>
			<c:set var="ymd" value="${fn:split(fn:split(item.d_birthday,' ')[0],'-')}"/>
			<tr>
				<th>생일</th>
				<td>${ymd[0]}년 ${ymd[1]}월 ${ymd[2]}일</td>
			</tr>
			<tr>
				<th>중성화</th>
				<td><c:choose><c:when test='${item.s_neutralize eq "Y"}'>완료</c:when><c:when test='${item.s_neutralize eq "N"}'>해당없음</c:when><c:when test='${item.s_neutralize eq "R"}'>예정</c:when></c:choose></td>
			</tr>
			<tr>
				<th>등록번호</th>
				<td>${item.s_reg_number}</td>
			</tr>
		</table>
	</div>
	</c:forEach>
</div>