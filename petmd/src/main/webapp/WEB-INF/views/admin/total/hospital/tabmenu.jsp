<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>

<c:set var="target" value="<%= request.getParameter(\"jsp_select_tab\") %>"/>
<div class="tab">
 	<ul>
     	<li id="tab_mobile" class="<c:if test="${target eq 'tab_mobile'}">on</c:if>" style="width:150px"><a href="hospitalMobile.latte?sid=${params.sid}">모바일</a></li>
        <li id="tab_manage" class="<c:if test="${target eq 'tab_manage'}">on</c:if>" style="width:150px"><a href="hospitalReg.latte?sid=${params.sid}">관리정보</a></li>
        <%-- <li id="sales" class="" style="width:150px"><a href="#">매출</a></li> --%>
        <li id="tab_point" class="<c:if test="${target eq 'tab_point'}">on</c:if>" style="width:150px"><a href="hospitalPointHistory.latte?sid=${params.sid}">포인트내역</a></li>
     </ul>
</div>
<c:if test="${mobile == 'on' }">
	<div class="tab mb30">
	 	<ul>
	     	<li id="shophome" class="${shophome}" style="width:100px"><a href="shopPreview.latte?s_sid=${s_sid}">샵홈</a></li>
	        <li id="staff" class="${staff}" style="width:120px"><a href="shopStaffList.latte?s_sid=${s_sid}">스탭</a></li>
	        <li id="goods" class="${goods}" style="width:120px"><a href="shopGoodsList.latte?s_sid=${s_sid}">상품</a></li>
	        <li id="coupon" class="${coupon}" style="width:120px"><a href="shopCouponList.latte?s_sid=${s_sid}">쿠폰</a></li>
	        <li id="review" class="${review}" style="width:120px"><a href="shopReviewList.latte?s_sid=${s_sid}">리뷰</a></li>
	        <li id="location" class="${location}" style="width:120px"><a href="shopLocation.latte?s_sid=${s_sid}">위치</a></li>
	     </ul>
	 </div>
 </c:if>

