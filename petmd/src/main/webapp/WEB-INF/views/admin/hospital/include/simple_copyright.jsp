<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<div id="footer">
	<p class="txt03 center">copyrightⓒ <c:choose><c:when test="${empty hospital_name}">${hospitalInfo.s_hospital_name}</c:when><c:otherwise>${hospital_name}</c:otherwise></c:choose> all rights reserved</p>
	<p class="txt03 center">
		<span class="border_r">Hosting by <a href="http://www.allpethome.com/">ALLPET</a>.</span>
		<span>Designed by <a href="http://www.allpethome.com/">ALLPET</a>.</span>
	</p>
</div>
