<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<div id="loadingCover" style="display:none; position:absolute; filter:alpha(opacity=25); opacity:0.25; background-color:black; top:0px; left:0px; right:0px; height:100%; z-index:99999;"></div>

<script>
/*
 * msg = 표시할 메세지
 * time = 다이얼로그 표시후 사라지는 시간 단위 msec, 'default' 입력시 기본 1000msec
 * fun = 창이 닫힐 때 실행할 함수
 */
function showDialog(msg,time,fun){
	
	var functionOfAtferLoadingClose = fun;
	var t = 1000;
	if(time!='default'&&time!=null)
		t = time;
	
	$('#loadingCover').show();
	
	$.mobile.loading('show',{
		text:msg,
		textVisible: true,
		textonly:true,
		html: ""
	});
	
	setTimeout(function(){
		$.mobile.loading('hide');
		$('#loadingCover').hide();
		
		if(typeof functionOfAtferLoadingClose==='function')
			functionOfAtferLoadingClose();
	}, t);
}
</script>