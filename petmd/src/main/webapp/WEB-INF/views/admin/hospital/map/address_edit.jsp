<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<jsp:include page="../include/total_header.jsp"/>

<script>

$(document).ready(function(){
	
	zipcodeSearchClose();
	$('#zip_search_result_area').hide();
	$('#zip_search_msg').hide();
});

function checkbox(me,targetId){
	
	if($(me).is(':checked'))
		$('#'+targetId).val('Y');
	else
		$('#'+targetId).val('N');
}

function saveInfo(){
	
	$('#old_zipcode').val($('#old_zipcode_1').val()+"-"+$('#old_zipcode_2').val());
	
	$.ajax({
		url:'ajaxSaveAddressInfo.latte',
		type:'POST',
		data:$('#form').serialize(),
		dataType:'json',
		success:function(response, status, xhr){
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				$('#bid').val(response.bid);
				showDialog('저장이 완료되었습니다.','default');
			}
		},
		error:function(xhr,status,error){
			alert(status+'\n'+error);
		}
	});
}

function zipcodeSearchOpen(){
	
	//$('#poparea').show();
	$('#input_layer').hide();
	$('#zip_layer').show();
}

function zipcodeSearchClose(){
	
	$('#input_layer').show();
	$('#zip_layer').hide();
	//$('#poparea').hide();
}

var _search_text = "";

function zipcodeSearch(){
	
	if (!$('#zipcode_search_text').val()) {
		alert("검색어를 입력해주시기 바랍니다.");
		return;
	}
	
	var search_text = $("#zipcode_search_text").val();
	
	if(search_text=="시"||search_text=="구"||search_text=="동"||search_text=="리"||search_text=="읍"||search_text=="면"||search_text=="군"){
		alert("해당 단어로는 검색할 수 없습니다.");
		return;
	}
	
	_search_text = search_text;
	
	jQuery.ajax({
		type:"POST",
		url:"zipcodeSearch.latte",
		data:{
			"search_text":search_text
		},
		dataType:'text',
		success:function(responseText, statusText, xhr, $form){
			
			var list = $.parseJSON(decodeURIComponent(responseText));
			
			$('#zipcode_search_first').hide();
			$('#zip_search_result_area').show();
			
			$('#zipcode_frame tr').remove();
			
			$('#zip_search_result_location').text('\''+_search_text+'\'');
			
			if(list.length == 0){
				
				$('#zip_search_result_msg').text('(으)로 검색된 우편번호가 없습니다.');
				
			}else{
				
				$('#zip_search_msg').show();

				$('#zip_search_result_msg').text('(으)로 검색된 우편번호 결과입니다.');
					
				$('#zipcode_frame').append('<tr><th>주소</th><th>우편번호</th></tr>');
				
				for(var i = 0; i < list.length; i++){
					
					var zip = list[i].s_zipcode.split('\-');
					
					var tag = $(''
					+'<tr>'
						+'<td><a onclick="updateZipcode(\''+zip[0]+'\',\''+zip[1]+'\',\''
							+list[i].s_sido+'\',\''+list[i].s_gugun+'\',\''+list[i].s_dong+'\',\''+list[i].s_bldg+'\')" data-role="button">'
							+list[i].s_sido+' '+list[i].s_gugun+' '+list[i].s_dong+' '+list[i].s_bldg+' '+list[i].s_bunji+'</a></td>'
						+'<td><a data-role="button">'+zip[0]+"-"+zip[1]+'</a></td>'
					+'</tr>');
							
					$('#zipcode_frame').append(tag);
					//$('#zipcode_list').append(tag);
				};
			}
			
			$('#zipcode_frame').trigger('create');
			 
		}, error: function(xhr,status,error){
			alert("error\n"+xhr+"\n"+status+"\n"+error);
		}
	});
}

function updateZipcode(zipcode1, zipcode2, sido, gugun, dong, detail){
		
	$("#old_zipcode_1").val(zipcode1);
	$("#old_zipcode_2").val(zipcode2);
	$("#old_zipcode").val(zipcode1+"-"+zipcode2);
	
	$("#old_addr_sido").val(sido);
	$("#old_addr_sigungu").val(gugun);
	$("#old_addr_dong").val(dong+" "+detail);
	$("#old_address").val(sido+" "+gugun+" "+dong+" "+detail);
	
	zipcodeSearchClose();
}

function cancel(){
	
	if($('#zip_layer').is(':visible')){
		
		zipcodeSearchClose();
	}
	else{
		history.back();
	}
}

</script>

</head>

<body>
		
	<div data-role="page">
	
		<jsp:include page="/common/admin/hospital/INC_INSTANCE_DIALOG.jsp"/>
		
		<jsp:include page="../include/main_title_bar.jsp"><jsp:param name="back_function" value="cancel"/></jsp:include>
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
			
			<!-- 메인메뉴 tab -->
			<jsp:include page="../include/main_menu.jsp"/>
			
			<form id="form">
			
			<input type="hidden" id="old_addr_sido" name="old_addr_sido" value="${addressInfo.s_old_addr_sido}"/>
			<input type="hidden" id="old_addr_sigungu" name="old_addr_sigungu" value="${addressInfo.s_old_addr_sigungu}"/>
			<input type="hidden" id="old_addr_dong" name="old_addr_dong" value="${addressInfo.s_old_addr_dong}"/>
			<input type="hidden" id="old_zipcode" name="old_zipcode" value="${addressInfo.s_old_zipcode}"/>
			
			<div id="input_layer">
				<h3 class="ma15"><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />오시는길 정보관리</h3>
				
				<div class="a_type02_b">
					<h3>주소정보</h3>
					<div class="area00 mt05">
						<p class="input01" style="display:inline-block; width:15%; vertical-align:top;"><input type="text" id="old_zipcode_1" value="${fn:split(addressInfo.s_old_zipcode,'-')[0]}"></p>
						<span style="display:inline-block; width:15px; text-align:center; line-height:35px;">-</span>
						<p class="input01" style="display:inline-block; width:15%; vertical-align:top;"><input type="text" id="old_zipcode_2" value="${fn:split(addressInfo.s_old_zipcode,'-')[1]}"></p>
						<p class="btn_black04" style="display:inline-block; width:40%; vertical-align:top;"><a onclick="zipcodeSearchOpen();" data-role="button">우편번호 검색</a></p>
					</div>
					<p class="input01 mt05" ><input type="text" id="old_address" value="${addressInfo.s_old_addr_sido} ${addressInfo.s_old_addr_sigungu} ${addressInfo.s_old_addr_dong}" readonly></p>
					<p class="input01 mt05" ><input type="text" name="old_addr_etc" value="${addressInfo.s_old_addr_etc}" placeholder="상세 주소를 입력해 주세요."></p>
				</div>
				
				<div class="a_type02_b">
					<input type="hidden" id="car_check" name="car_check" value="${addressInfo.path_car_status}"/>
					<h3>
						자가용 정보
						<p class="checkbox po_r02" style=" width:70px;">
							<input type="checkbox" id="checkbox-c1" value="c-1" <c:if test="${addressInfo.path_car_status eq 'Y'}">checked="checked"</c:if> onclick="checkbox(this,'car_check')"/>
							<label for="checkbox-c1">사용함</label>
						</p>
					</h3>
					<p class="textarea01 mt10"><textarea name="car" style="width:100%; height:60px;" placeholder="내용을 입력해 주세요.">${addressInfo.path_car}</textarea></p>
				</div>
				
				<div class="a_type02">
					<input type="hidden" id="bus_check" name="bus_check" value="${addressInfo.path_bus_status}"/>
					<h3>
						버스 정보
						<p class="checkbox po_r02" style=" width:70px;">
							<input type="checkbox" id="checkbox-c2" value="c-2" <c:if test="${addressInfo.path_bus_status eq 'Y'}">checked="checked"</c:if> onclick="checkbox(this,'bus_check')"/>
							<label for="checkbox-c2">사용함</label>
						</p>
					</h3>
					<p class="textarea01 mt10"><textarea name="bus" style="width:100%; height:60px;" placeholder="내용을 입력해 주세요.">${addressInfo.path_bus}</textarea></p>
				</div>
				
				<div class="a_type02_b">
					<input type="hidden" id="subway_check" name="subway_check" value="${addressInfo.path_subway_status}"/>
					<h3>
						지하철 정보
						<p class="checkbox po_r02" style=" width:70px;">
							<input type="checkbox" id="checkbox-c3" value="c-3" <c:if test="${addressInfo.path_subway_status eq 'Y'}">checked="checked"</c:if> onclick="checkbox(this,'subway_check')"/>
							<label for="checkbox-c3">사용함</label>
						</p>
					</h3>
					<p class="textarea01 mt10"><textarea name="subway" style="width:100%; height:60px;" placeholder="내용을 입력해 주세요.">${addressInfo.path_subway}</textarea></p>
				</div>
				
				<div class="btn_area03">
					<p class="btn_black02 btn_l" style="width:100px;"><a onclick="cancel();" data-role="button">취소</a></p>
					<p class="btn_red02" style="margin-left:104px;"><a onclick="saveInfo();" data-role="button">수정</a></p>
				</div>
			</div>
			
			<div id="zip_layer">
				<div class="a_type02_b">
					<div class="tab02">
						<ul>
							<li class="on" style="width:100%;"><a data-role="button">구주소로 검색하기</a></li>
							<!-- <li><a href="index.html" data-role="button" style="border-left:none;">신주소로 검색하기</a></li> -->
						</ul>
					</div>
					
					<p class="txt_gray11 mt15">동(읍/면/리) 지역명을 입력해 주세요.</p>
					<div class="area00 mt05">
						<p class="input01" style="margin-right:85px;" ><input type="text" id="zipcode_search_text"></p>
						<p class="btn_black04 abs_rt" style="width:80px;"><a onclick="zipcodeSearch()" data-role="button">검색</a></p>
					</div>
					<p class="txt_gray12 mt15" id="zip_search_result_area">
						<img src="${con.IMGPATH}/common/bu_arrow.png" alt="" width="4" height="8"/>
						<span class="orange bold" id="zip_search_result_location">'서초동'</span><span id="zip_search_result_msg">(으)로 검색된 우편번호 결과입니다.</span> 
					</p>
					<p class="txt_gray12 mt15" id="zipcode_search_first">
						<img src="${con.IMGPATH}/common/bu_arrow.png" alt="" width="4" height="8"/>
						<span class="orange bold">지역명 : </span>예) 역삼동, 화도읍, 장유면
					</p>
					<table  class="table_type02 mt05" id="zipcode_frame">
						<colgroup>
							<col width="75%" /><col width="25%" />
						</colgroup>
					</table>
					<p class="txt_gray11 mt05" id="zip_search_msg">선택을 하시려면 해당 결과를 클릭해 주세요.</p>
				</div>
			</div>
			
			</form>
		</div>
	
	</div>
	
	<jsp:include page="../include/simple_copyright.jsp"/>

</body>
</html>