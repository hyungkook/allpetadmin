<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>

<jsp:include page="../include/total_header.jsp"/>

<script src="${con.JSPATH}/jquery.number.js"></script>

<script>

var user_name = '';
var uid = '';
var pre_uid = '';

if(location.hash=='pet'||location.hash=='#pet'){
	history.back();
}

$(document).ready(function(){
	
	$('#user_list').hide();
	$('#pet_area').hide();
	
	setInputConstraint('phoneNumber','phone',12);
	setInputConstraint('numberOnly','point_val',10);
	
	setPayMode('${params.type}');
});

function checkbox(me,targetId){
	
	if($(me).is(':checked'))
		$('#'+targetId).val('Y');
	else
		$('#'+targetId).val('N');
}

function pageChange(type,page,id){
	
	alert(id);
	$.ajax({
		url:'ajaxInnerPetList.latte',
		type:'POST',
		data:{
			pagingSendValue:id,
			pagingBlockId:id,
			pageNumber:page
		},
		dataType:'text',
		success:function(response, status, xhr){
			
			$('#pet_list_inner').empty();
			$('#pet_list_inner').append(response);
		},
		error:function(xhr,status,error){
			alert(status+'\n'+error);
		}
	});
}

function openPetList(id){
	
	uid = id;
	//if($('#pet_list_inner').html()==''){
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

function searchUser(type,phone,id){
	
	$.ajax({
		url:'ajaxSearchUser.latte',
		type:'POST',
		data:{
			type:type,
			phone:phone,
			uid:id
		},
		dataType:'json',
		success:function(response, status, xhr){
			
			if(response.result!='${codes.SUCCESS_CODE}'){
				
				alert('검색 결과가 없습니다.');
				return;
			}
			
			$('#user_list').show();
			
			$('#uid').val(response.uid);
			uid=response.uid;
			
			user_name = decodeURIComponent(response.name);
			$('#user_list #user_name').html(user_name+' ('+formatPhoneNumber(response.cphone_number,'-')+')');
			var up_icon = $('#user_list #user_point img').detach();
			$('#user_list #user_point').html($.number(response.point_sum)+" ");
			$('#user_list #user_point').append(up_icon);
			
			$('#pet_btn').off('click');
			$('#pet_btn').on('click',function(){openPetList(response.uid);});
			
			$('#pet_list').hide();
		},
		error:function(xhr,status,error){
			alert(status+'\n'+error);
		}
	});
}

function pointPay(){
	
	//$('#old_zipcode').val($('#old_zipcode_1').val()+"-"+$('#old_zipcode_2').val());
	
	if(isNoValue('point_val')){
		alert('포인트를 입력하세요.');
		return;
	}
	
	$.ajax({
		url:'ajaxUserPoint.latte',
		type:'POST',
		async:false,
		data:$('#form').serialize(),
		dataType:'json',
		success:function(response, status, xhr){
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				$('#bid').val(response.bid);
				showDialog('처리되었습니다.');
			}
			else if(response.result=='${codes.ERROR_POINT_LACKED}'){
				$('#point_val').val(response.point);
			}
			else
				alert(response.result);
		},
		error:function(xhr,status,error){
			alert(status+'\n'+error);
		}
	});
}

function setPayMode(val){
	if(val=='pay'){
		$('#pt_btn .ui-btn-text').html('포인트 지급');
		$('#type').val('pay');
	}
	if(val=='return'){
		$('#pt_btn .ui-btn-text').html('포인트 회수');
		$('#type').val('return');
	}
	if(val=='history'){
		goPage('pointHistory.latte?period=7');
	}
}

function back(){
	
	if($('#pet_area').is(':visible')){
		$('#pet_area').hide();
		$('#point_area').show();
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
			$('#point_area').hide();
			$('#pet_area').show();
			manage_title_icon_change('back');
		}
	}
	else{
		if($('#pet_area').is(':visible')){
			$('#pet_area').hide();
			$('#point_area').show();
			manage_title_icon_change('home');
		}
	}
});

</script>
</head>

<body>
		
	<div data-role="page">
		
		<jsp:include page="/common/admin/hospital/INC_IMAGE_CROP2.jsp"></jsp:include>
		<jsp:include page="/common/admin/hospital/INC_INSTANCE_DIALOG.jsp"/>
		
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
			
			<div id="point_area">
			<div class="a_type01_b">
				<div class="btn_select02">
					<a data-role="button" >
					<select data-icon="false" onchange="setPayMode($(this).val());">
						<option value="pay" <c:if test="${params.type eq 'pay'}">selected="selected"</c:if>>포인트 지급</option>
						<option value="return" <c:if test="${params.type eq 'return'}">selected="selected"</c:if>>포인트 회수</option>
						<option value="history" <c:if test="${params.type eq 'history'}">selected="selected"</c:if>>포인트 이력 및 회원관리</option>
					</select>
					</a>
					<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
				</div>
			</div>
			
			
			
			<div class="a_type01">
			<!-- <a data-role="button" onclick="location.hash=(new Date()).getTime();">aaa</a> -->
				<h3>사용자 검색 <span class="t01">(휴대폰 번호로 검색하실 수 있습니다.)</span></h3>
				<div class="area00 mt05">
					<p class="input01" style="margin-right:85px;" ><input type="text" id="phone"></p>
					<p class="btn_black04 abs_rt" style="width:80px;"><a onclick="searchUser('',$('#phone').val(),'')" data-role="button">검색</a></p>
				</div>
				<p class="txt_gray11 mt05">*숫자만 입력해 주세요.</p>
	
				<div class="g_box mt20" id="user_list">
					<ul>
						<li>
							<p class="txt01" id="user_name">홍길동 (010-1234-5678)</p>
							<p class="txt02 orange mt05" id="user_point">123,456,789 <img src="${con.IMGPATH}/common/icon_p.png" alt="" width="15" height="15"/></p>
							<p class="btn_red03 btn_r" style="width:80px;"><a id="pet_btn" data-role="button">반려동물 <img src="${con.IMGPATH}/common/bu_arrow02.png" alt="" width="6" height="10"/></a></p>
						</li>
					</ul>
				</div>
				
				<div class="dl_type01 mt10">
					<form id="form">
					<input type="hidden" id="uid" name="uid" value=""/>
					<input type="hidden" id="type" name="type" value="pay"/>
					<dl>
						<dt>지급 포인트</dt>
						<dd><p class="input01"><input type="text" id="point_val" name="point"></p></dd>
					</dl>
					<dl class="mt05">
						<dt>지급 사유</dt>
						<dd><p class="input01"><input type="text" name="desc"></p></dd>
					</dl>
					</form>
				</div>
				
				<p class="btn_red02 mt15"><a id="pt_btn" onclick="pointPay();" data-role="button">포인트 지급</a></p>
				
			</div>
			</div>
			
			<div id="pet_area">
			</div>
			
		</div>
		<!-- contents end -->
		
		<jsp:include page="../include/simple_copyright.jsp"/>
	
	</div>

</body>
</html>