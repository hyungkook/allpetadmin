<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>

<jsp:include page="../include/total_header.jsp"/>

<script src="${con.JSPATH}/jquery.number.js"></script>

<script>

var user_name = '';
var uid = '';
var pre_uid = '';
var last_tag = '';

if(location.hash=='pet'||location.hash=='#pet'){
	history.back();
}

$(document).ready(function(){
	
	$('#pet_area').hide();
});

function checkbox(me,targetId){
	
	if($(me).is(':checked'))
		$('#'+targetId).val('Y');
	else
		$('#'+targetId).val('N');
}

var pageNumber = parseInt("${params.pageNumber}");
var totalPage = parseInt("${params.pageCount}");

$(document).ready(function(){
	
	var p = $('#user_list [data-sub-name="phone"]');
	
	for(var i=0; i < p.length; i++){
		$(p[i]).html(formatPhoneNumber($(p[i]).html(),'-'));
	}
});

function expand(){
	
	pageNumber++;
	if(pageNumber > totalPage){
		pageNumber = totalPage;
		alert('더 이상 항목이 없습니다.');
		$('#more_btn').css('visibility','hidden');
		return;
	}
	
	$.mobile.showPageLoadingMsg('a','목록을 불러오는 중입니다.');
	
	$.ajax({
		url:'pointHistory.latte<c:if test="${not empty params.period}">?period=${params.period}</c:if>',
		type:'POST',
		data:{pageNumber:pageNumber,
			period:'${params.period}'},
		dataType:'text',
		success:function(response,status,xhr){
			
			var t = $(response);
			
			<%-- 전화번호 하이픈 추가 --%>
			var p = t.find('[data-sub-name="phone"]');
			for(var i=0; i < p.length; i++){
				$(p[i]).html(formatPhoneNumber($(p[i]).html(),'-'));
			}
			<%-- 같은 유저가 check 되어 있을 경우 check --%>
			p = t;
			for(var i=0; i < p.length; i++){
				
				if($('#user_list [data-group-id="'+$(p[i]).attr('data-group-id')+'"] [type="checkbox"]').is(':checked')){
					$(p[i]).find('[type="checkbox"]').prop("checked",true);
				}
			}
			
			$('#user_list').append(t);
			
			$('#user_list').trigger('create');
			
			$.mobile.hidePageLoadingMsg();
			
			if(pageNumber >= totalPage){
				pageNumber = totalPage;
				$('#more_btn').css('visibility','hidden');
				return;
			}
			
		},
		error:function(xhr,status,error){
			
			$.mobile.hidePageLoadingMsg();
		}
	});
}

function moveTop(){
	
	$('html, body').animate( { 'scrollTop': 0 }, 'fast' );
}

function pageChange(type,page,id,val){
	
	$.ajax({
		url:'ajaxInnerPetList.latte',
		type:'POST',
		data:{
			uid:id,
			pageNumber:page,
			pagingBlockId:id,
			pagingSendValue:val
		},
		dataType:'text',
		success:function(response, status, xhr){
			
			$('#pet_list_inner'+id).empty();
			$('#pet_list_inner'+id).append(response);
		},
		error:function(xhr,status,error){
			alert(status+'\n'+error);
		}
	});
}

function openPetList(tag, id, name){
	
	uid = id;
	user_name = name;
	last_tag = tag;
	
	if(uid!=pre_uid){
		$.ajax({
			url:'ajaxInnerPetList.latte',
			type:'POST',
			data:{pagingSendValue:id,pagingBlockId:id},
			dataType:'text',
			success:function(response, status, xhr){
				
				pre_uid = uid;
				
				$('#pet_area').empty();
				$('#pet_area').append(response);
				
				var s = $('#pet_area #user_name span').detach();
				$('#pet_area #user_name').text(user_name);
				$('#pet_area #user_name').append(s);
				
				location.hash='#pet';
			},
			error:function(xhr,status,error){
				alert(status+'\n'+error);
			}
		});
		
	}
	else{
		location.hash='#pet';
	}
}

function back(){
	
	if($('#pet_area').is(':visible')){
		$('#pet_area').hide();
		$('#history_area').show();
		manage_title_icon_change('home');
		history.back();
	}
	else{
		goPage('hospitalHome.latte');
	}
}

$(window).on('hashchange',function(){
	
	if(location.hash=='pet'||location.hash=='#pet'){
		if(!$('#pet_area').is(':visible')){
			$('#history_area').hide();
			$('#pet_area').show();
			manage_title_icon_change('back');
			moveTop();
		}
	}
	else{
		if($('#pet_area').is(':visible')){
			$('#pet_area').hide();
			$('#history_area').show();
			manage_title_icon_change('home');
			$('html, body').animate( { 'scrollTop': $(last_tag).offset().top }, 'fast' );
		}
	}
});

function setPayMode(val){
	goPage('managePoint.latte?type='+val);
}

function toggleAllcheck(){
	
	if($('#checkbox-c1').is(':checked')){
		
		$('#user_list [type="checkbox"]').prop("checked",true).checkboxradio("refresh");
	}
	else{
		
		$('#user_list [type="checkbox"]').prop("checked",false).checkboxradio("refresh");
	}
}

function groupCheck(me,group_id){
	
	if($(me).is(':checked')){
		
		$('#user_list [data-group-id="'+group_id+'"] [type="checkbox"]').prop("checked",true).checkboxradio("refresh");
	}
	else{
		
		$('#user_list [data-group-id="'+group_id+'"] [type="checkbox"]').prop("checked",false).checkboxradio("refresh");
	}
}

function goSchedule(){
	
	var arr = new Array();
	var params = "";
	
	var userCount = ($('#user_list [type="checkbox"]').length-1);
	
	for(var i = 1; i < userCount; i++){
		
		if($($('#user_list [type="checkbox"]')[i]).is(':checked')){
			//alert(i+1);
			if(arr[$('#id'+i).val()]==null){
				arr[$('#id'+i).val()]=$('#id'+i).val();
				if(params=="")
					params+=(''+$('#id'+i).val());
				else
					params+=('&'+$('#id'+i).val());
			}
		}
	}
	
	$('#ids').val(params);
	document.scheduleForm.submit();
	
	return;
	
	var userCount = ($('#user_list > li').length-1) / 2;
	
	var arr = new Array();
	var params = "";
	
	for(var i = 0; i < userCount; i++){
		
		if($('#check'+i).is(':checked')){
			//console.log(arr[$('#id'+i).val()]);
			if(arr[$('#id'+i).val()]==null){
				arr[$('#id'+i).val()]=$('#id'+i).val();
				if(params=="")
					params+=(''+$('#id'+i).val());
				else
					params+=('&'+$('#id'+i).val());
			}
		}
	}
	
	
	//goPage('manageScheduleEdit.latte'+params);
}

</script>
</head>

<body>
		
	<div data-role="page">
		
		<jsp:include page="../include/manage_title_bar.jsp">
			<jsp:param name="title_bar_title" value="포인트출납 및 회원관리"/>
			<jsp:param name="title_btn_icon" value="home"/>
			<jsp:param name="back_function" value="back"/>
		</jsp:include>
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
		
			<!-- 메인메뉴 tab -->
			<jsp:include page="../include/manage_menu.jsp">
				<jsp:param value="3" name="cur_manage_menu"/>
			</jsp:include>
			<!-- // tab 끝-->
			
			<div id="history_area">
				<div class="a_type01_b">
					<div class="btn_select02">
						<a data-role="button" >
						<select data-icon="false" onchange="setPayMode($(this).val());">
							<option value="pay">포인트 지급</option>
							<option value="return">포인트 회수</option>
							<option value="history" selected="selected">포인트 이력 및 회원관리</option>
						</select>
						</a>
						<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
					</div>
				</div>
				
				<div class="a_type01">
				
					<div class="btn_select02">
						<a data-role="button" >
						<select onchange="goPage('pointHistory.latte?period='+$(this).val());" data-icon="false">
							<option value="7" <c:if test="${params.period eq '7'}">selected="selected"</c:if>>최근 1주일</option>
							<option value="30" <c:if test="${params.period eq '30'}">selected="selected"</c:if>>최근 1달</option>
							<option value="90" <c:if test="${params.period eq '90'}">selected="selected"</c:if>>최근 3달</option>
						</select>
						</a>
						<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
					</div>
					
					<div class="p_list mt10">
						<ul id="user_list">
							<li class="p_top">
								<p class="cb checkbox" style="width:24px;">
									<input type="checkbox" id="checkbox-c1" value="c-1" onclick="toggleAllcheck();"/>
									<label for="checkbox-c1">&nbsp;</label>
								</p>
								<h4>총 <span class="orange"><fmt:formatNumber value="${params.totalCount}" pattern="#,###"/></span>건</h4>
								<p class="btn01 btn_gray03"><a onclick="goSchedule();" data-role="button">스케줄</a></p>
								<!-- <p class="btn02 btn_gray03"><a href="index.html" data-role="button">SMS</a></p> -->
							</li>
							<jsp:include page="user_inner.jsp"/>
						</ul>
					</div>
				
				</div>
				
				<div class="btn_area02">
					<p class="btn_more" id="more_btn" style="margin-right:80px;"><a onclick="expand()" data-role="button">더보기</a></p>
					<p class="btn_top btn_r" style="width:80px;"><a onclick="moveTop();" data-role="button">맨위로</a></p>
				</div>
				
				<form name="scheduleForm" method="post" action="manageScheduleEdit.latte">
				<input type="hidden" id="ids" name="ids"/>
				</form>
			</div>
			
			<div id="pet_area">
			</div>
			
		</div>
	
	</div>

</body>
</html>