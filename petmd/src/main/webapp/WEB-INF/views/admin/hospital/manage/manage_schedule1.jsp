<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%-- <jsp:include page="/WEB-INF/views/admin/hospital/include/INC_JSP_HEADER.jsp"/> --%>
<jsp:include page="../include/total_header.jsp"/>

<script>
function getDDayList(monthdate){
	
	$.ajax({
		url:'ajaxManageScheduleList.latte?date='+monthdate,
		//type:"POST",
		//url:'hospitalServiceMenuEdit.latte',
		//data:$('#subMenuForm').serialize(),
		//dataType:'text',
		success:function(response, status, xhr){
			
			$('#ddaylist').empty();
			$('#ddaylist').append(response);
		},
		error:function(xhr, status, error){
			
			alert(status+","+error);
		}
	});
}

var pageNumber = parseInt("${params.pageNumber}");
var totalPage = parseInt("${params.pageCount}");

function expand(){
	
	pageNumber++;
	if(pageNumber > totalPage){
		pageNumber = totalPage;
		alert('더 이상 항목이 없습니다.');
		$('#more_btn').attr('disabled',true);
		$('#more_btn').off('click');
		$('#more_btn').remove();
		return;
	}
	
	$.mobile.showPageLoadingMsg('a','목록을 불러오는 중입니다.');
	
	$.ajax({
		url:'ajaxManageScheduleList.latte',
		type:'POST',
		data:{
			pageNumber:pageNumber,
			date:$('#month_select').val()
		},
		dataType:'text',
		success:function(response,status,xhr){
			
			$('#ddaylist').append(response);
			
			$.mobile.hidePageLoadingMsg();
			
			if(pageNumber >= totalPage){
				pageNumber = totalPage;
				$('#more_btn').attr('disabled',true);
				$('#more_btn').off('click');
				$('#more_btn').remove();
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

</script>

</head>
<body>

	<div id="page" data-role="page" style="background: #f7f3f4; overflow: hidden">
	
		<jsp:include page="../include/manage_title_bar.jsp">
			<jsp:param name="title_bar_title" value="스케줄"/>
		</jsp:include>
		
		<!-- content 시작-->
		<div data-role="content" id="contents" style="overflow: hidden">
		
			<jsp:include page="../include/manage_menu.jsp">
				<jsp:param name="cur_manage_menu" value="4"/>
			</jsp:include>
		
			<div style="display:inline-block; width:70%; margin-top:10px;">
			<select id="month_select" onchange="goPage('manageSchedule.latte?date='+$(this).val());">
				<c:forEach var="item" items="${monthList}">
					<option value="${item.date}" <c:if test="${item.date eq selectedDate}">selected="selected"</c:if>>${item.date}</option>
				</c:forEach>
			</select>
			</div>
			
			<a onclick="goPage('manageScheduleEdit.latte')">등록</a>
			
			<div id="ddaylist" style="margin:5px 5px;">
				<jsp:include page="schedule_list_item.jsp"/>
			</div>
			
			<div style="overflow:hidden;">
				<div style="float:left; width:75%;">
					<a data-role="button" onclick="expand()" id="more_btn" style="margin:8px; padding:7px;">더보기</a>
				</div>
				<div style="float:left; width:25%;">
					<a data-role="button" onclick="moveTop();" style="margin:8px; padding:7px;">맨 위로</a>
				</div>
			</div>
			
		</div>
	
	</div>

</body>
</html>