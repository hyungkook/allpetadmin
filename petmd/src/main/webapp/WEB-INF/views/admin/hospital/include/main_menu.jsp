<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:if test="${not empty param.main_menu_interceptor}">
<c:set var="f" value="if(typeof ${param.main_menu_interceptor}==='function'){if(!${param.main_menu_interceptor}()){return;}};"/>
</c:if>
<!-- 탭 영역 시작-->
<div class="tab">
	<ul>
		<c:set var="mainMenuLen" value="${fn:length(mainMenu)}"/>
		<c:forEach var="item" items="${mainMenu}" varStatus="c">
			<c:if test="${item.s_cmid eq curMenuId}">
				<c:set var="curMenu" value="${c.index}"/>
			</c:if>
		</c:forEach>
		<c:forEach var="item" items="${mainMenu}" varStatus="c">
			<c:set var="w">${c.count*100/mainMenuLen - c.index*100/mainMenuLen}</c:set>
			<li<c:if test="${c.count eq 1}"> class="first"</c:if> style="width: ${w}%;"><a onclick="${f}goPage('${item['HADMIN_PAGE']}');"<c:if test="${curMenu eq c.index}"> class="on"</c:if>><img src="${con.IMGPATH}<c:choose><c:when test="${curMenu eq c.index}">${item['ICON_ON_PATH']}</c:when><c:otherwise>${item['ICON_OFF_PATH']}</c:otherwise></c:choose>" alt="" width="25" height="25"/><span>${item.s_name}</span></a></li>
		</c:forEach>
	</ul>
</div>
<!-- // 탭 영역 끝-->