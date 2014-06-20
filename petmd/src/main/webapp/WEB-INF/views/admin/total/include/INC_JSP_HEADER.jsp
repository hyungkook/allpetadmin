<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

	<!-- <meta http-equiv="X-UA-Compatible" content="IE=9"> -->

    <!-- <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi">
    <meta name="apple-mobile-web-app-capable" content="yes"> -->
	
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
	
	<title>병원관리 통합 관리자</title>
	
	<link rel="stylesheet" href="${con.CSSPATH}/admin.css" type="text/css"/>
	<link rel="stylesheet" href="${con.CSSPATH}/total.css" type="text/css"/>
    <!--[if IE 7]><link rel="stylesheet" type="text/css" href="${con.CSSPATH}/ie7.css" /><![endif]-->
    <!--[if IE 8]><link rel="stylesheet" type="text/css" href="${con.CSSPATH}/ie8.css" /><![endif]-->
    <!--[if IE 9]><link rel="stylesheet" type="text/css" href="${con.CSSPATH}/ie9.css" /><![endif]-->
    
    <!-- 달력관련 -->
	<link rel="stylesheet" type="text/css" href="${con.CSSPATH}/codebase/dhtmlxcalendar.css"></link>
	<link rel="stylesheet" type="text/css" href="${con.CSSPATH}/codebase/skins/dhtmlxcalendar_dhx_skyblue.css"></link>
	<script src="${con.CSSPATH}/codebase/dhtmlxcalendar.js"></script>
	
    <script type="text/javascript" src="${con.JSPATH}/fakeselect.js"></script>
    <script type='text/javascript' src='${con.JSPATH}/ajax.js'></script>
    <script type='text/javascript' src='${con.JSPATH}/common.js'></script>
    <script src="${con.JSPATH}/jquery.min.js"></script>
    <script type='text/javascript' src='${con.JSPATH}/jquery-1.8.3.min.js'></script>
    <script type='text/javascript' src='${con.JSPATH}/jquery.tablednd.js'></script>
    <script type='text/javascript' src='${con.JSPATH}/jquery.form.js'></script>
    
    <script src="${con.JSPATH}/jquery.commonAssistant-1.0.js"></script>
	
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
	