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

</jsp:scriptlet>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>샵 홈</title>
<jsp:include page="../include/total_header.jsp"/>

<script>
var siteListOptions = new Array();
</script>
<c:forEach var="sitem" items="${siteSelectList}" varStatus="c">
<script>siteListOptions[parseInt('${c.index}',10)] = {tagName:"option",value:"${sitem.s_key}",text:"${sitem.s_value}"};/*'<option value="${sitem.s_key}">${sitem.s_value}</option>';*/</script>
</c:forEach>

<c:forEach var="item" items="${siteList}" varStatus="c">
<c:set var="pre_data" value="${pre_data}/${item.s_type}${item.s_url}"/>
</c:forEach>

<script>

var itemCnt = parseInt("${fn:length(siteList)}");

function addItem(){
	
	var index = itemCnt;
	
	var $div = $.createElementJson(
			{
				tagName:"div",cls:"a_type02_b",id:"item"+index,children:
				[
				{
					tagName:"div",cls:"area00",style:"margin:0 35px 0 0;",children:
					[
					{
						tagName:"div",cls:"btn_select02",style:"float:left; width:38%;",children:
						[
						{
							tagName:"a",dataRole:"button",child:
								{tagName:"select",name:"type",dataIcon:"false",children:siteListOptions}
						},
						{
							tagName:"p",cls:"bu",child:
							{	tagName:"img",src:"${con.IMGPATH}/common/select_arrow.png",alt:"",width:"26",height:"34"}
						}
						]
					},
					{
						tagName:"p",cls:"input01",style:"float:left; width:50%; margin-left:4px;",child:
						{	tagName:"input",type:"text",name:"url"}
					}
					]
				},
				{
					tagName:"p",cls:"btn_admin01 delet_ap",child:
					{
						tagName:"a",onclick:"removeItem('item"+index+"')",dataRole:"button",child:
							{tagName:"img",src:"${con.IMGPATH}/btn/btn_d.png",alt:"",width:"31",height:"31"}
					}
				}
				]
			}
	);
	
	itemCnt++;
	
	$('#site_list').append($div);
	$('#site_list').trigger('create');
}

function removeItem(id){
	
	$('#'+id).remove();
}

function saveInfo(){
	
	/* if(!confirm('내용을 저장하시겠습니까?'))
		return; */
	
	$.ajax({
		type:'POST',
		url:'ajaxSaveSiteInfo.latte',
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
	
	var len = $('#site_list > div').length;
	
	new_data = '';
	
	for(var i = 0; i < len; i++){
		
		new_data+="/";
		new_data+=$($('#site_list > div')[i]).find("[name='type']").val();
		new_data+=$($('#site_list > div')[i]).find("[name='url']").val();
	}
	
	if(pre_data!=new_data && !confirm('변경된 내용이 있습니다.\n작성을 취소하시겠습니까?'))
		return;
	
	history.back();
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
			
			<h3 class="ma15"><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />웹사이트</h3>
			
			<form id="dataForm">
			
			<!--웹사이트 입력 -->
			<div id="site_list">
			<c:forEach var="item" items="${siteList}" varStatus="c">
			<div class="a_type02_b" id="item${c.index}">
				<div class="area00" style="margin:0 35px 0 0;">
					<div class="btn_select02" style=" float:left; width:38%;">
						<a data-role="button" >
						<select name="type" data-icon="false">
							<c:forEach var="sitem" items="${siteSelectList}">
								<option value="${sitem.s_key}" <c:if test="${sitem.s_key eq item.s_type}">selected="selected"</c:if>>${sitem.s_value}</option>
							</c:forEach>
						</select>
						</a>
						<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
					</div>
					<p class="input01" style="float:left; width:50%; margin-left:4px;"><input type="text" name="url" value="${item.s_url}"></p>
				</div>
				<p class="btn_admin01 delet_ap"><a onclick="removeItem('item${c.index}')" data-role="button"><img src="${con.IMGPATH}/btn/btn_d.png" alt="" width="31" height="31" /></a></p>
			</div>
			</c:forEach>
			</div>
			
			</form>
			
			<!-- 추가영역 버튼 -->
			<div class="btn_area">
				<p class="btn_gray02" style="width:50%"><a onclick="addItem();" data-role="button">웹사이트 추가</a></p>
			</div>
			<!-- //추가영역 버튼 끝-->
			
			<div class="btn_area03">
				<p class="btn_black02 btn_l" style="width:100px;"><a onclick="cancel();" data-role="button">취소</a></p>
				<p class="btn_red02" style="margin-left:104px;"><a onclick="saveInfo();" data-role="button">저장</a></p>
			</div>
			
			
			
			<%-- <div id="site_list">
				<c:forEach var="item" items="${siteList}" varStatus="c">
				<div id="item${c.index}" style="overflow:hidden; padding:10px;">
					<div style="float:left; width:100px;">
						<select name="type">
							<c:forEach var="sitem" items="${siteSelectList}">
								<option value="${sitem.s_key}" <c:if test="${sitem.s_key eq item.s_type}">selected="selected"</c:if>>${sitem.s_value}</option>
							</c:forEach>
						</select>
					</div>
					<div style="float:left; width:50%;">
						<input type="text" name="url" placeholder="링크될 URL 정보를 입력해 주세요." style="border:1px solid gray; color:gray;" value="${item.s_url}"/>
					</div>
					<div style="float:right;">
						<a data-role="button" onclick="removeItem('item${c.index}')" style="padding:10px;">X</a>
					</div>
				</div>
				</c:forEach>
			</div>
			</form>
			
			<hr/>
			
			<div>
				<div style="float:left; padding:10px;"><a data-role="button" onclick="cancel();" style="padding:10px;">취소</a></div>
				<div style="float:left; padding:10px;"><a data-role="button" onclick="saveInfo();" style="padding:10px;">저장</a></div>
			</div> --%>
		</div>
		
		<jsp:include page="copyright.jsp"/>
	</div>
</body>
</html>