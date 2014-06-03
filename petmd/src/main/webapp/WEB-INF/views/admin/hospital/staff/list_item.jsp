<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<ajax id="ajax" result="${params.result}" type="${params.type}"/>
<c:if test="${params.result eq codes.SUCCESS_CODE}">
<li id="${params.tagId}">
	<a onclick="goPage('staffEdit.latte?stid=${staffInfo.s_stid}')" data-role="button">
		<img src="${con.img_dns}${staffInfo.image_path}" alt="" class="thum" width="75" height="100"/>
		<p class="bu"><label>${staffInfo.s_position}</label></p>
		<h3>${staffInfo.s_name}</h3>
		<p>현 ${hospitalInfo.s_hospital_name} 소속</p>
		<p>${staffInfo.s_specialty}</p>
	</a>
	<p class="btn_t btn_admin01"><a onclick="switching($(this).parent().parent().attr('id'),'${staffInfo.s_stid}','previous')" data-role="button"><img src="${con.IMGPATH}/btn/btn_t.png" alt="" width="31" height="31" /></a></p>
	<p class="btn_b btn_admin01"><a onclick="switching($(this).parent().parent().attr('id'),'${staffInfo.s_stid}','next')" data-role="button"><img src="${con.IMGPATH}/btn/btn_b.png" alt="" width="31" height="31" /></a></p>
	<p class="btn_d btn_admin01"><a onclick="remove('${staffInfo.s_stid}');" data-role="button"><img src="${con.IMGPATH}/btn/btn_d.png" alt="" width="31" height="31" /></a></p>
</li>
</c:if>