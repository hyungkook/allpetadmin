<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:forEach var="item" items="${userList}" varStatus="c">
<c:set var="itemIndex" value="${(params.pageNumber - 1) * (params.onePageCountRow) + c.index}"/>
<div style="overflow:hidden;">
	<div style="float:left;">
		<div>
			<p style="padding:10px;">${item.s_name} (<span id="phone${itemIndex}"></span>)</p>
		</div>
	</div>
	<div style="float:right;">
		<a data-role="button" style="padding:10px;">X</a>
	</div>
	<div style="float:right;">
		<p id="point${itemIndex}" style="padding:10px;"></p>
	</div>
</div>
<hr/>
<script>
$('#pet_list${itemIndex}').hide();
$('#phone${itemIndex}').html(formatPhoneNumber('${item.s_cphone_number}','-'));
$('#point${itemIndex}').html($.number('${item.point_sum}'));
listCnt++;
//$('#uid').val($('#uid').val()+($('#uid').val()==''?"":";")+response.uid);
uidList = (uidList+(uidList==''?"":";")+'${item.s_uid}');
if(userList['${item.s_uid}']==null) userList['${item.s_uid}']='${item.s_uid}';
/* <c:if test="${not empty item.s_rownumber}">g_rownum=(g_rownum==''?g_rownum:g_rownum+';')+'${item.s_rownumber}';</c:if> */
</script>

</c:forEach>