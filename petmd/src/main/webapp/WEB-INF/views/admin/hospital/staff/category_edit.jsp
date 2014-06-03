<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../include/total_header.jsp"/>

<c:forEach var="item" items="${staffMenu}" varStatus="c">
<c:set var="pre_data" value="${pre_data}/${item.s_cmid}${item.s_name}"/>
</c:forEach>

<script>

var itemCnt = parseInt("${fn:length(staffMenu)}");

function upSub(id){
	
	var list = $('#staff_list > div');
	var d;
	
	for(var i = 1; i < list.length; i++){
		if($(list[i]).attr('id')==id){
			d = $(list[i]).detach();
			d.insertBefore($(list[i-1]));
			break;
		}
	}
}

function downSub(id){
	
	var list = $('#staff_list > div');
	var d;
	
	for(var i = 0; i < list.length-1; i++){
		if($(list[i]).attr('id')==id){
			d = $(list[i]).detach();
			d.insertAfter($(list[i+1]));
			break;
		}
	}
}

function addItem(){
	
	var $div = $.createElementJson(
			{
				tagName:"div",id:"item"+itemCnt,cls:"area00",style:"padding:0 105px 0 0; margin-bottom:5px;",children:
				[
				{
					tagName:"input",type:"hidden",name:"cmid"
				},
				{
					tagName:"p",cls:"input01",child:
					{
						tagName:"input",type:"text",name:"name",placeholder:"이름을 입력하세요."
					}
				},
				{
					tagName:"p",cls:"btn_admin01 abs_r01",child:
					{
						tagName:"a",onclick:"removeItem('item"+itemCnt+"');",dataRole:"button",child:
						{	tagName:"img",src:"${con.IMGPATH}/btn/btn_d.png",alt:"",width:"31",height:"31"}
					}
				},
				{
					tagName:"p",cls:"btn_admin01 abs_r02",child:
					{
						tagName:"a",onclick:"upSub('item"+itemCnt+"');",dataRole:"button",child:
						{	tagName:"img",src:"${con.IMGPATH}/btn/btn_t.png",alt:"",width:"31",height:"31"}
					}
				},
				{
					tagName:"p",cls:"btn_admin01 abs_r03",child:
					{
						tagName:"a",onclick:"downSub('item"+itemCnt+"');",dataRole:"button",child:
						{	tagName:"img",src:"${con.IMGPATH}/btn/btn_b.png",alt:"",width:"31",height:"31"}
					}
				}
				]
			}
	);
	
	/* var $div = $('<div id="item'+itemCnt+'" style="overflow:hidden; padding:10px;">'
		+'<input type="hidden" name="cmid"/>'
		+'<div style="float:left; width:50%;">'
			+'<input type="text" name="name" style="border:1px solid gray; color:gray;"/>'
		+'</div>'
		+'<div style="float:right;"><a data-role="button" onclick="removeItem(\'item'+itemCnt+'\')" style="padding:10px;">삭제</a></div>'
		+'<div style="float:right;"><a data-role="button" onclick="downSub(\'item'+itemCnt+'\')" style="padding:10px;">▼</a></div>'
		+'<div style="float:right;"><a data-role="button" onclick="upSub(\'item'+itemCnt+'\')" style="padding:10px;">▲</a></div>'
	+'</div>'); */
	
	itemCnt++;
	
	$('#staff_list').append($div);
	$('#staff_list').trigger('create');
}

function removeItem(id){
	
	if($('#'+id).find('#staff_cnt').val()>0
			&& !confirm('소속된 콘텐츠가 있습니다. \n'
					+'삭제 시 소속된 콘텐츠는 모두 미분류 항목으로 이동됩니다. 정말 삭제하시겠습니까?'))
		return;
	
	$('#'+id).remove();
}

function saveInfo(){
	
	/* if(!confirm('내용을 저장하시겠습니까?'))
		return; */
	
	$.ajax({
		type:'POST',
		url:'ajaxSaveStaffCategory.latte',
		data:$('#dataForm').serialize(),
		dataType:'json',
		success:function(response,status,xhr){
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				showDialog('저장이 완료되었습니다.','default');
			}
			else
				showDialog('저장 중 오류가 발생하였습니다.','default');
		},
		error:function(xhr,status,error){
			
			alert("실패하였습니다.\n"+status+"\n"+error);
		}
	});
}

var pre_data = '${pre_data}';
var new_data = '';

function cancel(){
	
	var len = $('#staff_list > div').length;
	
	new_data = '';
	
	for(var i = 0; i < len; i++){
		
		new_data+="/";
		new_data+=$($('#staff_list > div')[i]).find("[name='cmid']").val();
		new_data+=$($('#staff_list > div')[i]).find("[name='name']").val();
	}
	
	if(pre_data!=new_data && !confirm('변경된 내용이 있습니다.\n작성을 취소하시겠습니까?')){
		return;
	}
	
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
			
			<form id="dataForm">
			<!--의료진 관리  -->
			<h3 class="ma15"><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />의료진/스탭 메뉴 관리</h3>
			<div class="a_type01" id="staff_list" style="padding:5px 15px 0 15px;">
				<c:forEach var="item" items="${staffMenu}" varStatus="c">
				<div id="item${c.index}" class="area00" style="padding:0 105px 0 0; margin-bottom:5px;">
					<input type="hidden" name="cmid" value="${item.s_cmid}"/>
					<input type="hidden" id="staff_cnt" value="${item.staff_cnt}"/>
					<p class="input01"><input type="text" name="name" placeholder="이름을 입력하세요." value="${item.s_name}"></p>
					<p class="btn_admin01 abs_r01"><a onclick="removeItem('item${c.index}')" data-role="button"><img src="${con.IMGPATH}/btn/btn_d.png" alt="" width="31" height="31" /></a></p>
					<p class="btn_admin01 abs_r02"><a onclick="upSub('item${c.index}')" data-role="button"><img src="${con.IMGPATH}/btn/btn_t.png" alt="" width="31" height="31" /></a></p>
					<p class="btn_admin01 abs_r03"><a onclick="downSub('item${c.index}')" data-role="button"><img src="${con.IMGPATH}/btn/btn_b.png" alt="" width="31" height="31" /></a></p>
				</div>
				</c:forEach>
			</div>
			</form>
			
			<!-- 추가영역 버튼 -->
			<div class="btn_area">
				<p class="btn_gray02" style="width:50%"><a onclick="addItem();" data-role="button">스탭 분류 추가</a></p>
			</div>
			<!-- //추가영역 버튼 끝-->
			
			<div class="btn_area03">
				<p class="btn_black02 btn_l" style="width:100px;"><a onclick="cancel();" data-role="button">취소</a></p>
				<p class="btn_red02" style="margin-left:104px;"><a onclick="saveInfo();" data-role="button">저장</a></p>
			</div>
			
		</div>
		
		<jsp:include page="../home/copyright.jsp"/>
	</div>
</body>
</html>