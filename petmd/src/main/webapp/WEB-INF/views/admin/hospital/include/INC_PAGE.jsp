<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>

<script>

function prePageChange(type, num) {
	
	var curPage = "${params.pageNumber}";

	if (curPage == "0" || curPage == "") {
		curPage = 1;
	}
	
	if ("${params.pageNumber}" == "0") {
		num = 1;
	}
	
	if (parseInt("${params.pageCount}") < num) {
		
		if(parseInt("${params.pageNumber}") < num - 1){
			num = parseInt("${params.pageCount}");
		}
		else{
			alert("맨 마지막 페이지 입니다.");
			return;
		}
	}
	
	if (type == "prev") {
		
		if (parseInt("${params.pageNumber}") == 1 || parseInt("${params.pageNumber}") == 0) {
			alert("맨 첫 페이지 입니다.");
			return;				
		}
	}
	
	pageChange(type, num);
} 

</script>

<div class="paging02">
	<p><a onclick="prePageChange('prev','${params.pageNumber - 1}');" data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_l03.png" width="29" height="29"/></a></p>
	<span class="txt"><label>${params.pageNumber}</label>/${params.pageCount}</span>
	<p><a onclick="prePageChange('next','${params.pageNumber + 1}');" data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_r03.png" width="29" height="29"/></a></p>
</div>