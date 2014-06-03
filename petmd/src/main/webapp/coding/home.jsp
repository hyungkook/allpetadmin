<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi">
<meta name="apple-mobile-web-app-capable" content="yes">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name = "format-detection" content = "telephone=no">
	<title>동물병원</title>

<script src="/petmd/common/template/js/jquery-1.6.4.js"></script>
	<script src="/petmd/common/template/js/jquery.mobile-1.2.0.js"></script>
	
	<link rel="stylesheet" href="/petmd/common/template/css/jquery.mobile-1.2.0.css" type="text/css"/>
<link rel="stylesheet" href="/petmd/common/template/css/common.css" type="text/css"/>
<link rel="stylesheet" href="/petmd/common/template/css/style.css" type="text/css"/>
</head>

<script>
$(window).load(function(){
	var mh = $('.mypage_header').find('img');
	mh.height($('.mypage_header').find('a').height());
	mh.width($('.mypage_header').find('a').height());
});

</script>

<body>
<div data-role="page">

	<!-- content 시작-->
	<div data-role="content" id="contents">
	
		<div class="mypage_header">
			<div class="back"><a data-role="button"><img height="0" src="/petmd/common/template/images/btn/btn_back.png"/></a></div>
			<div class="back"><a data-role="button"><img height="0" src="/petmd/common/template/images/btn/btn_back.png"/></a></div>
			마이페이지
		</div>
		
		<div class="mypage_home_edit">
			<div class="info">
				<p class="name">홍길동(크리스탈)</p>
				<p class="email mt05">gildong@google.com</p>
			</div>
			<div class="btn">
				<a data-role="button"><img src="/petmd/common/template/images/btn/btn_myinfo_edit.png" alt="" width="100%" height="100%" /></a>
			</div>
		</div>
		
		<div class="a_type02">
			<h3><img src="/petmd/common/template/images/common/bu_tt.png" alt="" width="16" height="14" />예정 스케줄</h3>
			<div class="round_list">
				<div class="tag"><img src="/petmd/common/template/images/common/icon_schedule_on.png" alt="" width="24" height="24"/></div>
				<table>
					<colgroup>
						<col width="25%"><col width="*">
					</colgroup>
					<tr>
						<td rowspan="3" class="dday_red">
						<div>D-day<br/><span>12</span>
						
						</div></td>
						<td class="title">강남동물병원</td>
					</tr>
					<tr>
						<td class="contents">뽀미 심장 사상충 1차 예방 접종 예약</td>
					</tr>
					<tr>
						<td class="time">[2014-02-28 06:00]</td>
					</tr>
				</table>
			</div>
			<div class="round_list">
				<table>
					<colgroup>
						<col width="25%"><col width="*">
					</colgroup>
					<tr>
						<td rowspan="3" class="dday"><span>종료</span></td>
						<td class="title">강남동물병원</td>
					</tr>
					<tr>
						<td class="contents">뽀미 심장 사상충 1차 예방 접종 예약</td>
					</tr>
					<tr>
						<td class="time">[2014-02-28 06:00]</td>
					</tr>
				</table>
			</div>
			
			<div class="btn_area02">
				<div class="l_60">
					<p class="btn_bar_red btn_bar_shape01">
						<a data-role="button"><span>일정추가</span></a>
					</p>
				</div>
				<div class="r_40">
					<p class="btn_bar_black btn_bar_shape01">
						<a data-role="button"><span>더보기</span></a>
					</p>
				</div>
			</div>
		</div>
		
		<div class="a_type02">
			<h3><img src="/petmd/common/template/images/common/bu_tt.png" alt="" width="16" height="14" />적립 포인트</h3>
			
			<div class="list_item01">
				<div class="inner">
					<p class="name">강남 동물 병원 적립 포인트</p>
					<p class="point">123,456&nbsp;<img src="/petmd/common/template/images/common/icon_point.png" alt="" height="16px" /></p>
				</div>
				<div class="btn">
					<img src="/petmd/common/template/images/btn/btn_arrow_r.png" alt="" height="52px" />&nbsp;
				</div>
			</div>
			
			<div class="list_item01">
				<div class="inner">
					<p class="name">강남 동물 병원 적립 포인트</p>
					<p class="point">123,456&nbsp;<img src="/petmd/common/template/images/common/icon_point.png" alt="" height="16px" /></p>
				</div>
				<div class="btn">
					<img src="/petmd/common/template/images/btn/btn_arrow_r.png" alt="" height="52px" />&nbsp;
				</div>
			</div>
		</div>
	
		<div class="a_type02">
			<h3><img src="/petmd/common/template/images/common/bu_tt.png" alt="" width="16" height="14" />반려동물</h3>
			
			<div class="mypage_home_pet">
				<div class="list">
					<p><span class="pet_name">나비</span><span class="pet_age">&nbsp;|&nbsp;</span><span class="pet_species">Cat</span></p>
					<p class="pet_age">러시안블루 2개월령</p>
				</div>
				<div class="btn">
					<img src="/petmd/common/template/images/btn/btn_arrow_r.png" alt="" height="52px" />&nbsp;
				</div>
			</div>
			
			<div class="mypage_home_pet">
				<div class="list">
					<p><span class="pet_name">레오나르도 디카프리오</span><span class="pet_age">&nbsp;|&nbsp;</span><span class="pet_species">Dog</span></p>
					<p class="pet_age">골든리트리버 8개월령</p>
				</div>
				<div class="btn">
					<img src="/petmd/common/template/images/btn/btn_arrow_r.png" alt="" height="52px" />&nbsp;
				</div>
			</div>
			
			<p class="btn_bar_red btn_bar_shape01 mt08">
				<a data-role="button"><span>반려동물 등록하기</span></a>
			</p>
			
		</div>
		
		<div class="a_type02">
		
			<p class="btn_bar_black btn_bar_shape01">
				<a data-role="button"><span>로그아웃</span></a>
			</p>
			
			<p class="btn_bar_black btn_bar_shape01 mt08">
				<a data-role="button"><span>탈퇴신청</span></a>
			</p>
		</div>
	
	</div>
	<!-- ///// content 끝-->

</div>
</body>
</html>
