<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<script>
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
	
	var tag = $('<tr/>');
	for(var i = 0; i < 7; i++){
		if((i+first)%7==5){
			tag.append($.createElementJson({tagName:'th',cls:'sat',html:dayoftheweek[(i+first)%7]}));
		}
		else if((i+first)%7==6){
			//tag.append($.createTagElement('p',{attrs:{cls:'sun'},html:dayoftheweek[(i+first)%7]}));
			tag.append($.createElementJson({tagName:'th',cls:'sun',html:dayoftheweek[(i+first)%7]}));
		}
		else{
			//tag.append($.createTagElement('p',{attrs:{cls:'other'},html:dayoftheweek[(i+first)%7]}));
			tag.append($.createElementJson({tagName:'th',html:dayoftheweek[(i+first)%7]}));
		}
	}
	$('#schedule_calendar').append(tag);
	
//	var div = $.createTagElement('div',{attrs:{cls:'body'}});
	var div = $('<tr/>');
	
	//var div2 = div;//$.createTagElement('div',{});
	var tail = 0;
	if(week<first)
		tail = pre_ml - (week+7-first)+1;
	else
		tail = pre_ml - (week-first)+1;
	for(var i = first; i != (week)%7; i=(i+1)%7){
		var d = pre_year+twoDigits(pre_month)+twoDigits(tail);
		
		div.append($.createElementJson({
			tagName:'td',cls:'off',id:d,child:{tagName:'a',dataRole:'button',onclick:'createPreMonthCalendar('+d+')',html:tail}
		}));
		//div.append($.createTagElement('p',{attrs:{cls:'external',id:d,onclick:'createPreMonthCalendar('+d+')'},
		//	children:[$.createTagElement('label',{html:tail})]}));
		tail++;
	}
	
	for(var i = 0; i < ml; i++){
		week=week%7;
		if(week==first){
			//div.append(div2);
			div.trigger('create');
			$('#schedule_calendar').append(div);
			div = $('<tr/>');//.createTagElement('div',{});
		}
		var d = year+twoDigits(month)+twoDigits(i+1);
		
		//var p = $.createTagElement('p',{attrs:{id:d,onclick:'selectDate('+d+')'}});
		
		if(map[d]!=null){
			var holiday = false;
			var name = "";
			var scheduleCnt = 0;
			for(var j = 0; j < map[d].length; j++){
				if(map[d][j].type=='h'){//휴일
					holiday = true;
					name += map[d][j].comment;
				}
				else if(map[d][j].type=='s'){//스케줄
					scheduleCnt++;
				}
			}
			var t1 = null;
			if(holiday){
				t1 = $.createElementJson({
					tagName:'td',id:d,child:
						{tagName:'a',dataRole:'button',onclick:'selectDate('+d+')',html:(i+1),css:{color:'red'}}
				});
			}
			else{
				t1 = $.createElementJson({
					tagName:'td',id:d,child:
						{tagName:'a',dataRole:'button',onclick:'selectDate('+d+')',html:(i+1)}
				});
			}
			if(scheduleCnt > 0){
				t1.append($.createElementJson({tagName:"label",cls:"pl",html:scheduleCnt}));
				//p.append($.createTagElement('span',{attrs:{cls:'number_tag'},html:scheduleCnt}));
				//div.append($.createElementJson({
				//	tagName:'td',child:
				//		{tagName:'a',id:d,onclick:'selectDate('+d+')',html:(i+1)}
				//}));
				
			}
			if(holiday){
				//p.append($.createTagElement('label',{attrs:{cls:'red'},html:(i+1)}));
			}
			else{
				//p.append($.createTagElement('label',{html:(i+1)}));
			}
			div.append(t1);
		}
		else{
			div.append($.createElementJson({
				tagName:'td',id:d,child:
					{tagName:'a',dataRole:'button',onclick:'selectDate('+d+')',html:(i+1)}
			}));
			//p.append($.createTagElement('label',{html:(i+1)}));
		}
		//div.append(p);
		week++;
	}
	var head_d = 1;
	for(var i = week; i != first%7; i=(i+1)%7){
		var d = next_year+twoDigits(next_month)+twoDigits(head_d);
		
		div.append($.createElementJson({
			tagName:'td',cls:'off',id:d,child:{tagName:'a',dataRole:'button',onclick:'createNextMonthCalendar('+d+')',html:head_d}
		}));
		//div.append($.createTagElement('p',{attrs:{cls:'external',id:d,onclick:'createNextMonthCalendar('+d+')'},
//			children:[$.createTagElement('label',{html:head_d})]}));
		
		head_d++;
	}
	//div.append(div2);
	
	$('#schedule_calendar').append(div);
	
	$('#schedule_calendar').trigger('create');
	
	//console.log(old_date);
	//console.log(currentDate);
	//selectDate(old_date,'old');
	//selectDate(currentDate);
	
	if(typeof afterCreateCalendar==='function'){
		afterCreateCalendar();
	}
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
	
	$('#title').html(cur_year+'.'+cur_month+'');
}

var old_date = '';
var currentDate;



var _y = 0;//parseInt("${params.year}",10);
var _m = 0;//parseInt("${params.month}",10);



var dayoftheweek = ['MON','TUE','WED','THU','FRI','SAT','SUN'];

var disableMap = new Array();

var scheduleMap;

var cacheKey = "";

function initCalendar(year,month,dayoftheweek){
	
	_y = year;
	_m = month;
	
	updateDateTags(_y,_m);
	createCalendar(_y,_m,'');
}

</script>