<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/views/admin/hospital/include/INC_JSP_HEADER.jsp"/>

<title>스케줄</title>

<script src="${con.JSPATH}/dateFunctions.js"></script>
<script src="${con.JSPATH}/jquery.number.js"></script>

<style>

.calrendar_cell_header {display:table-cell; width:100px; border:1px solid #aaaaaa; margin:0px; padding:5px; background-color:#eeeeee; text-align:center;}

.calendar_normal_cell {border-spacing:1px; display:table-cell; width:100px; height:70px; border:1px solid #aaaaaa; margin:0px; padding:3px; background-color:#ffffff; position:relative;}
.calendar_sat_cell {display:table-cell; width:100px; height:70px; border:1px solid #aaaaaa; margin:0px; padding:3px; background-color:#ddeeff; position:relative;}
.calendar_holiday_cell {display:table-cell; width:100px; height:70px; border:1px solid #aaaaaa; margin:0px; padding:3px; background-color:#ffcccc; position:relative;}
.calendar_outer_normal_cell {display:table-cell; width:100px; height:70px; border:1px solid #aaaaaa; margin:0px; padding:3px; background-color:#fafafa; color:#aaaaaa; position:relative;}
.calendar_outer_sat_cell {display:table-cell; width:100px; height:70px; border:1px solid #aaaaaa; margin:0px; padding:3px; background-color:#ccddff; color:#aaaaaa; position:relative;}
.calendar_outer_holiday_cell {display:table-cell; width:100px; height:70px; border:1px solid #aaaaaa; margin:0px; padding:3px; background-color:#eecccc; color:#aaaaaa; position:relative;}

</style>

<script>

var _y = parseInt("${params.year}");
var _m = parseInt("${params.month}");

if(_m < 10)
	_m = parseInt("0"+_m);

var dayoftheweek = ['월','화','수','목','금','토','일'];

var startLimit = 0;//20130915;
var endLimit = 99999999;//20131115;

var disableMap = new Array();

var scheduleMap;

var cacheKey = "";

function createCalendar(year,month,anniversary){
	
	var pre_year = year;
	var pre_month = month-1;
	var next_year = year;
	var next_month = month+1;
	
	if(pre_month<1){
		pre_month=12;
		pre_year--;
	}
	
	if(next_month>12){
		next_month=1;
		next_year++;
	}
	
	var searchKey = year;
	
	// 연단위로 받아옴
	if(cacheKey != searchKey){
		cacheKey = searchKey;
		
		// 동기식으로 휴일/스케줄 정보를 받아옴.
		$.ajax({
			type:'POST',
			async:false,
			url:'ajaxRequestAnniversary.latte',
			data:{month:year+"-"+twoDigits(month)},
			dataType:'text',
			success:function(response, status, xhr){
				
				var json = $.parseJSON(decodeURIComponent(response));
				
				/* scheduleMap = new Array();
				
				for(var i = 0; i < json.length; i++){
					scheduleMap[json[i].d] = json[i];
				} */
				
				scheduleMap= json;
				
				//disableMap['20131022']='e';
			},
			error:function(xhr, status, error){
				
				alert(status+","+error);
			}
		});
	}
	
	var first = 6; // 0 = monday, 6 = sunday
	
	var ml = getLastDate(year,month);
	var pre_ml = getLastDate(pre_year,pre_month);
	var week = getFirstDateWeek(year,month);
	var map = scheduleMap;
	
	//console.log(ml+","+week);
	var tag = '<div style="display:table-row;">';
	/* for(var i = first; i != (first+6)%7; i=(i+1)%7){
		tag+='<div class="calrendar_cell">'+dayoftheweek[i]+'</div>';
		console.log("h"+i);
	} */
	var row;
	for(var i = 0; i < 7; i++){
		if((i+first)%7==6)
			tag+='<div class="calrendar_cell_header">'+dayoftheweek[(i+first)%7]+'</div>';
		else
			tag+='<div class="calrendar_cell_header">'+dayoftheweek[(i+first)%7]+'</div>';
		//console.log("h"+(i+first)%7);
	}
	tag+='</div>';
	tag+='<div style="display:table-row;">';
	var tail = 0;
	if(week<first)
		tail = pre_ml - (week+7-first)+1;
	else
		tail = pre_ml - (week-first)+1;
	for(var i = first; i != (week)%7; i=(i+1)%7){
		var d = pre_year+twoDigits(pre_month)+twoDigits(tail);
		if(i==5)
			tag+='<div id="'+d+'" class="calendar_outer_sat_cell" onclick="createPreMonthCalendar('+d+')">'+tail+'</div>';
		else if(i==6)
			tag+='<div id="'+d+'" class="calendar_outer_holiday_cell" onclick="createPreMonthCalendar('+d+')">'+tail+'</div>';
		else
			tag+='<div id="'+d+'" class="calendar_outer_normal_cell" onclick="createPreMonthCalendar('+d+')">'+tail+'</div>';
		tail++;//createPreMonthCalendar(selectedDate)
		//console.log("b"+i);
	}
	for(var i = 0; i < ml; i++){
		week=week%7;
		//console.log("d"+i+","+week);
		if(week==first){
			tag+='</div>';
			tag+='<div style="display:table-row;">';
		}
		var d2 = year+"-"+twoDigits(month)+"-"+twoDigits(i+1);
		var d = year+twoDigits(month)+twoDigits(i+1);
		
		if(map[d]!=null){
			var cssclass = "calendar_normal_cell";
			var holiday = false;
			var reserved = false;
			var funstr = "";
			var scheduleCheck = "";
			var name = "";
			
			for(var j = 0; j < map[d].length; j++){
				if(map[d][j].type=='h'){
					cssclass = "calendar_holiday_cell";
					holiday = true;
					name += map[d][j].comment;
					//content += "type:h ";
				}
					//tag+='<div class="calendar_holiday_cell" onclick="act(\''+d+', '+map[d].comment+'\');">'+(i+1)+'<br/>'+map[d].comment+'</div>';
				else if(map[d][j].type=='s'){
					reserved = true;
					scheduleCheck = "<br/>&nbsp;&nbsp;&nbsp;V";
					//tag+='<div class="calendar_normal_cell" onclick="act(\''+d+', 스케쥴\');">'+(i+1)+'</div>';
				}
			}
//			tag+='<div class="'+cssclass+'" onclick="act(\''+d+', '+content+'\');">'+(i+1)+'</div>';
			if(reserved){
				funstr = 'selectDate('+d+')';//'+year+','+twoDigits(month)+','+twoDigits(i+1)+');';//"openModifySchedule('"+d+"')";
			}
			else{
				funstr = 'selectDate('+d+')';//"openCreateSchedule('"+d+"')";
			}
			if(!holiday){
				cssclass = getCssClass(week,d);
			}
			tag+='<div id="'+d+'" class="'+cssclass+'" onclick="'+funstr+';">'+(i+1)+scheduleCheck+'<br/>'+name+'</div>';
		}
		else{
			tag+='<div id="'+d+'" class="'+getCssClass(week,d)+'" onclick="selectDate('+d+');">'+(i+1)+'</div>';
		}
		week++;
	}
	var head_d = 1;
	for(var i = week; i != first%7; i=(i+1)%7){
		var d = next_year+twoDigits(next_month)+twoDigits(head_d);
		if(i==6)
			tag+='<div id="'+d+'" class="calendar_outer_holiday_cell" onclick="createNextMonthCalendar('+d+')">'+head_d+'</div>';
		else if(i==5)
			tag+='<div id="'+d+'" class="calendar_outer_sat_cell" onclick="createNextMonthCalendar('+d+')">'+head_d+'</div>';
		else
			tag+='<div id="'+d+'" class="calendar_outer_normal_cell" onclick="createNextMonthCalendar('+d+')">'+head_d+'</div>';
		head_d++;
		//console.log("b"+i);
	}
	tag+='</div>';
	$('#schedule_calendar').append(tag);
	
	selectDate(currentDate);
	//alert('3243423');
}

function getCssClass(week, d){
	
	if(d > endLimit || d < startLimit)
		return "calendar_holiday_cell";
	else if(disableMap[d+""]=='e')
		return "calendar_holiday_cell";
	else if(week==5)
		return "calendar_sat_cell";
	else if(week==6)
		return "calendar_holiday_cell";
	else
		return "calendar_normal_cell";
	
	
}

function createPreMonthCalendar(selectedDate){
	
	_m--;
	if(_m==0){_y--;_m = 12;}
	
	$('#schedule_calendar').empty();
	createCalendar(_y,_m,'');
	
	updateDateTags(_y,_m);
	
	if(selectDate!=null){
		selectDate(selectedDate);
	}
}

function createNextMonthCalendar(selectedDate){
	
	_m++;
	if(_m==13){_y++;_m = 1;}
	
	$('#schedule_calendar').empty();
	createCalendar(_y,_m,'');
	
	updateDateTags(_y,_m);
	
	if(selectDate!=null){
		selectDate(selectedDate);
	}
}

function updateDateTags(cur_year,cur_month){
	
	$('#title').html(cur_year+'년 '+cur_month+'월');
	
	if(cur_month-1==0)
		$("#pre_btn").html((cur_year-1)+"년 12월");
	else
		$("#pre_btn").html(cur_year+"년 "+(cur_month-1)+"월");
	
	if(cur_month+1==13)
		$("#next_btn").html((cur_year+1)+"년 1월");
	else
		$("#next_btn").html(cur_year+"년 "+(cur_month+1)+"월");
}

onload = function(){

	createCalendar(_y,_m,'');
	
	var date = new Date();
	date.setFullYear(parseInt("${params.year}"),parseInt("${params.month}")-1,parseInt("${params.day}"));
	
	var defaultDate = date.format('yyyymmdd');
	
	var type = "${params.type}";
	
	if(type=="new"){
		openCreateSchedule(defaultDate);
	}
	else if(type=="modify"){
		openModifySchedule(defaultDate);
	}
};

function openCreateSchedule(d){
	
	$('#modify_common_area').show();
	$('#reg_btn_area').show();
	$('#modify_btn_area').hide();
	
	$('#comment').val('');
	selectDate(d);
}

function openModifySchedule(d){
	
	$('#modify_common_area').show();
	$('#reg_btn_area').hide();
	$('#modify_btn_area').show();
		
	$('#comment').val("${schedule.s_comment}");//getScheduleValue(d).comment);
	selectDate(d);
}

function transitionModifySchedule(){
	
	$('#reg_btn_area').hide();
	$('#modify_btn_area').show();
	
	$("#header_title").html("스케줄 변경");
}

function getScheduleValue(d){
	
	for(var j = 0; j < scheduleMap[d].v.length; j++){
		if(scheduleMap[d].v[j].type=='s'){
			return scheduleMap[d].v[j];
		}
	}
}

function reg_hour_up(){
	
	var h = $('#reg_hour').html();
	var hour = parseInt(h[0])*10+parseInt(h[1])+1;
	if(hour > 23)
		hour=23;
	$('#reg_hour').html(twoDigits(hour));
}

function reg_hour_down(){
	
	var h = $('#reg_hour').html();
	var hour = parseInt(h[0])*10+parseInt(h[1])-1;
	if(hour < 0)
		hour = 0;
	$('#reg_hour').html(twoDigits(hour));
}

function reg_minute_up(){
	
	var h = $('#reg_hour').html();
	var m = $('#reg_minute').html();
	var minute = parseInt(m[0])*10+parseInt(m[1])+10;
	if(minute > 50){
		var hour = parseInt(h[0])*10+parseInt(h[1])+1;
		if(hour > 23){
			hour=23;
			minute=50;
		}
		else
			minute=0;
		$('#reg_hour').html(twoDigits(hour));
	}
	$('#reg_minute').html(twoDigits(minute));
}

function reg_minute_down(){
	
	var h = $('#reg_hour').html();
	var m = $('#reg_minute').html();
	var minute = parseInt(m[0])*10+parseInt(m[1])-10;
	if(minute < 0){
		var hour = parseInt(h[0])*10+parseInt(h[1])-1;
		if(hour < 0){
			hour = 0;
			minute = 0;
		}
		else
			minute = 50;
		$('#reg_hour').html(twoDigits(hour));
	}
	$('#reg_minute').html(twoDigits(minute));
}

function reg_set_oclock(){
	
	$('#reg_minute').html("00");
}

function createSchedule(){
	
	if(isNoValue('comment')){
		alert('설명을 입력하세요.');
		return;
	}
	
//	alert($('#uid').val());
	alert(uidList);
	
	$.ajax({
		type:'POST',
		url:'ajaxRegSchedule.latte',
		data:{
			year:$('#year').val(),
			month:$('#month').val(),
			day:$('#day').val(),
			hour:$('#reg_hour').html(),
			minute:$('#reg_minute').html(),
			comment:$('#comment').val(),
			uid:uidList
		},
		dataType:'text',
		success:function(response, status, xhr){
			
			var json = $.parseJSON(response);
			
			if(json.result=='${codes.SUCCESS_CODE}'){
				
				showDialog('등록되었습니다.','default',function(){
					transitionModifySchedule();
					g_rownum = json.rownum;
				});
			}
			else{
				alert('등록에 실패하였습니다.\n에러코드:'+json.result);
			}
		},
		error:function(xhr, status, error){
			
			alert(status+","+error);
		}
	});
}

function modifySchedule(){
	
	if(isNoValue('comment')){
		alert('설명을 입력하세요.');
		return;
	}
	
	$.ajax({
		type:'POST',
		url:'ajaxUpdateSchedule.latte',
		data:{
			rownum:g_rownum,
			year:$('#year').val(),
			month:$('#month').val(),
			day:$('#day').val(),
			hour:$('#reg_hour').html(),
			minute:$('#reg_minute').html(),
			comment:$('#comment').val()
		},
		dataType:'text',
		success:function(response, status, xhr){
			
			var json = $.parseJSON(response);
			
			if(json.code=='${codes.SUCCESS_CODE}'){
				
				showDialog('수정되었습니다.','default',function(){
					goPage('myPageSchedule.latte');
				});
			}
			else{
				alert('수정에 실패하였습니다.\n에러코드:'+json.resultCode);
			}
		},
		error:function(xhr, status, error){
			
			alert(status+","+error);
		}
	});
}

function removeSchedule(){
	
	if(!confirm('스케줄을 삭제하시겠습니까?'))
		return;
	
	$.ajax({
		type:'POST',
		url:'ajaxRemoveSchedule.latte',
		data:{
			rownum:g_rownum
		},
		dataType:'json',
		success:function(response, status, xhr){
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				
				showDialog('삭제되었습니다.','default',function(){
					goPage('manageSchedule.latte');
				});
			}
			else{
				alert('삭제에 실패하였습니다.\n에러코드:'+response.result);
			}
		},
		error:function(xhr, status, error){
			
			alert(status+","+error);
		}
	});
}

var currentDate;
var g_rownum = "${params.rownum}";

function selectDate(d){//year, month, day){
	
	if(d!=null){
		currentDate = d;
	
		var y = d / 10000;
		$('#year').val(y - y % 1);
		var m = (d % 10000) / 100;
		$('#month').val(m = m - m % 1);
		$('#day').val(d % 100);
		$('#todo_date').html($('#year').val()+"년 "+$('#month').val()+"월 "+$('#day').val()+"일");
		
		//$('#smsList').find('th');
		var llen = $('#selectedLayer').length;
		var tlen = $('#'+d).length;
		
		if(llen==0 || tlen==0)
			$('#'+d).append("<div id='selectedLayer' style='width:100%; height:100%; filter:alpha(opacity=50); opacity:0.5; background-color:red; position:absolute; top:0; left:0; bottom:0; right:0;'></div>");
		else{
			var l = $('#selectedLayer').detach();
			$('#'+d).append(l);
		}
	}
}

var userList = new Array();
var listCnt = 0;
var itemCntLimit = 5;
var groupCntLimit = 5;
var curGroup = 1;

var uidList = '';
var rowList = '';

function searchUser(type,phone,id){
	
	$.ajax({
		url:'ajaxSearchUser.latte',
		type:'POST',
		data:{
			type:type,
			phone:phone,
			uid:id,
			aaa:[1,2,3]
		},
		dataType:'json',
		success:function(response, status, xhr){
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				
				
				//$('#user_list').empty();
				if(userList[response.uid]==null)
					userList[response.uid]=response.uid;
				else
					return;
				
				listCnt++;
				//$('#uid').val($('#uid').val()+($('#uid').val()==''?"":";")+response.uid);
				uidList = (uidList+(uidList==''?"":";")+response.uid);
				
				var $tag = $(
				'<div style="overflow:hidden;">'
					+'<div style="float:left;">'
						+'<div>'
							+'<p style="padding:10px;">'+decodeURIComponent(response.name)+' ('+formatPhoneNumber(response.cphone_number,'-')+')</p>'
						+'</div>'
					+'</div>'
					+'<div style="float:right;">'
						+'<a data-role="button" style="padding:10px;">X</a>'
					+'</div>'
					+'<div style="float:right;">'
						+'<p id="point${itemIndex}" style="padding:10px;">'+$.number(response.point_sum)+'</p>'
					+'</div>'
				+'<div>');
				
				$('#user_list').append($tag);
				$('#user_list').trigger('create');
				
				if(!$('#user_list_paging').is(':visible')){
					$('#user_list_paging').show();
				}
				else if(listCnt > (curGroup-1)*groupCntLimit*itemCntLimit && listCnt < curGroup*groupCntLimit*itemCntLimit){
					
					var page = Math.floor((listCnt-1) / itemCntLimit);
					alert(page);
				}
			}
			else
				alert('오류가 발생했습니다.\n'+response.result);
		},
		error:function(xhr,status,error){
			alert(status+'\n'+error);
		}
	});
}

</script>

</head>
<body>

	<div id="page" data-role="page" style="background: #f7f3f4; overflow: hidden; position:relative;">
	
		<jsp:include page="/common/admin/hospital/INC_INSTANCE_DIALOG.jsp"/>
		
		<c:if test="${empty appType}" >
		<!-- header 시작-->
		<div data-role="header" id="head" data-position="fixed" data-tap-toggle="false" data-theme="a">
			<h1 id="header_title">스케줄 <c:if test="${params.type eq \"new\"}">등록</c:if><c:if test="${params.type eq \"modify\"}">편집</c:if></h1>
			<!--<h1>검색 결과</h1>-->
			<a data-role="button" onclick="goPage('myPageSchedule.latte');"><img src="${con.IMGPATH_OLD}/btn/btn_back.png" alt="back" width="32" height="32"/>&nbsp;</a>
		</div>
		<!-- ///// header 끝-->
		</c:if>

		<!-- content 시작-->
		<div data-role="content" id="contents" style="overflow: hidden">
		
			<jsp:include page="../include/manage_menu1.jsp">
				<jsp:param value="2" name="curMainMenu"/>
			</jsp:include>
		
			<p>사용자 검색(휴대폰 번호로 검색하실 수 있습니다)</p>
			
			<div style="overflow:hidden">
				<div style="float:left; width:49%">
					<input type="text" id="phone">
				</div>
				<div style="float:left; width:49%">
					<a data-role="button" onclick="searchUser('',$('#phone').val(),'')" style="padding:10px;">검색</a>
				</div>
			</div>
			
			<p>숫자만 입력해 주세요</p>
			
			<div id="user_list">
				<jsp:include page="schedule_user_inner.jsp"/>
			</div>
			
			<input type="hidden" id="uid"/>
			
			<div class="list_num" id="user_list_paging">

				<span class="btn_num"><a onclick="prePageChange('prev','1','${pagingBlockId}','${pagingSendValue}');" data-role="button"><img src="${con.IMGPATH_OLD}/btn/btn_prev.png" alt="" width="7" height="10" style="padding-right:2px;"/></a></span>
				<span class="btn_num"><a onclick="prePageChange('prev','${pageGroupNumber * pageGroupSize + 1 - pageGroupSize}','${pagingBlockId}','${pagingSendValue}');" data-role="button"><img src="${con.IMGPATH_OLD}/btn/btn_prev.png" alt="" width="7" height="10" style="padding-right:2px;"/></a></span>
				<span id="user_list_paging_inner">
				<a onclick="prePageChange('cur','${pageGroupNumber * pageGroupSize + c.count}','${pagingBlockId}','${pagingSendValue}');"><span style="color:red;">${pageGroupNumber * pageGroupSize + c.count}</span></a>&nbsp;
				</span>
					<%-- <c:forEach begin="0" end="${curPageGroupSize-1}" varStatus="c">
						<c:if test="${pageGroupNumber * pageGroupSize + c.count <= params.pageCount}">
							<c:choose>
								<c:when test="${pageGroupNumber * pageGroupSize + c.count eq params.pageNumber}">
								&nbsp;<a onclick="prePageChange('cur','${pageGroupNumber * pageGroupSize + c.count}','${pagingBlockId}','${pagingSendValue}');"><span style="color:red;">${pageGroupNumber * pageGroupSize + c.count}</span></a>&nbsp;
								</c:when>
								<c:otherwise>
								&nbsp;<a onclick="prePageChange('cur','${pageGroupNumber * pageGroupSize + c.count}','${pagingBlockId}','${pagingSendValue}');"><span>${pageGroupNumber * pageGroupSize + c.count}</span></a>&nbsp;
								</c:otherwise>
							</c:choose>
						</c:if>
					</c:forEach> --%>
				<%-- <span class="num">${params.pageNumber} / ${params.pageCount}</span> --%>
				<span class="btn_num"><a onclick="prePageChange('next','${pageGroupNumber * pageGroupSize + 1 + curPageGroupSize}','${pagingBlockId}','${pagingSendValue}');" data-role="button"><img src="${con.IMGPATH_OLD}/btn/btn_next.png" alt="" width="7" height="10" style="padding-left:2px;"/></a></span>
				<span class="btn_num"><a onclick="prePageChange('next','${params.pageCount}','${pagingBlockId}','${pagingSendValue}');" data-role="button"><img src="${con.IMGPATH_OLD}/btn/btn_next.png" alt="" width="7" height="10" style="padding-left:2px;"/></a></span>
				
			</div>
			
			<script>
			$('#user_list_paging').hide();
			</script>
			
			<hr/>

			<span id="week"></span>
			
			<div>
				<div style="overflow:hidden; text-align:center;padding:10px;">
					<span id="title" style="font-size:20px; font-weight:bold;"></span>
					<a data-role="button" id="pre_btn" onclick="createPreMonthCalendar(null);" style="display:block; float:left; width:100px;">이전</a>
					<a data-role="button" id="next_btn" onclick="createNextMonthCalendar(null);" style="display:block; float:right; width:100px;">이후</a>
				</div>
			</div>
			
			<div style="padding:0 15px;">
				<div id="schedule_calendar" style="display:table; border-collapse:collapse; margin-bottom:15px;"></div>
				
				<c:if test="${not empty printAnnotaion}">
				<!-- 시간을 15분 단위로 반올림하는 루틴 --></c:if>
				
				<c:set var="adder" value="${10 - params.minute % 10}"/>
				<c:if test="${adder==10}">
					<c:set var="adder" value="0"/>
				</c:if>
				<c:set var="_minute" value="${params.minute+adder}"/>
				<c:set var="_hour" value="${params.hour}"/>
				<c:if test="${adder gt 0 and _minute eq 60}">
					<c:if test="${_hour eq 23}">
						<c:set var="_minute" value="50"/>
					</c:if>
					<c:if test="${_hour lt 23}">
						<c:set var="_hour" value="${_hour+1}"/>
						<c:set var="_minute" value="00"/>
					</c:if>
				</c:if>
				<c:if test="${_hour lt 10}">
					<c:set var="_hour" value="0${_hour}"/>
				</c:if>
				<c:if test="${_minute ne \"00\" and _minute lt 10}">
					<c:set var="_minute" value="0${_minute}"/>
				</c:if>
				
				<div id="modify_common_area">
					<div style="overflow:hidden;">
						<c:if test="${schedule.timeout_flag eq 'N' or params.type eq 'new'}">
						<div style="float:left; font-size:48px;">
							<p id="reg_hour">${_hour}</p>
						</div>
						<div style="float:left">
							<div style="cursor:pointer;" onclick="reg_hour_up();">▲</div>
							<div style="cursor:pointer;" onclick="reg_hour_down();">▼</div>
						</div>
						<div style="float:left; font-size:48px;">
							<p id="reg_minute">${_minute}</p>
						</div>
						<div style="float:left">
							<div style="cursor:pointer;" onclick="reg_minute_up();">▲</div>
							<div style="cursor:pointer;" onclick="reg_minute_down();">▼</div>
						</div>
						<div style="float:left; font-size:48px;">
							<a data-role="button" onclick="reg_set_oclock();" style="display:block; float:left; width:100px;">정시</a>
						</div>
						</c:if>
						<c:if test="${schedule.timeout_flag eq 'Y'}">
						<div style="float:left; font-size:48px;">완료!</div>
						</c:if>
					</div>
					
					<div>
						<input type="hidden" id="year"/>
						<input type="hidden" id="month"/>
						<input type="hidden" id="day"/>
						<p id="todo_date">2013</p>
						<textarea id="comment" placeholder="스케줄 내용을 입력하세요" style="border:1px solid black; color:black;"></textarea>
					</div>
					
				</div>
				
				<div id='reg_btn_area' style="overflow:hidden;">
					<a data-role="button" id="reg_btn" style="display:block; float:left; width:100%;">일정등록</a>
				</div>
				<div id='modify_btn_area' style="overflow:hidden;">
					<c:if test="${schedule.timeout_flag eq 'N' or params.type eq 'new'}">
					<a data-role="button" onclick="removeSchedule();" style="display:block; float:left; padding:5px 50px;">삭제</a>
					<a data-role="button" id="modify_btn" onclick="modifySchedule();" style="display:block; float:right; padding:5px 100px;">일정수정</a>
					</c:if>
					<c:if test="${schedule.timeout_flag eq 'Y'}">
					<a data-role="button" onclick="removeSchedule();" style="display:block; float:left; width:100%;">삭제</a>
					</c:if>
				</div>
			
			</div>
		</div>
		
	</div>

<script>

updateDateTags(_y,_m);

$('#modify_common_area').hide();
$('#reg_btn_area').hide();
$('#modify_btn_area').hide();

$('#reg_btn').bind('click',createSchedule);

setInputConstraint('phoneNumber','phone',12);

</script>

</body>
</html>