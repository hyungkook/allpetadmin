<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<script type="text/javascript">
<!--
	function selectSubMenu(menu_id){
		var select_menu = document.getElementById(menu_id);
		select_menu.className = "on";
	}
//-->
</script>
<h2>병원</h2>
    <div class="lnb">
    	<ul>
            <c:if test="${not empty permission.PMENUA1 }"><li><a id="submenu_hospital_search" 		href="${permission.PMENUA1.s_url}">${permission.PMENUA1.s_link_name }</a></li></c:if>
        	<c:if test="${not empty permission.PMENUA2 }"><li><a id="submenu_hospital_reg" 			href="${permission.PMENUA2.s_url}">${permission.PMENUA2.s_link_name }</a></li></c:if>
        </ul>	
    </div>
 <!-- 
PMENUC1',	'검색')      
PMENUC2',	'등록')      
PMENUC3',	'포인트충전')
PMENUC4',	'포인트환불')
 
 
  -->