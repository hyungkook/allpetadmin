<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:choose>
<c:when test="${boardInfo.s_group eq codes.CUSTOM_BOARD_TYPE_IMAGE}">
	<c:set var="inner_layout" value="board/hospital_img_board_edit.jsp"/></c:when>
<c:when test="${boardInfo.s_group eq codes.CUSTOM_BOARD_TYPE_NOTICE}">
	<c:set var="inner_layout" value="board/hospital_img_board_edit.jsp"/></c:when>
<c:when test="${boardInfo.s_group eq codes.CUSTOM_BOARD_TYPE_FAQ}">
	<c:set var="inner_layout" value="board/hospital_faq_board_edit.jsp"/></c:when>
</c:choose>
<c:if test="${not empty inner_layout}">
<jsp:include page="${inner_layout}"/>
</c:if>