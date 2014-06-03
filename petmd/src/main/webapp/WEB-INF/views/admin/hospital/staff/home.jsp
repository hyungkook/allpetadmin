<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../include/total_header.jsp"/>

<c:set var="staffListLen" value="${fn:length(staffList)}"/>

<script>

function pageChange(type, num){
	
	goPage('staffHome.latte?cmid='+$('#category').val()+'&pageNumber='+num);
}

var switchingTagId;

function switching(tagId,id,type){
	
	switchingTagId = tagId;
	
	if(!((switchingTagId=='item${staffListLen-1}' && type=='next' && '${params.pageNumber}'=='${params.pageCount}')
			|| (switchingTagId=='item0' && type=='previous' && '${params.pageNumber}'=='1'))){
		
		$.ajax({
			url:'ajaxStaffSwitching.latte',
			type:'POST',
			data:{
				stid:id,
				type:type,
				tagId:tagId
			},
			dataType:'text',
			success:function(response,status,xhr){
				
				var $tag = $(response);
				var $ajax = $($tag,'ajax');
	
				var result = $ajax.attr('result');
				var type = $ajax.attr('type');
				
				if(result=='${codes.SUCCESS_CODE}'){
					
					if((switchingTagId=='item${staffListLen-1}' && type=='next') || (switchingTagId=='item0' && type=='previous')){
						
						//console.log(type);
						$('#'+switchingTagId).remove();
	
						if(type=='next')
							$('#staff_list').append($tag);
						if(type=='previous')
							$('#staff_list').prepend($tag);
						
						$('ajax').remove();
						$('#staff_list').trigger('create');
						
					}else{
						//console.log(type);
						var $next = null;
						if(type=='next'){
							$next = $('#'+switchingTagId).next('li');
						}
						if(type=='previous'){
							$next = $('#'+switchingTagId).prev('li');
						}
						
						var $d = $('#'+switchingTagId).detach();
						//console.log($d.attr('id')+','+$next.attr('id'));
						var did = $d.attr('id');
						$d.attr('id', $next.attr('id'));
						$next.attr('id', did);
						//console.log($d.attr('id')+','+$next.attr('id'));
						
						if(type=='next')
							$d.insertAfter($next);// = $('#'+switchingTagId).next('div');
						if(type=='previous')
							$d.insertBefore($next);//
						
					}
				}else{
					alert('오류가 발생했습니다.\ncode : '+result);
				}
			},
			error:function(xhr,status,error){
				alert(status+'\n'+error);
			}
		});
	}
}

function remove(id){
	
	if(!confirm('작성된 내용을 삭제하시겠습니까?'))
		return;
	
	$.ajax({
		type:'POST',
		async:false,
		url:'ajaxRemoveStaffInfo.latte',
		data:{stid:id},
		dataType:'json',
		success:function(response,status,xhr){
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				alert('삭제되었습니다.');
				location.reload();
				//goPage('staffHome.latte?cmid='+$('#category').val());
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
		
		<jsp:include page="../include/main_title_bar.jsp">
			<jsp:param value="Y" name="ignore_title_back_btn"/>
		</jsp:include>
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
			
			<!-- 메인메뉴 tab -->
			<jsp:include page="../include/main_menu.jsp"/>
			
			<div class="a_type01_b">
				<div class="btn_select02" style="margin-right:84px;">
					<a data-role="button" >
					<select id="category" onchange="goPage('staffHome.latte?cmid='+$(this).val());" data-icon="false">
						<c:forEach var="item" items="${staffMenu}" varStatus="c">
							<option value="${item.s_cmid}" <c:if test="${categoryInfo.s_cmid eq item.s_cmid}">selected="selected"</c:if>>${item.s_name}</option>
						</c:forEach>
					</select>
					</a>
					<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
				</div>
				<p class="btn_black03 abs_rt02" style="width:80px;"><a onclick="goPage('staffCategoryEdit.latte')" data-role="button">메뉴 편집</a></p>
			</div>
			
			<div class="a_type01">
				<p class="btn_red02"><a onclick="goPage('staffEdit.latte')" data-role="button">등록하기</a></p>
				<div class="ad_doctor mt10">
					<ul id="staff_list">
						<c:forEach var="item" items="${staffList}" varStatus="c">
						<li id="item${c.index}">
							<a onclick="goPage('staffEdit.latte?stid=${item.s_stid}')" data-role="button">
								<img src="${con.img_dns}${item.image_path}" alt="" class="thum" width="75" height="100"/>
								<p class="bu"><label>${item.s_position}</label></p>
								<h3>${item.s_name}</h3>
								<p>현 ${hospitalInfo.s_hospital_name} 소속</p>
								<p>${item.s_specialty}</p>
							</a>
							<p class="btn_t btn_admin01"><a onclick="switching($(this).parent().parent().attr('id'),'${item.s_stid}','previous')" data-role="button"><img src="${con.IMGPATH}/btn/btn_t.png" alt="" width="31" height="31" /></a></p>
							<p class="btn_b btn_admin01"><a onclick="switching($(this).parent().parent().attr('id'),'${item.s_stid}','next')" data-role="button"><img src="${con.IMGPATH}/btn/btn_b.png" alt="" width="31" height="31" /></a></p>
							<p class="btn_d btn_admin01"><a onclick="remove('${item.s_stid}');" data-role="button"><img src="${con.IMGPATH}/btn/btn_d.png" alt="" width="31" height="31" /></a></p>
						</li>
						</c:forEach>
						<c:if test="${empty staffList}">
						<li style="padding:20px;">등록된 항목이 없습니다</li>
						</c:if>
					</ul>
				</div>
			</div>
			
			<jsp:include page="../include/INC_PAGE.jsp"/>
			
		</div>
		<!-- ///// content 끝-->
		
		<jsp:include page="../home/copyright.jsp"/>

	</div>

</body>
</html>