<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<p class="s_data">검색된 이용내역 수 <span><fmt:formatNumber value="${params.totalCount}" pattern="#,###" /></span> 건</p>
<table cellpadding="0" border="0" cellspacing="0" class="table_list">
	<colgroup>
		<col width="40" /><col width="40" /><col width="140" /><col width="90" />
		<col width="110" /><col width="*" />
	</colgroup>
	<tr>
		<th class="bgn">번호</th>
		<th><input type="checkbox" class="checkbox" value="" /></th>
		<th>일시</th>
		<th>회원명</th>
		<th>이용내역</th>
		<th>사유</th>
	</tr>
	<c:set var="rownum" value="${fn:length(userList) }"></c:set>
	<c:forEach items="${userList}" var="list" varStatus="c" >
	<tr>
		<td class="bgn">${params.listStartNumber - (c.count -1) }</td>
		<td class="bgn"><input type="checkbox" class="checkbox" value="" /></td>
		<td class="bgn">${list.d_reg_date}</td>
		<td class="bgn">${list.s_name }</td>
		<td class="bgn">
			<c:set var="subject_comment" value="${fn:split(list.s_desc, ';') }"></c:set>
			<%-- <c:if test="${subject_comment[0] == '충전'}">
				+ <fmt:formatNumber value="${list.n_point}" pattern="#,###" />
			</c:if>
			<c:if test="${subject_comment[0] != '충전'}">
				<c:if test="${list.n_point > 0}">-</c:if> --%>
				<fmt:formatNumber value="${list.n_point}" pattern="#,###" />
			<%-- </c:if> --%>
		</td> 
		<td class="bgn">${list.s_desc}</td>
	</tr>
	</c:forEach>
</table>
<jsp:include page="/WEB-INF/views/admin/total/include/paging.jsp"/>