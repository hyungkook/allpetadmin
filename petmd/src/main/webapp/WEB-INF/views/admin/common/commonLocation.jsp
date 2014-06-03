<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	
	 	<jsp:include page="/WEB-INF/views/admin/hospital/include/INC_JSP_HEADER.jsp"/>
		
		<script>
		$(document).ready(function() {
			$("#area_list").listview("refresh");
		});
		
			function searchGugun(type,p_key){
				$('#type').val(type);
				$('#sido').val(p_key);
				$('#value').val(p_key);
				
				try{
					//$('#s_subject',top.document).val($('#s_subject').val());
					//$('#s_subject',top.document).val($('#s_subject').val());
					//parent.document.getElementById("s_subject").value = document.getElementById("s_subject").value; 
					//parent.document.getElementById("className").innerHTML = p_value;
				}catch(e){}
				
				if ("${params.type}" == "myLocation") {
					
					$("#myLocation", parent.document).val(p_key);
					$("#myLocation_txt", parent.document).html(p_key);
					
					parent.closeSearchDiv();
					
					return;
				}
				
				document.form.submit();
			}
			
			function searchDong(type,p_key){
				$('#type').val(type);
				$('#gugun').val(p_key);
				$('#value').val(p_key);
				
				//document.getElementById("type").value = type;
				//document.getElementById("gugun").value = p_key;
				//document.getElementById("value").value = p_key;
					
				document.form.submit();
			}

			function searchEnd(dong) {
				$('#dong').val(dong);
				
				var sido = $('#sido').val();
				var gugun =$('#gugun').val();
				
				var v_location_ori =  sido +" " + gugun + " " + dong;
				
				var v_location = "";
				
				if(v_location_ori.length > 10){
					
					v_location = v_location_ori.substring(0,10) + "..";
					
				}else{
					
					v_location = v_location_ori;
					
				}
				
				
				$('#s_do',parent.document).val(sido);
				$('#s_sigu',parent.document).val(gugun);
				$('#s_dong',parent.document).val(dong);
				
				
				try {
					$("#locationArea", parent.document).html(v_location);
				} catch(e) {
					v_location = v_location_ori;
				};
				
				
				try {
					$("#locationView", parent.document).html(v_location);
					
				} catch (e) {
					
				};
				parent.closeSearchDiv();
			}
			
			function goSearch(key) {
				$('#location_key',parent.document).val(key);
				
				parent.goSearchList();
				parent.closeSearchDiv();
			}
		</script>
</head>
    	
    <body>
<!-- <div data-role="page" style="background:#f7f3f4;"> -->
	
    <!-- header 시작-->
<%--     <div data-role="header" id="head" data-position="fixed" data-tap-toggle="false" data-theme="a">
    	<h1>${title}</h1>
        <a href="index.html" data-role="botton" data-rel="back"><img src="${con.IMGPATH}/btn/btn_back.png" alt="back" width="32" height="32"/>&nbsp;</a>
        <a href="#" data-role="botton" data-rel="menu" id="RightMenu"><img src="${con.IMGPATH}/btn/btn_menu.png" alt="shop" width="32" height="32"/>&nbsp;</a>
      <a href="index.html" data-role="botton" class="shop"><img src="${con.IMGPATH}/btn/btn_shop.png" alt="shop" width="32" height="32"/>&nbsp;</a> 
    </div> --%>
    <!-- ///// header 끝-->
    
    <!-- content 시작-->
<!-- 	<div data-role="content" id="contents"> -->
        
        <div class="area_list">
        	<ul>
        		 <li class="ttl">${title}<a onclick="parent.closeSearchDiv();" data-role="button" class="btn_close"><img src="${con.IMGPATH}/btn/btn_close03.png" alt="" width="18" height="18"/></a></li>
        		<c:if test="${params.type eq 'search'}">
        				<li><a onclick="goSearch('');" data-role="button">전지역</a></li>
        			<c:forEach items="${searchLocationList}" var="list">
        				<li><a onclick="goSearch('${list.s_dong}');" data-role="button">${list.s_dong}</a></li>
        			</c:forEach>
        		</c:if>
        		
            	<c:if test="${params.type eq 'init' || params.type eq 'myLocation'}">
	                	<li><a onclick="searchGugun('gugun','서울')" data-role="button">서울</a></li>
	                	<li><a onclick="searchGugun('gugun','경기도')" data-role="button">경기도</a></li>
	                	<li><a onclick="searchGugun('gugun','인천')" data-role="button">인천</a></li>
	                	<li><a onclick="searchGugun('gugun','부산')" data-role="button">부산</a></li>
	                	<li><a onclick="searchGugun('gugun','경상남도')" data-role="button">경상남도</a></li>
	                	<li><a onclick="searchGugun('gugun','대구')" data-role="button">대구</a></li>
	                	<li><a onclick="searchGugun('gugun','울산')" data-role="button">울산</a></li>
	                	<li><a onclick="searchGugun('gugun','광주')" data-role="button">광주</a></li>
	                	<li><a onclick="searchGugun('gugun','경상북도')" data-role="button">경상북도</a></li>
	                	<li><a onclick="searchGugun('gugun','강원도')" data-role="button">강원도</a></li>
	                	<li><a onclick="searchGugun('gugun','대전')" data-role="button">대전</a></li>
	                	<li><a onclick="searchGugun('gugun','전라북도')" data-role="button">전라북도</a></li>
	                	<li><a onclick="searchGugun('gugun','충청남도')" data-role="button">충청남도</a></li>
	                	<li><a onclick="searchGugun('gugun','충청북도')" data-role="button">충청북도</a></li>
	                	<li><a onclick="searchGugun('gugun','전라남도')" data-role="button">전라남도</a></li>
	                	<li><a onclick="searchGugun('gugun','세종특별자치시')" data-role="button">세종특별자치시</a></li>
	                	<li><a onclick="searchGugun('gugun','제주도')" data-role="button">제주도</a></li>
                </c:if>
                <c:if test="${params.type eq 'gugun' }">
                	<c:forEach items="${gugunList}" var="list" varStatus="c" >
	                	<li><a onclick="searchDong('dong','${list.S_GUGUN }')" data-role="button">${list.S_GUGUN}</a></li>
                	</c:forEach>
                	</c:if>
                	
                	<c:if test="${params.type eq 'dong' }">
                    <c:forEach items="${dongList }" var="list" >
                   		<li><a onclick="searchEnd('${list.S_DONG }')" data-role="button">${list.S_DONG}</a></li>
                    </c:forEach>
                    </c:if>
            </ul>
        </div>
<!--     </div> -->
    
    <!-- footer 시작-->
	<%-- <div data-role="footer" data-position="fixed" data-tap-toggle="false" class="f_gnb">
    	<ul>
        	<li><a href="/index.jsp"><img src="${con.IMGPATH}/common/gnb01_on.png" width="45" height="36" /></a>&nbsp;</li>
            <li><a href="/myshop/bookmark.jsp"><img src="${con.IMGPATH}/common/gnb02_off.png" width="45" height="36" /></a>&nbsp;</li>
            <li><a href="#"><img src="${con.IMGPATH}/common/gnb03_off.png" width="45" height="36" /></a>&nbsp;</li>
            <li><a href="#"><img src="${con.IMGPATH}/common/gnb04_off.png" width="45" height="36" /></a>&nbsp;</li>
            <li><a href="#"><img src="${con.IMGPATH}/common/gnb05_off.png" width="45" height="36" /></a>&nbsp;</li>
        </ul>
    </div> --%>
<!-- </div>  -->   

<form name="form" id="form">
	<input type="hidden" name="sido" id="sido" value="${params.sido }"/>
	<input type="hidden" name="gugun" id="gugun" value="${params.gugun }"/>
	<input type="hidden" name="dong" id="dong" value="${params.dong }"/>
	<input type="hidden" name="type" id="type" value="${params.type }"/>
	<input type="hidden" name="value" id="value" value="${params.value }"/>
</form>
</body>
</html>