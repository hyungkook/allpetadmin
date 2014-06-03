<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:scriptlet>
 
pageContext.setAttribute("crlf", "\r\n");
pageContext.setAttribute("lf", "\n");
pageContext.setAttribute("cr", "\r");

</jsp:scriptlet>

<!DOCTYPE html>
<html lang="ko">
<head>
<%-- <jsp:include page="/WEB-INF/views/admin/hospital/include/INC_JSP_HEADER.jsp"/> --%>
<jsp:include page="../include/total_header.jsp"/>

<script>

function dataCorrection(){
	
	$('#tel').val($('#tel1').val()+"-"+$('#tel2').val()+"-"+$('#tel3').val());
	if($('#checkbox-c1').is(':checked'))
		$('#sns_id_check').val('Y');
	else
		$('#sns_id_check').val('N');
}

function saveCallInfo(){
	
	dataCorrection();
	
	/* if($('#old_sns_id').val()!=$('#sns_id').val()
			|| $('#old_sns_id_check').val()!=$('#sns_id_check').val()
			|| $('#old_display_tel').val()!=$('#display_tel').val()
			|| $('#old_tel').val()!=$('#tel').val()){
		if(!confirm('내용을 저장하시겠습니까?'))
			return;
	}
	else
		return; */
	
	$.ajax({
		type:'POST',
		url:'ajaxSaveCallInfo.latte',
		data:$('#dataForm').serialize(),
		dataType:'json',
		success:function(response,status,xhr){
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				showDialog('저장이 완료되었습니다.','default');
				$('#old_sns_id').val($('#sns_id').val());
				$('#old_sns_id_check').val($('#sns_id_check').val());
				$('#old_display_tel').val($('#display_tel').val());
				$('#old_tel').val($('#tel').val());
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
	
	/* dataCorrection();
	
	if($('#old_sns_id').val()!=$('#sns_id').val()
			|| $('#old_sns_id_check').val()!=$('#sns_id_check').val()
			|| $('#old_display_tel').val()!=$('#display_tel').val()
			|| $('#old_tel').val()!=$('#tel').val())
		if(!confirm('변경된 내용이 있습니다. 작성을 취소하시겠습니까?'))
			return; */
			
	if(!allow_change()){
		return;
	}
	
	history.back();
}

function allow_change(){
	
	dataCorrection();
	
	if($('#old_sns_id').val()!=$('#sns_id').val()
			|| $('#old_sns_id_check').val()!=$('#sns_id_check').val()
			|| $('#old_display_tel').val()!=$('#display_tel').val()
			|| $('#old_tel').val()!=$('#tel').val())
		if(!confirm('변경된 내용이 있습니다. 작성을 취소하시겠습니까?'))
			return false;
	
	return true;
}

$(document).ready(function(){
	
	setInputConstraint('phoneNumber','tel1',3);
	setInputConstraint('phoneNumber','tel2',4);
	setInputConstraint('phoneNumber','tel3',4);
});

</script>

<style>
label {display:inline-block !important;}
label span{display:inline-block !important;}
label span span{width:auto;}
</style>

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
			<jsp:include page="../include/main_menu.jsp">
				<jsp:param value="allow_change" name="main_menu_interceptor"/>
			</jsp:include>
			
			<form id="dataForm">
			
			<input type="hidden" id="old_sns_id" value="${hospitalInfo.SNS_ID}"/>
			<input type="hidden" id="old_sns_id_check" value="${hospitalInfo.SNS_ID_status}"/>
			<input type="hidden" id="old_display_tel" value="${hospitalInfo.s_display_tel}"/>
			<input type="hidden" id="old_tel" value="${hospitalInfo.s_tel}"/>
			
			<div class="a_type01_b">
				<div class="dl_type01">
					<dl>
						<dt>카카오톡 아이디</dt>
						<dd><p class="input01 txt_r"><input type="text" id="sns_id" name="sns_id" value="${hospitalInfo.SNS_ID}"></p></dd>
						<dd>
							<p class="checkbox">
							<input type="hidden" id="sns_id_check" name="sns_id_check" value="<c:if test="${hospitalInfo.SNS_ID_status eq 'Y'}">hospitalInfo.SNS_ID_status</c:if>"/>
							<input type="checkbox" id="checkbox-c1" value="c-1" <c:if test="${hospitalInfo.SNS_ID_status eq 'Y'}">checked="checked"</c:if>/>
							<label for="checkbox-c1">사용함</label>
							</p>
						</dd>
					</dl>
				</div>
			</div>
			
			<div class="a_type01_b">
				<div class="dl_type01">
					<dl>
						<dt>연락처</dt>
						<dd><p class="input01"><input type="text" id="display_tel" name="display_tel" value="${hospitalInfo.s_display_tel}"></p></dd>
						<dd class="pt05">*표시될 연락처를 입력 해 주세요.</dd>
						<dd>ex) 02-1234-5000~5003 </dd>
					</dl>
				</div>
			</div>
			
			<div class="a_type01_b" style=" border:none;">
				<div class="dl_type01">
					<dl>
						<dt>전화연결 번호</dt>
						<dd>
							<input type="hidden" id="tel" name="tel" value="${hospitalInfo.s_tel}"/>
							<p class="input01" style="display:inline-block; width:20%;"><input type="text" id="tel1" value="${fn:split(hospitalInfo.s_tel,'-')[0]}"></p> -
							<p class="input01" style="display:inline-block; width:20%;"><input type="text" id="tel2" value="${fn:split(hospitalInfo.s_tel,'-')[1]}"></p> -
							<p class="input01" style="display:inline-block; width:20%;"><input type="text" id="tel3" value="${fn:split(hospitalInfo.s_tel,'-')[2]}"></p>
						</dd>
						<dd class="pt05">* 휴대폰 전화걸기를 통해 연결될 번호를 입력해주세요.</dd>
						<dd>* 숫자만 입력이 가능합니다.</dd>
					</dl>
				</div>
				
				<div class="btn_area02 mt20 mb20">
					<p class="btn_black02 btn_l" style="width:100px;"><a onclick="cancel();" data-role="button">취소</a></p>
					<p class="btn_red02" style="margin-left:104px;"><a onclick="saveCallInfo();" data-role="button">저장</a></p>
				</div>
				
			</div>
			
			</form>
			
			<%-- <form id="dataForm">
			<p>카카오톡 아이디</p>
			<input type="text" value="${hospitalInfo.SNS_ID}"/>
			<input type="hidden" id="sns_id_check" name="sns_id_check" value="<c:if test="${hospitalInfo.SNS_ID_status eq 'Y'}">hospitalInfo.SNS_ID_status</c:if>"/>
			<div style="padding:10px;">
				<div style="display:inline-block;"><input type="checkbox" id="sns_id_checkbox" <c:if test="${hospitalInfo.SNS_ID_status eq 'Y'}">checked="checked"</c:if>/></div><span>사용함</span>
			</div>
			
			<div style="overflow:hidden; margin-top:20px;">
				<div style="float:left; padding:10px;">연락처</div><div style="float:left;"><input type="text" id="display_tel" name="display_tel" value="${hospitalInfo.s_display_tel}"/></div>
			</div>
			
			<p>표시될 연락처를 입력해 주세요.</p>
			
			<div style="overflow:hidden; margin-top:20px;">
				<input type="hidden" id="tel" name="tel" value="${hospitalInfo.s_tel}"/>
				<div style="float:left; padding:10px;">전화연결 번호</div><div style="float:left;"><input type="text" id="tel1" style="width:100px; display:inline-block;" value="${fn:split(hospitalInfo.s_tel,'-')[0]}"/>-<input type="text" id="tel2" style="width:100px; display:inline-block;" value="${fn:split(hospitalInfo.s_tel,'-')[1]}"/>-<input type="text" id="tel3" style="width:100px; display:inline-block;" value="${fn:split(hospitalInfo.s_tel,'-')[2]}"/></div>
			</div>
			
			<p>휴대폰 전화걸기를 통해 연결될 번호를 입력해 주세요.</p>
			</form>
			
			<div>
				<div style="float:left; padding:10px;"><a data-role="button" onclick="cancel();" style="padding:10px;">취소</a></div>
				<div style="float:left; padding:10px;"><a data-role="button" onclick="saveCallInfo();" style="padding:10px;">저장</a></div>
			</div> --%>
			
		</div>
		
		<jsp:include page="copyright.jsp"/>
	</div>
</body>
</html>