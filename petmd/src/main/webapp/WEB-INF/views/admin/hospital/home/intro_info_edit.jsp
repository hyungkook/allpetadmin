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

function saveInfo(){
	
	if(!confirm('내용을 저장하시겠습니까?'))
		return;
	
	$.ajax({
		type:'POST',
		url:'ajaxSaveIntroInfo.latte',
		data:$('#dataForm').serialize(),
		dataType:'json',
		success:function(response,status,xhr){
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				showDialog('저장이 완료되었습니다.','default',function(){
					history.back();
				});
				$('#old_keyword').val($('#keyword').val());
				$('#old_introduce').val($('#introduce').val());
				$('#old_shortIntroduce').val($('#shortIntroduce').val());
				$('#old_represent_staff').val($('#represent_staff').val());
			}
			else
				showDialog('저장 중 오류가 발생하였습니다.','default');
		},
		error:function(xhr,status,error){
			
			alert("실패하였습니다.\n"+status+"\n"+error);
		}
	});
}

function cancel(){
	
	if($('#old_keyword').val()!=$('#keyword').val()
			|| $('#old_introduce').val()!=$('#introduce').val()
			|| $('#old_shortIntroduce').val()!=$('#shortIntroduce').val()
			|| $('#old_represent_staff').val()!=$('#represent_staff').val())
		if(!confirm('내용 수정을 취소하시겠습니까?'))
			return;
	
	history.back();
}

$(document).ready(function(){
	
	setInputConstraint('lengthLimit','keyword',20);
	setInputConstraint('lengthLimit','shortIntroduce',50);
});

</script>

</head>
<body>

	<div data-role="page">
	
		<jsp:include page="/common/admin/hospital/INC_INSTANCE_DIALOG.jsp"/>
		
		<jsp:include page="../include/main_title_bar.jsp">
			<jsp:param name="back_function" value="cancel"/>
		</jsp:include>
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
			
			<!-- 메인메뉴 tab -->
			<jsp:include page="../include/main_menu.jsp"/>
			
			<input type="hidden" id="old_keyword" value="${hospitalInfo.s_keyword}"/>
			<input type="hidden" id="old_shortIntroduce" value="${hospitalInfo.s_shortIntroduce}"/>
			<input type="hidden" id="old_introduce" value="${hospitalInfo.s_introduce}"/>
			<input type="hidden" id="old_represent_staff" value="${hospitalInfo.s_represent_staff}"/>
			
			<form id="dataForm">
			
			<div class="a_type01_b">
				<h3>소개키워드</h3>
				<p class="input01 mt05"><input type="text" name="keyword" id="keyword" value="${hospitalInfo.s_keyword}"></p>
				<p class="txt_gray11 mt05">* 20자 이하만 입력 가능합니다.</p>
				<p class="txt_gray11">등록 예) 365일 24시간 진료, CT촬영, 재활치료, 안과, 고양이</p>
			</div>
			
			<div class="a_type01_b">
				<h3>인사말 입력</h3>
				<p class="input01 mt05"><input type="text" name="shortIntroduce" id="shortIntroduce" value="${hospitalInfo.s_shortIntroduce}"></p>
				<p class="txt_gray11 mt05">* 50자 이하만 입력 가능합니다.</p>
			</div>
			
			<div class="a_type01_b">
				<h3>소개글 입력<span class="txt_r">0/500</span></h3>
				<p class="textarea01 mt05"><textarea id="introduce" name="introduce" style="width:100%; height:150px;" placeholder="소개글을 입력해주세요.">${hospitalInfo.s_introduce}</textarea></p>
			</div>
			
			<div class="a_type01_b" style="border:none;">
				<h3>대표자 선택<span class="t01"> (ex. <label class="bold">홍길동</label> 원장 외 123명)</span></h3>
				<div class="btn_select mt05">
					<a data-role="button" >
					<select name="represent_staff" id="represent_staff" data-icon="false">
						<c:forEach var="item" items="${staffList}">
							<option value="${item.s_stid}" <c:if test="${hospitalInfo.s_represent_staff eq item.s_stid}">selected="selected"</c:if>>${item.s_name}</option>
						</c:forEach>
						<!-- <option value="">선택</option>
						<option value="">홍길동</option>
						<option value="">길동홍</option> -->
					</select>
					</a>
					<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
				</div>
				<p class="txt_gray11 mt05">* 의료진/스탭 메뉴 페이지에 대표자 정보가 등록되어야 선택이 가능합니다.</p>
				
				<div class="btn_area02 mt20 mb20">
					<p class="btn_black02 btn_l" style="width:100px;"><a onclick="cancel();" data-role="button">취소</a></p>
					<p class="btn_red02" style="margin-left:104px;"><a onclick="saveInfo();" data-role="button">저장</a></p>
				</div>
			</div>
			
			</form>
			
		</div>
		
		<jsp:include page="copyright.jsp"/>
	</div>
</body>
</html>