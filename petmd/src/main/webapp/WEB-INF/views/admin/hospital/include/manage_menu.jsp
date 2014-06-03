<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!-- 탭 영역 시작-->
<div class="tab03">
	<ul>
		<li class="first<c:if test='${param.cur_manage_menu eq "1"}'> on</c:if>" style="width:33%;"><a onclick="goPage('manageHome.latte');"><span>메인메뉴편집</span></a></li>
		<%-- <li<c:if test='${param.cur_manage_menu eq "2"}'> class="on"</c:if>><a><span><strike>통계</strike></span></a></li> --%>
		<%-- <li<c:if test='${param.cur_manage_menu eq "3"}'> class="on"</c:if> style="width:34%;"><a onclick="goPage('managePoint.latte');"><span class="t01">회원관리 및<br/>포인트출납</span></a></li> --%>
		<li<c:if test='${param.cur_manage_menu eq "3"}'> class="on"</c:if> style="width:34%;"><a onclick="goPage('manageVaccination.latte');"><span>접종설정</span></a></li>
		<li<c:if test='${param.cur_manage_menu eq "4"}'> class="on"</c:if> style="width:33%;"><a onclick="goPage('manageSchedule.latte');"><span>스케쥴</span></a></li>
	</ul>
</div>
<!-- // 탭 영역 끝-->
<%-- <c:set var="curMenu" value="<%= request.getParameter(\"curMainMenu\") %>"/>
			<c:set var="mainMenuLen" value="${fn:length(mainMenu)}"/>
			<li style="width:28%;" class="<c:if test="${curMenu-1 eq c.index}">noborder</c:if><c:if test="${curMenu eq c.index}">on</c:if><c:if test="${curMenu ne c.index and mainMenuLen eq c.count}">noborder</c:if>"><a onclick="goPage('manageHome.latte');" data-role="button">메인메뉴 편집</a></li>
			<li style="width:12%;" class="<c:if test="${curMenu-1 eq c.index}">noborder</c:if><c:if test="${curMenu eq c.index}">on</c:if><c:if test="${curMenu ne c.index and mainMenuLen eq c.count}">noborder</c:if>"><a onclick="goPage('manageStatistics.latte');" data-role="button"><strike>통계</strike></a></li>
			<li style="width:44%;" class="<c:if test="${curMenu-1 eq c.index}">noborder</c:if><c:if test="${curMenu eq c.index}">on</c:if><c:if test="${curMenu ne c.index and mainMenuLen eq c.count}">noborder</c:if>"><a onclick="goPage('managePoint.latte');" data-role="button">포인트 출납 및 회원관리</a></li>
			<li style="width:16%;" class="<c:if test="${curMenu-1 eq c.index}">noborder</c:if><c:if test="${curMenu eq c.index}">on</c:if><c:if test="${curMenu ne c.index and mainMenuLen eq c.count}">noborder</c:if>"><a onclick="goPage('manageSchedule.latte');" data-role="button">스케줄</a></li> --%>