<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
			
			<%-- <div style="overflow:hidden;" class="product_list">
				<c:if test="${not empty imgBoardList}">
		      	<ul id="list" data-role="listview" data-split-icon="gear" data-split-theme="d" style="overflow:hidden; padding:0; margin:0;">
					
					<c:forEach items="${imgBoardList}" var="item">
		              <li class="li_productList" data-icon="false" style="border-top:none; border-bottom:solid 1px #b6b6b6;">
		                  <a onclick='goPage("boardContentEdit.latte?cmid=${boardInfo.s_cmid}&bid=${item.s_bid}")' class="list_info blog" style="overflow:hidden; position:relative;">
		                  <c:if test="${not empty item.thum_img_path}"><img src="${con.img_dns}${item.thum_img_path}" width="130px" height="130px"/></c:if>
		                      <h3>${item.s_subject} <span class="stitle"></span></h3>
		                      <p class="sub_txt12">(내용)</p>
		                  </a>
		              </li>
					</c:forEach>
				</ul>
				</c:if>
				<c:if test="${empty imgBoardList}">등록된 글이 없습니다.</c:if>
			</div> --%>
			
<jsp:scriptlet>
pageContext.setAttribute("crlf", "\r\n");
pageContext.setAttribute("lf", "\n");
pageContext.setAttribute("cr", "\r");
pageContext.setAttribute("quot", "\"");
pageContext.setAttribute("equot", "\\\"");
</jsp:scriptlet>

<c:forEach items="${boardList}" var="item" varStatus="c">
<li id="b_item_${c.count}" class="li_list02" data-icon="false">
	<c:set var="ymdhms" value="${fn:split(item.d_reg_date,' ')}"/>
	<a onclick='preProcess();goPage("boardContentEdit.latte?idx=${params.idx}&cmid=${boardInfo.s_cmid}&bid=${item.s_bid}")' class="list_info" style="overflow:hidden; position:relative;">
	<c:if test="${not empty item.thum_img_path}"><img src="${con.img_dns}${item.thum_img_path}" width="65" height="65"/></c:if>
	<h3 id="subject_${c.count}">${item.s_subject}</h3>
	<p id="${item.s_bid}">${fn:replace(fn:replace(fn:replace(item.s_contents,lf,' '),'<','&lt;'),quot,equot)}</p>
	<p class="data">${ymdhms[0]}</p>
	</a>
</li>
<script>

$('#b_item_i${c.count}').ready(function(){
	
	var content = "${fn:replace(fn:replace(fn:replace(item.s_subject,lf,' '),'<','&lt;'),quot,equot)}";
	var $item = $('#subject_${c.count}');
	$item.html('1<br/>1');
	var item_h = $item.height()-1;
	
	createEllipse(content, 'subject_${c.count}', item_h);
	content = "${fn:replace(fn:replace(fn:replace(item.s_contents,lf,' '),'<','&lt;'),quot,equot)}";
	$item = $('#${item.s_bid}');
	$item.html('1<br/>1<br/>1');
	item_h = $item.height()-1;
	
	createEllipse(content, '${item.s_bid}', item_h);
});
</script>
</c:forEach>