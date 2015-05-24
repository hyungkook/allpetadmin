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

<% String[] weekstr = new String[]{"매일","평일","주말","공휴일","월요일","화요일","수요일","목요일","금요일","토요일","일요일","연중무휴"}; %>
<%String[] str = new String[48]; %>
<%int index = 0; %>
<%int t = 0; %>
<%for(int i = 0; i < 24; i++){ %>
<%	str[i*2]=(i<10?"0"+i:""+i)+":00"; %>
<%	str[i*2+1]=(i<10?"0"+i:""+i)+":30"; %>
<%} %>

<c:set var="weeks" value='<%= weekstr %>'/>
<c:set var="times" value='<%= str %>'/>

<c:forEach var="item" items="${workingTimeList}" varStatus="c">
<c:set var="pre_data" value="${pre_data}/nm${item.s_name}cm${item.s_comment}st${item.s_start_time}et${item.s_end_time}at${item.s_alltime}do${item.s_dayoff}"/>
</c:forEach>

<script>
var weeks = new Array();
<c:forEach var="item" items="${weeks}" varStatus="c">
weeks[parseInt('${c.index}')]='${item}';
</c:forEach>
var times = new Array();
<c:forEach var="item" items="${times}" varStatus="c">
times[parseInt('${c.index}')]='${item}';
</c:forEach>

var index = parseInt("${fn:length(workingTimeList)}");

function addItem(){
	
	var weeks_options = new Array();
	for(var wi = 0; wi < weeks.length; wi++){
		//weeks_options += '<option value="'+weeks[wi]+'">'+weeks[wi]+'</option>';
		weeks_options[wi]=
			{
				tagName:"option",value:weeks[wi],text:weeks[wi]
			};
	}
	
	var times_options = new Array();
	for(var ti = 0; ti < times.length; ti++){
		//times_options += '<option value="'+times[ti]+'">'+times[ti]+'</option>';
		times_options[ti]=
		{
			tagName:"option",value:times[ti],text:times[ti]
		};
	}
		
	var check_num1 = (index)*2+1;
	var check_num2 = index*2+2;
	
	var $tag = ps(
			{
				tagName:"div",cls:"a_type02_b",id:"item"+index,children:
					[
					{
						tagName:"div",cls:"area00",style:"margin:0 35px 0 0;",children:
							[
							{tagName:"input",type:"hidden",id:"alltime"+index,name:"alltime",value:"N"},
							{tagName:"input",type:"hidden",id:"dayoff"+index,name:"dayoff",value:"N"},
							{
								tagName:"div",cls:"btn_select02",style:"float:left; width:44%;",child:
								{
									tagName:"p",cls:"input01",child:
										{tagName:"input",type:"text",name:"name"}
								}
 							},
							{
								tagName:"p",cls:"checkbox",style:"float:left; width:28%; margin:10px 0 0 5px;",children:
									[
									{tagName:"input",type:"checkbox",id:"checkbox-c"+check_num1,onclick:"check('alltime"+index+"',this)"},
									{tagName:"label",_for:"checkbox-c"+check_num1,text:"24시간"}
									]
							},
							{
								tagName:"p",cls:"checkbox",style:"float:left; width:25%; margin:10px 0 0 0;",children:
									[
									{tagName:"input",type:"checkbox",id:"checkbox-c"+check_num2,onclick:"check('dayoff"+index+"',this)"},
									{tagName:"label",_for:"checkbox-c"+check_num2,text:"휴무"}
									]
							}
							]
					},
					{
						tagName:"div",cls:"area00",style:"margin:5px 35px 0 0;",children:
							[
							{
								tagName:"div",cls:"btn_select02",style:"float:left; width:44%;",children:
									[
									{
										tagName:"a",dataRole:"button",child:
											{tagName:"select",name:"start_time",dataIcon:"false",children:times_options}
									},
									{
										tagName:"p",cls:"bu",child:
											{tagName:"img",src:"${con.IMGPATH}/common/select_arrow.png",alt:"",width:"26",height:"34"}
									}
									]
							},
							{tagName:"p",cls:"fleft",style:"text-align:center; width:10%; padding-top:10px;",text:"~"},
							{
								tagName:"div",cls:"btn_select02",style:"float:left; width:44%;",children:
								[
								{
									tagName:"a",dataRole:"button",child:
										{tagName:"select",name:"end_time",dataIcon:"false",children:times_options}
								},
								{
									tagName:"p",cls:"bu",child:
										{tagName:"img",src:"${con.IMGPATH}/common/select_arrow.png",alt:"",width:"26",height:"34"}
								}
								]
							}
							]
					},
					{
						tagName:"div",cls:"area00",style:"margin:5px 35px 0 0;",child:
						{
							tagName:"p",cls:"input01",child:
								{tagName:"input",type:"text",name:"comment"}
						}
					},
					{
						tagName:"p",cls:"btn_admin01 delet_ap",child:
						{
							tagName:"a",onclick:"removeItem('item"+index+"');",dataRole:"button",child:
								{tagName:"img",src:"${con.IMGPATH}/btn/btn_d.png",alt:"",width:"31",height:"31"}
						}
					}
					]
			}
	);
	
	$('#time_list').append($tag);
	$('#time_list').trigger('create');
	
	index++;
}

function removeItem(id){
	
	$('#'+id).remove();
}

function check(targetId,chkbox){
	
	if($(chkbox).is(':checked'))
		$('#'+targetId).val('Y');
	else
		$('#'+targetId).val('N');
}

function saveInfo(){
	
	if(!confirm('내용을 저장하시겠습니까?'))
		return;
	
	$.ajax({
		type:'POST',
		url:'ajaxSaveWorkingTime.latte',
		data:$('#dataForm').serialize(),
		dataType:'json',
		success:function(response,status,xhr){
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				showDialog('저장이 완료되었습니다.','default',function(){
					history.back();
				});
			}
			else
				showDialog('저장 중 오류가 발생하였습니다.','default');
		},
		error:function(xhr,status,error){
			
			alert("실패하였습니다.\n"+status+"\n"+error);
		}
	});
}

var pre_data = '${pre_data}';
var new_data = '';

function cancel(){
	
	var len = $('#time_list > div').length;
	
	new_data = '';
	
	for(var i = 0; i < len; i++){
		
		new_data+="/";
		new_data+="nm"+$($('#time_list > div')[i]).find("[name='name']").val();
		new_data+="cm"+$($('#time_list > div')[i]).find("[name='comment']").val();
		new_data+="st"+$($('#time_list > div')[i]).find("[name='start_time']").val();
		new_data+="et"+$($('#time_list > div')[i]).find("[name='end_time']").val();
		new_data+="at"+$($('#time_list > div')[i]).find("[name='alltime']").val();
		new_data+="do"+$($('#time_list > div')[i]).find("[name='dayoff']").val();
	}
	
	if(pre_data!=new_data && !confirm('변경된 내용이 있습니다.\n작성을 취소하시겠습니까?'))
		return;
	
	history.back();
}

$(document).ready(function(){
	ddd();
});

function ddd(){
	
	var e =
	{
		tagName:"p",cls:"aaa",css:{width:"100px",zIndex:"1"},children:
			[
				{
					tagName:"span",cls:"bbb",html:"으악악"
				},
				{
					tagName:"span",cls:"ccc"
				}
			]
	};
	
	$('body').append(ps(e));
}

function ps(p){
	
	var tag = $("<"+p.tagName+"/>");
	
	for(var attr in p){
		var attr1 = attr;
		for(var i=0; i < attr.length; i++){
			//console.log((attr_item.charAt(i)+""));
			if((attr.charAt(i)+"").match(/A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z/)){
				attr=attr.substring(0,i)+"-"+attr.substring(i).toLowerCase();
				//alert(attr_item);
				i++;
			}
			else if(attr.charAt(0)=='_'){
				attr=attr.substring(1);
				//alert(attr_item);
				i++;
			}
		}
		console.log(attr);
		if(attr=='css'||attr=='tagName'||attr=='children'){
			
		}
		else{
			if(attr=='cls'){tag.attr('class',p[attr1]);}
			else{
				if(attr=='html'){
					tag.html(p[attr1]);
				}
				else if(attr=='text'){
					tag.text(p[attr1]);
				}
				else if(attr=='value'){
					tag.val(p[attr1]);
				}
				else{
					tag.attr(attr,p[attr1]);
				}
			};
		}
	}
	
	if(!(typeof p.css === 'undefined')){
		for(var css_item in p.css){
			tag.css(css_item,p.css[css_item]);
		}
	}
	
	if(!(typeof p.child === 'undefined')){
		tag.append(ps(p.child));
	}
	
	if(!(typeof p.children === 'undefined')){
		for(var ci=0;ci<p.children.length;ci++){
			tag.append(ps(p.children[ci]));
		}
	}
	
	return tag;
}

</script>



</head>
<body>

	<div data-role="page">
	
		<jsp:include page="/common/admin/hospital/INC_INSTANCE_DIALOG.jsp"/>
		<jsp:include page="../include/main_title_bar.jsp">
			<jsp:param name="back_function" value="cancel"/>
		</jsp:include>
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
			
			<!-- 메인메뉴 tab -->
			<jsp:include page="../include/main_menu.jsp"/>
			
			<!-- 운영시간 등록 1 설정 -->
			<h3 class="ma15"><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />운영시간 등록</h3>
			
			<form id="dataForm">
			<div id="time_list">
			<c:forEach var="item" items="${workingTimeList}" varStatus="c">
				<c:set var="check_num1" value="${c.index*2+1}"/>
				<c:set var="check_num2" value="${c.index*2+2}"/>
			<div class="a_type02_b" id="item${c.index}">
				<div class="area00" style="margin:0 35px 0 0;">
					<input type="hidden" id="alltime${c.index}" name="alltime" value="<c:if test='${empty item.s_alltime}'>N</c:if><c:if test='${not empty item.s_alltime}'>${item.s_alltime}</c:if>"/>
					<input type="hidden" id="dayoff${c.index}" name="dayoff" value="<c:if test='${empty item.s_dayoff}'>N</c:if><c:if test='${not empty item.s_dayoff}'>${item.s_dayoff}</c:if>"/>
					<div class="area00" style="float:left; width:44%;">
						<p class="input01"><input type="text" name="name" placeholder="운영시간을 입력하세요." value="${item.s_name}"></p>
					</div>
					<%-- <div class="btn_select02" style=" float:left; width:44%;">
						<a data-role="button" >
						<select name="name" data-icon="false">
							<c:forEach var="witem" items="${weeks}">
								<option value="${witem}" <c:if test="${witem eq item.s_name}">selected="selected"</c:if>>${witem}</option>
							</c:forEach>
						</select>
						</a>
						<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
					</div> --%>
					<p class="checkbox" style="float:left; width:28%; margin:10px 0 0 5px;">
						<input type="checkbox" id="checkbox-c${check_num1}" value="c-${check_num1}"<c:if test="${item.s_alltime eq 'Y'}"> checked="checked"</c:if> onclick="check('alltime${c.index}',this)"/>
						<label for="checkbox-c${check_num1}">24시간</label>
					</p>
					<p class="checkbox" style="float:left; width:25%; margin:10px 0 0 0;">
						<input type="checkbox" id="checkbox-c${check_num2}" value="c-${check_num2}" <c:if test="${item.s_dayoff eq 'Y'}">checked="checked"</c:if> onclick="check('dayoff${c.index}',this)"/>
						<label for="checkbox-c${check_num2}">휴무</label>
					</p>
				</div>
				<div class="area00" style="margin:5px 35px 0 0;">
					<div class="btn_select02" style=" float:left; width:44%;">
						<a data-role="button" >
						<select name="start_time" data-icon="false">
							<c:forEach var="titem" items="${times}">
								<option value="${titem}" <c:if test="${titem eq item.s_start_time}">selected="selected"</c:if>>${titem}</option>
							</c:forEach>
						</select>
						</a>
						<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
					</div>
					<p class="fleft" style="text-align:center; width:10%; padding-top:10px;" >~</p>
					<div class="btn_select02" style=" float:left; width:44%;">
						<a data-role="button" >
						<select name="end_time" data-icon="false">
							<c:forEach var="titem" items="${times}">
								<option value="${titem}" <c:if test="${titem eq item.s_end_time}">selected="selected"</c:if>>${titem}</option>
							</c:forEach>
						</select>
						</a>
						<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
					</div>
				</div>
				<div class="area00" style="margin:5px 35px 0 0;">
					<p class="input01"><input type="text" name="comment" placeholder="추가 내용을 입력하세요." value="${item.s_comment}"></p>
				</div>
				<p class="btn_admin01 delet_ap"><a onclick="removeItem('item${c.index}')" data-role="button"><img src="${con.IMGPATH}/btn/btn_d.png" alt="" width="31" height="31" /></a></p>
			</div>
			</c:forEach>
			</div>
			<!-- //운영시간 등록 1 설정 끝 -->
			</form>
			
			<!-- 추가영역 버튼 -->
			<div class="btn_area">
				<p class="btn_gray02" style="width:50%"><a onclick="addItem();" data-role="button">운영시간 정보 추가</a></p>
			</div>
			<!-- //추가영역 버튼 끝-->
			
			<div class="btn_area03">
				<p class="btn_black02 btn_l" style="width:100px;"><a onclick="cancel();" data-role="button">취소</a></p>
				<p class="btn_red02" style="margin-left:104px;"><a onclick="saveInfo();" data-role="button">저장</a></p>
			</div>

		</div>
		
		<jsp:include page="copyright.jsp"/>
	</div>
</body>
</html>