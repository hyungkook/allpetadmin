<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/views/admin/hospital/include/total_header.jsp"/>

<script type="text/javascript" src="${con.JSPATH}/jquery.event.drag-1.5.min.js"></script>
<script type="text/javascript" src="http://dohoons.com/test/flick/jquery.touchSlider.js"></script>
</head>
<body>
	<table border="1">
		<tr>
			<th>병원이름</th>
			<th>TODAY</th>
			<th>TOTAL</th>
		</tr>
		<c:forEach items="${hospitalList}" var="list">
		<tr>
			<td align="center">${list.S_HOSPITAL_NAME}</td>
			<td align="center">${list.S_TODAY_COUNT}</td>
			<td align="center">${list.S_TOTAL_COUNT}</td>
		</tr>
		</c:forEach>
	</table>
</body>
</html>