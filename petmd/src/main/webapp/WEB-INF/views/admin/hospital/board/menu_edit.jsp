<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../include/total_header.jsp" />

<c:forEach var="item" items="${menuList}" varStatus="c">
<c:set var="pre_data" value="${pre_data}/${item.s_name}${item.s_group}${item.attr_url}"/>
</c:forEach>

<c:set var="init_data" value='['/>
<c:forEach var="item" items="${menuList}" varStatus="c">
<c:set var="init_data" value='${init_data}{\"index\":\"menu${c.index}\",\"group\":\"${item.s_group}\"}'/>
<c:if test="${not c.last}"><c:set var="init_data" value='${init_data},'/></c:if>
</c:forEach>
<c:set var="init_data" value="${init_data}]"/>

<script>

var menuLen = parseInt("${fn:length(menuList)}");

var boardTypeOptions = '';
<c:forEach var="bt_it" items="${board_type}">
boardTypeOptions+='<option value="${bt_it.s_key}">${bt_it.s_value}</option>';
</c:forEach>

function addMenu(){
	
	var tag = '';
	
	+'<div class="a_type02_b" id="menu'+menuLen+'">'
		+'<input name="cmid" type="hidden"/>'
		+'<input name="status" type="hidden" value="Y"/>'
		+'<p class="input01"><input type="text" name="name" placeholder="메뉴 이름을 입력하세요."></p>'
		+'<p class="input01 mt05" id="rssurl"><input type="text" name="rssurl" placeholder="RSS 주소를 입력 해 주세요."></p>'
		+'<div class="area00 mt05" style="padding:0 105px 0 0; margin-bottom:5px;">'
			+'<div class="btn_select">'
				+'<a data-role="button" >'
				+'<select name="group" onchange="changeType(\'menu'+menuLen+'\',$(this).val())" data-icon="false">'
				+boardTypeOptions
				+'</select>'
				+'</a>'
				+'<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>'
			+'</div>'
			+'<p class="btn_admin01 abs_r01"><a onclick="removeMenu(\'menu'+menuLen+'\');" data-role="button"><img src="${con.IMGPATH}/btn/btn_d.png" alt="" width="31" height="31" /></a></p>'
			+'<p class="btn_admin01 abs_r02"><a onclick="upMenu(\'menu'+menuLen+'\');" data-role="button"><img src="${con.IMGPATH}/btn/btn_t.png" alt="" width="31" height="31" /></a></p>'
			+'<p class="btn_admin01 abs_r03"><a onclick="downMenu(\'menu'+menuLen+'\');" data-role="button"><img src="${con.IMGPATH}/btn/btn_b.png" alt="" width="31" height="31" /></a></p>'
		+'</div>'
		+'<p class="checkbox">'
			+'<input type="hidden" id="visible'+menuLen+'" name="visible" value="Y">'
			+'<input type="checkbox" id="checkbox-c'+(menuLen+1)+'" value="c-'+(menuLen+1)+'" onclick="checkbox(this,"visible'+menuLen+'");" checked="checked"/>'
			+'<label for="checkbox-c'+(menuLen+1)+'">공개 (비공개 처리 시 유저에게 노출되지 않습니다.)</label>'
		+'</p>'
	+'</div>'
	
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
	
	var $next = $('#'+id).prev('div');
	var $d = $('#'+id).detach();
	$d.insertBefore($next);
}

function changeType(id, type){
	
	if(type=='${codes.CUSTOM_BOARD_TYPE_RSS}'){
		
		$('#'+id).find('#rssurl').show();
	}
	else{
		
		$('#'+id).find('#rssurl').hide();
	}
}

function downMenu(id){
	
	var $next = null;
	//if(type=='next'){
		$next = $('#'+id).next('div');
	var $d = $('#'+id).detach();
	$d.insertAfter($next);
}

function saveMenu(){
	
	$.ajax({
		type:"POST",
		url:'ajaxBoardMenuEdit.latte',
		data:$('#menuForm').serialize(),
		dataType:'text',
		success:function(response, status, xhr){
			
			var json = $.parseJSON(response);
			
			if(json.result=="${codes.SUCCESS_CODE}"){
				
				alert('처리되었습니다.');
				document.location.reload();
			}else{
				
				alert('처리도중 문제가 발생했습니다.\ncode : '+json.result);
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
		new_data+=$($('#menuDiv > div')[i]).find("[name='group']").val();
		new_data+=$($('#menuDiv > div')[i]).find("[name='rssurl']").val();
	}
	
	if(pre_data!=new_data && !confirm('변경된 내용이 있습니다.\n작성을 취소하시겠습니까?'))
		return;
	
	history.back();
}

function checkbox(me,targetId){
	
	if($(me).is(':checked'))
		$('#'+targetId).val('Y');
	else
		$('#'+targetId).val('N');
}

$(document).ready(function(){
	
	var json = $.parseJSON('${init_data}');
	for(var i = 0; i < json.length; i++){
		changeType(json[i].index,json[i].group);
	}
});

</script>
</head>
<body>
		
	<div data-role="page" >
			
		<jsp:include page="../include/main_title_bar.jsp"><jsp:param name="back_function" value="cancel"/></jsp:include>
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
			
			<!-- 메인메뉴 tab -->
			<jsp:include page="../include/main_menu.jsp"/>
			
			<form id="menuForm">
			
			<div id="menuDiv">
			<c:forEach var="item" items="${menuList}" varStatus="c">
				<%-- <div id="menu${c.index}">${item.BOARD_TYPE}
				<input name="value" type="text" value="${item.s_value}" style="width:100px; display:inline-block;"/>
				<span>&nbsp;<a onclick="removeMenu('menu${c.index}')" style="color:red;">삭제</a></span>&nbsp;<a onclick="upMenu('menu${c.index}')">▲</a>&nbsp;<a onclick="downMenu('menu${c.index}')">▼</a><br/>
				<c:if test="${item.BOARD_TYPE eq codes.CUSTOM_BOARD_TYPE_RSS}">
				<div>
					<input type="text" value="${item.URL}"/>
				</div>
				</c:if>
				<input name="cmid" type="hidden" value="${item.s_cmid}"/>
				<input name="parent" type="hidden" value="MENU3"/>
				<input name="status" type="hidden" value="${item.s_status}"/>
				<input id="menuIndex${c.index}" name="index" type="hidden" value="${item.n_index}"/>
				</div> --%>
				
				<div class="a_type02_b" id="menu${c.index}">
					<input name="cmid" type="hidden" value="${item.s_cmid}"/>
					<input name="status" type="hidden" value="${item.s_status}"/>
					<input id="content_cnt" type="hidden" value="${item.content_cnt}"/>
					<input id="sub_cnt" type="hidden" value="${item.sub_cnt}"/>
					<p class="input01"><input type="text" name="name" placeholder="메뉴 이름을 입력하세요." value="${item.s_name}"></p>
					<p class="input01 mt05" id="rssurl"><input type="text" name="rssurl" placeholder="RSS 주소를 입력 해 주세요." value="${item.attr_url}"></p>
					<div class="area00 mt05" style="padding:0 105px 0 0; margin-bottom:5px;">
						<div class="btn_select">
							<a data-role="button" >
							<select name="group" onchange="changeType('menu${c.index}',$(this).val())" data-icon="false">
								<c:forEach var="bt_it" items="${board_type}">
								<option value="${bt_it.s_key}" <c:if test="${bt_it.s_key eq item.s_group}">selected="selected"</c:if>>${bt_it.s_value}</option>
								</c:forEach>
							</select>
							</a>
							<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
						</div>
						<p class="btn_admin01 abs_r01"><a onclick="removeMenu('menu${c.index}');" data-role="button"><img src="${con.IMGPATH}/btn/btn_d.png" alt="" width="31" height="31" /></a></p>
						<p class="btn_admin01 abs_r02"><a onclick="upMenu('menu${c.index}');" data-role="button"><img src="${con.IMGPATH}/btn/btn_t.png" alt="" width="31" height="31" /></a></p>
						<p class="btn_admin01 abs_r03"><a onclick="downMenu('menu${c.index}');" data-role="button"><img src="${con.IMGPATH}/btn/btn_b.png" alt="" width="31" height="31" /></a></p>
					</div>
					<p class="checkbox">
						<input type="hidden" id="visible${c.index}" name="visible" value='<c:choose><c:when test="${item.s_visible ne 'Y'}">N</c:when><c:otherwise>${item.s_visible}</c:otherwise></c:choose>'>
						<input type="checkbox" id="checkbox-c${c.count}" value="c-${c.count}" onclick="checkbox(this,'visible${c.index}');" <c:if test="${item.s_visible eq 'Y'}">checked="checked"</c:if>/>
						<label for="checkbox-c${c.count}">공개 (비공개 처리 시 유저에게 노출되지 않습니다.)</label>
					</p>
				</div>
				
				<%-- <div>

					<div style="overflow:hidden;">
						<div style="float:left;">
							<input name="name" type="text" value="${item.s_name}" style="width:100px; display:inline-block;"/>
						</div>
						<div style="float:left; width:30%">
							<select name="group" onchange="changeType('menu${c.index}',$(this).val())">
								<c:forEach var="bt_it" items="${board_type}">
								<option value="${bt_it.s_key}" <c:if test="${bt_it.s_key eq item.s_group}">selected="selected"</c:if>>${bt_it.s_value}</option>
								</c:forEach>
							</select>
						</div>
						<div style="float:right;"><a data-role="button" onclick="removeMenu('menu${c.index}');" style="padding:10px;">삭제</a></div>
						<div style="float:right;"><a data-role="button" onclick="downMenu('menu${c.index}');" style="padding:10px;">▼</a></div>
						<div style="float:right;"><a data-role="button" onclick="upMenu('menu${c.index}');" style="padding:10px;">▲</a></div>
					</div>
					<input name="cmid" type="hidden" value="${item.s_cmid}"/>
					<input name="status" type="hidden" value="${item.s_status}"/>
					<input id="content_cnt" type="hidden" value="${item.content_cnt}"/>
					<input id="sub_cnt" type="hidden" value="${item.sub_cnt}"/>
					<div id="rssurl">
						<input type="text" name="rssurl" value="${item.attr_url}"/>
					</div>
					<div style="overflow:hidden; padding:10px;">
						
						<div style="float:left; height:20px;width:20px;"><input type="checkbox" id="visible_chk${c.index}" onclick="checkbox(this,'visible${c.index}');" style="margin-top:5px;" <c:if test="${item.s_visible eq 'Y'}">checked="checked"</c:if>/></div>
						<p style="float:left">공개 (비공개 처리시 유저에게 노출되지 않습니다.)</p>
					</div>
					
					<!-- <script>
					changeType('menu${c.index}','${item.s_group}');
					</script> -->
					
				</div> --%>
			</c:forEach>
			</div>
			
			</form>
			
			<!-- 추가영역 버튼 -->
			<div class="btn_area">
				<p class="btn_gray02" style="width:50%"><a onclick="addMenu();" data-role="button">메뉴 추가</a></p>
			</div>
			<!-- //추가영역 버튼 끝-->
			
			<div class="btn_area03">
				<p class="btn_black02 btn_l" style="width:100px;"><a onclick="cancel();" data-role="button">취소</a></p>
				<p class="btn_red02" style="margin-left:104px;"><a onclick="saveMenu();" data-role="button">저장</a></p>
			</div>
			
			<!-- <a style="color:red;">추가</a>
			
			<hr/>
			
			<div>
				<div style="float:left; padding:10px;"><a data-role="button" style="padding:10px;">취소</a></div>
				<div style="float:left; padding:10px;"><a data-role="button" style="padding:10px;">저장</a></div>
			</div> -->
			
		</div>
		<!-- ///// content 끝-->
		

		<!-- footer 시작-->
		<jsp:include page="/common/admin/hospital/INC_JSP_FOOTER.jsp" />
		<!-- ///// footer 끝-->

	</div>
	
	

</body>
</html>