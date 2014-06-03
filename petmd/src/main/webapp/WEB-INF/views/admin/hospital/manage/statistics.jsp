<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>

<jsp:include page="/WEB-INF/views/admin/hospital/include/INC_JSP_HEADER.jsp"/>


<script>

function checkbox(me,targetId){
	
	if($(me).is(':checked'))
		$('#'+targetId).val('Y');
	else
		$('#'+targetId).val('N');
}

function saveInfo(){
	
	//$('#old_zipcode').val($('#old_zipcode_1').val()+"-"+$('#old_zipcode_2').val());
	
	$.ajax({
		url:'ajaxSaveManageMainInfo.latte',
		type:'POST',
		data:$('#form').serialize(),
		dataType:'json',
		success:function(response, status, xhr){
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				$('#bid').val(response.bid);
				showDialog('처리되었습니다.');
			}
		},
		error:function(xhr,status,error){
			alert(status+'\n'+error);
		}
	});
}

</script>
</head>

<body>
		
	<div id="page" data-role="page" style="background: #f7f3f4; overflow: hidden">
		
		<c:if test="${empty appType}" >
		<!-- header 시작-->
		<div data-role="header" id="head" data-position="fixed" data-tap-toggle="false" data-theme="a"><!-- data-tap-toggle="false"  -->
			<h1>메인메뉴편집</h1>
			<!--<h1>검색 결과</h1>-->
			<a data-role="button" onclick="goPage('hospitalHome.latte')"><img src="${con.IMGPATH_OLD}/btn/btn_home.png" alt="shop" width="32" height="32" />&nbsp;</a>
			<a data-role="button" data-rel="menu"><img src="${con.IMGPATH_OLD}/btn/btn_menu.png" alt="shop" width="32" height="32" />&nbsp;</a>
		</div>
		<!-- ///// header 끝-->
		</c:if>
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
			
			<!-- 메인메뉴 tab -->
			<jsp:include page="../include/manage_menu1.jsp">
				<jsp:param value="2" name="curMainMenu"/>
			</jsp:include>
			<!-- // tab 끝-->
			
			<p style="padding:10px;">...</p>
			
			
			
		</div>
	
	</div>

</body>
</html>