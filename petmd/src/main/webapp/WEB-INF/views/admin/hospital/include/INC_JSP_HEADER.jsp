<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

	<!-- <meta http-equiv="X-UA-Compatible" content="IE=9"> -->

	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	
	<title>동물병원</title>
	
	<link rel="stylesheet" href="${con.CSSPATH}/jquery.mobile-1.2.0.css" type="text/css"/>
	<link rel="stylesheet" href="${con.CSSPATH}/style_old.css" type="text/css"/>
	<!-- <link rel="stylesheet" href="http://designbt.medilatte.co.kr/css/style.css" type="text/css"/> -->
	<c:if test="${adminFlag eq 'Y'}">
	<link rel="stylesheet" href="${con.CSSPATH}/style_edit.css" type="text/css"/>
	<!-- <link rel="stylesheet" href="http://designbt.medilatte.co.kr/css/style_edit.css" type="text/css"/> -->
	</c:if>
	
	<script src="${con.JSPATH}/jquery-1.8.3.min.js"></script>
	<script src="${con.JSPATH}/jquery.mobile-1.2.0.min.js"></script>
	
	<script src="${con.JSPATH}/jquery.commonAssistant-1.0.js"></script>
	
	<script type='text/javascript' src='${con.JSPATH}/jquery.cookie.js'></script>
	
	<script>
	
	/* 에이전트 확인 */
	function isUA() {
		var ua = navigator.userAgent.toLowerCase();
		
		var ret1 = ua.search("android");
		var ret2 = ua.search("iphone");
		var ret3 = ua.search("androidwebview");
		var ret4 = ua.search("ioswebview");

		if(ret1 > -1){
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
	
	/* 팝업 */
	function goPOP(url) {
		
		window.open(url,'popup','toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=300,height=300');
		
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
	
	function formatSplitedPhoneNumber(num, delim) {
		
		if(num == undefined) return num;
		
		// (식별번호(휴대폰, 평생번호, 인터넷) or 지역번호)-?(국번)-?(나머지번호)
		var pt = /^(01\d{1}|02|0505|0506|0502|0\d{1,2})-?(\d{3,4})$/g;
		return num.replace(/^\s+|\s+$/g, "").replace(pt, "$1" +delim+ "$2");
	}
	
	/**
	 * 전화번호(휴대폰번호 포함)에 특정문자를 넣어서 반환한다.
	 * ex) formatPhoneNumber("01012345678", "-");
	 * @param num 전화번호(휴대폰번호포함)
	 * @param delim 구분자
	 */
	function formatPhoneNumber(num, delim) {
		if(num == undefined) return num;
		// (식별번호(휴대폰, 평생번호, 인터넷) or 지역번호)-?(국번)-?(나머지번호)
		var pt = /^(01\d{1}|02|0505|0506|0502|0\d{1,2})-?(\d{3,4})-?(\d{4})$/g;
		return num.replace(/^\s+|\s+$/g, "").replace(pt, "$1" +delim+ "$2" +delim+ "$3");
	}
	 
	// 01로 시작하는 핸드폰 및 지역번호와 050, 070 검증
	// 원래 050은 0505 평생번호인가 그런데 보편적으로 050-5xxx-xxxx 로 인식함
	// 0505-xxx-xxxx 라는 식으로 넣으면 통과할 수 없음. 그래서 경고창 띄울때 예시 넣는것이 좋음.
	// -(하이픈)은 넣어도 되고 생략해도 되나 넣을 때에는 정확한 위치에 넣어야 함.
	var regExp = /^(01[016789]{1})-?[0-9]{3,4}-?[0-9]{4}$/;
	
	function chkPhoneNumber(obj) {
		if (!regExp.test(obj)) {
			return false;
		}
		return true;
	}
	
	function replaceAll(str, searchStr, replaceStr) {

		while (str.indexOf(searchStr) != -1) {
			str = str.replace(searchStr, replaceStr);
		}
		return str;
	}
	
	// 숫자만 추출
	function getNumberOnly(val) {
		
		val = new String(val);
		var regex = /[^0-9]/g;
		val = val.replace(regex, '');
		return val;
	}
	
	// 태그생성함수를 jquery에 추가
	(function(__jquery){
		
		__jquery.createTagElement=function(tagName,params){
			
			var constants_str = '';
			if(constants_str=='');
			
			if(!(typeof params.constants === 'undefined')){
				for(var con_item in params.constants){
					constants_str=' '+con_item+'="'+params.constants[con_item]+'"';
				}
			}
			
			var tag = $('<'+tagName+constants_str+'/>');
			
			if(!(typeof params.attrs === 'undefined')){
				for(var attr_item in params.attrs){
					tag.attr(attr_item,params.attrs[attr_item]);
				}
			}
			
			if(!(typeof params.css === 'undefined')){
				for(var css_item in params.css){
					tag.css(css_item,params.css[css_item]);
				}
			}
			
			if(!(typeof params.html === 'undefined')){
				tag.html(params.html);
			}
			
			return tag;
		};
	}($));

	</script>