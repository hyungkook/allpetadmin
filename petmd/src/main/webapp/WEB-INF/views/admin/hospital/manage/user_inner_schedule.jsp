<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:forEach var="item" items="${userList}" varStatus="c">
<c:set var="itemIndex" value="${(params.pageNumber - 1) * (params.onePageCountRow) + c.index}"/>
<%-- <div style="overflow:hidden;">
	<input type="hidden" id="id${itemIndex}" value="${item.s_uid}"/>
	<div style="float:left;">
		<p style="padding:10px;">${item.s_name} (<span id="phone${itemIndex}"></span>)</p>
		<p style="padding:10px;">${item.s_desc}</p>
	</div>
	<div style="float:right;">
		<div style="overflow:hidden;">
			<div style="float:right;">
				<div style="padding:0 10px;">
					<a data-role="button" onclick="openPetList(${itemIndex},'${item.s_uid}');" style="padding:10px;">반려동물</a>
				</div>
			</div>
		</div>
		<div style="overflow:hidden;">
			<div style="float:right;">
			<p id="point${itemIndex}" style="padding:10px;"><fmt:formatNumber value="${item.point_sum}" pattern="#,###"/> point</p>
			</div>
		</div>
	</div>
</div>
<div>
	<div id="pet_list${itemIndex}" style="margin:10px; padding:10px; margin-top:-10px; padding-top:0;">
		<hr/>
		<div id="pet_list_inner${itemIndex}"></div>
		<p onclick="$('#pet_list${itemIndex}').hide();">펼침 닫기</p>
	</div>
</div>
<hr/> --%>
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