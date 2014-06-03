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
<jsp:include page="../../include/total_header.jsp" />

<script src="${con.JSPATH}/jquery.form.js"></script>
<jsp:include page="/common/include/js_ajaxfileuploader.jsp"/>

<c:set var="pre_data" value="${pre_data}/${boardContents.s_iid}"/>
<c:set var="pre_data" value="${pre_data}/${boardContents.s_subject}"/>
<c:set var="pre_data" value="${pre_data}/${fn:replace(fn:replace(boardContents.s_contents,crlf,'\\\n'),quot,equot)}"/>
<%-- <c:set var="pre_data" value="${pre_data}/${fn:replace(boardContents.s_contents,quot,equot)}"/> --%>
<c:forEach var="video_item" items="${videoList}" varStatus="c">
<c:set var="pre_data" value="${pre_data}/${fn:replace(video_item.s_value,quot,equot)}"/>
</c:forEach>

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
				+'&contents='+encodeURIComponent($('#board_contents').val())
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
	
	var pre_data = "${pre_data}";
	var new_data = '';
	
	function cancel(){
		
		if(!parseBool('${empty params.view_type}')){
			new_data = '';
			
			new_data += '/'+$('#iid').val(); 
			new_data += '/'+$('#subject').val(); 
			new_data += '/'+$('#board_contents').val(); 
			
			var video_url = $("[name='video_url']");
			var len = $(video_url).length;
			
			for(var i = 0; i < len; i++){
				
				//alert(i);
				new_data+="/";
				new_data+=$(video_url[i]).val();
			}
			
			if(pre_data!=new_data && !confirm('변경된 내용이 있습니다.\n작성을 취소하시겠습니까?')){
				return;
			}
		}
		history.back();
	}
	
	$(document).ready(function(){
		
		if($('#img_area img').attr('src')==''||$('#img_area img').attr('src')=='undefined'){
			
			$('#img_reg_btn .ui-btn-text').text('등록');
			$('#img_area').hide();
		}else{
			
			$('#img_reg_btn .ui-btn-text').text('재등록');
		}
		
		new AjaxFileUploader2('img_reg_btn',{
			url:'ajaxBoardImgUpload.latte',
			success:function(response){
				setJcropOptions({rate_fixed:false});
				openCropLayer($.parseJSON(response));
			}
		});
	});
	
	function imageUpdate(targetId,imgsrc,iid){
		
		$('#img_reg_btn .ui-btn-text').text('재등록');
		$('#img_area').show();
		
		$('#img').attr('src',imgsrc);
		$('#iid').val(iid);
	}
	
	function removeImage(){
		
		$('#img_area').hide();
		$('#img_reg_btn .ui-btn-text').text('등록');
		
		$('#iid').val('');
		$('#img').attr('src','');
	}
	
	function remove(bid){
		
		if(!confirm('작성된 내용을 삭제하시겠습니까?'))
			return;
		
		//ajaxDeleteBoardContent
		$.ajax({
			url:'ajaxDeleteImgBoardContent.latte',
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

</script>

<style>.embed-container { position: relative; padding-bottom: 56.25%; padding-top: 30px; height: 0; overflow: hidden; max-width: 100%; height: auto; } .embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }</style>

</head>
<body>
		
	<div data-role="page">
	
		<jsp:include page="/common/admin/hospital/INC_INSTANCE_DIALOG.jsp"/>
		<jsp:include page="/common/admin/hospital/INC_IMAGE_CROP.jsp"/>
		
		<jsp:include page="../../include/main_title_bar.jsp"><jsp:param name="back_function" value="cancel"/></jsp:include>
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
			
			<!-- 메인메뉴 tab -->
			<jsp:include page="../../include/main_menu.jsp"/>
			
			<!-- tab -->
			<%-- <div class="tab">
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
			</div> --%>
			<!-- // tab 끝-->
			
			<input type="hidden" id="bid" value="${boardContents.s_bid}"/>
			
			<%-- 조회 페이지 --%>
			<c:if test="${empty params.view_type}">
			
				<div class="view_top">
					<h3>${boardContents.s_subject}</h3>
					<p class="data mt05">${boardContents.d_reg_date}<span class="border">조회수 ${boardContents.n_read}</span></p>
				</div>
				<div class="view_contents">
					<c:forEach var="video_item" items="${videoList}">
					<c:if test="${video_item.s_sub_type eq codes.ELEMENT_BOARD_CONTENTS_SUBTYPE_RAW_CODE}">
					<div class='embed-container' style="margin:10px;">
						${video_item.s_value}
					</div>
					</c:if>
					</c:forEach>
					<c:if test="${not empty boardContents.image_path}">
					<p class="view_img"><img src="<c:choose><c:when test="${empty boardContents.image_path}"></c:when><c:otherwise>${con.img_dns}${boardContents.image_path}</c:otherwise></c:choose>" alt="" width="100%"/></p>
					</c:if>
					<p class="txt01">${fn:replace(fn:replace(boardContents.s_contents,'<','&lt;'),lf,'<br/>')}</p>
				</div>
				<div class="btn_area">
					<ul>
						<li class="fleft" style="width:33%;"><p class="btn_black02"><a onclick="remove($('#bid').val());" data-role="button">삭제</a></p></li>
						<li class="fleft" style="width:34%;"><p class="btn_red02" style="margin-left:4px;"><a onclick="goPage('boardContentEdit.latte?cmid=${params.cmid}&bid=${boardContents.s_bid}&view_type=edit')" data-role="button">수정</a></p></li>
						<li class="fleft" style="width:33%;"><p class="btn_gray" style="margin-left:4px;"><a onclick="goPage('boardHome.latte?cmid=${params.cmid}')" data-role="button">이전목록</a></p></li>
					</ul>
				</div>
				
			
				<%-- <h3>${boardContents.s_subject}</h3>
				
				
				
				<img src="" width="100%"/>
				<div class="cont_area">
				
					<p class="textarea02"><textarea id="introduce" class="textarea" style="width:100%; height:150px;" placeholder="샵 소개 내용을 입력하여 주세요">${boardContents.s_contents}</textarea></p>
					<p class="textarea02">${fn:replace(fn:replace(boardContents.s_contents,'<','&lt;'),lf,'<br/>')}</p>
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
					
				</div> --%>
			
			</c:if>
			
			<%-- 등록/수정 페이지 --%>
			<c:if test="${not empty params.view_type}">
			
				<div class="a_type02_b">
					<h3>제목</h3>
					<p class="input01 mt10"><input type="text" id="subject" placeholder="제목을 입력하세요" value="${boardContents.s_subject}"></p>
				</div>
				
				<div id="video_area" class="a_type02_b">
					<h3>동영상</h3>
					<form id="video_form">
					<div id="video_list">
					<c:forEach var="video_item" items="${videoList}" varStatus="c">
					<div class="area00 mt10">
						<p class="input01" id="video_url${c.index}" style="margin-right:36px;"><input type="text" name="video_url" value="${fn:replace(video_item.s_value,quot,'&quot;')}"></p>
						<p class="abs_rt03 btn_admin01" id="video_url_del${c.index}"><a onclick="removeVideo(${c.index});" data-role="button"><img src="${con.IMGPATH}/btn/btn_d.png" alt="" width="31" height="31" /></a></p>
					</div>
					</c:forEach>
					</div>
					</form>
					<p class="btn_gray02 mt05" style="width:80px;"><a onclick="addVideo();" data-role="button">추가</a></p>
				</div>
				
				<div class="a_type02_b">
					<input type="hidden" id="iid" value="${boardContents.s_iid}"/>
					<h3>이미지</h3>
					<div id="img_area" class="w_box02 mt10">
						<p class="img_area"><img id="img" src="<c:choose><c:when test="${empty boardContents.image_path}"></c:when><c:otherwise>${con.img_dns}${boardContents.image_path}</c:otherwise></c:choose>" alt="" width="100%" /></p>
					</div>
					<div class="btn_area02 mt05">
						<p id="img_reg_btn" class="btn_gray02 fleft" style="width:140px;"><a data-role="button">재등록</a></p>
						<p class="btn_gray02 fleft" style="width:80px; margin-left:4px;"><a onclick="removeImage();" data-role="button">삭제</a></p>
					</div>
				</div>
				
				<div class="a_type02_b">
					<h3>본문</h3>
					<p class="textarea01 mt10"><textarea id="board_contents" style="width:100%; height:150px;" placeholder="">${boardContents.s_contents}</textarea></p>
				</div>
				
				<p class="checkbox" style="margin:15px 15px 0 15px; width:100px;">
					<input type="hidden" id="visible" name="visible" value='<c:choose><c:when test="${boardContents.s_visible eq 'Y' or empty boardContents}">Y</c:when><c:otherwise>${boardContents.s_visible}</c:otherwise></c:choose>'>
					<input type="checkbox" id="checkbox-c1" value="c-1" onclick="checkbox(this,'visible');" <c:if test="${boardContents.s_visible eq 'Y' or empty boardContents}">checked="checked"</c:if>/>
					<label for="checkbox-c1">공개</label>
				</p>
				
				<c:if test="${boardInfo.s_group eq codes.CUSTOM_BOARD_TYPE_NOTICE}">
				<p class="checkbox" style="margin:15px 15px 0 15px; width:300px;">
					<input type="hidden" id="important" name="important" value='<c:choose><c:when test="${boardContents.s_type eq codes.ELEMENT_BOARD_TYPE_IMPORTANT}">Y</c:when><c:otherwise>N</c:otherwise></c:choose>'>
					<input type="checkbox" id="checkbox-c2" value="c-2" onclick="checkbox(this,'important');" <c:if test="${boardContents.s_type eq codes.ELEMENT_BOARD_TYPE_IMPORTANT}">checked="checked"</c:if>/>
					<label for="checkbox-c2">중요 공지사항으로 등록</label>
				</p>
				</c:if>
				
				<%-- <div style="overflow:hidden; padding:10px;">
					
					<div style="float:left; height:20px;width:20px;"><input type="checkbox" id="visible_chk" onclick="checkbox(this,'important');" style="margin-top:5px;" <c:if test="${boardContents.s_type eq codes.ELEMENT_BOARD_TYPE_IMPORTANT}">checked="checked"</c:if>/></div>
					<p style="float:left">중요 공지사항으로 등록</p>
				</div> --%>
				
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
				
			
				
				
				<%-- <p>제목</p>
				<input type="text" id="subject" value="${boardContents.s_subject}"/> --%>
				
				
				
				<!-- <div style="overflow:hidden;">
					<div style="float:left; width:49%; position:relative;">
					</div>
					<div style="float:right; width:49%">
					</div>
				</div> -->
				
				
				<%-- <form id="uploadForm" name="uploadForm" method="post" enctype="multipart/form-data" action="ajaxBoardImgUpload.latte">
				 <!-- 인테리어 이미지 -->
				<div class="shopimg_edit">
					
					<p><img src="${con.IMGPATH_OLD}/common/bu_point02.png" width="6" height="6"/> 이미지</p>
					<div style="overflow:hidden;">
						<div style="float:left; width:49%; position:relative;">
							<div style=";">
								<a data-role="button" style="padding:10px; z-index:0;">+ 이미지추가</a>
							</div>
							<!-- <div id="file_btn" style="position:absolute; overflow:hidden; top:0; left:0; height:100%; width:100%;">
								<input type="file" name="image" style="width:100%; height: 100%; cursor:pointer; font-size: 500px; z-index:1; opacity:0; filter:alpha(opacity=0);" onchange="uploadImage();"/>
							</div> -->
						</div>
						<div style="float:right; width:49%">
						<a data-role="button" onclick="removeImage();">이미지 삭제</a>
						</div>
					</div>
					<div class="s_edit">
								
								<div class="thum" style="overflow:hidden;"><div style="position:relative;"><a data-role="button" style="z-index:0"><img  id="img" src="" width="100%"/></a>
								</div>
					</div>
				</div>
				</div>
				</form> --%>
	
				<%-- <p class="textarea02"><textarea id="board_contents" class="textarea" style="width:100%; height:150px;" placeholder="샵 소개 내용을 입력하여 주세요">${boardContents.s_contents}</textarea></p>
				
				<hr/>
				<div style="overflow:hidden; padding:10px;">
					
					<div style="float:left; height:20px;width:20px;"><input type="checkbox" id="visible_chk" onclick="checkbox(this,'visible');" style="margin-top:5px;" <c:if test="${boardContents.s_visible eq 'Y' or empty boardContents}">checked="checked"</c:if>/></div>
					<p style="float:left">공개</p>
				</div>
	
				<c:if test="${params.view_type eq 'new'}">
				<div style="overflow:hidden;">
					<div style="float:left; width:49%;">
					<a data-role="button" id="cancel_btn" onclick="cancel();" style="padding:10px;">취소</a>
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
					<div style="float:left; width:49%;">
					<a data-role="button" id="cancel_btn" onclick="cancel();" style="padding:10px;">취소</a>
					</div>
					<div style="float:right; width:49%;">
					<a data-role="button" id="save_btn" onclick="saveInfo();" style="padding:10px;">수정하기</a>
					</div>
				</div>
				</c:if> --%>
			
			</c:if>
			
		</div>
		<!-- ///// content 끝-->
		
		<jsp:include page="../../include/simple_copyright.jsp"/>
		
		<!-- footer 시작-->
		<jsp:include page="/common/admin/hospital/INC_JSP_FOOTER.jsp" />
		<!-- ///// footer 끝-->

	</div>
	
	

</body>
</html>