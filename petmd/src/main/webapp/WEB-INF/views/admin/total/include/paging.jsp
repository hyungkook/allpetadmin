<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
 <div class="paging">
   	<c:if test="${params.groupNumber > 0 }"><!-- 첫페이지 -->
    <a style="cursor:pointer;"  onClick="pageChange('1');" class="btn"><img src="${con.IMGPATH_OLD}/btn/btn_prev02.gif" /></a>
	</c:if>
	
   	<c:if test="${params.groupNumber > 0 }"><!-- 이전페이지 -->
    <a style="cursor:pointer;"  onClick="pageChange('${params.startPage -1 }');" class="btn"><img src="${con.IMGPATH_OLD}/btn/btn_prev01.gif" /></a>
    </c:if>
       
       <c:forEach begin="${params.startPage}" end="${params.endPage}" varStatus="c">
       	<c:choose>
        	<c:when test="${(params.startPage + c.count -1) == params.pageNumber}">
        		<a class="on" 	style="cursor:pointer;" onclick="pageChange('${params.startPage + c.count -1}');">${params.startPage + c.count -1 }</a>
        	</c:when>
        	<c:otherwise>
        		<a 				style="cursor:pointer;" onclick="pageChange('${params.startPage + c.count -1}');">${params.startPage + c.count -1 }</a>
        	</c:otherwise>
       	</c:choose>
       	
       </c:forEach>

	<c:if test="${params.groupNumber < params.groupCount-1}"><!-- 다음페이지 -->
	<a style="cursor:pointer;" onClick="pageChange('${params.endPage +1 }');" class="btn"><img src="${con.IMGPATH_OLD}/btn/btn_next01.gif" /></a>
	</c:if>
       
    <c:if test="${params.groupNumber < params.groupCount-1}"><!-- 마지막페이지 -->
    <a style="cursor:pointer;" onClick="pageChange('${params.totalCount - params.pageGroupCount }');" class="btn"><img src="${con.IMGPATH_OLD}/btn/btn_next02.gif" /></a>
    </c:if>
</div>
<input type="hidden" name="pageNumber" value="${params.pageNumber }" />