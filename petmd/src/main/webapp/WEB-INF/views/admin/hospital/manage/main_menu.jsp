<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<jsp:include page="../include/total_header.jsp"/>

<script src="${con.JSPATH}/jquery.form.js"></script>
<jsp:include page="/common/include/js_ajaxfileuploader.jsp"/>

<c:set var="pre_data" value="${pre_data}/${hospitalInfo.s_company_name}"/>
<c:set var="pre_data" value="${pre_data}/${hospitalInfo.s_corp_reg_number}"/>
<c:set var="pre_data" value="${pre_data}/${hospitalInfo.s_president}"/>
<c:set var="pre_data" value="${pre_data}/${hospitalInfo.s_email}"/>
<c:set var="fax" value="${fn:split(hospitalInfo.s_fax,'-')}"/>
<c:set var="pre_data" value="${pre_data}/${fax[0]}${fax[1]}${fax[2]}"/>
<c:forEach var="item" items="${mainMenu}">
<c:set var="pre_data" value="${pre_data}/${item.s_name}${item.s_status}"/>
</c:forEach>
<c:set var="pre_data" value="${pre_data}/${logo_img.s_iid}"/>
<c:set var="pre_data" value="${pre_data}/${header_img.s_iid}"/>

<script>

function checkbox(me,targetId){
	
	if($(me).is(':checked'))
		$('#'+targetId).val('Y');
	else
		$('#'+targetId).val('N');
}

function saveInfo(){
	
	if(isNoValue($('#form [name="company_name"]'))){
		alert("법인(상호)명을 입력하세요.");
		return;
	}
	if(isNoValue($('#form [name="corp_reg_number"]'))){
		alert("사업자등록번호를 입력하세요.");
		return;
	}
	if(isNoValue($('#form [name="president"]'))){
		alert("대표자를 입력하세요.");
		return;
	}
	
	$.ajax({
		url:'ajaxSaveManageMainInfo.latte',
		type:'POST',
		data:$('#form').serialize()+"&logo_id="+$('#logo_id').val()+"&header_id="+$('#header_id').val(),
		dataType:'json',
		success:function(response, status, xhr){
						
			if(response.result=='${codes.SUCCESS_CODE}'){
				$('#bid').val(response.bid);
				showDialog('처리되었습니다.','default');
			}
		},
		error:function(xhr,status,error){
			alert(status+'\n'+error);
		}
	});
}

var pre_data = "${pre_data}";
var new_data = '';

function cancel(){
	
	new_data = '';
	
	new_data += '/'+$('#form [name="company_name"]').val();
	new_data += '/'+$('#form [name="corp_reg_number"]').val();
	new_data += '/'+$('#form [name="president"]').val();
	new_data += '/'+$('#form [name="email"]').val();
	new_data += '/'+$('#form #fax1').val()+$('#form #fax2').val()+$('#form #fax3').val();
	
	var main_menu = $("#main_menu dl");
	var len = $(main_menu).length;
	
	for(var i = 0; i < len; i++){
		
		new_data+="/";
		new_data+=$(main_menu[i]).find('[name="name"]').val();
		new_data+=$(main_menu[i]).find('[name="status"]').val();
	}
	
	new_data += '/'+$('#logo_id').val();
	new_data += '/'+$('#header_id').val();
	
	if(pre_data!=new_data && !confirm('변경된 내용이 있습니다.\n작성을 취소하시겠습니까?')){
		return;
	}
	
	goPage('hospitalHome.latte');
}

function imageUpdate(targetId,imgsrc,iid){
	
	$('#'+targetId+"img").attr('src',imgsrc);
	$('#'+targetId+"id").val(iid);
}

var jcropCore = null;

function imageUploadSuccess(response,data){
	
	var map = $.parseJSON(response);
	
	if(map.result=='${codes.ERROR_UNSUPPORTED_IMAGE}'){
		alert('지원하지 않는 파일입니다.');
		closeDialog();
		return;
	}
	else if(map.result!='${codes.SUCCESS_CODE}'){
		alert('저장에 실패했습니다.');
		closeDialog();
		return;
	}
	
	jcropCore.openCropLayer(map);
	
	closeDialog();
}

$(document).ready(function(){
	
	jcropCore = new JcropCore();
	
	new AjaxFileUploader2('logo_img_btn',{
		click:function(){
			showDialog('이미지를 업로드 하고 있습니다.');
			jcropCore.setTargetTagId('logo_');
		},
		url:'ajaxLogoImgUpload.latte',
		success:imageUploadSuccess,
		error:function(){closeDialog();}
	});
	
	new AjaxFileUploader2('header_img_btn',{
		click:function(){
			showDialog('이미지를 업로드 하고 있습니다.');
			jcropCore.setTargetTagId('header_');
		},
		url:'ajaxHeaderImgUpload.latte',
		success:imageUploadSuccess,
		error:function(){closeDialog();}
	});
	
	setInputConstraint('phoneNumber','fax1',4);
	setInputConstraint('phoneNumber','fax2',4);
	setInputConstraint('phoneNumber','fax3',4);
});

</script>
</head>

<body>
		
	<div data-role="page">
	
		<jsp:include page="/common/admin/hospital/INC_IMAGE_CROP2.jsp"></jsp:include>
		<jsp:include page="/common/admin/hospital/INC_INSTANCE_DIALOG.jsp"/>
		
		<jsp:include page="../include/manage_title_bar.jsp">
			<jsp:param name="title_bar_title" value="메인메뉴편집"/>
			<jsp:param name="title_btn_icon" value="home"/>
			<jsp:param name="back_function" value="cancel"/>
		</jsp:include>
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
		
			<!-- 메인메뉴 tab -->
			<jsp:include page="../include/manage_menu.jsp">
				<jsp:param value="1" name="cur_manage_menu"/>
			</jsp:include>
			<!-- // tab 끝-->
			
			<div class="a_type02_b">
				<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />병원 로고</h3>
				<input type="hidden" id="logo_id" value="${logo_img.s_iid}"/>
				<div class="dl_type01 mt05">
					<dl style="height:81px;">
						<dd style="margin:0 0 0 90px;">
						<p id="logo_img_btn" class="btn_gray02" style="width:120px; position:relative; overflow:hidden;"><a id="pppp2" data-role="button">찾아보기</a>
						</dd>
						<dd style="margin:5px 0 0 90px;">* 로고 권장사이즈 : 158px * 158px</dd>
						<dd class="thum02"><img id="logo_img" src="<c:choose><c:when test="${not empty logo_img.s_image_path}">${con.img_dns}${logo_img.s_image_path}</c:when><c:otherwise>${con.IMGPATH}/contents/sample_logo02.png</c:otherwise></c:choose>" alt="" width="79" height="79"/></dd>
					</dl>
				</div>
			</div>
			
			<div class="a_type02_b">
				<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />상단이미지</h3>
				<input type="hidden" id="header_id" value="${header_img.s_iid}"/>
				<div class="dl_type01 mt05">
					<dl style=" min-height:70px;">
						<dd style="margin:0 0 0 130px;">
							<p class="btn_gray02" id="header_img_btn" style="width:100px; display:inline-block;"><a data-role="button">찾아보기</a>
							<p class="btn_gray02" style="width:50px; display:inline-block; margin-left:4px;"><a href="index.html" data-role="button">삭제</a>
						</dd>
						<dd style="margin:5px 0 0 130px;">*이미지 권장사이즈 : 800px * 450px</dd>
						<dd style="margin:5px 0 0 130px;">*이미지를 등록하지 않으시면, 기본으로 제공되는 이미지가 등록됩니다.</dd>
						<dd class="thum03"><img id="header_img" src="<c:choose><c:when test="${not empty header_img.s_image_path}">${con.img_dns}${header_img.s_image_path}</c:when><c:otherwise>${con.IMGPATH}/common/default_header.jpg</c:otherwise></c:choose>" alt="" width="120" height="68"/></dd>
					</dl>
				</div>
			</div>
			
			<form id="form">
			
			<!-- 메인메뉴 이름편집 -->
			<div class="a_type02_b">
				<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />메인메뉴 이름편집</h3>
				<div id="main_menu" class="dl_type01 mt05">
					<c:forEach var="item" items="${mainMenu}" varStatus="c">
					<input type="hidden" name="cmid" value="${item.s_cmid}"/>
					<dl<c:if test="${c.count ne 1}"> class="mt10"</c:if>>
						<dt>${c.count}번메뉴</dt>
						<dd style="margin:0 80px 0 80px;"><p class="input01"><input type="text" name="name" value="${item.s_name}"></p></dd>
						<dd style="margin:5px 0 0 80px;">*${item.attr_description}</dd>
						<dd class="abs_rt" style="width:75px; top:6px;">
							<p class="checkbox">
								<input type="hidden" id="status${c.index}" name="status" value="${item.s_status}"/>
								<input type="checkbox" id="checkbox-c${c.count}" value="c-${c.count}" onclick="checkbox(this,'status${c.index}');" <c:if test="${item.s_status eq 'Y'}">checked="checked"</c:if>/>
								<label for="checkbox-c${c.count}">사용함</label>
							</p>
						</dd>
					</dl>
					</c:forEach>
				</div>
			</div>
			
			<!-- 사이트 기본정보 -->
			<div class="a_type02">
				<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />사이트 기본정보 <span class="txt_gray11"><label class="orange">* </label>는 필수입력 사항입니다.</span></h3>
				
				<h4 class="mt10"><span class="orange">* </span>법인(상호)명</h4>
				<p class="input01"><input type="text" name="company_name" value="${hospitalInfo.s_company_name}"></p>
				
				<h4 class="mt10"><span class="orange">* </span>사업자등록번호</h4>
				<p class="input01"><input type="text" name="corp_reg_number" value="${hospitalInfo.s_corp_reg_number}"></p>
				
				<h4 class="mt10"><span class="orange">* </span>대표자</h4>
				<p class="input01"><input type="text" name="president" value="${hospitalInfo.s_president}"></p>
				
				<h4 class="mt10">이메일</h4>
				<p class="input01"><input type="text" name="email" value="${hospitalInfo.s_email}"></p>
				
				<h4 class="mt10">FAX</h4>
				<c:set var="fax" value="${fn:split(hospitalInfo.s_fax,'-')}"/>
				<div class="area00">
					<p class="input01" style="display:inline-block; width:20%;"><input type="text" id="fax1" name="fax" value="${fax[0]}"></p> -
					<p class="input01" style="display:inline-block; width:20%;"><input type="text" id="fax2" name="fax" value="${fax[1]}"></p> -
					<p class="input01" style="display:inline-block; width:20%;"><input type="text" id="fax3" name="fax" value="${fax[2]}"></p>
				</div>
				<p class="txt_gray11 mt05">*숫자만 입력이 가능합니다.</p>
			</div>
			
			</form>
			
			<div class="btn_area03">
				<p class="btn_black02 btn_l" style="width:100px;"><a onclick="cancel();" data-role="button">취소</a></p>
				<p class="btn_red02" style="margin-left:104px;"><a onclick="saveInfo();" data-role="button">저장</a></p>
			</div>
			
		</div>
		
		<jsp:include page="../include/simple_copyright.jsp"/>
	
	</div>
	
</body>
</html>