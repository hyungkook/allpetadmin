<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ page import="java.net.URLDecoder" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../include/total_header.jsp" />

<script>

function pageChange(type, num) {
	
	slideMenu.saveTemporary();
	goPage('boardHome.latte?idx=${params.idx}&cmid=${boardInfo.s_cmid}&pageNumber='+num+'&search_type='+$('#search_type').val()+'&search_text='+escape(encodeURIComponent($('#search_input').val())));
}

function preProcess(){
	
	slideMenu.saveTemporary();
	//$.cookie('menuPosition', menuPosition, {expires:1});
}

</script>

<script>

var slideMenu;

$(window).load(function(){	
	
	//initSlideMenu();
	slideMenu = new SlideMenu('menuPosition', parseInt('${boardInfo.sequence}',10), parseInt('${fn:length(menuList)}',10), 'boardMenu');
});
</script>
<jsp:include page="../service/SlideBoardMenu.jsp"/>

</head>
<body>
		
	<div data-role="page">
		
		<jsp:include page="../include/main_title_bar.jsp"><jsp:param name="ignore_title_back_btn" value="Y"/></jsp:include>
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
		
			<!-- 메인메뉴 tab -->
			<jsp:include page="../include/main_menu.jsp"/>
			
			<!-- tab -->
			<%-- <div class="tab">
				<div class="tab_area">
					<ul>
						<c:set var="curMenu" value="${boardInfo.sequence}"/>
						<c:set var="mainMenuLen" value="${fn:length(menuList)}"/>
						<c:forEach var="item" items="${menuList}" varStatus="c">
							<c:set var="w">${c.count*100/mainMenuLen - c.index*100/mainMenuLen}</c:set>
							<li style="width: ${w}%;" class="<c:if test="${curMenu-1 eq c.count}">noborder</c:if><c:if test="${curMenu eq c.count}">on</c:if><c:if test="${curMenu ne c.count and mainMenuLen eq c.count}">noborder</c:if>"><a onclick="goPage('boardHome.latte?idx=${params.idx}&cmid=${item.s_cmid}');" data-role="button">${item.s_name}</a></li>
						</c:forEach>
					</ul>
				</div>
			</div>
			<!-- // tab 끝-->
			
			<div style="padding:5px 10px 0px 10px; overflow:hidden;">
				<c:if test="${boardInfo.s_group ne codes.CUSTOM_BOARD_TYPE_RSS}">
				<div style="float:left; width:50%;">
					<div style="padding-right:10px;">
					<a data-role="button" onclick="goPage('boardMenuEdit.latte')" style="padding:10px;">메뉴 편집</a>
					</div>
				</div>
				<div style="float:left; width:50%;">
					<a data-role="button" onclick="goPage('boardContentEdit.latte?cmid=${boardInfo.s_cmid}')" style="padding:10px;">등록하기</a>
				</div>
				</c:if>
				<c:if test="${boardInfo.s_group eq codes.CUSTOM_BOARD_TYPE_RSS}">
				<a data-role="button" onclick="goPage('boardMenuEdit.latte')" style="padding:10px;">메뉴 편집</a>
				</c:if>
			</div> --%>
			
			<!-- 상단 메뉴 영역 시작-->
			<c:set var="curMenu" value="${boardInfo.sequence}"/>
			<c:set var="mainMenuLen" value="${fn:length(menuList)}"/>
			
			<div id="boardMenu" class="tab_2depth">
				<p id="right_btn" class="btn_l btn_img02"><a data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_l02.png" alt="" width="34" height="45"/></a></p>
				<p id="left_btn" class="btn_r btn_img02"><a data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_r02.png" alt="" width="34" height="45"/></a></p>
				<p class="btn_r02 btn_modify02"><a onclick="goPage('boardMenuEdit.latte')" data-role="button"><img src="${con.IMGPATH}/btn/icon_modify.png" alt="" width="31" height="31"/></a></p>
				<div class="list" id="list" style="overflow:hidden;">
					<ul id="ccc">
						<li id="center" style="width:${mainMenuLen * 33}%; cursor:pointer;">
							<c:forEach items="${menuList}" var="item" varStatus="c">
							<c:set var="www"><fmt:formatNumber value="${100.0 / mainMenuLen}" pattern="0"/></c:set>
							<a id="menu${c.index}" style="width:${www}%; overflow:hidden;"<c:if test="${c.index eq curMenu-1}"> class="on"</c:if> onclick="slideMenu.goMenuLink('boardHome.latte?idx=${params.idx}&cmid=${item.s_cmid}');">
								<p style="position:relative; overflow:hidden;">&nbsp;<div style="position:absolute; left:50%; top:0;"><b style="visibility:hidden;">${item.s_name}</b><div style="position:absolute; left:-1000%; top:0; width:2000%;">${item.s_name}</div></div></p>
								<span><img src="${con.IMGPATH}/common/b_arrow02.png" alt="" width="10" height="5"/></span>
							</a>
							</c:forEach>
						</li>
					</ul>
				</div>
			</div>
			<!-- 상단 메뉴 영역 끝-->
			
			<c:if test="${boardInfo.s_group ne codes.CUSTOM_BOARD_TYPE_RSS}">
			<!-- 등록버튼 -->
			<div class="a_type01_b">
				<p class="btn_red02"><a onclick="goPage('boardContentEdit.latte?cmid=${boardInfo.s_cmid}')" data-role="button"> 게시물 등록하기</a></p>
			</div>
			</c:if>
			
			<!-- 검색 -->
			<div class="search_area">
				<input type="hidden" id="search_type" value="subjectcontents"/>
				<p class="search_input"><input type="text" id="search_input" value="${params.search_text}"></p>
				<p class="btn_search"><a id="search_btn" data-role="button"><img src="${con.IMGPATH}/btn/icon_search.png" alt="" width="18" height="18"/></a></p>
			</div>
			
			<%-- <jsp:include page="board/${inner_layout}"></jsp:include> --%>
			<%-- 게시판 타입에 따라 레이아웃 결정 --%>
			
			<c:choose>
			<c:when test="${boardInfo.s_group eq codes.CUSTOM_BOARD_TYPE_RSS}">
				<c:set var="inner_layout" value="hospital_rss_board_inner.jsp"/></c:when>
			<c:when test="${boardInfo.s_group eq codes.CUSTOM_BOARD_TYPE_IMAGE}">
				<c:set var="inner_layout" value="hospital_img_board_inner.jsp"/></c:when>
			<c:when test="${boardInfo.s_group eq codes.CUSTOM_BOARD_TYPE_NOTICE}">
				<c:set var="inner_layout" value="hospital_notice_board_inner.jsp"/></c:when>
			<c:when test="${boardInfo.s_group eq codes.CUSTOM_BOARD_TYPE_FAQ}">
				<c:set var="inner_layout" value="hospital_faq_board_inner.jsp"/></c:when>
			</c:choose>
			
			<div class="list_type">
				<ul data-role="listview" data-split-icon="gear" data-split-theme="d" style="padding:0; margin:0;">
				<jsp:include page="board/${inner_layout}"></jsp:include>
				</ul>
			</div>
			<%-- <div style="overflow:hidden;">
				<input type="hidden" id="search_type" value="subjectcontents"/>
				<div style="float:left; width:70%; padding:0 10px;">
					<input type="text" id="search_input" style="color:black; border:1px solid black;" value="<%=request.getParameter("search_text")!=null?URLDecoder.decode(request.getParameter("search_text"),"UTF-8"):""%>"/>
				</div>
				<div style="float:left; width:20%; padding:0 10px;">
					<a data-role="button" id="search_btn" style="padding:10px;">검색</a>
				</div>
			</div> --%>
			
			<c:if test="${not empty params.pageNumber}">
			<jsp:include page="../include/INC_PAGE.jsp"></jsp:include>
			</c:if>
			
		</div>
		
		<!-- ///// content 끝-->
		
		<jsp:include page="../include/simple_copyright.jsp"/>
		
	</div>
	
	
	
	<script>
		$('#search_input').on('keyup',function(){
			if(event.keyCode==13) $('#search_btn').click();
		});
		$('#search_btn').on('click',function(){
			//alert('boardHome.latte?cmid=${boardInfo.s_cmid}&search_type='+$('#search_type').val()+'&search_text='+escape(encodeURIComponent($('#search_input').val())));
			goPage('boardHome.latte?cmid=${boardInfo.s_cmid}&search_type='+$('#search_type').val()+'&search_text='+escape(encodeURIComponent($('#search_input').val())));
		});
	</script>

</body>
</html>