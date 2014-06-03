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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../include/total_header.jsp" />

<script src="${con.JSPATH}/dateFunctions.js"></script>
<script src="${con.JSPATH}/jquery.number.js"></script>

<jsp:include page="calendar.jsp"/>

<c:forEach var="item" items="${userList}" varStatus="c">
<c:choose>
<c:when test="${c.index eq 0}">
<c:set var="cpList1" value="${item.s_uid}"/>
<c:set var="cpList" value="${item.s_cphone_number}"/>
</c:when>
<c:otherwise>
<c:set var="cpList1" value="${cpList1};${item.s_uid}"/>
<c:set var="cpList" value="${cpList};${item.s_cphone_number}"/>
</c:otherwise>
</c:choose>
</c:forEach>

<script>

function afterCreateCalendar(){
	selectDate(old_date,'old');
	selectDate(currentDate);
}

$(window).load(function(){
	
	var date = new Date();
	date.setFullYear(parseInt("${params.year}",10),parseInt("${params.month}",10)-1,parseInt("${params.day}",10));
	
	var defaultDate = date.format('yyyymmdd');
	
	old_date = defaultDate+"";
	
	//createCalendar(_y,_m,'');
	var y = parseInt("${params.year}",10);
	var m = parseInt("${params.month}",10); 
	initCalendar(y, m);
	
	var type = "${params.type}";
	
	if(type=="new"){
		openCreateSchedule(defaultDate);
		openUserlist();
	}
	else if(type=="modify"){
		openModifySchedule(defaultDate);
	}
});

function openCreateSchedule(d){
	
	$('#modify_common_area').show();
	$('#reg_btn_area').show();
	$('#modify_btn_area').hide();
	
	$('#comment').val('[${params.hospital_name}]');
	selectDate(d);
}

function openModifySchedule(d){
	
	$('#modify_common_area').show();
	$('#reg_btn_area').hide();
	$('#modify_btn_area').show();
		
	$('#comment').val('${fn:replace(schedule.s_comment,lf,"\\n")}');//getScheduleValue(d).comment);
	selectDate(d);
}

function transitionModifySchedule(){
	
	$('#reg_btn_area').hide();
	$('#modify_btn_area').show();
	
	//$("#admin_head h1").html("스케줄 변경");
}

function getScheduleValue(d){
	
	for(var j = 0; j < scheduleMap[d].v.length; j++){
		if(scheduleMap[d].v[j].type=='s'){
			return scheduleMap[d].v[j];
		}
	}
}

var saveLock = false;

function createSchedule(){
	
	if(saveLock){return;}
	
	saveLock=true;
	setTimeout(function(){
		if(saveLock){saveLock=false;}
	},1000);
	
	if(isNoValue('comment')){
		alert('설명을 입력하세요.');
		return;
	}
	
	var tw = 0;
	if($('#reg_ampm').html()=='PM'){
		tw = 12;
	}
	var h = parseInt($('#reg_hour').html());
	h = h+tw;
	h = h % 24;
	
	if(uidList==null || uidList.length==0){
		alert('사용자를 선택하세요.');
		return;
	}
	
	$.ajax({
		type:'POST',
		url:'ajaxRegScheduleVer2.latte',
		data:{
			year:$('#year').val(),
			month:$('#month').val(),
			day:$('#day').val(),
			hour:h,
			minute:$('#reg_minute').html(),
			comment:$('#comment').val(),
			uid:uidList,
			phone:phoneList,
			sms_rsv:$('#checkbox-c1').is(':checked')?sms_radio_val:''
		},
		dataType:'text',
		success:function(response, status, xhr){
			
			var json = $.parseJSON(response);
			
			if(json.result=='${codes.SUCCESS_CODE}'){
				
				var msg = '';
				if($('#checkbox-c1').is(':checked')){
					if(sms_radio_val=='sms_now'){
						msg='등록 성공. 문자가 발송되었습니다.';
					}
					else{
						msg='등록 성공. 문자 발송 예약되었습니다.';
					}
				}else{
					msg='등록되었습니다';
				}
				
				showDialog(msg,'default',function(){
					transitionModifySchedule();
					g_rownum = json.rownum;
					history.back();
				});
			}
			else{
				alert('등록에 실패하였습니다.\n에러코드:'+json.result);
			}
			if(saveLock){saveLock=false;}
		},
		error:function(xhr, status, error){
			
			alert(status+","+error);
			if(saveLock){saveLock=false;}
		}
	});
}

function modifySchedule(){
	
	if(saveLock){return;}
	
	saveLock=true;
	setTimeout(function(){
		if(saveLock){saveLock=false;}
	},1000);
	
	if(isNoValue('comment')){
		alert('설명을 입력하세요.');
		return;
	}
	
	var tw = 0;
	if($('#reg_ampm').html()=='PM'){
		tw = 12;
	}
	var h = parseInt($('#reg_hour').html());
	h = h+tw;
	h = h % 24;
	
	$.ajax({
		type:'POST',
		url:'ajaxUpdateScheduleVer2.latte',
		data:{
			rownum:g_rownum,
			year:$('#year').val(),
			month:$('#month').val(),
			day:$('#day').val(),
			hour:h,
			minute:$('#reg_minute').html(),
			comment:$('#comment').val(),
			phone:phoneList,
			sms_rsv:$('#checkbox-c1').is(':checked')?sms_radio_val:'',
			sms_key:'${schedule.s_sms_key}'
		},
		dataType:'text',
		success:function(response, status, xhr){
			
			var json = $.parseJSON(response);
			
			if(json.result=='${codes.SUCCESS_CODE}'){
				
				showDialog('수정되었습니다.','default',function(){
					//goPage('manageSchedule.latte');
					history.back();
				});
			}
			else{
				alert('수정에 실패하였습니다.\n에러코드:'+json.result);
			}
			if(saveLock){saveLock=false;}
		},
		error:function(xhr, status, error){
			
			alert(status+","+error);
			if(saveLock){saveLock=false;}
		}
	});
}

function removeSchedule(){
	
	if(!confirm('스케줄을 삭제하시겠습니까?'))
		return;
	
	$.ajax({
		type:'POST',
		url:'ajaxRemoveScheduleVer2.latte',
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

//var currentDate;
var g_rownum = "${params.rownum}";

function selectDate(d,type){//year, month, day){
	
	//console.log(d+", "+type);
	if(d!=null){
		if(type=='old'){
			$('#schedule_calendar td').removeClass('today');
			$('#'+d).addClass('today');
		}
		else{
			currentDate = d;
			
			var y = d / 10000;
			$('#year').val(y - y % 1);
			var m = (d % 10000) / 100;
			$('#month').val(m = m - m % 1);
			$('#day').val(d % 100);
			$('#todo_date').html($('#year').val()+"년 "+$('#month').val()+"월 "+$('#day').val()+"일");
			
			$('#schedule_calendar td').removeClass('on');
			$('#'+d).addClass('on');
		}
	}
}

$(document).ready(function(){
	
	var h = parseInt('${params.hour}');
	var m = parseInt('${params.minute}');
	
	var ap = (h+1) / 12;
	
	m = parseInt(m / 10) * 10;
	
	if(ap > 0)
		selectPM();
	else
		selectAM();
	
	selectHour(h%12);
	selectMinute(twoDigits(m));
	
	completeTimePopup();
});

function openTimePopup(){
	
	$('#time_popup').show();
}

function closeTimePopup(){
	
	$('#time_popup').hide();
}

function completeTimePopup(){
	
	$('#reg_ampm').html($('#btn_am p').attr('class')=='on'?'AM':'PM');
	$('#reg_hour').html($('#h_selector').parent().find('label').html());
	$('#reg_minute').html($('#m_selector').parent().find('label').html());
	
	var tw = 0;
	if($('#reg_ampm').html()=='PM'){
		tw = 12;
	}
	var h = parseInt($('#reg_hour').html());
	h = h+tw;
	h = h % 24;
	
	$('#print_time').html(twoDigits(h)+':'+$('#reg_minute').html());
	
	$('#time_popup').hide();
}

function selectAM(){
	$('#btn_am p').attr('class','on');
	$('#btn_pm p').attr('class','off');
}

function selectPM(){
	$('#btn_am p').attr('class','off');
	$('#btn_pm p').attr('class','on');
}

function selectHour(h){
	
	var llen = $('#h_selector').length;
	var tlen = $('#h'+h).length;
	
	if(llen==0 || tlen==0){
		
		$('#h'+h).append($(
		'<span class="selected" id="h_selector">'
			+'<span class="type01">'
				+'<span class="inner"></span>'
				+'<label>'+h+'</label>'
			+'</span>'
		+'</span>'));
	}
	else{
		var l = $('#h_selector').detach();
		l.find('label').html(h+'');
		$('#h'+h).append(l);
	}
	
	$('#popup_hour').html(twoDigits(h));
}

function selectMinute(m){
	
	var llen = $('#m_selector').length;
	var tlen = $('#m'+m).length;
	
	if(llen==0 || tlen==0){
		
		$('#m'+m).append($(
		'<span class="selected" id="m_selector">'
			+'<span class="type01">'
				+'<span class="inner"></span>'
				+'<label>'+m+'</label>'
			+'</span>'
		+'</span>'));
	}
	else{
		var l = $('#m_selector').detach();
		l.find('label').html(m+'');
		$('#m'+m).append(l);
	}
	
	$('#popup_minute').html(m);
}

function checkReserve(cb){
	
	if(cb.is(':checked')){
		$('#sms_select_area').show();
	}else{
		$('#sms_select_area').hide();
	}
}

var sms_radio_val = '';

function sms_radio_disable(id){
	if($('#'+id+"_btn").hasClass('on')){$('#'+id+"_btn").removeClass('on');}
	//if(!$('#'+id).hasClass('off')){$('#'+id).addClass('btn_bar_gray');}
}
function sms_radio_enable(id){
	
	$('#'+id+"_btn").addClass('on');
	//if($('#'+id).hasClass('btn_bar_gray')){$('#'+id).removeClass('btn_bar_gray');}
	//if(!$('#'+id).hasClass('btn_bar_black')){$('#'+id).addClass('btn_bar_black');}
}

function sms_toggle(){
	
}

var sms_radio_array = new Array();
sms_radio_array['sms_3d']="N";
sms_radio_array['sms_2d']="N";
sms_radio_array['sms_1d']="N";
sms_radio_array['sms_3h']="N";

function create_sms_radio_val(){
	
	var str = "";
	var fill = false;
	if(sms_radio_array['sms_3d']=="Y"){
		if(fill){str+=";";}
		else{fill=true;}
		str+="sms_3d";
	}
	if(sms_radio_array['sms_2d']=="Y"){
		if(fill){str+=";";}
		else{fill=true;}
		str+="sms_2d";
	}
	if(sms_radio_array['sms_1d']=="Y"){
		if(fill){str+=";";}
		else{fill=true;}
		str+="sms_1d";
	}
	if(sms_radio_array['sms_3h']=="Y"){
		if(fill){str+=";";}
		else{fill=true;}
		str+="sms_3h";
	}
	return str;
}

function sms_radio(target){
	
	if($('#'+target+"_btn").hasClass('on')){
		$('#'+target+"_btn").removeClass('on');
		sms_radio_array[target]="N";
	}
	else{
		$('#'+target+"_btn").addClass('on');
		sms_radio_array[target]="Y";
	}
	
	/* sms_radio_disable('sms_3d');
	sms_radio_disable('sms_1d');
	sms_radio_disable('sms_3h');
	sms_radio_disable('sms_1h');
	sms_radio_disable('sms_now');
	
	sms_radio_enable(target); */
	
	$('#'+target).trigger('create');

	//sms_radio_val = target;
	sms_radio_val = create_sms_radio_val();
	
	//alert(sms_radio_val);
}




var userList = new Array();
var listCnt = 0;
var itemCntLimit = 5;
var groupCntLimit = 5;
var curGroup = 1;

var uidList = '${cpList1}';
var rowList = '';

var phoneList = '${cpList}';

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
				uidList = (uidList+(uidList==''?"":";")+(response.uid==null?"":response.uid));
				phoneList = (phoneList+(phoneList==''?"":";")+(response.cphone_number==null?"":response.cphone_number));
				
				var new_id = $('#user_list li').length;
				
				var $tag = $(
				'<li>'
					+'<input type="hidden" id="id'+new_id+'" value="'+response.uid+'"/>'
					+'<p class="txt01">'+decodeURIComponent(response.name)+' ('+formatPhoneNumber(response.cphone_number,'-')+')</p>'
					+'<p class="txt02 orange mt05">&nbsp;</p>'
					//+'<p class="txt02 orange mt05">'+$.number(response.point_sum)+' <img src="${con.IMGPATH}/common/icon_p.png" alt="" width="15" height="15"/></p>'
					+'<p class="btn_admin01 btn_r02"><a onclick="removeUser(\''+response.uid+'\',\''+response.cphone_number+'\');" data-role="button"><img src="${con.IMGPATH}/btn/btn_close.png" alt="" width="31" height="31" /></a></p>'
				+'</li>');
				
				userArea.userCnt++;
				$('#user_cnt1').text(userArea.userCnt+"명");
				$('#user_cnt2').text(userArea.userCnt+"명");
				
				//for(var i =0; i < userArea.uidList.length; i++){
				//	console.log(userArea.uidList[i]);
				//	console.log(userArea.phoneList[i]);
				//}
				
				$('#user_list').append($tag);
				$('#user_list').trigger('create');
				
				/* if(!$('#user_list_paging').is(':visible')){
					$('#user_list_paging').show();
				}
				else if(listCnt > (curGroup-1)*groupCntLimit*itemCntLimit && listCnt < curGroup*groupCntLimit*itemCntLimit){
					
					var page = Math.floor((listCnt-1) / itemCntLimit);
					//alert(page);
				} */
			}
			else if(response.result=='${codes.ERROR_QUERY_PROCESSED}'){
				
				alert('검색 결과가 없습니다.');
			}
			else if(response.result=='${codes.ERROR_UNAUTHORIZED}'){
				
				goPage('login.latte');
			}
			else
				alert('오류가 발생했습니다.\n'+response.result);
		},
		error:function(xhr,status,error){
			alert(status+'\n'+error);
		}
	});
}

function removeUser(id,phone){
	
	//?console.log('remove1 '+uidList+' '+phoneList);
	//console.log(typeof uidList);
	
	var idi = uidList.indexOf(id);
	if(idi>-1){
		
		var si = uidList.indexOf(';',idi+1);
		if(si>-1){
			uidList = uidList.substr(0,idi)+uidList.substr(si+1);
		}
		else{
			uidList = uidList.substr(0,idi);
		}
		
		var pi = phoneList.indexOf(phone);
		si = phoneList.indexOf(';',pi+1);
		if(si>-1){
			phoneList = phoneList.substr(0,pi)+phoneList.substr(si+1);
		}
		else{
			phoneList = phoneList.substr(0,pi);
		}
	}
	
	//console.log('remove '+uidList+' '+phoneList);
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

function openPetList(index, id){
	
	if($('#pet_list_inner'+index).html()==''){
		$.ajax({
			url:'ajaxInnerPetList.latte',
			type:'POST',
			data:{
				pagingBlockId:index,
				pagingSendValue:id
			},
			dataType:'text',
			success:function(response, status, xhr){
				
				$('#pet_list_inner'+index).append(response);
				$('#pet_list'+index).show();
			},
			error:function(xhr,status,error){
				alert(status+'\n'+error);
			}
		});
		
	}
	else	
		$('#pet_list'+index).show();
}

function checkbox(me,targetId){
	
	if($(me).is(':checked'))
		$('#'+targetId).val('Y');
	else
		$('#'+targetId).val('N');
}

function openUserlist(){
	//location.hash = 'userlist';
	$('#user_area').show();
	$('#calendar_area').hide();
}

function openCalendar(){
	$('#user_area').hide();
	$('#calendar_area').show();
	//$(window).trigger('hashchange');	
	//history.back();
}


//while(!(location.hash==''||location.hash=='#')){
//	history.back();
//}

$(window).hashchange(function(){
	if(location.hash.indexOf('userlist')>-1){
		$('#user_area').show();
		$('#calendar_area').hide();
	}
	else{
		if(!$('#calendar_area').is(':visible')){
			$('#user_area').hide();
			$('#calendar_area').show();
		}
	}
});

var userArea = new function(){
	
	this.userCnt = parseInt('${fn:length(userList)}',10);
};

function scheduleConfirm(){
	
	$.ajax({
		url:"ajaxVaccineConfirm.latte",
		data:{
			rownum:g_rownum
		},
		dataType:'json',
		success:function(response,status,xhr){
			
			
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				
				alert('인증되었습니다.');
				
				location.reload();
			}
			else{
				alert('에러가 발생하였습니다.');
			}
		},
		error:function(xhr,status,error){
			
			alert('에러 : '+status+'\n'+error);
		}
	});
}

</script>


<style>
.simple_popup01 {position:absolute; position:fixed; top:0; bottom:0; left:0; right:0; z-index:9999;}

.simple_popup01 .bg {position:absolute; top:0; bottom:0; width:100%; background:black; opacity:0.5; z-index:0;}

.simple_popup01 .c_area_l1 {position:absolute; top:0; bottom:0; width:100%; z-index:1;}

.simple_popup01 .aliner {display:inline-block; width:4%; height:100%; vertical-align:middle;}

.simple_popup01 .c_area_l2 {display:inline-block; width:90%; vertical-align:middle;}

.simple_popup01 .c_area_l2 .title_bar {background: #383838; border-radius:5px 5px 0 0; overflow:hidden;}

.simple_popup01 .c_area_l2 .title_bar a {background:transparent; box-shadow:none;}

.simple_popup01 .c_area_l2 .title_name {float:left; font-size:18px; font-weight: bold; margin:18px; color:white;}

.simple_popup01 .c_area_l2 .title_close {float:right; margin:10px; background: transparent;}

.simple_popup01 .c_area_l2 .center {background: white; border-radius:0 0 5px 5px; padding:15px;}

.simple_popup01 .c_area_l2 .center2 {background: white; border-radius:0 0 5px 5px; padding:15px;}


.schedule_time_ampm {padding:15px;}

.schedule_time_ampm a {display:inline-block; vertical-align:middle; padding:0px; margin:0px; background:transparent; box-shadow:none;}

.schedule_time_ampm .inner {display:inline-block; height:100%; vertical-align:middle; margin-left:-5px;}

.schedule_time_ampm label {display:inline-block; vertical-align:middle; text-align:center; font-size:large; color:white;}

.schedule_time_ampm .on {display:inline-block; width:50px; height:50px; background:#fc816e; border-radius:50%; text-align:center;}

.schedule_time_ampm .off {display:inline-block; width:50px; height:50px; background:#bdbdbd; border-radius:50%; text-align:center;}

.schedule_time_ampm .time {display:inline-block; vertical-align:middle; font-size:xx-large;}



.select_time_msg01 {font-size:small; padding:5px;}



.select_table_header {background:#f0f0f0; text-align:center; padding:5px;}

.select_table p {width:15%; text-align:center; display:inline-block; color:#1c1c1c; padding:15px 0px; font-size:large; position:relative;}

.select_table label {display:inline-block; vertical-align:middle; text-align:center;}

.select_table .inner {display:inline-block; height:100%; vertical-align:middle;}/*  margin-left:-5px;} */

.select_table .number_tag {display:block; position:absolute; top:1px; right:1px; background:#1c1c1c; color:white; width:10px; height:10px; border-radius:50%; font-size:12px; padding:3px; padding-bottom:4px;}

.select_table .selected {display:block; position:absolute; top:50%; left:50%;}

.select_table .selected .type01 {display:block; background:#fc816e; color:black; width:40px; height:40px; border-radius:50%; margin-top:-50%;margin-left:-50%; color:white;}

.select_table .selected .type02 {display:block; border:1px solid #1c1c1c; color:black; width:40px; height:40px; border-radius:50%; margin-top:-50%;margin-left:-50%; color:#1c1c1c;}
</style>

</head>
<body>

	<div id="page" data-role="page">
	
		<jsp:include page="temp_INC_INSTANCE_DIALOG.jsp"/>
		
		<c:set var="tt"><c:choose><c:when test="${params.type eq 'new'}">스케줄 추가</c:when><c:otherwise>스케줄 변경</c:otherwise></c:choose></c:set>
		<jsp:include page="../include/manage_title_bar.jsp">
			<jsp:param name="title_bar_title" value="${tt}"/>
		</jsp:include>
		
		<%-- <jsp:param name="back_function" value="back"/> --%>
		
		<div class="simple_popup01" id="time_popup">
			<div class="bg"></div>
			<div class="c_area_l1">
				<span class="aliner"></span>
				<div class="c_area_l2">
					<div class="title_bar">
						<p class="title_name">시간 설정</p>
						<a class="title_close" data-role="button" onclick="closeTimePopup();"><img src="${con.IMGPATH}/btn/btn_pop_close.png" height="32px"/></a>
					</div>
					<div class="center">
						<div class="schedule_time_ampm">
							<a data-role="button" id="btn_am" onclick="selectAM();"><p class="on">
								<span class="inner"></span>
								<label>AM</label>
							</p></a>
							<a data-role="button" id="btn_pm" onclick="selectPM();"><p class="off">
								<span class="inner"></span>
								<label>PM</label>
							</p></a>
							<span class="time" id="popup_hour">09</span>
							<span class="time">:</span>
							<span class="time" id="popup_minute">00</span>
						</div>
						<p class="select_time_msg01">▼ 시간을 선택해주세요</p>
						<p class="select_table_header">시</p>
						<div class="select_table">
							<p id="h0" onclick="selectHour(0);"><label>0</label></p>
							<p id="h1" onclick="selectHour(1);"><label>1</label></p>
							<p id="h2" onclick="selectHour(2);"><label>2</label></p>
							<p id="h3" onclick="selectHour(3);"><label>3</label></p>
							<p id="h4" onclick="selectHour(4);"><label>4</label></p>
							<p id="h5" onclick="selectHour(5);"><label>5</label></p>
						</div>
						<div class="select_table">
							<p id="h6" onclick="selectHour(6);"><label>6</label></p>
							<p id="h7" onclick="selectHour(7);"><label>7</label></p>
							<p id="h8" onclick="selectHour(8);"><label>8</label></p>
							<p id="h9" onclick="selectHour(9);"><label>9</label></p>
							<p id="h10" onclick="selectHour(10);"><label>10</label></p>
							<p id="h11" onclick="selectHour(11);"><label>11</label></p>
						</div>
						<p class="select_table_header">분</p>
						<div class="select_table">
							<p id="m00" onclick="selectMinute('00');"><label>00</label></p>
							<p id="m10" onclick="selectMinute('10');"><label>10</label></p>
							<p id="m20" onclick="selectMinute('20');"><label>20</label></p>
							<p id="m30" onclick="selectMinute('30');"><label>30</label></p>
							<p id="m40" onclick="selectMinute('40');"><label>40</label></p>
							<p id="m50" onclick="selectMinute('50');"><label>50</label></p>
						</div>
						<p class="btn_red02"><a data-role="button" onclick="completeTimePopup();">설정 완료</a></p>
					</div>
				</div>
			</div>
		</div>
		
		

		<!-- content 시작-->
		<div data-role="content" id="contents" style="overflow: hidden">
		
			<%-- <div class="mypage_header">
				<div class="back"><a data-role="button" data-rel="back"><img height="0" src="${con.IMGPATH}/btn/btn_back_t.png"/></a></div>
				스케줄 <c:if test="${params.type eq \"new\"}">등록</c:if><c:if test="${params.type eq \"modify\"}">편집</c:if>
			</div> --%>
			
			<div id="calendar_area">
			
			<!-- 회원 정보 시작-->
			<div class="top_info">총 <span id="user_cnt1">${fn:length(userList)}명</span>의 회원이 선택되었습니다.</div>
			<!-- 회원 정보 끝-->
			
			<%-- <div>
				<p>사용자 검색(휴대폰 번호로 검색하실 수 있습니다)</p>
				
				<div class="btn_area01">
					<div class="rate50">
					<div class="input01">
						<p class="inner_input"><input type="text" id="phone"></p>
					</div>
					</div>
					<p class="rate50 btn_bar_black btn_bar_shape02">
						<a data-role="button" onclick="searchUser('',$('#phone').val(),'')"><span>검색</span></a>
					</p>
				</div>
				
				<p>숫자만 입력해 주세요</p>
				
				<div id="user_list">
					<jsp:include page="user_inner_schedule.jsp"/>
				</div>
				
				<input type="hidden" id="uid"/>
				
				<div class="list_num" id="user_list_paging">
	
					<span class="btn_num"><a onclick="prePageChange('prev','1','${pagingBlockId}','${pagingSendValue}');" data-role="button"><img src="${con.IMGPATH}/btn/btn_prev.png" alt="" width="7" height="10" style="padding-right:2px;"/></a></span>
					<span class="btn_num"><a onclick="prePageChange('prev','${pageGroupNumber * pageGroupSize + 1 - pageGroupSize}','${pagingBlockId}','${pagingSendValue}');" data-role="button"><img src="${con.IMGPATH}/btn/btn_prev.png" alt="" width="7" height="10" style="padding-right:2px;"/></a></span>
					<span id="user_list_paging_inner">
					<a onclick="prePageChange('cur','${pageGroupNumber * pageGroupSize + c.count}','${pagingBlockId}','${pagingSendValue}');"><span style="color:red;">${pageGroupNumber * pageGroupSize + c.count}</span></a>&nbsp;
					</span>
						<c:forEach begin="0" end="${curPageGroupSize-1}" varStatus="c">
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
						</c:forEach>
					<span class="num">${params.pageNumber} / ${params.pageCount}</span>
					<span class="btn_num"><a onclick="prePageChange('next','${pageGroupNumber * pageGroupSize + 1 + curPageGroupSize}','${pagingBlockId}','${pagingSendValue}');" data-role="button"><img src="${con.IMGPATH}/btn/btn_next.png" alt="" width="7" height="10" style="padding-left:2px;"/></a></span>
					<span class="btn_num"><a onclick="prePageChange('next','${params.pageCount}','${pagingBlockId}','${pagingSendValue}');" data-role="button"><img src="${con.IMGPATH}/btn/btn_next.png" alt="" width="7" height="10" style="padding-left:2px;"/></a></span>
					
				</div>
				
				<script>
				$('#user_list_paging').hide();
				</script>
			</div> --%>
			
			<%-- <div class="schedule_top">
				<div class="center">
					<div class="paging">
						<p><a data-role="button" id="pre_btn" onclick="createPreMonthCalendar(null);"><img src="${con.IMGPATH}/btn/btn_arrow_l03_t.png" width="29" height="29"/></a></p>
						<span class="headline_white" id="title"></span>
						<p><a data-role="button" id="next_btn" onclick="createNextMonthCalendar(null);"><img src="${con.IMGPATH}/btn/btn_arrow_r03_t.png" width="29" height="29"/></a></p>
					</div>
				</div>
			</div> --%>
			
			<!-- 스케줄 상단 시작-->
			<div class="schedule_top">
				<div class="date_tt">
					<h4 id="title">2014.01</h4>
					<p class="btn_l btn_arrow01"><a onclick="createPreMonthCalendar(null);" data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_l03.png" alt="" width="29" height="29"/></a></p>
					<p class="btn_r btn_arrow01"><a onclick="createNextMonthCalendar(null);" data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_r03.png" alt="" width="29" height="29"/></a></p>
				</div>
			</div>
			<!-- 스케줄 상단 끝-->
			
			<!-- <div class="calendar" id="schedule_calendar"></div> -->
			<!-- 켈린더 시작-->
			<div class="calendar_area">
				<table class="calendar" id="schedule_calendar">
				</table>
			</div>
			
			<div class="time_area">
				<p class="txt"><img src="${con.IMGPATH}/common/icon_clock.png" alt="" width="16" height="18"/>예약시간 설정</p>
				<span id="reg_ampm">AM</span>
							<span id="reg_hour">07</span>
							<span>:</span>
							<span id="reg_minute">00</span>
				<p class="btn_modify"><a onclick="openTimePopup();" data-role="button"><img src="${con.IMGPATH}/btn/icon_modify.png" alt="" width="31" height="31" /></a></p>
			</div>
			
			<%-- <div class="schedule_time_select">
				<table>
					<colgroup>
						<col width="50%"/><col width="*"/>
					</colgroup>
					<tr>
						<td class="title">
							<img src="${con.IMGPATH}/common/icon_time_t.png" height="20px"/>
							<span>예약시간 설정</span>
						</td>
						<td class="time">
							<span id="reg_ampm">AM</span>
							<span id="reg_hour">07</span>
							<span>:</span>
							<span id="reg_minute">00</span>
							<img onclick="openTimePopup();" src="${con.IMGPATH}/btn/btn_time_edit_t.png" height="30px"/>
						</td>
					</tr>
				</table>
			</div> --%>
			
			<input type="hidden" id="year"/>
			<input type="hidden" id="month"/>
			<input type="hidden" id="day"/>
			
			<div class="a_type02_b">
				<h3><span id="todo_date">2014년 1월 5일</span> (<span id="print_time">07:00</span>) 일정<span class="txt_r">0/80</span></h3>
				<p class="textarea01 mt05"><textarea id="comment" style="width:100%; height:100px;" placeholder="스케줄 내용을 입력해 주세요."></textarea></p>
				<%--
				<c:if test="${sms_sended eq 'Y' and not empty schedule.d_sms_time}"><p class="txt_gray12 mt05">문자발송(회원에게 ${schedule.d_sms_time} 발송되었습니다.)</p></c:if>
				<div class="sms_box mt15">
					<p class="checkbox02">
						<input type="checkbox" id="checkbox-c1" value="c-1" onchange="checkReserve($(this));"/>
						<label for="checkbox-c1">문자발송(회원에게 발송됩니다.)</label>
					</p>
					<div class="sms_btnarea mt05" id="sms_select_area">
						<ul>
							<li id="sms_3d_btn" style="width:23%;"><a data-role="button" onclick="sms_radio('sms_3d');">3일전</a></li>
							<li id="sms_2d_btn" style="width:23%;"><a data-role="button" onclick="sms_radio('sms_2d');">2일전</a></li>
							<li id="sms_1d_btn" style="width:23%;"><a data-role="button" onclick="sms_radio('sms_1d');">1일전</a></li>
							<li id="sms_3h_btn" style="width:23%;"><a data-role="button" onclick="sms_radio('sms_3h');">3시간전</a></li>
						</ul>
					</div>
				</div>
				 --%>
				<%-- 유저가 등록했고 시간이 아직 유효할 경우 or 새로 등록하는 경우 --%>
				<c:if test="${schedule.timeout_flag eq 'N' or params.type eq 'new'}">
				<div class="btn_area02 mt10" id='modify_btn_area'>
					<p class="btn_black02 btn_l" style="width:100px;"><a onclick="removeSchedule();" data-role="button">삭제</a></p>
					<p class="btn_red02" style="margin-left:104px;"><a id="modify_btn" onclick="modifySchedule();" data-role="button">일정수정</a></p>
				</div>
				</c:if>
				<%-- 병원에서 등록했거나 시간이 유효하지 않을 경우 --%>
				<c:if test="${schedule.timeout_flag eq 'Y'}">
				<div class="btn_area02 mt10" id='modify_btn_area'>
					<p class="btn_black02"><a onclick="removeSchedule();" data-role="button">삭제</a></p>
				</div>
				</c:if>
				<div class="btn_area02 mt10" id='reg_btn_area'>
					<p class="btn_red02"><a id="reg_btn" data-role="button">일정 등록</a></p>
				</div>
				
			</div>
			
			<div class="a_type02_b">
			<c:if test="${empty schedule.s_confirmer}"><p class="btn_red02" ><a onclick="scheduleConfirm();" data-role="button">이 스케줄 달성을 인증</a></p></c:if>
			<c:if test="${not empty schedule.s_confirmer}"><p class="btn_black02" ><a data-role="button">인증됨</a></p></c:if>
			</div>
			
			<div class="a_type02_b">
				<p class="btn_black02" ><a onclick="openUserlist();" data-role="button">수신자 변경/추가</a></p>
			</div>
			
			<%-- <div class="a_type02">
				<c:if test="${schedule.s_type eq codes.REGISTRANT_TYPE_HOSPITAL}">
					<p class="title01">[${schedule.s_registrant_name}]</p>
				</c:if>
				<!-- <h3><span id="todo_date">2014년 1월 5일</span> (<span id="print_time">07:00</span>)일정</h3>
				<span style="font-size:small;">문자는 80자까지만 발송됩니다.</span>
				<p class="textarea01">
					<textarea id="comment" rows="3" placeholder="스케줄 내용을 입력해 주세요."></textarea>
				</p> -->
				
				<div class="sms_area">
				<p><input type="checkbox" id="sms_reserve" onchange="checkReserve($(this));" <c:if test="${not empty schedule.d_sms_time}">checked="checked"</c:if>/><span onclick="$('#sms_reserve').click();">문자발송(회원에게 발송됩니다.)</span></p>
				<c:if test="${sms_sended eq 'Y' and not empty schedule.d_sms_time}"><p>마지막 발송 시간 ${schedule.d_sms_time}</p></c:if>
				<!-- <div id="sms_select_area">
				<div class="btn_area01">
					<p id='sms_3d' class="rate25 btn_bar_gray btn_bar_shape02 mt08">
						<a data-role="button" id="sms_3d_btn" onclick="sms_radio('sms_3d');"><span>3일전</span></a>
					</p>
					<p id='sms_1d' class="rate25 btn_bar_gray btn_bar_shape02 mt08">
						<a data-role="button" id="sms_1d_btn" onclick="sms_radio('sms_1d');"><span>1일전</span></a>
					</p>
					<p id='sms_3h' class="rate25 btn_bar_gray btn_bar_shape02 mt08">
						<a data-role="button" id="sms_3h_btn" onclick="sms_radio('sms_3h');"><span>3시간전</span></a>
					</p>
					<p id='sms_1h' class="rate25 btn_bar_gray btn_bar_shape02 mt08">
						<a data-role="button" id="sms_1h_btn" onclick="sms_radio('sms_1h');"><span>1시간전</span></a>
					</p>
				</div>
				<p id='sms_now' class="btn_bar_gray btn_bar_shape02 mt08">
					<a data-role="button" id="sms_now_btn" onclick="sms_radio('sms_now');"><span>즉시</span></a>
				</p>
				</div> -->
				<!-- </div> -->
			
			</div>
			<div class="a_type02">
				<p id='reg_btn_area' class="btn_bar_red btn_bar_shape02 mt08">
					<a data-role="button" id="reg_btn"><span>일정 등록</span></a>
				</p>
				<div id='modify_btn_area'>
					유저가 등록했고 시간이 아직 유효할 경우 or 새로 등록하는 경우
					<c:if test="${schedule.timeout_flag eq 'N' or params.type eq 'new'}">
					<div class="btn_area02 mt08">
						<div class="l_30">
							<p class="btn_bar_black btn_bar_shape02">
								<a data-role="button" onclick="removeSchedule();"><span>삭제</span></a>
							</p>
						</div>
						<div class="r_70">
							<p class="btn_bar_red btn_bar_shape02">
								<a data-role="button" id="modify_btn" onclick="modifySchedule();"><span>수정</span></a>
							</p>
						</div>
					</div>
					</c:if>
					병원에서 등록했거나 시간이 유효하지 않을 경우
					<c:if test="${schedule.timeout_flag eq 'Y'}">
					<p class="btn_bar_black btn_bar_shape02 mt08">
						<a data-role="button" onclick="removeSchedule();"><span>삭제</span></a>
					</p>
					</c:if>
				</div>
			</div> --%>
			
			</div>
			
			<div id="user_area" style="display:none;">
			
			<div>
				
				<input type="hidden" id="uid"/>
				
				<%-- <div class="list_num" id="user_list_paging">
	
					<span class="btn_num"><a onclick="prePageChange('prev','1','${pagingBlockId}','${pagingSendValue}');" data-role="button"><img src="${con.IMGPATH}/btn/btn_prev.png" alt="" width="7" height="10" style="padding-right:2px;"/></a></span>
					<span class="btn_num"><a onclick="prePageChange('prev','${pageGroupNumber * pageGroupSize + 1 - pageGroupSize}','${pagingBlockId}','${pagingSendValue}');" data-role="button"><img src="${con.IMGPATH}/btn/btn_prev.png" alt="" width="7" height="10" style="padding-right:2px;"/></a></span>
					<span id="user_list_paging_inner">
					<a onclick="prePageChange('cur','${pageGroupNumber * pageGroupSize + c.count}','${pagingBlockId}','${pagingSendValue}');"><span style="color:red;">${pageGroupNumber * pageGroupSize + c.count}</span></a>&nbsp;
					</span> --%>
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
				<%-- 	<span class="btn_num"><a onclick="prePageChange('next','${pageGroupNumber * pageGroupSize + 1 + curPageGroupSize}','${pagingBlockId}','${pagingSendValue}');" data-role="button"><img src="${con.IMGPATH}/btn/btn_next.png" alt="" width="7" height="10" style="padding-left:2px;"/></a></span>
					<span class="btn_num"><a onclick="prePageChange('next','${params.pageCount}','${pagingBlockId}','${pagingSendValue}');" data-role="button"><img src="${con.IMGPATH}/btn/btn_next.png" alt="" width="7" height="10" style="padding-left:2px;"/></a></span>
					
				</div> --%>
				
				<script>
				$('#user_list_paging').hide();
				</script>
			</div>
			
				<div class="a_type01">
				<h3>대상 회원 추가 <span class="t01">(휴대폰 번호로 검색하실 수 있습니다.)</span></h3>
				<div class="area00 mt05">
					<p class="input01" style="margin-right:85px;" ><input type="text" id="phone"></p>
					<p class="btn_black04 abs_rt" style="width:80px;"><a onclick="searchUser('',$('#phone').val(),'')" data-role="button">검색</a></p>
				</div>
				<p class="txt_gray11 mt05">*숫자만 입력해 주세요.</p>
				
				
				<div class="g_box mt20">
					<ul id="user_list">
					<jsp:include page="user_inner_schedule.jsp"/>
					</ul>
				</div>
				<%-- <div class="paging03">
					<p><a href="index.html" data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_l03.png" width="29" height="29"/></a></p>
					<span class="txt"><label>2</label>/123</span>
					<p><a href="index.html" data-role="button"><img src="../images/btn/btn_arrow_r03.png" width="29" height="29"/></a></p>
				</div> --%>
				<p class="txt_gray12 mt05">총 <span class="num" id="user_cnt2">${fn:length(userList)}명</span>의 회원이 선택되었습니다.</p>
				
				<p class="btn_red02 mt15"><a onclick="openCalendar();" data-role="button">스케줄 입력하기</a></p>
				
				
			</div>
			
			</div>
			
		</div>
		<!-- contents 끝 -->
		
		<jsp:include page="../include/simple_copyright.jsp"/>
		<%-- <jsp:include page="../include/mypage_footer.jsp"/> --%>
		
	</div>
	
<c:forEach var="item" items="${msgs}">
<c:if test="${not empty item.n_term}">
<c:if test='${item.n_term eq "259200"}'><c:set var="sms_radio_param" value="sms_3d"/></c:if>
<c:if test='${item.n_term eq "172800"}'><c:set var="sms_radio_param" value="sms_2d;${sms_radio_param}"/></c:if>
<c:if test='${item.n_term eq "86400"}'><c:set var="sms_radio_param" value="sms_1d;${sms_radio_param}"/></c:if>
<c:if test='${item.n_term eq "10800"}'><c:set var="sms_radio_param" value="sms_3h;${sms_radio_param}"/></c:if>
<c:if test='${item.n_term eq "3600"}'><c:set var="sms_radio_param" value="sms_1h;${sms_radio_param}"/></c:if>
<c:if test='${item.n_term eq "0"}'><c:set var="sms_radio_param" value="sms_now${sms_radio_param}"/></c:if>
</c:if>
</c:forEach>

<script>

//updateDateTags(_y,_m);



$(document).ready(function(){
	
	$('#modify_common_area').hide();
	$('#reg_btn_area').hide();
	$('#modify_btn_area').hide();

	$('#reg_btn').on('click',createSchedule);
	
	//if("${sms_radio_param}"!=""){sms_radio('${sms_radio_param}');}
	if('${sms_radio_param}'!=''){
		var srp = '${sms_radio_param}'.split(';');
		//alert(srp);
		for(var i=0;i<srp.length;i++){
			//alert(srp[i]);
			if(srp[i]!=""){sms_radio(srp[i]);}
		}
		if(srp.length>0){
			$('#checkbox-c1').prop("checked",true).checkboxradio("refresh");
			checkReserve($('#checkbox-c1'));
		}
	}
	checkReserve($('#checkbox-c1'));
});

</script>

</body>
</html>