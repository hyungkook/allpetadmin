<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>

<p class="mt05">※ 실시간 현황 페이지에서는 하룻동안 발생한 이벤트에 대한 정보를 실시간 업데이트로 보여드립니다.</p>
<table cellpadding="0" border="0" cellspacing="0" class="table_list">
 <colgroup>
        <col width="20%" /><col width="45%" /><col width="15%" /><col width="20%" />
    </colgroup>
    <tr>
    	<th>일시</th>
    	<th>내용</th>
    	<th>연락처</th>
    	<th>비고</th>
	</tr>
	<c:forEach items="${mainList }" var="list" varStatus="c">
		<tr>
			<td class="date">${fn:split(list.D_REG_DATE, ' ')[0]} (${fn:split(list.D_REG_DATE, ' ')[1]})</td>
			<td style="text-align:left;"> 
				<c:choose>
					<c:when test="${list.S_TYPE == 'SHOP' }">
						<span class="icon_new">신규등록</span> 
					</c:when>
					<c:when test="${list.S_TYPE == 'CHARGE' }">
						<span class="icon_new">충전</span> 
					</c:when>
					<c:when test="${list.S_TYPE == 'AD' }">
						<span class="icon_new">신규광고</span> 
					</c:when>
					<c:when test="${list.S_TYPE == 'REFUND' }">
						<span class="icon_new03">환불</span> 
					</c:when>
					<c:when test="${list.S_TYPE == 'SUBTRACT' }">
						<span class="icon_new03">차감</span> 
					</c:when>
				</c:choose>
				${list.S_SHOP_NAME}
				<c:if test="${list.ISNEW=='NEW'}">
			 	<span class="icon_new02">N</span> 
			 	</c:if>
			 	<c:if test="${list.N_POINT != '0' }">
				 	<c:choose>
						<c:when test="${list.S_TYPE == 'SHOP' }">
						</c:when>
						<c:when test="${list.S_TYPE == 'CHARGE' }">
							<fmt:formatNumber value="${list.N_POINT }" pattern="#,###" /> <img src="http://img.medilatte.com/admin/images/common/icon_p02.gif" alt=""/>
						</c:when>
						<c:when test="${list.S_TYPE == 'AD' }">
							<fmt:formatNumber value="${list.N_POINT }" pattern="#,###" /> 원 
						</c:when>
						<c:when test="${list.S_TYPE == 'REFUND' }">
						<fmt:formatNumber value="${list.N_POINT }" pattern="#,###" /> <img src="http://img.medilatte.com/admin/images/common/icon_p02.gif" alt=""/>
					</c:when>
					<c:when test="${list.S_TYPE == 'SUBTRACT' }">
						<<fmt:formatNumber value="${list.N_POINT }" pattern="#,###" /> <img src="http://img.medilatte.com/admin/images/common/icon_p02.gif" alt=""/> 
					</c:when>
					</c:choose>
				</c:if>
			 </td>
			 <td>${list.S_CPHONE}</td>
			<td class="td_right">담당자 : ${list.S_CHARGE_TEAM} <c:if test="${not empty list.S_CHARGE_NAME }">- ${list.S_CHARGE_NAME}</c:if> <c:if test="${empty list.S_CHARGE_NAME }">없음</c:if></td>
		</tr>
		</c:forEach>
</table>