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

function checkbox(me,targetId){
	
	if($(me).is(':checked'))
		$('#'+targetId).val('Y');
	else
		$('#'+targetId).val('N');
}

function saveCallInfo(){
	
	/* if(!confirm('내용을 저장하시겠습니까?'))
		return; */
	
	if($('#checkbox-c1').is(':checked'))
		$('#equipment_check').val('Y');
	else
		$('#equipment_check').val('N');
	
	$.ajax({
		type:'POST',
		url:'ajaxSaveEquipment.latte',
		data:$('#dataForm').serialize(),
		dataType:'json',
		success:function(response,status,xhr){
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				showDialog('저장이 완료되었습니다.','default');
				$('#old_equipment').val($('#equipment').val());
				$('#old_equipment_check').val($('#equipment_check').val());
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
	
	if($('#checkbox-c1').is(':checked'))
		$('#equipment_check').val('Y');
	else
		$('#equipment_check').val('N');

	if($('#old_equipment').val()!=$('#equipment').val()
			|| $('#old_equipment_check').val()!=$('#equipment_check').val())
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
			
			<input type="hidden" id="old_equipment" value="${hospitalInfo.EQUIPMENT}"/>
			<input type="hidden" id="old_equipment_check" value="${hospitalInfo.EQUIPMENT_status}"/>
			
			<form id="dataForm">
			
			<div class="a_type01">
				<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" /> 보유장비
					<p class="checkbox po_r02" style=" width:70px;">
						<input type="hidden" id="equipment_check" name="equipment_check" value="${hospitalInfo.EQUIPMENT_status}"/>
						<input type="checkbox" id="checkbox-c1" value="c-1" onclick="checkbox(this,'equipment_check');" <c:if test="${hospitalInfo.EQUIPMENT_status eq 'Y'}">checked="checked"</c:if>/>
						<label for="checkbox-c1">사용함</label>
					</p>
				</h3>
				<p class="textarea01 mt10"><textarea id="equipment" name="equipment" style="width:100%; height:150px;" placeholder="보유장비를 넣어주세요">${hospitalInfo.EQUIPMENT}</textarea></p>
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