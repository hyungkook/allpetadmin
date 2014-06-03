<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
			<jsp:scriptlet>
pageContext.setAttribute("crlf", "\r\n");
pageContext.setAttribute("lf", "\n");
pageContext.setAttribute("cr", "\r");
pageContext.setAttribute("quot", "\"");
pageContext.setAttribute("equot", "\\\"");
</jsp:scriptlet>
<%-- 			<div style="overflow:hidden;" class="product_list">
		      	<ul id="list" data-role="listview" data-split-icon="gear" data-split-theme="d" style="overflow:hidden; padding:0; margin:0;">
					<c:forEach items="${rssList}" var="item">
		              <li class="li_productList" data-icon="false" style="border-top:none; border-bottom:solid 1px #b6b6b6;">
		                  <a href='${item.value.link[0]}' target="_black" class="list_info blog" style="overflow:hidden; position:relative;">
		                      <h3>${item.value.title[0]} <span class="stitle">- ${item.value.author[0]}</span></h3>
		                      <p class="sub_txt12">${item.value.description[0]}</p>
		                  </a>
		              </li>
					</c:forEach>
				</ul>
			</div> --%>
			
<c:forEach items="${rssList}" var="item" varStatus="c">
<li id="b_item_i${c.count}" class="li_list" data-icon="false">
	<a href="${item.value.link[0]}" class="list_info" style="overflow:hidden; position:relative;" target="_blank">
		<c:if test="${not empty item.value.image and not empty item.value.image[0]}"><img src="${item.value.image[0]}" width="65" height="65"/></c:if>
		<h3 id="${c.count}"><c:if test="${fn:indexOf(item.value.link[0],'blog.naver')>-1}"><img src="${con.IMGPATH}/common/bu_naver.png" alt="" width="35" height="15"/></c:if>${item.value.title[0]}</h3>
		<p>${item.value.description[0]}</p>
	</a>
</li>
<script>
$('#b_item_i${c.count}').ready(function(){
	
	var content = "${fn:replace(fn:replace(item.value.title[0],lf,' '),quot,equot)}";
	var $item = $('#${c.count}');
	var $icon = $item.find('img').detach();
	$item.html('1<br/>1');
	var item_h = $item.height()-1;
	
	createEllipse(content, '${c.count}', item_h, null, $icon);
});
</script>
</c:forEach>