<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:scriptlet>
pageContext.setAttribute("crlf", "\r\n");
pageContext.setAttribute("lf", "\n");
pageContext.setAttribute("cr", "\r");
pageContext.setAttribute("quot", "\"");
pageContext.setAttribute("equot", "\\\"");
</jsp:scriptlet>

<!DOCTYPE>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../include/total_header.jsp"/>

<script src="${con.JSPATH}/jquery.form.js"></script>
<jsp:include page="/common/include/js_ajaxfileuploader.jsp"/>

<c:set var="pre_data" value="${pre_data}/${boardContents.s_iid}"/>
<c:set var="pre_data" value="${pre_data}/${boardContents.s_subject}"/>
<c:set var="pre_data" value="${pre_data}/${fn:replace(fn:replace(boardContents.s_contents,crlf,'\\\n'),quot,equot)}"/>
<c:forEach var="video_item" items="${videoList}" varStatus="c">
<c:set var="pre_data" value="${pre_data}/${fn:replace(video_item.s_value,quot,equot)}"/>
</c:forEach>

<script>

function commonToggle(area,btn){
	
	if($('#'+area).is(':visible')){
		$('#'+area).hide();
		$('#'+btn+' p').removeClass('btn_cb_on');
		$('#'+btn+' p').addClass('btn_cb_off');
		$('#'+btn+' img').hide();
	}
	else{
		$('#'+area).show();
		$('#'+btn+' p').removeClass('btn_cb_off');
		$('#'+btn+' p').addClass('btn_cb_on');
		$('#'+btn+' img').show();
	}
}

function toggleTitle(){
	
	commonToggle('title_area','title_btn');	
}

function toggleVideo(){
	
	commonToggle('video_area','video_btn');		
}

function toggleImage(){
	
	commonToggle('img_area','img_btn');
	
	if($('#img_area img').attr('src')==''){
		$('#img_reg_btn .ui-btn-text').text('등록');
		$('#inner_img_area').hide();
	}else{
		$('#img_reg_btn .ui-btn-text').text('재등록');
		$('#inner_img_area').show();
	}
}

function toggleContent(){
	
	commonToggle('content_area','content_btn');		
}

function removeItem(id){
	
	$('#'+id).remove();
}

function saveInfo(){
	
	if(!confirm('내용을 저장하시겠습니까?'))
		return;
	
	var title_visible = '';
	
	if($('#title_area').is(':visible')){
		title_visible = 'Y';
	}
	
	var img_visible = '';
	
	if($('#img_area').is(':visible')){
		img_visible = 'Y';
	}
	
	var content_visible = '';
	
	if($('#content_area').is(':visible')){
		content_visible = 'Y';
	}
	
	var video_visible = '';
	
	if($('#video_area').is(':visible')){
		video_visible = 'Y';
	}
	
	$.ajax({
		type:'POST',
		async:false,
		url:'ajaxSaveServiceInfo.latte',
		data:$('#form1').serialize()
		+'&title_visible='+title_visible+'&img_visible='+img_visible
		+'&content_visible='+content_visible+'&video_visible='+video_visible,
		dataType:'json',
		success:function(response,status,xhr){
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				alert('저장되었습니다. ');
				var url = 'serviceHome.latte?';
				if(!(typeof response.ancestor==='undefined')){
					url += 'cmid='+response.ancestor+'&';
				}
				url += 'cmid='+$('#group').val();
				goPage(url);
			}
			else{
				alert('에러입니다. code:'+response.result);
			}
		},
		error:function(xhr,status,error){
			
			alert("실패하였습니다.\n"+status+"\n"+error);
		}
	});
}

var pre_data = '${pre_data}';
var new_data = '';

function cancel(){
	
	new_data = '';
	
	new_data += '/'+$('#iid').val(); 
	new_data += '/'+$('#subject').val(); 
	new_data += '/'+$('#board_contents').val(); 
	
	var $video_url = $("[name='video_url']");
	var len = $video_url.length;
	
	for(var i = 0; i < len; i++){
		
		new_data+="/";
		new_data+=$video_url[i].val();
	}
	
	if(pre_data!=new_data && !confirm('변경된 내용이 있습니다.\n작성을 취소하시겠습니까?')){
		return;
	}
	
	history.back();
}

function imageUpdate(targetId,imgsrc,iid){
	
	if(!$('#inner_img_area').is(':visible')){
	
		$('#img_reg_btn .ui-btn-text').text('재등록');
		$('#inner_img_area').show();
	}
	
	$('#img').attr('src',imgsrc);
	$('#iid').val(iid);
}

function checkbox(me,targetId){
	
	if($(me).is(':checked'))
		$('#'+targetId).val('Y');
	else
		$('#'+targetId).val('N');
}

function remove(){
	
	if(!confirm('작성된 내용을 삭제하시겠습니까?'))
		return;
	
	//ajaxDeleteBoardContent
	$.ajax({
		url:'ajaxDeleteBoardContent.latte',
		type:'POST',
		data:{
			bid:$('#bid').val()
		},
		dataType:'json',
		success:function(response, status, xhr){
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				showDialog('삭제되었습니다.','default',function(){
					goPage('serviceHome.latte');
				});
			};
		},
		error:function(xhr,status,error){
			alert(status+'\n'+error);
		}
	});
}

var video_len = '${fn:length(videoList)}';

function addVideo(){
	
	var t = $('<div class="area00 mt10">'
		+'<p id="video_url'+video_len+'" class="input01" style="margin-right:36px;"><input type="text" name="video_url"></p>'
		+'<p id="video_url_del'+video_len+'" class="btn_admin01 abs_rt03"><a onclick="removeVideo('+video_len+');" data-role="button"><img src="${con.IMGPATH}/btn/btn_d.png" alt="" width="31" height="31" /></a></p>'
	+'</div>');

	video_len++;
	
	$('#video_list').append(t);
	
	$('#video_list').trigger('create');
}

function removeVideo(index){
	
	$('#video_url'+index).remove();
	$('#video_url_del'+index).remove();
}

$(document).ready(function(){
	
	new AjaxFileUploader2('img_reg_btn',{
		url:'ajaxServiceImgUpload.latte',
		success:function(response){
			setJcropOptions({rate_fixed:false});
			openCropLayer($.parseJSON(response));
		}
	});
	
	toggleTitle();
	toggleVideo();
	toggleImage();
	toggleContent();
	if(parseBool("${not empty boardContents.s_subject}")){toggleTitle();}
	if(parseBool("${not empty videoList}")){toggleVideo();}
	if(parseBool("${not empty boardContents.s_iid}")){toggleImage();}
	if(parseBool("${not empty boardContents.s_contents}")){toggleContent();}
});

</script>

</head>
<body>
		
	<div data-role="page">
	
		<jsp:include page="/common/admin/hospital/INC_IMAGE_CROP.jsp"></jsp:include>
		
		<jsp:include page="/common/admin/hospital/INC_INSTANCE_DIALOG.jsp"/>
		
		<jsp:include page="../include/main_title_bar.jsp"><jsp:param name="back_function" value="cancel"/></jsp:include>
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
			
			<!-- 메인메뉴 tab -->
			<jsp:include page="../include/main_menu.jsp"/>

			<form id="form1">
			
			<input type="hidden" id="group" name="group" value="<c:choose><c:when test="${empty params.g}">${boardContents.s_group}</c:when><c:otherwise>${params.g}</c:otherwise></c:choose>"/>
			<input type="hidden" id="bid" name="bid" value="${boardContents.s_bid}"/>
			<input type="hidden" id="iid" name="iid" value="${boardContents.s_iid}">
			
			<!-- 선택 메뉴 -->
			<div class="a_type03_b">
				<p class="txt_gray11">*추가할 항목을 선택해 주세요.</p>
				<ul>
					<li id="title_btn" style="width:25%;"><p class="btn_cb_off"><a onclick="toggleTitle();" data-role="button"><img src="${con.IMGPATH}/common/bu_check.png" alt="" width="18" height="18"/>제목 추가</a></p></li>
					<li id="video_btn" style="width:25%;"><p class="btn_cb_off" style="margin-left:4px;"><a onclick="toggleVideo();" data-role="button"><img src="${con.IMGPATH}/common/bu_check.png" alt="" width="18" height="18"/>동영상 추가</a></p></li>
					<li id="img_btn" style="width:25%;"><p class="btn_cb_off" style="margin-left:4px;"><a onclick="toggleImage();" data-role="button"><img src="${con.IMGPATH}/common/bu_check.png" alt="" width="18" height="18"/>이미지 추가</a></p></li>
					<li id="content_btn" style="width:25%;"><p class="btn_cb_off" style="margin-left:4px;"><a onclick="toggleContent();" data-role="button"><img src="${con.IMGPATH}/common/bu_check.png" alt="" width="18" height="18"/>본문 추가</a></p></li>
				</ul>
			</div>
			
			<div id="title_area" class="a_type02_b">
				<h3>제목</h3>
				<p class="input01 mt10"><input type="text" id="subject" name="subject" value="${boardContents.s_subject}"></p>
				<p class="btn_gray02 mt05" style="width:80px;"><a onclick="toggleTitle();" data-role="button">삭제</a></p>
			</div>
			
			<div id="video_area" class="a_type02_b">
				<h3>동영상</h3>
				<div id="video_list">
				<c:forEach var="video_item" items="${videoList}" varStatus="c">
				<div class="area00 mt10">
					<p class="input01" id="video_url${c.index}" style="margin-right:36px;"><input type="text" name="video_url" value="${fn:replace(video_item.s_value,quot,'&quot;')}"></p>
					<p class="abs_rt03 btn_admin01" id="video_url_del${c.index}"><a onclick="removeVideo(${c.index});" data-role="button"><img src="${con.IMGPATH}/btn/btn_d.png" alt="" width="31" height="31" /></a></p>
				</div>
				</c:forEach>
				</div>
				<p class="btn_gray02 mt05" style="width:80px;"><a onclick="addVideo();" data-role="button">추가</a></p>
			</div>
			
			<div id="img_area" class="a_type02_b">
				<h3>이미지</h3>
				<div id="inner_img_area" class="w_box02 mt10">
					<p class="img_area"><img id="img" src="<c:if test="${not empty boardContents.image_path}">${con.img_dns}${boardContents.image_path}</c:if>" alt="" width="100%" /></p>
				</div>
				<div class="btn_area02 mt05">
					<p id="img_reg_btn" class="btn_gray02 fleft" style="width:140px; overflow:hidden; position:relative;"><a data-role="button">재등록</a></p>
					<p class="btn_gray02 fleft" style="width:80px; margin-left:4px;"><a onclick="toggleImage();" data-role="button">삭제</a></p>
				</div>
				<p class="txt_gray11 mt05">*이미지 가로 권장사이즈 : 718px </p>
			</div>
			
			<div id="content_area" class="a_type02_b">
				<h3>본문</h3>
				<p class="textarea01 mt10"><textarea id="board_contents" name="contents" style="width:100%; height:150px;" placeholder="">${boardContents.s_contents}</textarea></p>
				<p class="btn_gray02 mt05" style="width:80px;"><a onclick="toggleContent();" data-role="button">삭제</a></p>
			</div>
			
			<p class="checkbox" style="margin:15px 15px 0 15px; width:100px;">
				<input type="hidden" id="visible" name="visible" value='<c:choose><c:when test="${boardContents.s_visible eq 'Y' or empty boardContents}">Y</c:when><c:otherwise>${boardContents.s_visible}</c:otherwise></c:choose>'>
				<input type="checkbox" id="checkbox-c1" value="c-1" onclick="checkbox(this,'visible');" <c:if test="${boardContents.s_visible eq 'Y'or empty boardContents}">checked="checked"</c:if>/>
				<label for="checkbox-c1">공개</label>
			</p>
			
			</form>
			
			<c:choose>
			<c:when test="${empty boardContents.s_bid}">
			<div class="btn_area03">
				<p class="btn_black02 btn_l" style="width:100px;"><a onclick="cancel();" data-role="button">취소</a></p>
				<p class="btn_red02" style="margin-left:104px;"><a onclick="saveInfo();" data-role="button">저장</a></p>
			</div>
			</c:when>
			<c:otherwise>
			<div class="btn_area">
				<ul>
					<li class="fleft" style="width:33%;"><p class="btn_black02"><a onclick="remove();" data-role="button">삭제</a></p></li>
					<li class="fleft" style="width:34%;"><p class="btn_gray" style="margin-left:4px;"><a onclick="cancel();" data-role="button">취소</a></p></li>
					<li class="fleft" style="width:33%;"><p class="btn_red02" style="margin-left:4px;"><a onclick="saveInfo();" data-role="button">저장</a></p></li>
				</ul>
			</div>
			</c:otherwise>
			</c:choose>
			
		</div>
		<!-- ///// content 끝-->

		<jsp:include page="../include/simple_copyright.jsp"/>

	</div>
	
	<script>
	</script>

</body>
</html>