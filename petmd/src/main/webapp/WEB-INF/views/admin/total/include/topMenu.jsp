<%@page import="java.util.Map"%>

<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>

<script type="text/javascript">
<!--
	function selectTopMenu(menu_id){
		var select_menu = document.getElementById(menu_id);
		select_menu.className = "on";
	}
//-->
</script>

<h1><a href="home.latte" style="font-size:48px; color:#a14d49;"><%-- <img src="${con.IMGPATH_OLD}/common/h1_logo.gif" /> --%>동물병원</a></h1>

<div class="gnb">
	<ul>
		<c:if test="${not empty permission.PMENUA }"><li><a id="topmenu_hospital" 	href="${permission.PMENUA.s_url}" style="cursor:pointer;">${permission.PMENUA.s_link_name }</a></li></c:if> 	<!-- href="hospital_01_reg.latte" -->
		<c:if test="${not empty permission.PMENUB }"><li><a id="topmenu_agency" 	href="${permission.PMENUB.s_url}" style="cursor:pointer;">${permission.PMENUB.s_link_name }</a></li></c:if>		<!-- href="member_01_list.latte" -->
	</ul>
</div>