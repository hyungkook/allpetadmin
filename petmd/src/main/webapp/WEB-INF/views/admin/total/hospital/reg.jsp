<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>

<script>

$(document).ready(function(){
	selectTopMenu("topmenu_hospital");
	selectSubMenu("submenu_hospital_reg");
	
	if(!isNoValue('hospital_id'))
		idCheck(document.getElementById('hospital_id'));

	//$('#hospital_name').on('keydown',function(){
	//	console.log('1');
	//});
	setInputConstraint('phoneNumber','manage_tel1',4);
});

var idChk = "N";

function selectTeam(obj){
	
	$.ajax({
		type:'POST',
		url:'ajaxGetAdminList.latte',
		data:{team:$(obj).val()},
		dataType:'text',
		success:function(response,status,xhr){
			
			$('#charge_sel_span').empty();
			$('#charge_sel_span').append($(response));
		},
		error:function(xhr,status,error){
			
			alert("실패하였습니다.\n"+status+"\n"+error);
		}
	});
	
}

function searchZipCode() {
	var url = 'getAddressZipcode.latte';
	var name = "popup";
	window.open(url, name, "width=355, height=546, toolbar=no, status=no, location=no, scrollbars=no, menubar=no, resizable=no");
}

function fieldcheck() {
	
	if(idChk == "N"){
		alert("아이디 확인이 되지 않았습니다.");
		return false;
	}
	
	if(isNoValue('hospital_name')) {
		alert("병원 이름을 입력하세요.");
		return false;
	}

	if (isNoValue('hospital_id')) {
		alert("병원 아이디를 입력하세요.");
		return false;
	}
	
	if($('#hospital_id').val().length < 5){
		alert("병원 아이디를 5자 이상 입력하세요.");
		return false;
	}

	if (isNoValue('status')) {
		alert("상태를 선택하세요.");
		return false;
	}
	
	if (isNoValue('manage_tel1')) {
		alert("병원 연락처를 입력하세요.");
		return false;
	}
	if (isNoValue('manage_tel2')) {
		alert("병원 연락처를 입력하세요.");
		return false;
	}
	if (isNoValue('manage_tel3')) {
		alert("병원 연락처를 입력하세요.");
		return false;
	}
	
	if (isNoValue('domain')) {
		alert("모바일 사이트 주소를 입력하세요.");
		return false;
	}
	
	if (isNoValue('old_zipcode')) {
		alert("우편번호를 검색하세요.");
		return false;
	}
	/*
	if (isNoValue('aid')) {
		alert("담당자를 선택하세요.");
		return false;
	}
	*/
	/* var s_state = document.getElementsByName("s_state");
	var isState = false;
	for(var i=0;i<s_state.length;i++) {
		if (s_state[i].checked == true) {
			isState = true;
		}
	}
	
	if (isState == false) {
		alert("병원 상태를 선택하세요.");
		return false;
	} */
	/* var s_aid = document.getElementById("s_aid").value;
	if (trim(s_aid) == '') {
		alert("담당자(뷰티라떼 관리자)를 선택하세요.");
		return false;
	}
	var s_zipcode = document.getElementById("old_zipcode").value;
	if (trim(s_zipcode) == '') {
		alert("우편번호를 검색하세요.");
		return false;
	}
	var s_addr_etc = document.getElementById("s_addr_etc").value;
	if (trim(s_addr_etc) == '') {
		alert("상세 주소를 입력하세요.");
		return false;
	} */
	return true;
}

function save(){
	
	if(!fieldcheck())
		return;
	
	$.ajax({
		type:'POST',
		url:'ajaxInsertOrUpdateHospital.latte',
		data:$('#form').serialize(),
		dataType:'json',
		success:function(response,status,xhr){
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				$('#sid').val(response.sid);
				alert('병원이 등록되었습니다.');
				goPage('hospitalSearch.latte');
			}
			else if(response.result=='${codes.ERROR_ID_DUPLICATED}'){
				alert('ID가 중복되었습니다. 다른 아이디를 사용하세요.');
			}
			else if(response.result=='${codes.ERROR_UNAUTHORIZED}'){
				goPage('login.latte');
			}
			else if(response.result=='${codes.ERROR_MISSING_PARAMETER}'){
				alert('필수 요소를 입력하지 않았습니다.');
			}
			else{
				alert('에러가 발생했습니다.');
			}
		},
		error:function(xhr,status,error){
			
			alert("실패하였습니다.\n"+status+"\n"+error);
		}
	});
}

function idCheck(obj){
	
	idChk = "N";
	
	$.ajax({
		type:'POST',
		url:'ajaxHospitalIdCheck.latte',
		data:{
			hospital_id:$(obj).val(),
			sid:'${params.sid}'
		},
		dataType:'text',
		success:function(response,status,xhr){
			
			if(response == '${codes.SUCCESS_CODE}'){
				document.getElementById('idchkview').innerHTML = "사용가능한 아이디 입니다";
				idChk = "Y";	
			}else{
				document.getElementById('idchkview').innerHTML = "사용할 수 없는 아이디 입니다";
				idChk = "N";
			}
		},
		error:function(xhr,status,error){
			
			alert("실패하였습니다.\n"+status+"\n"+error);
		}
	});
}

function passwordInit(){
	
	$.ajax({
		type:'POST',
		url:'ajaxInitHospitalPw.latte',
		data:{
			sid:'${params.sid}'
		},
		dataType:'text',
		success:function(response,status,xhr){
			
			if(response == '${codes.SUCCESS_CODE}'){
				alert('암호가 초기화되었습니다.');
			}else{
				alert('암호 초기화에 실패하였습니다.\n'+status);
			}
		},
		error:function(xhr,status,error){
			
			alert("실패하였습니다.\n"+status+"\n"+error);
		}
	});
}

</script>

<c:if test="${not empty params.sid }">
	<jsp:include page="tabmenu.jsp">
		<jsp:param value="tab_manage" name="jsp_select_tab"/>
	</jsp:include>
</c:if>

<form id="form">

	<input type="hidden" name="sid" value="${params.sid}" />
	<div class="box716 mt15">
	<h4>병원 기본 정보</h4>
	<table cellpadding="0" border="0" cellspacing="0" class="table_edit mb30">
		<colgroup>
			<col width="25%" /><col width="75%" />
		</colgroup>
		<tr>
			<th>병원 이름<label class="surely">*</label></th>
			<td>
				<span><input type="text" id="hospital_name" name="hospital_name" class="txt" style="width:200px;"  value="${hospitalInfo.s_hospital_name }" /></span>
				<span></span>
			</td>
		</tr>
		 
		 <tr>
			<th>병원 관리자 아이디<label class="surely">*</label></th>
			<td>
				<span><input type="text" id="hospital_id" name="hospital_id" class="txt" style="width:200px;"  value="${hospitalInfo.s_hospital_id}"  onkeyup="idCheck(this)" /></span>
			   <span class="ex11 pl10" id="idchkview"></span>
			</td>
		 </tr>
		  <tr>
			<th>병원 관리자 비밀번호</th>
			<td>
				 <c:if test="${empty params.sid}">
				 <span class="ex11 pl12" >※ 초기 비밀번호는 아이디와 동일합니다.(등록 페이지에서 비밀번호는 수정할수 없습니다)</span>
				 </c:if>
				 <c:if test="${not empty params.sid}">
				 <span>
				 	<a onClick="passwordInit()" class="black01" style="cursor:pointer;padding-left:20px; padding-right:20px;">초기화하기</a>
				 </span>
				 <span class="pl12" id="span_pass"></span>
				 </c:if>
			</td>
		</tr>
		 <c:if test="${not empty params.n_fail_count}">
		<tr>
			<th>로그인실패 횟수 초기화</th>
			<td>
				<a onClick="loginFailCountInit()" class="black01" style="cursor:pointer;padding-left:20px; padding-right:20px;">초기화하기</a>
				<span class="ex11 pl10"> ※ 실패횟수 : ${params.n_fail_count} 회</span>
			</td>
		</tr>
		</c:if>
		<tr>
			<th>상태</th>
			<td>
				<span>
					<select class="searchsel" style="width:210px;" name="status" id="status">
						<option value="">선택</option>
		   				<c:forEach items="${statusList}" var="status_item">
		   					<option value="${status_item.s_key}" <c:if test="${hospitalInfo.s_status == status_item.s_key}">selected</c:if>>${status_item.s_value}</option>
		   				</c:forEach>
					</select>
				</span>
				<span></span>
			</td>
		</tr>
		<tr>
			<th>연락처<label class="surely">*</label></th>
			<td>
				<c:set var="tel" value="${fn:split(hospitalInfo.s_manage_tel,'-') }"/>
				<input type="text" class="txt" style="width:60px;" id="manage_tel1" name="manage_tel" maxlength="4" style="ime-mode:disabled;" value="${tel[0]}"/> 
				- <input type="text" class="txt" style="width:60px;" id="manage_tel2" name="manage_tel" maxlength="4" style="ime-mode:disabled;" value="${tel[1]}"/>
				- <input type="text" class="txt" style="width:60px;" id="manage_tel3" name="manage_tel" maxlength="4" style="ime-mode:disabled;" value="${tel[2]}"/>
				<span class="ex11 pl12" >※ 각 최대 4자리수(숫자)까지 입력 가능</span>
			</td>
		</tr>
		 <%-- <tr>
			<th>0504 전화번호</th>
			<td>
				<c:set var="s_0504_tel" value="${fn:split(params.s_0504_tel,'-') }"/>
				<input type="text" class="txt" style="width:60px;"  name="s_0504_tel" maxlength="4" style="ime-mode:disabled;" disabled value="${s_0504_tel[0]}"/> 
				- <input type="text" class="txt" style="width:60px;"  name="s_0504_tel" maxlength="4" style="ime-mode:disabled;" disabled value="${s_0504_tel[1]}"/>
				- <input type="text" class="txt" style="width:60px;"  name="s_0504_tel" maxlength="4" style="ime-mode:disabled;" disabled value="${s_0504_tel[2]}"/>
				<c:if test="${not empty params.s_0504_tel}">
		   			<a onClick="cancelOnse(true)" class="black01" style="cursor:pointer;padding-left:20px; padding-right:20px;">번호해지</a>
				</c:if>
			</td>
		</tr> --%>
		<tr>
			<th>모바일 사이트 주소<label class="surely">*</label></th>
			<td>
				<input type="text" class="txt" style="width:200px;" id="domain" name="domain" value="${hospitalInfo.s_domain}"/> 
				
			</td>
		</tr>
	</table>
	
	<h4>결제 정보 및 위치</h4>
	<table cellpadding="0" border="0" cellspacing="0" class="table_edit mb30">
		<colgroup>
			<col width="25%" /><col width="75%" />
		</colgroup>
		<tr>
			<th>사업자 등록번호</th>
			<td>
				<span><input id="corp_reg_number" name="corp_reg_number" type="text" class="txt" style="width:200px;"  value="${hospitalInfo.s_corp_reg_number }" /></span>
				<span></span>
			</td>
		</tr>
		<tr>
			<th>사업자명</th>
			<td>
				<span><input id="president" name="president" type="text" class="txt" style="width:200px;"  value="${hospitalInfo.s_president}" /></span>
				<span></span>
			</td>
		</tr>
		<tr>
			<th>거래은행</th>
			<td>
				<span>
					<select class="searchsel" style="width:210px;" name="bank" id="bank">
						<option value="">선택</option>
		   				<c:forEach items="${bankList}" var="bank_item">
		   					<option value="${bank_item.s_key}" <c:if test="${hospitalInfo.s_bank == bank_item.s_key}">selected</c:if>>${bank_item.s_value}</option>
		   				</c:forEach>
					</select>
				</span>
				<span></span>
			</td>
		</tr>
		<tr>
			<th>계좌번호</th>
			<td>
				<span><input id="account_number" name="account_number" type="text" class="txt" style="width:200px;"  value="${hospitalInfo.s_account_number}" /></span>
				<span></span>
			</td>
		</tr>
		<tr>
			<th>계좌주</th>
			<td>
				<span><input id="account_holder" name="account_holder" type="text" class="txt" style="width:200px;"  value="${hospitalInfo.s_account_holder}" /></span>
				<span></span>
			</td>
		</tr>
		 <tr>
		 <th>병원 위치<label class="surely">*</label></th>
		<td>
			<input id="old_zipcode" name="old_zipcode" type="hidden" value="${hospitalInfo.s_old_zipcode}" />
			<input id="old_addr_sido" name="old_addr_sido" type="hidden" value="${hospitalInfo.s_old_addr_sido}" />
			<input id="old_addr_sigungu" name="old_addr_sigungu" type="hidden" value="${hospitalInfo.s_old_addr_sigungu}" />
			<input id="old_addr_dong" name="old_addr_dong" type="hidden" value="${hospitalInfo.s_old_addr_dong}" />
			<input id="n_latitude" name="n_latitude" type="hidden" value="${hospitalInfo.n_latitude}" />
			<input id="n_longitude" name="n_longitude" type="hidden" value="${hospitalInfo.n_longitude}" />
			<p><input type="text" class="txt" style="width:60px;"  readonly id="old_zipcode_1" name="old_zipcode_1" value="${fn:split(hospitalInfo.s_old_zipcode, '-')[0] }"/> - 
			   <input type="text" class="txt" style="width:60px;"  readonly id="old_zipcode_2" name="old_zipcode_2"value="${fn:split(hospitalInfo.s_old_zipcode, '-')[1] }"/>
			   <a class="black01" onclick="searchZipCode()"style="cursor:pointer;">검색</a>
			 </p>
			<p class="mt05">
				<input type="text" class="txt" id="old_addr" name="old_addr" style="width:284px;"  readonly  value="${hospitalInfo.s_old_addr_sido} ${hospitalInfo.s_old_addr_gugun} ${hospitalInfo.s_old_addr_dong}"/>
				<%-- <input type="text" class="txt" id="old_addr_ri" name="old_addr_ri" style="width:150px;"  readonly  value="${params.s_addr_ri}"/> --%>
			</p>
			<p class="mt05"><input type="text" class="txt" id="old_addr_etc" name="old_addr_etc" style="width:450px;"  placeholder="상세정보 입력" value="${hospitalInfo.s_old_addr_etc}"/></p>
		</td>
		</tr>
	</table>
	
	<h4>담당자 정보</h4>
	<table cellpadding="0" border="0" cellspacing="0" class="table_edit">
		<colgroup>
			<col width="25%" /><col width="75%" />
		</colgroup>
		<tr>
			<th>담당자<label class="surely">*</label></th>
			<td>
				<span>
					<SELECT class="searchsel" style="width:190px;" name="s_team" id="s_team" onchange="selectTeam(this)">
						<option value="">선택</option>
						<c:forEach items="${adminTeamList}" var="list" varStatus="c">
							<option value="${list.s_team}" <c:if test="${hospitalInfo.s_team == list.s_team}">selected</c:if>>${list.s_team}</option>
						</c:forEach>
					</SELECT>
				</span>
				<span id="charge_sel_span">
					<jsp:include page="admin_select.jsp"/>
				</span>
			</td>
		</tr>
	</table>
	<c:if test="${not empty params.sid }">
	<div class="btn_c"><a onClick="save()" name="save" class="blueGreen" style="cursor:pointer;padding-left:20px; padding-right:20px;">수정</a></div>
	</c:if>
	 <c:if test="${empty params.sid }">
	<div class="btn_c"><a onClick="save()" name="save" class="blueGreen" style="cursor:pointer;padding-left:20px; padding-right:20px;">등록</a></div>
	</c:if>
</div>
</form>