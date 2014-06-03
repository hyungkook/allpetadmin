<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<div class="tab">
	<div class="tab_area">
		<ul>
			<c:set var="curMenu" value="<%= request.getParameter(\"curMainMenu\") %>"/>
			<c:set var="mainMenuLen" value="${fn:length(mainMenu)}"/>
			<li style="width:28%;" class="<c:if test="${curMenu-1 eq c.index}">noborder</c:if><c:if test="${curMenu eq c.index}">on</c:if><c:if test="${curMenu ne c.index and mainMenuLen eq c.count}">noborder</c:if>"><a onclick="goPage('manageHome.latte');" data-role="button">메인메뉴 편집</a></li>
			<li style="width:12%;" class="<c:if test="${curMenu-1 eq c.index}">noborder</c:if><c:if test="${curMenu eq c.index}">on</c:if><c:if test="${curMenu ne c.index and mainMenuLen eq c.count}">noborder</c:if>"><a<%--  onclick="goPage('manageStatistics.latte');" --%> data-role="button"><strike>통계</strike></a></li>
			<li style="width:44%;" class="<c:if test="${curMenu-1 eq c.index}">noborder</c:if><c:if test="${curMenu eq c.index}">on</c:if><c:if test="${curMenu ne c.index and mainMenuLen eq c.count}">noborder</c:if>"><a onclick="goPage('managePoint.latte');" data-role="button">포인트 출납 및 회원관리</a></li>
			<li style="width:16%;" class="<c:if test="${curMenu-1 eq c.index}">noborder</c:if><c:if test="${curMenu eq c.index}">on</c:if><c:if test="${curMenu ne c.index and mainMenuLen eq c.count}">noborder</c:if>"><a onclick="goPage('manageSchedule.latte');" data-role="button">스케줄</a></li>
		</ul>
	</div>
</div>