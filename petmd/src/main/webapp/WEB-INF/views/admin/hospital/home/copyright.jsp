<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<div id="footer">
	<p class="txt01">
		<span class="border_r">법인(상호)명 : <label>${hospitalInfo.s_company_name}</label></span>
		<span>사업자등록번호 : <label>${hospitalInfo.s_corp_reg_number}</label></span>
	</p>
	<c:choose>
	<c:when test="${empty hospitalInfo.s_email and empty hospitalInfo.s_fax}">
	<p class="txt01">
		<span>대표자 : <label>${hospitalInfo.s_president}</label></span>
	</p>
	</c:when>
	<c:when test="${empty hospitalInfo.s_email and not empty hospitalInfo.s_fax}">
	<p class="txt01">
		<span class="border_r">대표자 : <label>${hospitalInfo.s_president}</label></span>
		<span>FAX : <label> ${hospitalInfo.s_fax}</label></span>
	</p>
	</c:when>
	<c:when test="${not empty hospitalInfo.s_email and empty hospitalInfo.s_fax}">
	<p class="txt01">
		<span class="border_r">대표자 : <label>${hospitalInfo.s_president}</label></span>
		<span>이메일 : <label> ${hospitalInfo.s_email}</label></span>
	</p>
	</c:when>
	<c:otherwise>
	<p class="txt01">
		<span class="border_r">대표자 : <label>${hospitalInfo.s_president}</label></span>
		<span>이메일 : <label> ${hospitalInfo.s_email}</label></span>
	</p>
	<p class="txt01">
		<span>FAX : <label> ${hospitalInfo.s_fax}</label></span>
	</p>
	</c:otherwise>
	</c:choose>
	<p class="txt02 mt10">본 사이트에서 사용된 모든 일러스트, 그래픽 이미지와 내용의 무단 도용을 금합니다.</p>
	<p class="txt03 mt05">copyrightⓒ${hospitalInfo.s_company_name} all rights reserved</p>
	<p class="txt03">
		<span class="border_r">Hosting by <a href="http://www.allpethome.com/">ALLPET</a>.</span>
		<span>Designed by <a href="http://www.allpethome.com/">ALLPET</a>.</span>
	</p>
</div>