<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<!DOCTYPE>
<html lang="ko">
<head>

	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
	
	<title>병원 관리 로그인 화면</title>
	
	<link rel="stylesheet" href="${con.CSSPATH}/admin.css" type="text/css"/>
    <!--[if IE 7]><link rel="stylesheet" type="text/css" href="../${con.CSSPATH}/ie7.css" /><![endif]-->
    <!--[if IE 8]><link rel="stylesheet" type="text/css" href="../${con.CSSPATH}/ie8.css" /><![endif]-->
    <!--[if IE 9]><link rel="stylesheet" type="text/css" href="../${con.CSSPATH}/ie9.css" /><![endif]-->
    <script type="text/javascript" src="../${con.JSPATH}/fakeselect.js"></script>
    <script type='text/javascript' src='../${con.JSPATH}/ajax.js'></script>
    <script type='text/javascript' src='../${con.JSPATH}/common.js'></script>
	
	<script>
		
	function isUA() {
		var ua = navigator.userAgent.toLowerCase();
	
		var ret1 = ua.search("android");
		var ret2 = ua.search("iphone");
		
		//APP용
		var ret3 = ua.search("androidwebview");
		var ret4 = ua.search("ioswebview");

		if(ret1 > -1){
			// 안드로이드
			return "A";
		} else if(ret2 > -1) {
			return "I";
		} else if(ret3 > -1) {
			return "AWV";
		} else if(ret4 > -1) {
			return "IWV";
		} else {
			return "ETC";
		}
	}
		
	
		/* 메세지 */
		if ("${msg}" != "") {
			alert("${msg}");
		}
		
		/* 페이지 이동 */
		function goPage(page) {
			
			location.href=page;
			
		}
		
		/* CHECKBOX 전부 체크 되어 있는지 확인 */
		function chkBox(id) {
			
	        var chk_listArr = $("input[name='"+ id +"']");
	        for (var i=0; i < chk_listArr.length; i++) {
	            if (chk_listArr[i].checked == false) {
	            	return false;
	            	break;
	            } 
	            
	        }
	        
	        return true;
		}
		
		/* 이메일 정규식 */
		function chkEmail(key) {
			 
			var t = escape(key);
			  if(t.match(/^(\w+)@(\w+)[.](\w+)$/ig) == null && t.match(/^(\w+)@(\w+)[.](\w+)[.](\w+)$/ig) == null){
			    return false;

			  } 

			return true;
		}
	</script>
	
    <script>
	function formSubmit(){
		//alert("로그인클릭");
		document.getElementById("form").action="loginAccept.latte";
		document.getElementById("form").submit();
	}
	
	function fncKeyChk()
	{
	    if(window.event.keyCode==13) formSubmit();
	}
	window.onload = function ()
	{
		document.getElementById("s_userid").focus();	
	};
	
	</script>
</head>

<body>
<div id="wrap">
<form id="form" name="form" method="post">
	
    <div id="login_wrap">
    	<div class="login">
        	<p class="ttl"><img src="../${con.IMGPATH_OLD}/common/h1_logo.png" /><span>통합 관리자 페이지</span></p>
            
            <div class="login_input" style="text-align:left;">
                <p class="t_input"><span>ID</span><input name="s_userid" id="s_userid" type="text" class="txt" style="width:200px;" value="" /></p>
                <p class="t_input"><span>PASSWORD</span><input name="s_password" id="s_password" type="password" class="txt" style="width:200px;" value="" onkeydown='fncKeyChk();' /></p>
                <div class="btn"><a href="#" class="btn_login" onclick="formSubmit()">관리자 로그인</a></div>
            </div>
            <p class="login_txt mt30">* 관리자 계정 정보를 입력해 주시고 관련 정보는 유출되지 않도록 보안사항을 지켜주세요.</p>
            <p class="login_txt">* 아이디 / 패스워드 분실 시 메디라떼 담당자에게 문의 해 주세요.</p>
            
            <div class="warn">
            	<dl>
                	<dt>※ 경고</dt>
                    <dd>
                        1. 본 사이트는 BeautyLatte 서비스를 통합관리하는 사이트로써 관련자가 아닌 사람은 사용하실 수 없습니다.<br /><br />
                        2. 관계자가 아닌 사람이 부정 사용 시 법적 제제 및 민형사 상의 처벌을 받을 수 있음을 알립니다.
                    </dd>
                </dl>
            </div>
        </div>
    </div>
</form>
    
    <!-- footer start-->
    <div id="footer" style="margin-top:100px;">
    	<div class="f_menu">
        	<!-- <a href="#" class="frist">이용약관</a>
            <a href="#">개인정보 취급방침</a> -->
        </div>
        <div class="copy">Copyright ⓒ AD Ventures Inc. All rights Reserved.</div>
    </div>
    <!-- /footer end -------------------------------------------------------------------->
   
</div>
</body>
</html>