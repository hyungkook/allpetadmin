<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:forEach var="item" items="${petList}">
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
</c:if>