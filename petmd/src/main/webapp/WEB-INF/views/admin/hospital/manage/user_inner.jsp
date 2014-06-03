<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%-- <c:forEach var="item" items="${userList}" varStatus="c">
<c:set var="itemIndex" value="${(params.pageNumber - 1) * (params.onePageCountRow) + c.index}"/>
<div style="overflow:hidden;">
	<input type="hidden" id="id${itemIndex}" value="${item.s_uid}"/>
	<div style="float:left;">
		<div style="padding:10px;">
		<input type="checkbox" id="check${itemIndex}" style="margin-top:10px;"/>&nbsp;
		</div>
	</div>
	<div style="float:left;">
		<div style="padding:10px;">
			<p style="padding:10px;">${item.d_reg_date}</p>
		</div>
	</div>
	<div style="float:left;">
		<div>
		<div>
			<p style="padding:10px;">${item.s_name} (<span id="phone${itemIndex}"></span>)</p>
		</div>
		</div>
		<div>
		<div>
			<p style="padding:10px;">${item.s_desc}</p>
		</div>
		</div>
	</div>
	<div style="float:right;">
		<div style="overflow:hidden;">
			<div style="float:right;">
				<div style="padding:0 10px;">
					<a data-role="button" style="padding:10px;">전화걸기</a>
				</div>
			</div>
			<div style="float:right;">
				<div style="padding:0 10px;">
					<a data-role="button" onclick="openPetList(${itemIndex},'${item.s_uid}');" style="padding:10px;">반려동물</a>
				</div>
			</div>
		</div>
		<div style="overflow:hidden;">
			<div style="float:right;">
			<p id="point${itemIndex}" style="padding:10px;">${item.n_point}</p>
			</div>
		</div>
	</div>
</div>
<div>
	<div id="pet_list${itemIndex}" style="margin:10px; padding:10px;">
		<hr/>
		<div id="pet_list_inner${itemIndex}"></div>
		<p onclick="$('#pet_list${itemIndex}').hide();">펼침 닫기</p>
	</div>
</div>
<hr/>
<script>
$('#pet_list${itemIndex}').hide();
$('#phone${itemIndex}').html(formatPhoneNumber('${item.s_cphone_number}','-'));
$('#point${itemIndex}').html($.number('${item.n_point}'));
</script>
</c:forEach> --%>

<c:forEach var="item" items="${userList}" varStatus="c">
<c:set var="itemIndex" value="${(params.pageNumber - 1) * (params.onePageCountRow) + c.index}"/>
<li data-group-id="group-${item.s_cphone_number}" id="user${itemIndex}">
	<input type="hidden" id="id${itemIndex}" value="${item.s_uid}"/>
	<p class="cb checkbox" style="width:24px;">
		<input type="checkbox" id="checkbox-c${itemIndex+2}" value="c-${itemIndex+2}" onclick="groupCheck(this,'group-${item.s_cphone_number}');"/>
		<label for="checkbox-c${itemIndex+2}">&nbsp;</label>
	</p>
	<p class="data">[${item.d_reg_date}]</p>
	<h4>${item.s_name} (<span id="phone${itemIndex}" data-sub-name="phone">${item.s_cphone_number}</span>)</h4>
	<p>${item.s_desc}</p>
		<c:choose>
		<c:when test="${item.n_point < 0}"><c:set var="p">- <fmt:formatNumber value="${-item.n_point}" pattern="#,###"/></c:set></c:when>
		<c:otherwise><c:set var="p">+ <fmt:formatNumber value="${item.n_point}" pattern="#,###"/></c:set></c:otherwise>
		</c:choose>
	<p class="txt01" id="point${itemIndex}">${p} <img src="${con.IMGPATH}/common/icon_p.png" alt="" width="15" height="15"/></p>
	<p class="btn01 btn_red03"><a onclick="openPetList('user${itemIndex}','${item.s_uid}','${item.s_name}');" data-role="button">반려동물 <img src="${con.IMGPATH}/common/bu_arrow02.png" alt="" width="6" height="10"/></a></p>
</li>
</c:forEach>