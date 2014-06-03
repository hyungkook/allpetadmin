<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<div class="tab">
	<div class="tab_area">
		<ul>
			<c:set var="mainMenu1Len" value="${fn:length(mainMenu1)}"/>
			<c:forEach var="item" items="${mainMenu1}" varStatus="c">
				<c:if test="${item.s_cmid eq curMenuId}">
					<c:set var="curMenu" value="${c.index}"/>
				</c:if>
			</c:forEach>
			<c:forEach var="item" items="${mainMenu1}" varStatus="c">
				<c:set var="w">${c.count*100/mainMenu1Len - c.index*100/mainMenu1Len}</c:set>
				<li style="width: ${w}%;" class="<c:if test="${curMenu-1 eq c.index}">noborder</c:if><c:if test="${curMenu eq c.index}">on</c:if><c:if test="${curMenu ne c.index and mainMenu1Len eq c.count}">noborder</c:if>"><a onclick="goPage('${item.attr_page}');" data-role="button">${item.s_name}</a></li>
			</c:forEach>
		</ul>
	</div>
</div>