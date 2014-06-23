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
pageContext.setAttribute("quot", "\"");
pageContext.setAttribute("equot", "\\\"");
</jsp:scriptlet>


<!DOCTYPE>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../../include/INC_JSP_HEADER.jsp" />

<script src="${con.JSPATH}/jquery.form.js"></script>

<script>	

	function checkbox(me,targetId){
		
		if($(me).is(':checked'))
			$('#'+targetId).val('Y');
		else
			$('#'+targetId).val('N');
	}
	
	function saveInfo(){
		
		$.ajax({
			url:'ajaxSaveImgBoard.latte',
			type:'POST',
			data:
				'bid='+$('#bid').val()
				+'&subject='+$('#subject').val()
				+'&contents='+encodeURIComponent($('#content').val())
				+'&group=${boardInfo.s_cmid}'
				+'&iid='+$('#iid').val()
				+'&visible='+$('#visible').val()
				+'&important='+$('#important').val()
				+'&'+$('#video_form').serialize()
			,
			dataType:'json',
			success:function(response, status, xhr){
				
				if(response.result=='${codes.SUCCESS_CODE}'){
					$('#bid').val(response.bid);
					showDialog('처리되었습니다.','default',function(){
						if('${params.view_type}'=='new'||'${params.view_type}'=='edit'){
							goPage('boardContentEdit.latte?cmid=${params.cmid}&bid='+$('#bid').val());
						}
					});
				}
			},
			error:function(xhr,status,error){
				alert(status+'\n'+error);
			}
		});
	}
	
	function remove(bid){
		
		if(!confirm('작성된 내용을 삭제하시겠습니까?'))
			return;
		
		//ajaxDeleteBoardContent
		$.ajax({
			url:'ajaxDeleteBoardContent.latte',
			type:'POST',
			data:{
				bid:bid
			},
			dataType:'json',
			success:function(response, status, xhr){
				
				if(response.result=='${codes.SUCCESS_CODE}'){
					showDialog('삭제되었습니다.','default',function(){
						goPage('boardHome.latte?cmid=${params.cmid}');
					});
				}
			},
			error:function(xhr,status,error){
				alert(status+'\n'+error);
			}
		});
	}
	
	
	
	var fileInputTemplate = '<input type ="file" class="file_input" name="image" '
		+'style="width:100%; height: 100%; cursor:pointer; font-size: 500px; z-index:1; opacity:0; filter:alpha(opacity=0);"></input>';

	$(document).ready(function(){
		/* alert('1');
		$('#uploadForm').ajaxForm(function(){
			alert('2');
		}); */
	});
		
	function uploadImage(){

		$('#uploadForm').ajaxForm({
			beforeSubmit: function(a,f,o) {
				
			},
			clearForm: false,
			resetForm: false,
			url:'ajaxBoardImgUpload.latte',
			type:'POST',
			success: function (responseText, statusText, xhr, $form) {
				//alert('1');
				var map = $.parseJSON(responseText);

				setJcropOptions({rate_fixed:false});
				openCropLayer(map);
				
				$('#uploadForm').unbind('submit').find('input:submit,input:image,button:submit').unbind('click');
				$('#file_btn > input').remove();
				
				var $input = $(fileInputTemplate).clone();
				$input.on('change',function(){uploadImage();});
				$('#file_btn').append($input);
				$('#file_btn').trigger('create');
			},
			error : function(jqXHR, textStatus, errorThrown) {

				alert('File Upload Failed : ' + jqXHR);
			}
		});
		//$("#uploadForm").ajaxSubmit();
		$('#uploadForm').submit(function(e){
			return false;
		});
		
		$('#uploadForm').submit();
	}
	
	function imageUpdate(targetId,imgsrc,iid){
		
		$('#img').attr('src',imgsrc);
		$('#iid').val(iid);
	}
	
	function removeImage(){
		
		$('#iid').val('');
		$('#img').attr('src','');
	}
	
	
	
	var video_len = '${fn:length(videoList)}';
	
	function addVideo(){
		
		$('#video_list').append($('<input type="text" id="video_url'+video_len+'" name="video_url" style="border:1px solid gray;" value=""/>'));
		$('#video_list').append($('<a data-role="button" id="video_url_del'+video_len+'" onclick="removeVideo('+video_len+');">삭제</a>'));
		$('#video_list').trigger('create');
	}
	
	function removeVideo(index){
		
		$('#video_url'+index).remove();
		$('#video_url_del'+index).remove();
	}
</script>

</head>
<body>
		
	<div data-role="page" id="home" style="background: #f7f3f4;">
	
		<jsp:include page="/common/admin/hospital/INC_INSTANCE_DIALOG.jsp"/>
		<jsp:include page="/common/admin/hospital/INC_IMAGE_CROP.jsp"/>
			
		<c:if test="${empty appType}" >
		<!-- header 시작-->
		<div data-role="header" id="head" data-position="fixed" data-tap-toggle="false" data-theme="a"><!-- data-tap-toggle="false"  -->
			<h1>${hospitalInfo.s_hospital_name}</h1>
			<!--<h1>검색 결과</h1>-->
			<a href="#" data-role="botton" data-rel="back">&nbsp;</a>
			<a href="#" data-role="botton" data-rel="menu" id="RightMenu"><img src="${con.IMGPATH_OLD}/btn/btn_menu.png" alt="shop" width="32" height="32" />&nbsp;</a>
			<c:if test="${editableAdminFlag == 'Y'}">
				<p class="t_edit02"><a onclick="goPage('shopHome?idx=${param.idx}&modify=true')" data-role="button">편집</a></p>
			</c:if> 
			<%-- <a href="index.html" data-role="botton" class="shop"><img src="${con.IMGPATH_OLD}/btn/btn_shop.png" alt="shop" width="32" height="32"/>&nbsp;</a> --%>
		</div>
		<!-- ///// header 끝-->
		</c:if>
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
			
			<!-- 메인메뉴 tab -->
			<jsp:include page="../../include/main_menu.jsp">
				<jsp:param value="3" name="curMainMenu"/>
			</jsp:include>
			<!-- // tab 끝-->
			
			<!-- tab -->
			<div class="tab">
				<div class="tab_area">
					<ul>
						<c:set var="curMenu" value="${boardInfo.sequence}"/>
						<c:set var="mainMenuLen" value="${fn:length(menuList)}"/>
						<c:forEach var="item" items="${menuList}" varStatus="c">
							<c:set var="w">${c.count*100/mainMenuLen - c.index*100/mainMenuLen}</c:set>
							<li style="width: ${w}%;" class="<c:if test="${curMenu-1 eq c.count}">noborder</c:if><c:if test="${curMenu eq c.count}">on</c:if><c:if test="${curMenu ne c.count and mainMenuLen eq c.count}">noborder</c:if>"><a onclick="goPage('boardHome.latte?idx=${params.idx}&cmid=${item.s_cmid}');" data-role="button">${item.s_name}</a></li>
						</c:forEach>
					</ul>
				</div>
			</div>
			<!-- // tab 끝-->
			
			<input type="hidden" id="bid" value="${boardContents.s_bid}"/>
			
			<c:if test="${empty params.view_type}">
			
			<h3>${boardContents.s_subject}</h3>
			
			<c:forEach var="video_item" items="${videoList}">
				<c:if test="${video_item.s_sub_type eq codes.ELEMENT_BOARD_CONTENTS_SUBTYPE_RAW_CODE}">
				<div class='embed-container' style="margin:10px;">
					${video_item.s_value}
				</div>
				</c:if>
				</c:forEach>
				
				<img src="<c:choose><c:when test="${empty boardContents.image_path}">${con.IMGPATH_OLD}/contents/edit_img.png</c:when><c:otherwise>${con.img_dns}${boardContents.image_path}</c:otherwise></c:choose>" width="100%"/>
				
			<div class="cont_area">
				
				<p class="textarea02"><textarea id="introduce" class="textarea" style="width:100%; height:150px;" placeholder="샵 소개 내용을 입력하여 주세요">${boardContents.s_contents}</textarea></p>
			</div>
			
			
			<div style="overflow:hidden;">
				<div style="float:left; width:29%;">
				<a data-role="button" id="cancel_btn" onclick="remove($('#bid').val());" style="padding:10px;">삭제</a>
				</div>
				<div style="float:right; width:35%;">
				<a data-role="button" style="padding:10px;" onclick="goPage('boardHome.latte?cmid=${params.cmid}')">이전목록</a>
				</div>
				<div style="float:right; width:35%;">
				<a data-role="button" id="save_btn" onclick="goPage('boardContentEdit.latte?cmid=${params.cmid}&bid=${boardContents.s_bid}&view_type=edit')" style="padding:10px;">수정하기</a>
				</div>
				
			</div>
			
			</c:if>
			
			<c:if test="${not empty params.view_type}">
			
			
			
			
			
			
			
			<p>제목</p>
			<input type="text" id="subject" value="${boardContents.s_subject}"/>
			
			<p>동영상</p>
				<form id="video_form">
				<div id="video_list">
					<c:forEach var="video_item" items="${videoList}" varStatus="c">
					<input type="text" id="video_url${c.index}" name="video_url" style="border:1px solid gray;" value="${fn:replace(video_item.s_value,quot,'&quot;')}"/>
					<a data-role="button" id="video_url_del${c.index}" onclick="removeVideo(${c.index});">삭제</a>
					</c:forEach>
				</div>
				</form>
				<a data-role="button" onclick="addVideo();">추가</a>
				<!-- <div style="overflow:hidden;">
					<div style="float:left; width:49%; position:relative;">
					</div>
					<div style="float:right; width:49%">
					</div>
				</div> -->
				
				
				<form id="uploadForm" name="uploadForm" method="post" enctype="multipart/form-data" action="ajaxBoardImgUpload.latte">
				 <!-- 인테리어 이미지 -->
				<div class="shopimg_edit">
					<input type="hidden" id="iid" value="${boardContents.s_iid}"/>
					<p><img src="${con.IMGPATH_OLD}/common/bu_point02.png" width="6" height="6"/> 이미지</p>
					<div style="overflow:hidden;">
						<div style="float:left; width:49%; position:relative;">
							<div style=";">
								<a data-role="button" style="padding:10px; z-index:0;">+ 이미지추가</a>
							</div>
							<div id="file_btn" style="position:absolute; overflow:hidden; top:0; left:0; height:100%; width:100%;">
								<input type="file" name="image" style="width:100%; height: 100%; cursor:pointer; font-size: 500px; z-index:1; opacity:0; filter:alpha(opacity=0);" onchange="uploadImage();"/>
							</div>
						</div>
						<div style="float:right; width:49%">
						<a data-role="button" onclick="removeImage();">이미지 삭제</a>
						</div>
					</div>
					<div class="s_edit">
								
								<div class="thum" style="overflow:hidden;"><div style="position:relative;"><a data-role="button" style="z-index:0"><img  id="img" src="<c:choose><c:when test="${empty boardContents.image_path}">${con.IMGPATH_OLD}/contents/edit_img.png</c:when><c:otherwise>${con.img_dns}${boardContents.image_path}</c:otherwise></c:choose>" width="100%"/></a>
								</div>
					</div>
				</div>
				</div>
				</form>
			
			
		<p>내용</p>
			<p class="textarea02"><textarea id="content" class="textarea" style="width:100%; height:150px;" placeholder="샵 소개 내용을 입력하여 주세요">${boardContents.s_contents}</textarea></p>
			
			<hr/>
			<div style="overflow:hidden; padding:10px;">
				<input type="hidden" id="visible" name="visible" value='<c:choose><c:when test="${boardContents.s_visible eq 'Y' or empty boardContents}">Y</c:when><c:otherwise>${boardContents.s_visible}</c:otherwise></c:choose>'>
				<div style="float:left; height:20px;width:20px;"><input type="checkbox" id="visible_chk" onclick="checkbox(this,'visible');" style="margin-top:5px;" <c:if test="${boardContents.s_visible eq 'Y' or empty boardContents}">checked="checked"</c:if>/></div>
				<p style="float:left">공개</p>
			</div>
			
			<div style="overflow:hidden; padding:10px;">
				<input type="hidden" id="important" name="important" value='<c:choose><c:when test="${boardContents.s_type eq codes.ELEMENT_BOARD_TYPE_IMPORTANT}">Y</c:when><c:otherwise>N</c:otherwise></c:choose>'>
				<div style="float:left; height:20px;width:20px;"><input type="checkbox" id="visible_chk" onclick="checkbox(this,'important');" style="margin-top:5px;" <c:if test="${boardContents.s_type eq codes.ELEMENT_BOARD_TYPE_IMPORTANT}">checked="checked"</c:if>/></div>
				<p style="float:left">중요 공지사항으로 등록</p>
			</div>

			<c:if test="${params.view_type eq 'new'}">
			<div style="overflow:hidden;">
				<div style="float:left; width:49%;">
				<a data-role="button" id="cancel_btn" style="padding:10px;">취소</a>
				</div>
				<div style="float:right; width:49%;">
				<a data-role="button" id="save_btn" onclick="saveInfo();" style="padding:10px;">등록하기</a>
				</div>
			</div>
			</c:if>
			<c:if test="${params.view_type eq 'edit'}">
			<div style="overflow:hidden;">
				<div style="float:left; width:49%;">
				<a data-role="button" id="cancel_btn" onclick="remove($('#bid').val());" style="padding:10px;">삭제</a>
				</div>
				<div style="float:right; width:49%;">
				<a data-role="button" id="save_btn" onclick="saveInfo();" style="padding:10px;">수정하기</a>
				</div>
			</div>
			</c:if>
			
			</c:if>
			
			
		</div>
		<!-- ///// content 끝-->
		
		<!-- footer 시작-->
		<jsp:include page="/common/admin/hospital/INC_JSP_FOOTER.jsp" />
		<!-- ///// footer 끝-->

	</div>
	
	

</body>
</html>