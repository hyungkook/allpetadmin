<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<jsp:scriptlet>
 
pageContext.setAttribute("crlf", "\r\n");
pageContext.setAttribute("lf", "\n");
pageContext.setAttribute("cr", "\r");
 
</jsp:scriptlet>

<!DOCTYPE html>
<html lang="ko">
<head>
<jsp:include page="../include/total_header.jsp"/>

<script>
	/* 메뉴토글 : 시작 *************/
	$(document).ready(function() {
		menuToggle("menu_mypage");		 
	});
	/* 메뉴토글 : 끝남 *************/
	
	function goSubmit() {
		
		if (!$('#old_pw').val()) {
			alert("기존 비밀번호를 입력하세요");
			return;
		}
		
		if ($("#new_pw").val().length < 4) {
			alert("비밀번호는 4자리 이상으로 설정해주세요");
			return;
		}
		
		if ($("#new_pw").val() != $("#new_re_pw").val()) {
			alert("비밀번호를 확인해주세요");
			return;
		}
		
		var r = Math.floor(Math.random() * 10);
		var r2 = Math.floor(Math.random() * 10);

		
		/* $("#form").attr("action","myPagePasswordChangeUpdate.latte");
		document.getElementById("form").submit();
		*/
		$.ajax({
			url:'ajaxPwChange.latte',
			type:'POST',
			data:{
				old_pw:(r+$('#old_pw').val()),
				new_pw:(r2+$("#new_pw").val()),
				new_re_pw:(r2+$("#new_re_pw").val())
			},
			dataType:'json',
			success:function(response,status,xhr){
				
				if(response.result=='${codes.SUCCESS_CODE}'){
					alert('변경되었습니다.');
				}
				else if(response.result=='${codes.ERROR_UNAUTHORIZED}'){
					if(confirm('로그인되지 않았습니다.\n로그인 페이지로 이동하시겠습니까?'))
						goPage('login.latte');
				}
				else if(response.result=='${codes.ERROR_INVALID_PARAMETER}'){
					alert('새 암호를 잘못 입력하였습니다.');
				}
				else if(response.result=='${codes.ERROR_QUERY_PROCESSED}'){
					alert('기존 암호를 잘못 입력하였습니다.');
				}
				else if(response.result=='${codes.ERROR_QUERY_EXCEPTION}'){
					alert('처리 도중 오류가 발생하였습니다.');
				}
			},
			error:function(xhr,status,error){
				
				alert("상태:"+status+"\n에러:"+error);
			}
		});
	}
	
</script>

</head>

<body>

	<form id="form" method="post">
	
	
	<div data-role="page">
	
		<jsp:include page="../include/manage_title_bar.jsp">
			<jsp:param name="title_bar_title" value="비밀번호 변경"/>
			<jsp:param name="ignore_title_btn2" value="Y"/>
		</jsp:include>
	
	<!-- content 시작-->
	<div data-role="content" id="contents">
	
		<div class="a_type01">

			<p class="txt_gray11">*비밀번호는 4자 이상 입력하셔야 합니다.</p>
			
			<div class="dl_type01 mt10">
				<dl>
					<dt>기존 비밀번호</dt>
					<dd><p class="input01"><input type="password" id="old_pw" name="old_pw"></p></dd>
				</dl>
				<dl class="mt05">
					<dt>새 비밀번호</dt>
					<dd><p class="input01"><input type="password" id="new_pw" name="new_pw"></p></dd>
				</dl>
				<dl class="mt05">
					<dt>새 비밀번호 재입력</dt>
					<dd><p class="input01"><input type="password" id="new_re_pw" name="new_re_pw"></p></dd>
				</dl>
			</div>
			
			<p class="btn_red02 mt15"><a onclick="goSubmit();" data-role="button">비밀번호 변경</a></p>
			
			
		</div>
		
		
		<!-- <div class="st01">
			<p class="txt_type04 pt30">※ 4자 이상의 영문 대소문자, 숫자를 조합하여사용하실 수 있습니다.</p>
			<p class="txt_type04 pt10">※ 생년월일, 전화번호 등 개인정보와 관련된 숫자, 연속된 숫자와 같이 쉬운 비밀번호는 다른 사람이 쉽게 알아낼 수 있으니 사용을 자제해 주세요.</p>
			<div class="stage_area02 mt15">
				<dl>
					<dt class="red">기존 비밀번호</dt>
					<dd style="padding-left:124px;"><p class="input_type01"><input type="password" id="old_pw" name="old_pw"/></p></dd>
				</dl>
				<dl style="margin-top:5px;">
					<dt class="red">새 비밀번호</dt>
					<dd style="padding-left:124px;"><p class="input_type01"><input type="password" id="new_pw" name="new_pw"/></p></dd>
				</dl>
				<dl style="margin-top:5px;">
					<dt class="red">새 비밀번호 재입력</dt>
					<dd style="padding-left:124px;"><p class="input_type01"><input type="password" id="new_re_pw" name="new_re_pw"/></p></dd>
				</dl>
			</div>
			<p class="btn_type02 mt20"><a  data-role="button">비밀번호 변경</a></p>
		</div>
		<div style="font-size:12px; padding-top:150px; height:50px;">&nbsp;</div> -->
		   
		
		
	</div>
	<!-- ///// content 끝-->
	
	<jsp:include page="../include/simple_copyright.jsp"/>

		<!-- footer 시작-->
		<jsp:include page="/common/admin/hospital/INC_JSP_FOOTER.jsp" />
		<!-- ///// footer 끝-->

	</div>
</form>
 </body>
</html>