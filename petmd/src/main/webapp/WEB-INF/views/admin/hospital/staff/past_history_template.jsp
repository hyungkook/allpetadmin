<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import = "java.util.HashMap" %>
<%@ page import = "java.util.ArrayList" %>
<c:if test="${param.is_template eq 'Y'}">
	<% ArrayList<HashMap<String,String>> l = new ArrayList<HashMap<String,String>>(); %>
	<% l.add(new HashMap<String,String>()); %>
	<c:set var="staffHistory" value="<%= l %>"/>
</c:if>
<c:forEach var="item" items="${staffHistory}" varStatus="c">
<c:choose>
	<c:when test="${param.is_template eq 'Y'}">
		<c:set var="id" value="$id$"/>
		<c:set var="type" value="${codes.STAFF_PAST_HISTORY}"/>
	</c:when>
	<c:otherwise>
		<c:set var="id" value="${c.index}"/>
		<c:set var="type" value="${item.s_type}"/>
	</c:otherwise>
</c:choose>
	<%-- <div style="overflow:hidden; padding:10px;">
		<div style="float:left; width:100px;">
			<c:set var="ymdhms" value="${fn:split(item.d_start_date,' ')}"/>
			<c:set var="year" value="${fn:split(ymdhms[0],'-')[0]}"/>
			<select name="start_date">
				<option value="">선택 안 함</option>
				<c:forEach begin="0" end="${curYear}" varStatus="y">
				<option value="${curYear-y.index+1900}" <c:if test="${year eq (curYear-y.index+1900)}">selected="selected"</c:if>>${curYear-y.index+1900}</option>
				</c:forEach>
			</select>
		</div>
		<div style="float:left; width:100px;">
			<c:set var="ymdhms" value="${fn:split(item.d_end_date,' ')}"/>
			<c:set var="year" value="${fn:split(ymdhms[0],'-')[0]}"/>
			<select name="end_date">
				<option value="">선택 안 함</option>
				<c:forEach begin="0" end="${curYear}" varStatus="y">
				<option value="${curYear-y.index+1900}" <c:if test="${year eq (curYear-y.index+1900)}">selected="selected"</c:if>>${curYear-y.index+1900}</option>
				</c:forEach>
			</select>
		</div>
		<div style="float:left; width:50%;">
			<input type="text" name="desc" style="border:1px solid gray; color:gray;" value="${item.s_desc}"/>
		</div>
		<div style="float:right;">
			<a data-role="button" onclick="removeItem('h_item${id}')" style="padding:10px;">X</a>
		</div>
	</div> --%>
<div id="h_item${id}" selector-name="history_item" class="items">
	<input type="hidden" name="type" value="${type}"/>
	<div class="area00" style="margin:10px 35px 0 0;">
		<div class="btn_select02" style=" float:left; width:30%;">
			<c:set var="ymdhms" value="${fn:split(item.d_start_date,' ')}"/>
			<c:set var="year" value="${fn:split(ymdhms[0],'-')[0]}"/>
			<a data-role="button" >
			<select name="start_date" data-icon="false" init-data="${year}">
				<option value="">선택 안 함</option>
			</select>
			</a>
			<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
		</div>
		<p class="fleft" style="text-align:center; width:10%; padding-top:10px;" >~</p>
		<div class="btn_select02" style=" float:left; width:30%;">
			<c:set var="ymdhms" value="${fn:split(item.d_end_date,' ')}"/>
			<c:set var="year" value="${fn:split(ymdhms[0],'-')[0]}"/>
			<a data-role="button" >
			<select name="end_date" data-icon="false" init-data="${year}">
				<option value="">선택 안 함</option>
			</select>
			</a>
			<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
		</div>
	</div>
	<div class="area00" style="padding:5px 110px 0 0;">
		<p class="input01"><input type="text" name="desc" value="${item.s_desc}"></p>
		<p class="btn_admin01 abs_r03"><a onclick="switchItem('h_item${id}','previous')" data-role="button"><img src="${con.IMGPATH}/btn/btn_t.png" alt="" width="31" height="31" /></a></p>
		<p class="btn_admin01 abs_r02"><a onclick="switchItem('h_item${id}','next')" data-role="button"><img src="${con.IMGPATH}/btn/btn_b.png" alt="" width="31" height="31" /></a></p>
		<p class="btn_admin01 abs_r01"><a onclick="removeItem('h_item${id}')" data-role="button"><img src="${con.IMGPATH}/btn/btn_d.png" alt="" width="31" height="31" /></a></p>
	</div>
</div>
</c:forEach>