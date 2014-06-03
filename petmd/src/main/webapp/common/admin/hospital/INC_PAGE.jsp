<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>

<script>

function prePageChange(type, num, pagingBlockId, pagingSendValue) {
	
	var curPage = "${params.pageNumber}";

	if (curPage == "0" || curPage == "") {
		curPage = 1;
	}
	
	if ("${params.pageNumber}" == "0") {
		num = 1;
	}
	
	//console.log(parseInt("${params.pageNumber}")+","+parseInt("${params.pageCount}")+","+num);
	
	if (parseInt("${params.pageCount}") < num) {
		
		if(parseInt("${params.pageNumber}") < num - 1){
			num = parseInt("${params.pageCount}");
		}
		else{
			alert("맨 마지막 페이지 입니다.");
			return;
		}
	}
	
	if (type == "prev") {
		
		if (parseInt("${params.pageNumber}") == 1 || parseInt("${params.pageNumber}") == 0) {
			alert("맨 첫 페이지 입니다.");
			return;				
		}
	}
	
	//console.log("2:"+parseInt("${params.pageNumber}")+","+parseInt("${params.pageCount}")+","+num);pagingSendValue
	
	pageChange(type, num, pagingBlockId, pagingSendValue);
} 

</script>

<div class="list_num">

	<c:if test="${empty params.pagingGroupSize}">
	<!-- pageGroupSize 기본값 -->
	<c:set var="pageGroupSize" value="3"/>
	<c:set var="curPageGroupSize" value="${pageGroupSize}"/>
	</c:if>
	<c:if test="${not empty params.pagingGroupSize}">
	<c:set var="pageGroupSize" value="${params.pagingGroupSize}"/>
	<c:set var="curPageGroupSize" value="${pageGroupSize}"/>
	</c:if>
	
	<c:set var="pagingBlockId" value="<%= request.getParameter(\"pagingBlockId\") %>"/>
	<c:set var="pagingSendValue" value="<%= request.getParameter(\"pagingSendValue\") %>"/>
	
	<c:if test="${printAnnotationFlag eq 'Y'}">
	<!-- 주석 --></c:if>
	
	<c:set var="tmp" value="${(params.pageNumber-1) / pageGroupSize}"/>
	<c:set var="pageGroupNumber"><fmt:formatNumber value="${tmp - (tmp % 1)}" pattern="0"/></c:set>
	
	<c:if test="${params.pageCount - pageGroupNumber * pageGroupSize < pageGroupSize}">
	<c:set var="curPageGroupSize" value="${params.pageCount - pageGroupNumber * pageGroupSize}"/>
	</c:if>
	
	<span class="btn_num"><a onclick="prePageChange('prev','1','${pagingBlockId}','${pagingSendValue}');" data-role="button"><img src="${con.IMGPATH_OLD}/btn/btn_prev.png" alt="" width="7" height="10" style="padding-right:2px;"/></a></span>
	<span class="btn_num"><a onclick="prePageChange('prev','${pageGroupNumber * pageGroupSize + 1 - pageGroupSize}','${pagingBlockId}','${pagingSendValue}');" data-role="button"><img src="${con.IMGPATH_OLD}/btn/btn_prev.png" alt="" width="7" height="10" style="padding-right:2px;"/></a></span>
		<c:forEach begin="0" end="${curPageGroupSize-1}" varStatus="c">
			<c:if test="${pageGroupNumber * pageGroupSize + c.count <= params.pageCount}">
				<c:choose>
					<c:when test="${pageGroupNumber * pageGroupSize + c.count eq params.pageNumber}">
					&nbsp;<a onclick="prePageChange('cur','${pageGroupNumber * pageGroupSize + c.count}','${pagingBlockId}','${pagingSendValue}');"><span style="color:red;">${pageGroupNumber * pageGroupSize + c.count}</span></a>&nbsp;
					</c:when>
					<c:otherwise>
					&nbsp;<a onclick="prePageChange('cur','${pageGroupNumber * pageGroupSize + c.count}','${pagingBlockId}','${pagingSendValue}');"><span>${pageGroupNumber * pageGroupSize + c.count}</span></a>&nbsp;
					</c:otherwise>
				</c:choose>
			</c:if>
		</c:forEach>
	<%-- <span class="num">${params.pageNumber} / ${params.pageCount}</span> --%>
	<span class="btn_num"><a onclick="prePageChange('next','${pageGroupNumber * pageGroupSize + 1 + curPageGroupSize}','${pagingBlockId}','${pagingSendValue}');" data-role="button"><img src="${con.IMGPATH_OLD}/btn/btn_next.png" alt="" width="7" height="10" style="padding-left:2px;"/></a></span>
	<span class="btn_num"><a onclick="prePageChange('next','${params.pageCount}','${pagingBlockId}','${pagingSendValue}');" data-role="button"><img src="${con.IMGPATH_OLD}/btn/btn_next.png" alt="" width="7" height="10" style="padding-left:2px;"/></a></span>
	
</div>


