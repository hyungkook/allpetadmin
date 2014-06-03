<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	
	<c:if test="${not empty appType || personalFlag == 'Y'}" >
		<script>
			function menuToggle(menu) {
			}
		</script>
	</c:if>
	
	<c:if test="${empty appType && personalFlag == 'N'}" >
	<script>
		function menuToggle(menu) {
			$("#menu_home").attr("src", $("#menu_home").attr("src").replace("_on", "_off"));
			$("#menu_my_shop").attr("src", $("#menu_my_shop").attr("src").replace("_on", "_off"));
			$("#menu_search").attr("src", $("#menu_search").attr("src").replace("_on", "_off"));
			$("#menu_coupon").attr("src", $("#menu_coupon").attr("src").replace("_on", "_off"));
			$("#menu_mypage").attr("src", $("#menu_mypage").attr("src").replace("_on", "_off"));
			
			$('#'+menu).attr("src", $('#'+menu).attr("src").replace("_off", "_on"));
		}
	</script>
	
	<div id="footer" data-role="footer" data-position="fixed" data-tap-toggle="false" class="f_gnb" data-tap-toggle="false">
    	<ul>
        	<li><a onclick="goPage('home.latte');"><img id="menu_home" src="${con.IMGPATH_OLD}/common/gnb01_on.png" width="45" height="36" /></a>&nbsp;</li>
            <li><a onclick="goPage('myShopList.latte?type=f');"><img id="menu_my_shop" src="${con.IMGPATH_OLD}/common/gnb02_off.png" width="45" height="36" /></a>&nbsp;</li>
            <li><a onclick="goPage('shopSearchCategory.latte');"><img id="menu_search" src="${con.IMGPATH_OLD}/common/gnb03_off.png" width="45" height="36" /></a>&nbsp;</li>
            <li><a onclick="goPage('couponList.latte?type=default');"><img id="menu_coupon" src="${con.IMGPATH_OLD}/common/gnb04_off.png" width="45" height="36" /></a>&nbsp;</li>
            <li><a onclick="goPage('myPageInfo.latte');"><img id="menu_mypage" src="${con.IMGPATH_OLD}/common/gnb05_off.png" width="45" height="36" /></a>&nbsp;</li>
        </ul>
    </div>
    
    </c:if>
    
        
    <script type="text/javascript">
	
	  var _gaq = _gaq || [];
	  _gaq.push(['_setAccount', 'UA-39177988-1']);
	  _gaq.push(['_trackPageview']);
	 
	
	  (function() {
	    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
	    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
	    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
	  })();
	 
	
	</script>
