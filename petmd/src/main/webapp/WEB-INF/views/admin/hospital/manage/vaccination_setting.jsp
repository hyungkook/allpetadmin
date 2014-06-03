<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<jsp:include page="../include/total_header.jsp"/>
<script>
$(document).ready(function(){
	setInputConstraint('numberOnly','dog_term',1);
	setInputConstraint('numberOnly','dog_len',1);
	setInputConstraint('numberOnly','cat_term',1);
	setInputConstraint('numberOnly','cat_len',1);
});

function save(){
	
	$.ajax({
		url:'ajaxSaveVaccination.latte',
		data:{
			dog_term:$('#dog_term').val(),
			dog_len:$('#dog_len').val(),
			cat_term:$('#cat_term').val(),
			cat_len:$('#cat_len').val()
		},
		success:function(response,status,xhr){
			
		},
		error:function(xhr,status,error){
			alert('처리중 문제가 발생하였습니다.');
		}
	});
}
</script>
</head>
<body>

	<div data-role="page">
		
		<jsp:include page="../include/manage_title_bar.jsp">
			<jsp:param name="title_bar_title" value="포인트출납 및 회원관리"/>
			<jsp:param name="title_btn_icon" value="home"/>
			<jsp:param name="back_function" value="back"/>
		</jsp:include>
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
		
			<!-- 메인메뉴 tab -->
			<jsp:include page="../include/manage_menu.jsp">
				<jsp:param value="3" name="cur_manage_menu"/>
			</jsp:include>
			<!-- // tab 끝-->
			
			<div class="a_type01_b">
				<h3>기초접종 (개)</h3>
			</div>
			
			<div class="a_type01_b">
				<div class="dl_type01">
					<dl>
						<dt>간격 (단위:주)</dt>
						<dd><p class="input01"><input type="text" id="dog_term" value="${m.BASIC_DOG.BASIC[0].term}"></p></dd>
					</dl>
				</div>
				<div class="dl_type01 mt10">
					<dl>
						<dt>최종 차수</dt>
						<dd><p class="input01"><input type="text" id="dog_len" value="${m.BASIC_DOG.BASIC[0].len}"></p></dd>
					</dl>
				</div>
			</div>
			
			<div class="a_type01_b">
				<h3>기초접종 (고양이)</h3>
			</div>
			
			<div class="a_type01_b">
				<div class="dl_type01">
					<dl>
						<dt>간격 (단위:주)</dt>
						<dd><p class="input01"><input type="text" id="cat_term" value="${m.BASIC_CAT.BASIC[0].term}"></p></dd>
					</dl>
				</div>
				<div class="dl_type01 mt10">
					<dl>
						<dt>최종 차수</dt>
						<dd><p class="input01"><input type="text" id="cat_len" value="${m.BASIC_CAT.BASIC[0].len}"></p></dd>
					</dl>
				</div>
			</div>
			
			<%-- <div class="a_type01_b">
				<h3>항체가검사</h3>
			</div>
			
			<div class="a_type01_b">
				<div class="dl_type01">
					<dl>
						<dt>시간</dt>
						<dd><p class="input01">기초접종 완료 이후 2주 후</p></dd>
					</dl>
				</div>
			</div>
			
			<div class="a_type01_b">
				<h3>추가접종</h3>
			</div>
			
			<div class="a_type01_b">
				<div class="dl_type01">
					<dl>
						<dt>시간</dt>
						<dd><p class="input01">기초접종 완료 이후 매 1년마다</p></dd>
					</dl>
				</div>
			</div>
			
			<div class="a_type01_b">
				<h3>심장사상충</h3>
			</div>
			
			<div class="a_type01_b">
				<div class="dl_type01">
					<dl>
						<dt>시간</dt>
						<dd><p class="input01">시작일 기준으로 매 1달마다</p></dd>
					</dl>
				</div>
			</div> --%>
			
			<div class="a_type01_b">
				<p class="btn_red02 mt15"><a onclick="save();" data-role="button">저장</a></p>
			</div>
		</div>
	</div>

</body>
</html>