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

function saveCallInfo(){
	
	/* if(!confirm('내용을 저장하시겠습니까?'))
		return; */
	
	$.ajax({
		type:'POST',
		url:'ajaxSaveExtraInfo.latte',
		data:$('#dataForm').serialize(),
		dataType:'json',
		success:function(response,status,xhr){
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				showDialog('저장이 완료되었습니다.','default');
				$('#old_parking_info').val($('#parking_info').val());
				$('#old_credit_info').val($('#credit_info').val());
				history.back();
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
	
	if($('#old_parking_info').val()!=$('#parking_info').val()
			|| $('#old_credit_info').val()!=$('#credit_info').val())
		if(!confirm('변경된 내용이 있습니다. 작성을 취소하시겠습니까?'))
			return;
	
	history.back();
}

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
			
			<input type="hidden" id="old_parking_info" value="${hospitalInfo.s_parking_info}"/>
			<input type="hidden" id="old_credit_info" value="${hospitalInfo.s_credit_info}"/>
			
			<form id="dataForm">
			
			<!--부가정보 입력 -->
			<h3 class="ma15"><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />부가정보</h3>
			<div class="a_type01">
				<h3>주차</h3>
				<p class="textarea01 mt05"><textarea id="parking_info" name="parking_info" style="width:100%; height:100px;" placeholder="">${hospitalInfo.s_parking_info}</textarea></p>
				
				<h3 class="mt20">신용카드</h3>
				<p class="textarea01 mt05"><textarea id="credit_info" name="credit_info" style="width:100%; height:100px;" placeholder="">${hospitalInfo.s_credit_info}</textarea></p>
			</div>
			
			<div class="btn_area03">
				<p class="btn_black02 btn_l" style="width:100px;"><a onclick="cancel();" data-role="button">취소</a></p>
				<p class="btn_red02" style="margin-left:104px;"><a onclick="saveCallInfo();" data-role="button">저장</a></p>
			</div>
			
			</form>
			
		</div>
		
		<jsp:include page="copyright.jsp"/>
	</div>
</body>
</html>