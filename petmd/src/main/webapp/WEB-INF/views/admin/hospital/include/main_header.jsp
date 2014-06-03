<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<div data-role="header" id="head" data-position="fixed" data-tap-toggle="false" data-theme="a"><!-- data-tap-toggle="false"  -->
	<h1>${hospitalInfo.s_hospital_name}</h1>
	<a data-role="button">&nbsp;</a>
	<a onclick="goPage('manageHome.latte');" data-role="button" data-rel="menu" id="RightMenu"><img src="${con.IMGPATH_OLD}/btn/btn_menu.png" alt="shop" width="32" height="32" />&nbsp;</a>
</div>