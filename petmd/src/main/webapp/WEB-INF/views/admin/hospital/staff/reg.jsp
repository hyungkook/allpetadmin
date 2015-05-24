<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@ page import = "java.util.Date" %>

<jsp:scriptlet>
 
pageContext.setAttribute("crlf", "\r\n");
pageContext.setAttribute("crlfs", "\r\n+");
pageContext.setAttribute("lf", "\n");
pageContext.setAttribute("cr", "\r");
pageContext.setAttribute("quot", "\"");
pageContext.setAttribute("equot", "\\\"");

</jsp:scriptlet>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%-- <jsp:include page="/WEB-INF/views/admin/hospital/include/INC_JSP_HEADER.jsp"/> --%>
<jsp:include page="../include/total_header.jsp"/>

<script src="${con.JSPATH}/jquery.form.js"></script>
<script src="${con.JSPATH}/jquery.form.ajaxfileuploader.js"></script>

<%-- 이력사항 추가시 동적으로 붙일 html 코드를 문자열로 저장 --%>
<c:set var="past_history_template">
	<jsp:include page="past_history_template.jsp">
		<jsp:param value="Y" name="is_template"/>
	</jsp:include>
</c:set>

<%-- past_history_template.jsp를 문자열로 만들기 위해 따옴표 개행문자들을 replace치환" --%>
<c:set var="past_history_template" value="${fn:replace(past_history_template,'	','')}"/>
<c:set var="past_history_template" value="${fn:replace(past_history_template,quot,equot)}"/>
<c:set var="past_history_template" value="${fn:replace(past_history_template,cr,'\"+\"')}"/>
<c:set var="past_history_template" value="${fn:replace(past_history_template,lf,'\"+\"')}"/>
<c:set var="past_history_template" value="${fn:replace(past_history_template,'+',crlfs)}"/>
<%-- <c:set var="past_history_template" value="${fn:replace(fn:replace(fn:replace(past_history_template,quot,equot),crlf,'\"+\"'),'+',crlfs)}"/> --%>

<c:set var="curYear" value="<%= (new Date()).getYear() %>"/>

<%-- 데이터 변경점을 검사하기 위하여 pre_data에 데이터 순차적으로 입력 --%>
<c:set var="pre_data" value="/${staffInfo.s_name}/${staffInfo.s_position}/${staffInfo.s_specialty}/${staffInfo.s_iid}"/>
<c:set var="pre_data" value="${pre_data}/${staffInfo.TIMETABLE_STATUS}/${staffInfo.s_working_time}/${staffInfo.HISTORY_STATUS}"/>
<c:forEach var="item" items="${staffHistory}" varStatus="c">
<c:set var="ymdhms" value="${fn:split(item.d_start_date,' ')}"/>
<c:set var="year1" value="${fn:split(ymdhms[0],'-')[0]}"/>
<c:set var="ymdhms" value="${fn:split(item.d_end_date,' ')}"/>
<c:set var="year2" value="${fn:split(ymdhms[0],'-')[0]}"/>
<c:set var="pre_data" value="${pre_data}/${item.s_type}${year1}${year2}${item.s_desc}"/>
</c:forEach>
<c:set var="pre_data" value="${pre_data}/${staffInfo.CAREER_STATUS}"/>
<c:forEach var="item" items="${staffCareer}" varStatus="c">
<c:set var="ymdhms" value="${fn:split(item.d_start_date,' ')}"/>
<c:set var="year" value="${fn:split(ymdhms[0],'-')[0]}"/>
<c:set var="pre_data" value="${pre_data}/${item.s_type}${year}${item.s_desc}"/>
</c:forEach>
<c:set var="pre_data" value="${pre_data}/${staffInfo.BOOKS_STATUS}"/>
<c:forEach var="item" items="${staffBooks}" varStatus="c">
<c:set var="pre_data" value="${pre_data}/${item.s_type}${item.s_desc}"/>
</c:forEach>
<%-- 끝 --%>

<script>

var past_history_template = "${past_history_template}";

var currentYear = parseInt("${curYear}")+1900;

var timeTable = [[,,,,,,,],[,,,,,,,],[,,,,,,,]];
//var timeTable = [['N','N','N','N','N','N','N','N'],['N','N','N','N','N','N','N','N'],['N','N','N','N','N','N','N','N']];

function checkTime(time,week){
	
	if(timeTable[time][week]=='Y'){
		timeTable[time][week]='N';
		//$('#'+time+'_'+week).html('');
		$('#'+time+'_'+week+" img").attr('src','${con.IMGPATH}/common/s_off.png');
	}
	else{
		timeTable[time][week]='Y';
		//$('#'+time+'_'+week).html('Y');
		$('#'+time+'_'+week+" img").attr('src','${con.IMGPATH}/common/s_on.png');
	}
}

$(document).ready(function(){
	
	var d = new Date();
	var y = d.getFullYear();
	var options_str = "";
	for(;y >= 1900; y--){
		options_str += ("<option value=\""+y+"\">"+y+"</option>");
	}
	var options = $(options_str);
	
	$('[name="start_date"]').append(options.clone());
	$('[name="end_date"]').append(options.clone());
	
	var earr = $('[name="start_date"]');
	var i = 0;
	for(i=0; i < earr.length; i++){
		
		var data = $(earr[i]).attr('init-data');
		if(data==""){
			continue;
		}
		var opt = $(earr[i]).find('[value="'+data+'"]');
		if(opt.length > 0){
			opt.attr('selected',true);
			$(earr[i]).parent().find('.ui-btn-text span').text(data);
		}
	}
	
	new AjaxFileUploader2('img_btn',{
		url:'ajaxStaffImgUpload.latte',
		success:function(map){
			openCropLayer($.parseJSON(map));
		},
		error:function(){}
	});
});

function mergeTimeTable(){
	
	var timestr = '';
	for(var ti = 0; ti < timeTable.length; ti++){
		for(var wi = 0; wi < timeTable[ti].length; wi++){
			if(timeTable[ti][wi]!='Y') timestr+='N';
			else timestr+='Y';
			if(wi==timeTable[ti].length-1){
				if(ti!=timeTable.length-1) timestr+='|';
			}else timestr+=';';
		}
	}
	
	return timestr;
}

/* 항목 추가시 붙일 아이디 */
var values = {
	historyId:parseInt("${fn:length(staffHistory)}"),
	careerId:parseInt("${fn:length(staffCareer)}"),
	booksId:parseInt("${fn:length(staffBooks)}")
};

function createDateOptions(){
	
	var d = new Date();
	var y = d.getFullYear();
	var options_str = "";
	for(;y >= 1900; y--){
		options_str += ("<option value=\""+y+"\">"+y+"</option>");
	}
	return $(options_str);
}

function addHistoryItem(){
		
	var item = $(past_history_template.replace(/\\$id\\$/g,''+values.historyId));
	item.find('select').append(createDateOptions().clone());
	
	values.historyId++;
	
	//$('#history_list').append($(past_history_template.replace(/\\$id\\$/g,''+values.historyId)));
	$('[selector-name="history_item"]:last').after(item);
//	$('#history_list').append($tag);
	$('#history_list').trigger('create');
}

function addCareerItem(){
		
	var $tag = $('<div id="c_item'+values.careerId+'" selector-name="career_item">'
		+'<input type="hidden" name="type" value="${codes.STAFF_PAST_CAREER}"/>'
		+'<input type="hidden" name="end_date""/>'
		+'<div class="area00" style="margin:10px 35px 0 0;">'
			+'<div class="btn_select02" style=" float:left; width:30%;">'
				+'<a data-role="button" >'
				+'<select name="start_date" data-icon="false">'
					+'<option value="">선택 안 함</option>'
				+'</select>'
				+'</a>'
				+'<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>'
			+'</div>'
		+'</div>'
		+'<div class="area00" style="padding:5px 110px 0 0;">'
			+'<p class="input01"><input type="text" name="desc" value=""></p>'
			+'<p class="btn_admin01 abs_r03"><a onclick="switchItem(\'c_item'+values.careerId+'\',\'previous\')" data-role="button"><img src="${con.IMGPATH}/btn/btn_t.png" alt="" width="31" height="31" /></a></p>'
			+'<p class="btn_admin01 abs_r02"><a onclick="switchItem(\'c_item'+values.careerId+'\',\'next\')" data-role="button"><img src="${con.IMGPATH}/btn/btn_b.png" alt="" width="31" height="31" /></a></p>'
			+'<p class="btn_admin01 abs_r01"><a onclick="removeItem(\'c_item'+values.careerId+'\')" data-role="button"><img src="${con.IMGPATH}/btn/btn_d.png" alt="" width="31" height="31" /></a></p>'
		+'</div>'
	+'</div>');
	
	$tag.find('select').append(createDateOptions().clone());
	
	values.careerId++;
	
	$('[selector-name="career_item"]:last').after($tag);
	$('#career_list').trigger('create');
}

function addBooksItem(){
		
	var $tag = $('<div id="b_item'+values.booksId+'" selector-name="books_item">'
		+'<input type="hidden" name="type" value="${codes.STAFF_PAST_BOOKS}"/>'
		+'<input type="hidden" name="start_date"/>'
		+'<input type="hidden" name="end_date"/>'
		+'<div class="area00" style="padding:5px 110px 0 0;">'
			+'<p class="input01"><input type="text" name="desc" value=""></p>'
			+'<p class="btn_admin01 abs_r03"><a onclick="switchItem(\'b_item'+values.booksId+'\',\'previous\')" data-role="button"><img src="${con.IMGPATH}/btn/btn_t.png" alt="" width="31" height="31" /></a></p>'
			+'<p class="btn_admin01 abs_r02"><a onclick="switchItem(\'b_item'+values.booksId+'\',\'next\')" data-role="button"><img src="${con.IMGPATH}/btn/btn_b.png" alt="" width="31" height="31" /></a></p>'
			+'<p class="btn_admin01 abs_r01"><a onclick="removeItem(\'b_item'+values.booksId+'\')" data-role="button"><img src="${con.IMGPATH}/btn/btn_d.png" alt="" width="31" height="31" /></a></p>'
		+'</div>'
	+'</div>');
	
	$tag.find('select').append(createDateOptions().clone());
	
	values.booksId++;
	
	$('[selector-name="books_item"]:last').after($tag);
	$('#books_list').trigger('create');
}
function switchItem(id, type){
	if( type == 'previous' ){
		if( $('#'+id).prev().hasClass('items') ){
			$('#'+id).insertBefore($('#'+id).prev());
		}
	}else if( type == 'next'){
		if( $('#'+id).next().hasClass('items') ){
			$('#'+id).insertAfter($('#'+id).next());
		}
	}
}
function removeItem(id){
	
	$('#'+id).remove();
}

function saveInfo(){
	
	//if(!confirm('내용을 저장하시겠습니까?'))
	//	return;
	
	$.ajax({
		type:'POST',
		url:'ajaxSaveStaffInfo.latte',
		data:$('#form1').serialize()+'&working_time='+mergeTimeTable()+'&'+$('#form2').serialize(),
		dataType:'json',
		success:function(response,status,xhr){
			
			//alert(response.result+" ${codes.SUCCESS_CODE}");
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				alert('저장되었습니다.');
				goPage('staffHome.latte?cmid='+$('#category').val());
			}
			else
				alert('저장 도중 오류가 발생하였습니다. '+response.result);
		},
		error:function(xhr,status,error){
			
			alert("실패하였습니다.\n"+status+"\n"+error);
		}
	});
}

var pre_data = '${pre_data}';
var new_data = '';

function createNewData(){
	
	new_data = '/'+$("[name='name']").val();
	new_data += '/'+$("[name='position']").val();
	new_data += '/'+$("[name='specialty']").val();
	new_data += '/'+$("[name='iid']").val();
	new_data += '/'+$("[name='timetable_status']").val();
	new_data += '/'+mergeTimeTable();
	new_data += '/'+$("[name='history_status']").val();
	
	var len = $('#history_list > div').length;
	
	for(var i = 0; i < len; i++){
		
		new_data+="/";
		new_data+=$($('#history_list > div')[i]).find("[name='type']").val();
		new_data+=$($('#history_list > div')[i]).find("[name='start_date']").val();
		new_data+=$($('#history_list > div')[i]).find("[name='end_date']").val();
		new_data+=$($('#history_list > div')[i]).find("[name='desc']").val();
	}
	
	new_data += '/'+$("[name='career_status']").val();
	
	len = $('#career_list > div').length;
	
	for(var i = 0; i < len; i++){
		
		new_data+="/";
		new_data+=$($('#career_list > div')[i]).find("[name='type']").val();
		new_data+=$($('#career_list > div')[i]).find("[name='start_date']").val();
		new_data+=$($('#career_list > div')[i]).find("[name='desc']").val();
	}
	
	new_data += '/'+$("[name='books_status']").val();
	
	len = $('#books_list > div').length;
	
	for(var i = 0; i < len; i++){
		
		new_data+="/";
		new_data+=$($('#books_list > div')[i]).find("[name='type']").val();
		new_data+=$($('#books_list > div')[i]).find("[name='desc']").val();
	}
}

function cancel(){
	
	/* 데이터 변경점 검사 */

	createNewData();
	
	if(pre_data==new_data || (pre_data!=new_data && confirm('변경된 내용이 있습니다.\n작성을 취소하시겠습니까?'))){

		goPage('cancelImgUpload.latte?redirectPage=staffHome.latte');
	}
}


function imageUpdate(targetId,imgsrc,iid){
	
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
	
	$.ajax({
		type:'POST',
		async:false,
		url:'ajaxRemoveStaffInfo.latte',
		data:{stid:$('#stid').val()},
		dataType:'json',
		success:function(response,status,xhr){
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				alert('삭제되었습니다.');
				goPage('staffHome.latte?cmid='+$('#category').val());
			}
			else
				alert('실패하였습니다. '+response.result);
		},
		error:function(xhr,status,error){
			
			alert("실패하였습니다.\n"+status+"\n"+error);
		}
	});
}

</script>

</head>
<body>
		
	<div data-role="page">
	
		<jsp:include page="/common/admin/hospital/INC_IMAGE_CROP.jsp"></jsp:include>
		
		<jsp:include page="../include/main_title_bar.jsp">
			<jsp:param name="back_function" value="cancel"/>
		</jsp:include>
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
			
			<!-- 메인메뉴 tab -->
			<jsp:include page="../include/main_menu.jsp"/>
			
			<form id="form1">
			
			<input type="hidden" id="stid" name="stid" value="${params.stid}"/>
			<input type="hidden" id="iid" name="iid" value="${staffInfo.s_iid}">
			
			<!-- 스탭 등록 시작-->
			<div class="a_type02_b">
				<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />스탭 등록</h3>
				<div class="btn_select02 mt05">
					<a data-role="button" >
					<select id="category" name="category" data-icon="false">
						<c:forEach var="item" items="${staffMenu}" varStatus="c">
							<option value="${item.s_cmid}" <c:if test="${staffInfo.s_category eq item.s_cmid}">selected="selected"</c:if>>${item.s_name}</option>
						</c:forEach>
					</select>
					</a>
					<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
				</div>
				<div class="dl_type01">
					<dl class="mt10">
						<dt>이름</dt>
						<dd><p class="input01"><input type="text" name="name" value="${staffInfo.s_name}"></p></dd>
					</dl>
					<dl class="mt05">
						<dt>직책</dt>
						<dd><p class="input01"><input type="text" name="position" value="${staffInfo.s_position}"></p></dd>
					</dl>
					<dl class="mt05">
						<dt>진단과</dt>
						<dd><p class="input01"><input type="text" name="specialty" value="${staffInfo.s_specialty}"></p></dd>
					</dl>
				</div>
			</div>
			<!-- //스탭 등록 끝-->
			
			</form>
			
			<form id="uploadForm" name="uploadForm" method="post" enctype="multipart/form-data"></form>
			
			<!-- 프로필이미지 등록 시작-->
			<div class="a_type02_b">
				<div class="dl_type01">
					<dl class="he">
						<dt>프로필 이미지</dt>
						<dd style="margin:0 0 0 205px; position:relative;">
							<p class="btn_gray" id="img_btn"><a href="index.html" data-role="button">찾아보기</a>
							<!-- <div id="file_btn_parent" style="position:absolute; overflow:hidden; top:0; left:0; height:100%; width:100%; z-index:1;">
								<input type="file" id="file_btn" name="image" style="width:100%; height: 100%; cursor:pointer; font-size: 500px; opacity:0; filter:alpha(opacity=0);" onchange="uploadImage();"/>
							</div> -->
						</dd>
						<dd style="margin:5px 0 0 205px;">*권장사이즈 : 150px * 200px</dd>
						<dd class="thum"><img id="img" src="<c:choose><c:when test="${empty staffInfo.image_path}">${con.IMGPATH}/contents/no_doc.png</c:when><c:otherwise>${con.img_dns}${staffInfo.image_path}</c:otherwise></c:choose>" alt="" width="75" height="100"/></dd>
					</dl>
				</div>
			</div>
			<!-- //프로필이미지 등록 끝-->
			
			<form id="form2">
			
			 <!-- 진료일정 시작-->
			<div class="a_type02_b">
				<input type="hidden" id="timetable_status" name="timetable_status" value="${staffInfo.TIMETABLE_STATUS}"/>
				<h3>
					진료일정
					<p class="checkbox po_r02" style=" width:70px;">
						<input type="checkbox" id="checkbox-c1" value="c-1" onclick="checkbox(this,'timetable_status');" <c:if test="${staffInfo.TIMETABLE_STATUS eq 'Y'}">checked="checked"</c:if>/>
						<label for="checkbox-c1">사용함</label>
					</p>
				</h3>
				<table  class="table_type01 mt10">
					<colgroup>
						<col width="*" /><col width="12%" /><col width="12%" /><col width="12%" /><col width="12%" /><col width="12%" /><col width="12%" /><col width="12%" />
					</colgroup>
					<tr>
						<th></th>
						<th>월</th>
						<th>화</th>
						<th>수</th>
						<th>목</th>
						<th>금</th>
						<th class="sat">토</th>
						<th class="sun">일</th>
					</tr>
					<c:set var="time_area" value="<%= new String[3][7] %>"/>
					<c:set var="term" value="${fn:split(staffInfo.s_working_time,'|')}"/>
					<c:forEach begin="0" end="${fn:length(time_area)-1}" varStatus="c">
						<tr>
						<td>
							<c:if test="${c.count==1}">오전</c:if>
							<c:if test="${c.count==2}">오후</c:if>
							<c:if test="${c.count==3}">야간</c:if>
						</td>
						<c:set var="week" value="${fn:split(term[c.index],';')}"/>
							<c:forEach begin="0" end="${fn:length(time_area[c.index])-1}" varStatus="w"><td id="${c.index}_${w.index}"><a onclick="checkTime(${c.index},${w.index});" data-role="button"><img src="${con.IMGPATH}/common/s_off.png" alt="" width="9" height="9" /></a></td>
							<c:if test="${week[w.index] eq 'Y'}"><script>checkTime('${c.index}','${w.index}');</script></c:if>
							</c:forEach>
						</tr>
					</c:forEach>
				</table>
				<p class="txt_gray11 mt10">* 업무 시간대를 터치하시면 <span class="red">ON/OFF</span>를 선택할 수 있습니다.</p>
			</div>
			<!-- //진료일정 끝-->
			
			<!-- 이력사항 시작-->
			<div class="a_type02_b" id="history_list">
				<input type="hidden" id="history_status" name="history_status" value="${staffInfo.HISTORY_STATUS}"/>
				<h3 selector-name="history_item">
					이력사항
					<p class="checkbox po_r02" style=" width:70px;">
						<input type="checkbox" id="checkbox-c2" value="c-2" onclick="checkbox(this,'history_status');" <c:if test="${staffInfo.HISTORY_STATUS eq 'Y'}">checked="checked"</c:if>/>
						<label for="checkbox-c2">사용함</label>
					</p>
				</h3>
				<jsp:include page="past_history_template.jsp"/>
				<p class="btn_gray02 mt10" style="width:100px"><a onclick="addHistoryItem();" data-role="button">추가</a></p>
			</div>
			<!-- //이력사항 끝-->
			
			<!-- 학회활동 및 논문발표 시작-->
			<div class="a_type02_b" id="career_list">
				<input type="hidden" id="career_status" name="career_status" value="${staffInfo.CAREER_STATUS}"/>
				<h3 selector-name="career_item">
					학회활동 및 논문발표
					<p class="checkbox po_r02" style=" width:70px;">
						<input type="checkbox" id="checkbox-c3" value="c-3" onclick="checkbox(this,'career_status');" <c:if test="${staffInfo.CAREER_STATUS eq 'Y'}">checked="checked"</c:if>/>
						<label for="checkbox-c3">사용함</label>
					</p>
				</h3>
				<c:forEach var="item" items="${staffCareer}" varStatus="c">
				<div id="c_item${c.index}" selector-name="career_item" class="items">
					<input type="hidden" name="type" value="${item.s_type}"/>
					<input type="hidden" name="end_date" value="${item.d_end_date}"/>
					<div class="area00" style="margin:10px 35px 0 0;">
						<div class="btn_select02" style=" float:left; width:30%;">
							<c:set var="ymdhms" value="${fn:split(item.d_start_date,' ')}"/>
							<c:set var="year" value="${fn:split(ymdhms[0],'-')[0]}"/>
							<a data-role="button" >
							<select name="start_date" data-icon="false" init-data="${year}">
								<option value="">선택 안 함</option>
							</select>
							</a>
							<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
						</div>
					</div>
					<div class="area00" style="padding:5px 110px 0 0;">
						<p class="input01"><input type="text" name="desc" value="${item.s_desc}"></p>
						<p class="btn_admin01 abs_r03"><a onclick="switchItem('c_item${c.index}','previous')" data-role="button"><img src="${con.IMGPATH}/btn/btn_t.png" alt="" width="31" height="31" /></a></p>
						<p class="btn_admin01 abs_r02"><a onclick="switchItem('c_item${c.index}','next')" data-role="button"><img src="${con.IMGPATH}/btn/btn_b.png" alt="" width="31" height="31" /></a></p>
						<p class="btn_admin01 abs_r01"><a onclick="removeItem('c_item${c.index}')" data-role="button"><img src="${con.IMGPATH}/btn/btn_d.png" alt="" width="31" height="31" /></a></p>
					</div>
				</div>
				</c:forEach>
				<p class="btn_gray02 mt10" style="width:100px"><a onclick="addCareerItem();" data-role="button">추가</a></p>
			</div>
			<!-- //학회활동 및 논문발표 끝-->
			
			<!-- 저서 시작-->
			<div class="a_type02_b" id="books_list">
				<input type="hidden" id="books_status" name="books_status" value="${staffInfo.BOOKS_STATUS}"/>
				<h3 selector-name="books_item">
					저서
					<p class="checkbox po_r02" style=" width:70px;">
						<input type="checkbox" id="checkbox-c4" value="c-4" onclick="checkbox(this,'books_status');" <c:if test="${staffInfo.BOOKS_STATUS eq 'Y'}">checked="checked"</c:if>/>
						<label for="checkbox-c4">사용함</label>
					</p>
				</h3>
				<c:forEach var="item" items="${staffBooks}" varStatus="c">
				<div id="b_item${c.index}" selector-name="books_item" class="items">
					<input type="hidden" name="type" value="${item.s_type}"/>
					<input type="hidden" name="start_date" value="${item.d_start_date}"/>
					<input type="hidden" name="end_date" value="${item.d_end_date}"/>
					<div class="area00" style="padding:5px 110px 0 0;">
						<p class="input01"><input type="text" name="desc" value="${item.s_desc}"></p>
						<p class="btn_admin01 abs_r03"><a onclick="switchItem('b_item${c.index}','previous')" data-role="button"><img src="${con.IMGPATH}/btn/btn_t.png" alt="" width="31" height="31" /></a></p>
						<p class="btn_admin01 abs_r02"><a onclick="switchItem('b_item${c.index}','next')" data-role="button"><img src="${con.IMGPATH}/btn/btn_b.png" alt="" width="31" height="31" /></a></p>
						<p class="btn_admin01 abs_r01"><a onclick="removeItem('b_item${c.index}')" data-role="button"><img src="${con.IMGPATH}/btn/btn_d.png" alt="" width="31" height="31" /></a></p>
					</div>
				</div>
				</c:forEach>
				<p class="btn_gray02 mt10" style="width:100px"><a onclick="addBooksItem();" data-role="button">추가</a></p>
			</div>
			<!-- //저서 끝-->
			
			</form>
			
			<c:choose>
			<c:when test="${empty params.stid}">
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
			
			<%-- <c:choose>
			<c:when test="${empty params.stid}">
			<div>
				<div style="float:left; padding:10px;"><a data-role="button" onclick="cancel();" style="padding:10px;">취소</a></div>
				<div style="float:left; padding:10px;"><a data-role="button" onclick="saveInfo();" style="padding:10px;">저장</a></div>
			</div>
			</c:when>
			<c:otherwise>
			<div>
				<div style="float:left; padding:10px;"><a data-role="button" onclick="remove();" style="padding:10px;">삭제</a></div>
				<div style="float:left; padding:10px;"><a data-role="button" onclick="cancel();" style="padding:10px;">취소</a></div>
				<div style="float:left; padding:10px;"><a data-role="button" onclick="saveInfo();" style="padding:10px;">수정</a></div>
			</div>
			</c:otherwise>
			</c:choose> --%>
			
			
		</div>
		<!-- ///// content 끝-->
		
		<jsp:include page="../home/copyright.jsp"/>

	</div>

</body>
</html>