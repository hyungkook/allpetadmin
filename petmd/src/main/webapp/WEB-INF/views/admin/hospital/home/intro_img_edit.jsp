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
<jsp:include page="/WEB-INF/views/admin/hospital/include/total_header.jsp"/>

<script src="${con.JSPATH}/jquery.form.js"></script>
<jsp:include page="/common/include/js_ajaxfileuploader.jsp"/>

<c:forEach var="item" items="${introImageList}" varStatus="c">
<c:set var="pre_data" value="${pre_data}/${item.s_iid}"/>
</c:forEach>

<script>

var count = parseInt("${fn:length(introImageList)}");
var index = count;

function upSub(id){
	
	var list = $('#imgList [valid-key="img_list"]');
	
	for(var i = 1; i < list.length; i++){
		if($(list[i]).attr('id')==id){
			var d = $(list[i]).detach();
			d.insertBefore($(list[i-1]));
			break;
		}
	}
}

function downSub(id){
	
	var list = $('#imgList [valid-key="img_list"]');
	
	for(var i = 0; i < list.length-1; i++){
		if($(list[i]).attr('id')==id){
			var d = $(list[i]).detach();
			d.insertAfter($(list[i+1]));
			break;
		}
	}
}

function deleteItem(id){
	
	$('#'+id).remove();
	
	if($('#imgList [valid-key="img_list"]').length<12){
		$('#add_area').show();
	}
}

function saveImg(){
	
	var f = $('<form/>');
	f.append($('#imgList [valid-key="img_list"]').clone());
	
	$.ajax({
		url:'ajaxSaveIntroduceImg.latte',
		type:'POST',
		data:f.serialize(),
		dataType:'json',
		success:function(response,status,xhr){
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				showDialog('저장이 완료되었습니다.',1000,function(){
					history.back();
				});
			}
			else
				showDialog('저장 중 오류가 발생하였습니다.',1000);
		},
		error:function(xhr,status,error){
			alert(status+"|\n"+error);
		}
	});
}

var pre_data = '${pre_data}';
var new_data = '';

function cancelEdit(){
	
	var len = $('#imgList [valid-key="img_list"]').length;
	
	new_data = '';
	
	for(var i = 0; i < len; i++){
		
		new_data+="/";
		new_data+=$($('#imgList [valid-key="img_list"]')[i]).find("[name='iid']").val();
	}
	
	if(pre_data==new_data)
		history.back();
	
	if(pre_data!=new_data && confirm('변경된 내용이 있습니다.\n작성을 취소하시겠습니까?')){
		
		goPage('cancelImgUpload.latte?redirectPage=hospitalHome.latte');
	}
}

$(document).ready(function(){
	if($('#imgList [valid-key="img_list"]').length>11){
		$('#add_area').hide();
	}
});

function imageUpdate(targetId,imgsrc,iid){
	
	count++;
	index++;
	var li = $.createElementJson(
	{
		tagName:"li",validKey:"img_list",id:'item'+index,children:
		[
		{
			tagName:"input",type:"hidden",name:"iid",value:iid
		},
		{
			tagName:"p",cls:"img01",child:
			{	tagName:"img",src:imgsrc,alt:"",width:"100%"}
		},
		{
			tagName:"p",cls:"btn_t btn_admin01",child:
			{
				tagName:"a",dataRole:"button",onclick:"upSub('item"+index+"')",child:
				{	tagName:"img",src:"${con.IMGPATH}/btn/btn_t.png",alt:"",width:"31",height:"31"}	
			}
		},
		{
			tagName:"p",cls:"btn_b btn_admin01",child:
			{
				tagName:"a",dataRole:"button",onclick:"downSub('item"+index+"')",child:
				{	tagName:"img",src:"${con.IMGPATH}/btn/btn_b.png",alt:"",width:"31",height:"31"}	
			}
		},
		{
			tagName:"p",cls:"btn_d btn_admin01",child:
			{
				tagName:"a",dataRole:"button",onclick:"deleteItem('item"+index+"')",child:
				{	tagName:"img",src:"${con.IMGPATH}/btn/btn_d.png",alt:"",width:"31",height:"31"}	
			}
		}
		]
		
	});
	
	$('#imgList').prepend(li);
	
	if($('#imgList [valid-key="img_list"]').length>11){
		$('#add_area').hide();
	}
	
	$('#imgList').trigger('create');
}

var fileInputTemplate = '<input type="file" id="file_btn" class="file_input" name="image" '
	+'style="width:100%; height: 100%; cursor:pointer; font-size: 500px; opacity:0; filter:alpha(opacity=0);"></input>';

function uploadImage(){
	
	if($('#imgList [valid-key="img_list"]').length>11){
		alert('12개까지만 등록할 수 있습니다.');
		return;
	}
	
	(new AjaxFileUploader({
		url:'ajaxIntroduceImgUpload.latte',
		success:function(map){
			
			openCropLayer(map);
			
			$('#file_btn').remove();
			
			var $input = $(fileInputTemplate);
			$input.on('change',function(){uploadImage();});
			$('#file_btn_parent').append($input);
			
			$('#file_btn_parent').trigger('create');
		}
	})).uploadImage($('#file_btn').detach());
}

</script>

</head>
<body>

	<div data-role="page">
	
		<jsp:include page="/common/admin/hospital/INC_IMAGE_CROP.jsp"></jsp:include>
		<jsp:include page="/common/admin/hospital/INC_INSTANCE_DIALOG.jsp"/>
		
		<jsp:include page="../include/main_title_bar.jsp">
			<jsp:param name="back_function" value="cancel"/>
		</jsp:include>
				
		<!-- content 시작-->
		<div data-role="content" id="contents">
			
			<!-- 메인메뉴 tab -->
			<jsp:include page="../include/main_menu.jsp"/>
			<!-- // tab 끝-->
			
			<!-- 이테리어 사진 설정 -->
			<div class="a_type01_b">
				<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />소개 이미지</h3>
				<div class="photo_set_area mt05">
					<ul id="imgList">
						<c:forEach items="${introImageList}" var="list" varStatus="c">
						<c:set var="itemId" value="item${c.index}"/>
						<li valid-key="img_list" id="${itemId}">
							<input type="hidden" name="iid" value="${list.s_iid}"/>
							<p class="img01"><img src="${con.img_dns}${list.s_image_path}" alt="" width="100%" /></p>
							<p class="btn_t btn_admin01"><a onclick="upSub('${itemId}')" data-role="button"><img src="${con.IMGPATH}/btn/btn_t.png" alt="" width="31" height="31" /></a></p>
							<p class="btn_b btn_admin01"><a onclick="downSub('${itemId}')" data-role="button"><img src="${con.IMGPATH}/btn/btn_b.png" alt="" width="31" height="31" /></a></p>
							<p class="btn_d btn_admin01"><a onclick="deleteItem('${itemId}')" data-role="button"><img src="${con.IMGPATH}/btn/btn_d.png" alt="" width="31" height="31" /></a></p>
						</li>
						</c:forEach>
						<li class="photo_add" id="add_area" style="position:relative;">
							<a data-role="button"><img src="${con.IMGPATH}/btn/btn_camera.png" alt="" width="67" height="44" /><label>이곳을 눌러 등록할 이미지를 선택해주세요. (최대 12개)<br />* 이미지 가로 권장 사이즈 : 718px</label></a>
							<div id="file_btn_parent" style="position:absolute; overflow:hidden; top:0; left:0; height:100%; width:100%; z-index:1;">
								<input type="file" id="file_btn" name="image" style="width:100%; height: 100%; cursor:pointer; font-size: 500px; opacity:0; filter:alpha(opacity=0);" onchange="uploadImage();"/>
							</div>
						</li>
					</ul>
				</div>
				<div class="btn_area02 mt10">
					<p class="btn_black02 btn_l" style="width:100px;"><a onclick="cancelEdit()" data-role="button">취소</a></p>
					<p class="btn_red02" style="margin-left:104px;"><a onclick="saveImg();" data-role="button">저장</a></p>
				</div>
				
			</div>
		</div>
		
		<jsp:include page="copyright.jsp"/>
	</div>

</body>
</html>