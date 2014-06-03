<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<script>
function manage_title_icon_change(id){
	if(id=='home'){$('#jf7san7f983ahwkrwe9').attr('src','${con.IMGPATH}/btn/btn_home.png');}
	else if(id=='back'){$('#jf7san7f983ahwkrwe9').attr('src','${con.IMGPATH}/btn/btn_back.png');}
}
</script>
<!-- header 시작-->
<div data-role="header" id="admin_head" data-position="fixed" data-theme="a">
	<h1>${param.title_bar_title}</h1>
	<c:if test="${param.ignore_title_back_btn ne 'Y'}">
	<c:set var="img_name"><c:choose><c:when test='${param.title_btn_icon eq "home"}'>btn_home.png</c:when><c:otherwise>btn_back.png</c:otherwise></c:choose></c:set>
	<a onclick="<c:choose><c:when test="${not empty param.back_function}">${param.back_function}();</c:when><c:when test="${not empty param.back_code}">${param.back_code}</c:when><c:otherwise>if(typeof title_back==='function'){title_back();}else{history.back();}</c:otherwise></c:choose>" data-role="button"><img id="jf7san7f983ahwkrwe9" src="${con.IMGPATH}/btn/${img_name}" alt="back" width="50" height="50"/>&nbsp;</a>
	</c:if>
	<c:if test="${param.ignore_title_btn2 ne 'Y'}">
	<a onclick="goPage('passwordEdit.latte')" data-role="botton" data-rel="menu" class="ui-btn-right"><img src="${con.IMGPATH}/btn/btn_set02.png" alt="set" width="50" height="50"/>&nbsp;</a>
	</c:if>
</div>
<!-- ///// header 끝-->
<%-- <div data-role="header" id="admin_head" data-position="fixed" data-theme="a">
	<h1>${hospital_name}</h1>
	<c:if test="${param.ignore_title_back_btn ne 'Y'}">
	back_function 로 함수명을 넘기면 back_function 함수를 뒤로가기s대신 호출
	title_back 함수를 구현하면 함수를 뒤로가기 대신 호출
	위 두 항목 모두 해당되지 않으면 history.back (기본 뒤로가기)
	<a onclick="<c:choose><c:when test="${not empty param.back_function}">${param.back_function}();</c:when><c:otherwise>if(typeof title_back==='function'){title_back();}else{history.back();}</c:otherwise></c:choose>" data-role="button"><img src="${con.IMGPATH}/btn/btn_back.png" alt="back" width="50" height="50"/>&nbsp;</a>
	</c:if>
	<a onclick="goPage('manageSchedule.latte');" data-role="button" data-rel="menu" class="ui-btn-right"><img src="${con.IMGPATH}/btn/btn_set.png" alt="set" width="50" height="50"/>&nbsp;</a>
</div> --%>