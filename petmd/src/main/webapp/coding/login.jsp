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
	
	<link rel="stylesheet" href="/petmdadmin/common/template/css/jquery.mobile-1.2.0.css" type="text/css"/>
	<link rel="stylesheet" href="/petmdadmin/common/template/css/common_admin.css" type="text/css"/>
	<link rel="stylesheet" href="/petmdadmin/common/template/css/style_login.css" type="text/css"/>
	
	<style>
/* 	.btn_cir_red {background:#fc816e; margin:0px auto; padding:0px; border-radius:50%; width:94%; line-height:0; font-size:0px; box-shadow:none; -webkit-box-shadow:none;}	
	
	.btn_cir_yellow {background:#f2d153; margin:0px auto; padding:0px; border-radius:50%; width:94%; line-height:0; font-size:0px; box-shadow:none; -webkit-box-shadow:none;}

	.btn_cir_skyblue {background:#32cad8; margin:0px auto; padding:0px; border-radius:50%; width:94%; line-height:0; font-size:0px; box-shadow:none; -webkit-box-shadow:none;}
	 */
	</style>
</head>

<body>
<div data-role="page">

	<!-- <div class="simple_popup01">
		<div class="bg"></div>
		<div class="c_area_l1">
			<span class="aliner"></span>
			<div class="c_area_l2">
				<div class="title_bar">
					<p class="title_name">아이디찾기</p>
					<a class="title_close" data-role="button"><img src="/petmd/common/template/images/btn/btn_pop_close.png" height="32px"/></a>
				</div>
				<div class="center">
					<div class="login_input">
						<p class="search_input"><input type="text" placeholder="휴대폰번호"></p>
					</div>
					<div class="login_btn" style="margin-top:20px;">
						<p class="btn_bar_red btn_bar_shape01">
							<a data-role="button"><img src="/petmd/common/template/images/btn/btn_confirm.png" alt="" height="20px"/>&nbsp;<span>확인</span></a>
						</p>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="simple_popup01">
		<div class="bg"></div>
		<div class="c_area_l1">
			<span class="aliner"></span>
			<div class="c_area_l2">
				<div class="title_bar">
					<p class="title_name">아이디찾기</p>
					<a class="title_close" data-role="button"><img src="/petmd/common/template/images/btn/btn_pop_close.png" height="32px"/></a>
				</div>
				<div class="center">
					<div class="login_input">
						<p class="search_input"><input type="text" placeholder="이메일계정"></p>
					</div>
					<div class="login_input">
						<p class="search_input"><input type="text" placeholder="휴대폰번호"></p>
					</div>
					<div class="login_btn" style="margin-top:20px;">
						<p class="btn_bar_red btn_bar_shape01">
							<a data-role="button"><img src="/petmd/common/template/images/btn/btn_confirm.png" alt="" height="20px"/>&nbsp;<span>임시비밀번호 받기</span></a>
						</p>
					</div>
				</div>
			</div>
		</div>
	</div> -->

	<!-- content 시작-->
	<div data-role="content" id="contents">
	
		<div style="position:absolute; left:50%; top:-30px; z-index:-1;">
			<img src="/petmd/common/template/images/common/footprint01.png" width="160px"/>
		</div>
	
		<div class="login_area">
		
			<p class="login_title">
				<span>ADMIN LOG-IN</span>
			</p>
			
			<p class="login_msg1">
				관리자 계정 정보를 입력해 주시고 관련 정보는 유출되지 않도록 보안사항을 지켜주세요.
			</p>
			
			<div class="login_input">
				<p class="search_input"><input type="text" placeholder="아이디"></p>
			</div>
			<div class="login_input">
				<p class="search_input"><input type="text" placeholder="비밀번호"></p>
			</div>
			
			<div class="login_btn">
				<p class="btn_bar_red btn_bar_shape01">
					<a data-role="button"><img src="/petmd/common/template/images/common/login_btn.png" alt="" height="20px"/>&nbsp;<span>관리자 로그인</span></a>
				</p>
			</div>
			
			<p class="id_search" style="padding-bottom:60px;">
				<b>아이디/패스워드 분실 시 담당자에게 문의해 주세요.<br/></b>
				<a><span>1666-1609</span></a>
			</p>
		</div>
		
		<div style="padding:20px 35px; background: white; border-top: 1px solid #e0e0e0; position:relative;">
			<div style="position:absolute; right:60%; top:-50px; z-index:-1;">
				<img src="/petmd/common/template/images/common/footprint02.png" width="120px"/>
			</div>
			<span style="color:#ee3d25; font-weight:bold; list-style-image: url('/petmd/common/template/images/common/icon_time.png');">경고</span>
			<ul style="padding:0 20px;">
				<li style="list-style-type:disc; padding:10px 0;">본 사이트는 동물병원 모바일 서비스를 관리하는 사이트로써 관련자가 아닌 사람은 사용하실 수 없습니다.</li>
				<li style="list-style-type:disc;">관계자가 아닌 사람이 부정 사용시 법적 제재 및 민, 형사 상의 처벌을 받을 수 있음을 알립니다.</li>
			</ul>
		</div>
	
	</div>
	<!-- ///// content 끝-->

</div>
</body>
</html>
