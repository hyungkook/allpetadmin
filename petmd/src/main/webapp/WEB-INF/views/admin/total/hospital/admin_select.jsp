<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<SELECT class="searchsel" style="width:190px;" name="aid" id="aid">
	<option value="">담당자 선택</option>
	<c:forEach items="${adminList}" var="list" varStatus="c">
		<option value="${list.s_aid}" <c:if test="${hospitalInfo.s_aid == list.s_aid}">selected</c:if>  >${list.s_name}</option>
	</c:forEach>
</SELECT>