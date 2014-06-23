<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:forEach var="item" items="${userList}" varStatus="c">
<c:set var="itemIndex" value="${(params.pageNumber - 1) * (params.onePageCountRow) + c.index}"/>
<li>
	<input type="hidden" id="id'${itemIndex}" value="${item.s_uid}"/>
	<p class="txt01">${item.s_name} (<span id="phone${itemIndex}"></span>)</p>
	<p class="txt02 orange mt05">&nbsp;<%-- '+$.number(response.point_sum)+' <img src="${con.IMGPATH}/common/icon_p.png" alt="" width="15" height="15"/> --%></p>
	<p class="btn_admin01 btn_r02"><a onclick="removeUser('${item.s_uid}','${item.s_cphone_number}');" data-role="button"><img src="${con.IMGPATH}/btn/btn_close.png" alt="" width="31" height="31" /></a></p>
</li>
<script>
$('#pet_list${itemIndex}').hide();
$('#phone${itemIndex}').html(formatPhoneNumber('${item.s_cphone_number}','-'));
//$('#point${itemIndex}').html($.number('${item.n_point}'));
</script>
</c:forEach>