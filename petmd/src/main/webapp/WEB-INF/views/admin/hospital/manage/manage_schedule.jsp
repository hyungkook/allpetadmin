<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%-- <jsp:include page="temp_INC_JSP_HEADER.jsp" /> --%>
<jsp:include page="../include/total_header.jsp"/>
<%-- <jsp:include page="../include/title_header.jsp" /> --%>

<script src="${con.JSPATH}/dateFunctions.js"></script>

<jsp:include page="calendar.jsp"/>

<script>

function afterCreateCalendar(){
	
	curDateUpdate(currentDate);
	if(view_type=='month'){
		getDDayList(_y+"-"+twoDigits(_m));
	}
}

function curDateUpdate(d){
	
	if(d!=null){
		currentDate = d;
	
		var y = d / 10000;
		$('#year').val(y - y % 1);
		var m = (d % 10000) / 100;
		$('#month').val(m = m - m % 1);
		$('#day').val(d % 100);
		$('#todo_date').html($('#year').val()+"년 "+$('#month').val()+"월 "+$('#day').val()+"일");
	}
}

function selectDate(d){//year, month, day){
	
	if(d!=null){
		
		currentDate = d;
		
		var y = d / 10000;
		$('#year').val(y - y % 1);
		var m = (d % 10000) / 100;
		$('#month').val(m = m - m % 1);
		$('#day').val(d % 100);
		$('#todo_date').html($('#year').val()+"년 "+$('#month').val()+"월 "+$('#day').val()+"일");
		
		$('#schedule_calendar td').removeClass('on');
		$('#'+d).addClass('on');
		
		getDDayList(Math.floor(y - y % 1)+"-"+twoDigits(Math.floor(m))+"-"+twoDigits(d % 100));
	}
}

var year = '';
var month = '';
var pageNumber = 1;
var last_page = false;
var last_date = '';

function nextPage(){
	
	getDDayListCore(last_date);
}

function getDDayList(monthdate){
	
	last_page = false;
	last_date=monthdate;
	pageNumber = 1;
	
	getDDayListCore(monthdate);
}

function getDDayListCore(d){
	
	if(last_page){
		alert('마지막 페이지입니다.');
		return;
	}
	
	$.ajax({
		url:'ajaxMyPageSchedule.latte',
		type:"POST",
		data:{
			date:d,
			view_type:view_type,
			pageNumber:pageNumber
		},
		success:function(response, status, xhr){
			
			var t = $(response);
			var temp_parent = $('<div/>').append(t);
			var p = temp_parent.find('[data-param-name="result"]').detach();
			
			if(pageNumber==parseInt(p.attr('data-result-pagecount'))){
				last_page = true;
			}
			
			var phone = t.find('#phone');
			for(var pi=0;pi<phone.length;pi++){
				$(phone[pi]).html(formatPhoneNumber($(phone[pi]).html(),'-'));
			}
			
			if(pageNumber==1){
				//$('#ddaylist li').remove();
				$('#ddaylist').empty();
			}
			
			if(temp_parent.find('li').length > 0){
				
				$('#ddaylist').append(temp_parent.find('li').detach());
				$('#ddaylist').listview('refresh');
				
				pageNumber = pageNumber + 1;
			}else{
			}
			
			if($('#ddaylist li').length > 0){
				$('#no_schedule').hide();
				$('#ddaylist').show();
			}else{
				$('#no_schedule').show();
				$('#ddaylist').hide();
			}
		},
		error:function(xhr, status, error){
			
			alert(xhr+","+status+","+error);
		}
	});
}

var view_type = '${params.view_type}'; 

$(document).ready(function(){
	//$('#month_select').html(curNode.val);
	
	if(view_type!='day'){
		$('#type_day').hide();
	}
	
	var y = parseInt("${params.year}");
	var m = parseInt("${params.month}");
	initCalendar(y,m);
});

function moveTop(){

	$('html,body').animate( { 'scrollTop': 0 }, 'fast' );
}

function toggleType(){
	
	if(view_type=='month'){
		view_type='day';
		$('#ddaylist').empty();
		$('#ddaylist').hide();
		$('#type_day').show();
		
		if(currentDate!=null&&currentDate!=""&&!(typeof currentDate==='undefined')){
			var y = Math.floor(currentDate / 10000);
			var m = Math.floor((currentDate % 10000) / 100);
			getDDayList((y - y % 1)+"-"+twoDigits(m)+"-"+twoDigits(currentDate % 100));
		}
	}else{
		view_type='month';
		$('#type_day').hide();
		getDDayList(_y+"-"+twoDigits(_m));
	}
	
	if($('#ddaylist > div').length > 0){
		$('#no_schedule').hide();
	}else{
		$('#no_schedule').show();
	}
}

</script>

</head>
<body>

	<div id="page" data-role="page">
	
		<jsp:include page="../include/manage_title_bar.jsp">
			<jsp:param name="title_bar_title" value="스케줄 조회"/>
		</jsp:include>

		<!-- content 시작-->
		<div data-role="content" id="contents" style="overflow: hidden">
		
			<c:set var="pre_date" value=""/>
			
			<!-- 메인메뉴 tab -->
			<jsp:include page="../include/manage_menu.jsp">
				<jsp:param value="4" name="cur_manage_menu"/>
			</jsp:include>
			<!-- // tab 끝-->
			
			<%-- <c:forEach var="item" items="${monthList}">
				<script>
				if(dnode==null){
					dnode=new DateNode('${item.date}', null);
				}
				else{
					var d = dnode;
					dnode = new DateNode('${item.date}', d);
					d.setPost(dnode);
				}
				<c:if test="${item.date eq selectedDate}">curNode=dnode;</c:if>
				</script>
			</c:forEach> --%>
		
			<%-- <div class="mypage_header">
				<div class="back"><a data-role="button" data-rel="back"><img height="0" src="${con.IMGPATH}/btn/btn_back.png"/></a></div>
				스케줄
				<div class="menu1"><a data-role="button" onclick="goPage('myPageHome.latte');"><img height="0" src="${con.IMGPATH}/btn/btn_home.png"/></a></div>
			</div> --%>
			
			<!-- 스케줄 상단 시작-->
			<div class="schedule_top">
				<p class="btn_s_l"><a onclick="toggleType();" data-role="button"><img src="${con.IMGPATH}/btn/btn_s_l.png" alt="" width="35" height="35"/></a></p>
				<p class="btn_s_r"><a onclick="goPage('manageScheduleEdit.latte')" data-role="button"><img src="${con.IMGPATH}/btn/btn_s_r.png" alt="" width="35" height="35"/></a></p>
				<div class="date_tt">
					<h4 id="title">2014.01</h4>
					<p class="btn_l btn_arrow01"><a id="pre_btn" onclick="createPreMonthCalendar(null);" data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_l03.png" alt="" width="29" height="29"/></a></p>
					<p class="btn_r btn_arrow01"><a id="next_btn" onclick="createNextMonthCalendar(null);" data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_r03.png" alt="" width="29" height="29"/></a></p>
				</div>
			</div>
			<!-- 스케줄 상단 끝-->
			
			<%-- <div class="schedule_top">
				<div class="calendar">
					<a data-role="button" onclick="toggleType();"><img id="vtype_btn" src="${con.IMGPATH}/btn/btn_calendar.png" alt="" width="100%" height="100%" /></a>
				</div>
				<div class="add">
					<a data-role="button" onclick="goPage('myPageScheduleEdit.latte')"><img src="${con.IMGPATH}/btn/btn_plus.png" alt="" width="100%" height="100%" /></a>
				</div>
				<div class="center">
					<div class="paging">
						<p><a data-role="button" id="pre_btn" onclick="createPreMonthCalendar(null);"><img src="${con.IMGPATH}/btn/btn_arrow_l03.png" width="29" height="29"/></a></p>
						<span class="headline_white" id="title"></span>
						<p><a data-role="button" id="next_btn" onclick="createNextMonthCalendar(null);"><img src="${con.IMGPATH}/btn/btn_arrow_r03.png" width="29" height="29"/></a></p>
					</div>
				</div>
				
			</div> --%>
			
			<!-- <div id="type_day">
				<div class="calendar" id="schedule_calendar"></div> -->
			<div class="calendar_area" id="type_day">
				<table class="calendar" id="schedule_calendar">
				</table>
			</div>
				
				
			<!-- </div> -->
			
			<div class="a_type01" id="no_schedule" style="display:none;">
				<p style="padding:50px 0; font-size:large; color:#727272; text-align:center;">
				등록된 일정이 없습니다.
				</p>
			</div>
			
			<div style="overflow:hidden;" class="schedule_list">
				<ul id="ddaylist" data-role="listview" data-split-icon="gear" data-split-theme="d" style="overflow:hidden; padding:0; margin:0;">
					
					<%-- <jsp:include page="schedule_list_item.jsp"/> --%>
					
				</ul>
			</div>
			
			<!-- <div class="a_type02" id="ddaylist">
				
			</div> -->
			
			<!-- <div class="more_top_area01">
				<div class="more"><a data-role="button">더보기</a></div>
				<div class="top"><a data-role="button" onclick="moveTop();">맨위로</a></div>
			</div> -->
			
			<div class="btn_area02">
				<p class="btn_more" style="margin-right:80px;"><a data-role="button" onclick="nextPage();">더보기</a></p>
				<p class="btn_top btn_r" style="width:80px;"><a data-role="button" onclick="moveTop();">맨위로</a></p>
			</div>
			
			<%-- <div style="display:inline-block; width:70%;">
			<select id="month_select" onchange="getDDayList($(this).val());">
				<c:forEach var="item" items="${monthList}">
					<option value="${item.date}" <c:if test="${item.date eq selectedDate}">selected="selected"</c:if>>${item.date}</option>
				</c:forEach>
			</select>
			</div>
			
			<a onclick="goPage('myPageScheduleEdit.latte')">등록</a>
			
			<div id="ddaylist" style="margin:5px 5px;">
				<jsp:include page="schedule_list_item.jsp"/>
			</div> --%>
			
		</div>
		<!-- contents 끝 -->
		
		<jsp:include page="../include/simple_copyright.jsp"/>
		<%-- <jsp:include page="../include/mypage_footer.jsp"/> --%>
	
	</div>
	
<script>

//updateDateTags(_y,_m);

</script>

</body>
</html>