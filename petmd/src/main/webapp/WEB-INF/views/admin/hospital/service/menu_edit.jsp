<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../include/total_header.jsp"/>

<c:forEach var="item" items="${menuList}" varStatus="c">
<c:set var="pre_data" value="${pre_data}/${item.s_name}"/>
</c:forEach>

<script>

var menuLen = parseInt("${fn:length(menuList)}");

function addMenu(){
	
	var tag = ''
	+'<div id="menu'+menuLen+'" class="area00" style="padding:0 105px 0 0; margin-bottom:5px;">'
		+'<p class="input01"><input type="text" name="name"></p>'
		+'<input type="hidden" name="cmid" value="${item.s_cmid}"/>'
		+'<input type="hidden" name="status" value="${item.s_status}"/>'
		+'<input type="hidden" id="menuIndex'+menuLen+'" name="index" value="${item.n_index}"/>'
		+'<p class="btn_admin01 abs_r01"><a onclick="removeMenu(\'menu'+menuLen+'\')" data-role="button"><img src="${con.IMGPATH}/btn/btn_d.png" alt="" width="31" height="31" /></a></p>'
		+'<p class="btn_admin01 abs_r02"><a onclick="upMenu(\'menu'+menuLen+'\')" data-role="button"><img src="${con.IMGPATH}/btn/btn_t.png" alt="" width="31" height="31" /></a></p>'
		+'<p class="btn_admin01 abs_r03"><a onclick="downMenu(\'menu'+menuLen+'\')" data-role="button"><img src="${con.IMGPATH}/btn/btn_b.png" alt="" width="31" height="31" /></a></p>'
	+'</div>';
	
	$('#menuDiv').append($(tag));
	
	$('#menuDiv').trigger('create');

	menuLen++;
}

function removeMenu(id){
	
	if(($('#'+id).find('#content_cnt').val()>0 || $('#'+id).find('#sub_cnt').val()>0)
			&& !confirm('소속된 콘텐츠가 있습니다. \n'
					+'삭제 시 소속된 콘텐츠는 모두 미분류 항목으로 이동됩니다. 정말 삭제하시겠습니까?'))
		return;
	
	var list = $('#menuDiv').find('div');
	
	for(var i = 0; i < list.length; i++){
		
		//console.log($(list[i]).attr('id')+" , "+id);
		if($(list[i]).attr('id')==id){
			$(list[i]).remove();
			break;
		}
	}
}

function upMenu(id){
	
	var list = $('#menuDiv').find('div');
	
	for(var i = 1; i < list.length; i++){
		if($(list[i]).attr('id')==id){
			var d = $(list[i]).detach();
			d.insertBefore($(list[i-1]));
			break;
		}
	}
}

function downMenu(id){
	
	var list = $('#menuDiv').find('div');
	
	for(var i = 0; i < list.length-1; i++){
		if($(list[i]).attr('id')==id){
			var d = $(list[i]).detach();
			d.insertAfter($(list[i+1]));
			break;
		}
	}
}

function saveMenu(){
	
	$.ajax({
		type:"POST",
		url:'ajaxServiceMenuEdit.latte',
		data:$('#menuForm').serialize(),
		dataType:'text',
		success:function(response, status, xhr){
			
			var json = $.parseJSON(response);
			
			if(json.result=='${codes.SUCCESS_CODE}'){
				alert("처리되었습니다.");
				document.location.reload();
			}
			else{
				alert('문제가 발생했습니다. code : '+json.result);
			}
		},
		error:function(xhr, status, error){
			
			alert(status+","+error);
		}
	});
}

var pre_data = '${pre_data}';
var new_data = '';

function cancel(){
	
	var len = $('#menuDiv > div').length;
	
	new_data = '';
	
	for(var i = 0; i < len; i++){
		
		new_data+="/";
		new_data+=$($('#menuDiv > div')[i]).find("[name='name']").val();
	}
	
	if(pre_data!=new_data && !confirm('변경된 내용이 있습니다.\n작성을 취소하시겠습니까?'))
		return;
	
	history.back();
}

</script>
</head>
<body>
		
	<div data-role="page">
			
		<jsp:include page="../include/main_header.jsp"/>
		<jsp:include page="../include/main_title_bar.jsp"><jsp:param name="back_function" value="cancel"/></jsp:include>
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
			
			<!-- 메인메뉴 tab -->
			<jsp:include page="../include/main_menu.jsp"/>
			
			<form id="menuForm">
			
			<!--진료/서비스 메뉴 관리 시작-->
			<h3 class="ma15"><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />진료/서비스 메뉴 관리</h3>
			
			<input name="parent" type="hidden" value="${parent}"/>
			
			<div id="menuDiv" class="a_type01" style="padding:5px 15px 0 15px;">
				<c:forEach var="item" items="${menuList}" varStatus="c">
				<div id="menu${c.index}" class="area00" style="padding:0 105px 0 0; margin-bottom:5px;">
					<p class="input01"><input type="text" name="name" value="${item.s_name}"></p>
					<input type="hidden" name="cmid" value="${item.s_cmid}"/>
					<input type="hidden" name="status" value="${item.s_status}"/>
					<input type="hidden" id="content_cnt" value="${item.content_cnt}"/>
					<input type="hidden" id="sub_cnt" value="${item.sub_cnt}"/>
					<input type="hidden" id="menuIndex${c.index}" name="index" value="${item.n_index}"/>
					<p class="btn_admin01 abs_r01"><a onclick="removeMenu('menu${c.index}')" data-role="button"><img src="${con.IMGPATH}/btn/btn_d.png" alt="" width="31" height="31" /></a></p>
					<p class="btn_admin01 abs_r02"><a onclick="upMenu('menu${c.index}')" data-role="button"><img src="${con.IMGPATH}/btn/btn_t.png" alt="" width="31" height="31" /></a></p>
					<p class="btn_admin01 abs_r03"><a onclick="downMenu('menu${c.index}')" data-role="button"><img src="${con.IMGPATH}/btn/btn_b.png" alt="" width="31" height="31" /></a></p>
				</div>
				</c:forEach>
			</div>
			<!--//진료/서비스 메뉴 관리 끝-->
			
			</form>
			
			<!-- 추가영역 버튼 -->
			<div class="btn_area">
				<p class="btn_gray02" style="width:50%"><a onclick="addMenu();" data-role="button">분류 추가</a></p>
			</div>
			<!-- //추가영역 버튼 끝-->
			
			<div class="btn_area03">
				<p class="btn_black02 btn_l" style="width:100px;"><a onclick="cancel();" data-role="button">취소</a></p>
				<p class="btn_red02" style="margin-left:104px;"><a onclick="saveMenu();" data-role="button">저장</a></p>
			</div>
			
		</div>
		<!-- ///// content 끝-->
		
		<jsp:include page="../include/simple_copyright.jsp"/>

		<!-- footer 시작-->
		<jsp:include page="/common/admin/hospital/INC_JSP_FOOTER.jsp" />
		<!-- ///// footer 끝-->

	</div>
	
	

</body>
</html>