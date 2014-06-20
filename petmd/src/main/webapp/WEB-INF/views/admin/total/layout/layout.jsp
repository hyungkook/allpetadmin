<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<!DOCTYPE html>

<html lang="ko">
<head>


<jsp:include page="/WEB-INF/views/admin/total/include/INC_JSP_HEADER.jsp"/>
		
		
		 
</head>

<body>
<div id="wrap">
	<!-- total menu -->
    <div id="total_menu">
        <div class="tmenu">
        <%-- <c:set var="admin" value="<%=session.getAttribute(Config.SESSION_KEY + Config.SVC_NAME_TOTAL) %>"/> --%>
        	<ul> 
                <%-- <li><a href="<%=Config.MEDILATTE_TOTAL_DNS%>/advapi/medilatte.latte?idx1=${admin.s_userid}&idx2=${admin.s_password}&idx3=main.latte"><img src="http://img.medilatte.com/admin/images/total/tmenu01_off.gif" /></a></li>
                <li><a href="#"><img src="http://img.medilatte.com/admin/images/total/tmenu02_on.gif" /></a></li>
                <li><a href="#"><img src="http://img.medilatte.com/admin/images/total/tmenu03_off.gif" /></a></li>
                <li><a href="<%=Config.MEDILATTE_TOTAL_DNS%>/advapi/medilatte.latte?idx1=${admin.s_userid}&idx2=${admin.s_password}&idx3=member_01_search.latte"><img src="http://img.medilatte.com/admin/images/total/tmenu04_off.gif" /></a></li>
                <li class="last"><a href="<%=Config.MEDILATTE_TOTAL_DNS%>/advapi/medilatte.latte?idx1=${admin.s_userid}&idx2=${admin.s_password}&idx3=admin_01_list.latte"><img src="http://img.medilatte.com/admin/images/total/tmenu05_off.gif" /></a></li> --%>
                <li class="last"><a href="home.latte"><img src="http://img.medilatte.com/admin/images/total/tmenu05_off.gif" /></a></li>
            </ul>
        </div>
        
        <div class="t_txt">
	        <a href="combineIndex.latte" class="border">메인으로</a>
	        <a href="modify_password.latte" class="border">비밀번호 관리</a>
	   		<a href="login/logout.latte">로그아웃</a>
        </div>
        
    </div>
	
	
    <!-- head start-->
    <div id="header">
    	<jsp:include page="${mainMenu }"/>
    </div>
    <!-- /head end  ---------------------------------------------------------------------->
    
    <!-- container start-->
    <c:if test="${not empty leftMenu || not empty containerName}">
    <div id="container">
    </c:if>
    
    <c:if test="${empty leftMenu && empty containerName}">
    <div id="container" style="background:none">
    </c:if>
    
        <!-- lnb star-->
        	<c:if test="${not empty leftMenu }">
        	<div id="lnbwrap">
        		<jsp:include page="${leftMenu }"/>
        	</div>
        	</c:if>
        	<c:if test="${not empty containerName }">
        	<div id="lnbwrap">
        		<h2>${containerName}</h2>
        		</div>
        		</c:if>
        <!-- /lnb end ------------------>
        
        <!-- contents start-->
        <c:if test="${not empty leftMenu || not empty containerName}">
        <div id="contents">
            <div class="nav">
            <!-- 
            	<a href="#">메인</a> > 
                <a href="#">고객관리</a> > 
                <span>최근 내원 고객</span>
                 -->
            </div>
            <!--section -->
            <div class="section">
            <%--컨텐츠 --%>
            <jsp:include page="${body}"/>
            </div>
            <!--section -->
        </div>
        <div class="main_section"></div>
        <!-- /contents end ------------->
        </c:if>
         <c:if test="${empty leftMenu && empty containerName}">
         <jsp:include page="${body}"/>
         </c:if>
    </div>
    <!-- /container end ----------------------------------------------------------------->
    
    
    <!-- footer start-->
  
  
	<jsp:include page="/WEB-INF/views/admin/total/include/INC_JSP_FOOTER.jsp"/> 


    <!-- /footer end -------------------------------------------------------------------->
   
</div>
</body>
</html>