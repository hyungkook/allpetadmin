<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:scriptlet>
pageContext.setAttribute("crlf", "\r\n");
pageContext.setAttribute("lf", "\n");
pageContext.setAttribute("cr", "\r");
pageContext.setAttribute("quot", "\"");
pageContext.setAttribute("equot", "\\\"");
</jsp:scriptlet>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%-- <jsp:include page="/WEB-INF/views/admin/hospital/include/INC_JSP_HEADER.jsp"/> --%>
<jsp:include page="../include/total_header.jsp"/>

<c:set var="boardListLen" value="${fn:length(boardList)}"/>

<script>

function sms(phone,msg){
	
	location.href="sms://"+phone+"?body="+encodeURIComponent(msg);
}

var switchingTagId;

function switching(tagId,id,type){
	
	switchingTagId = tagId;
	
	if(!((switchingTagId=='item${boardListLen-1}' && type=='next') || (switchingTagId=='item0' && type=='previous'))){
		$.ajax({
			url:'ajaxServiceSwitching.latte',
			type:'POST',
			data:{
				bid:id,
				type:type,
				tagId:tagId
			},
			dataType:'json',
			success:function(response,status,xhr){
				
				if(response.result=='${codes.SUCCESS_CODE}'){
						
					if((switchingTagId=='item${boardListLen-1}' && type=='next') || (switchingTagId=='item0' && type=='previous')){
						
					}else{
						var $next = null;
						if(response.type=='next'){
							$next = $('#'+switchingTagId).next('div');
						}
						if(response.type=='previous'){
							$next = $('#'+switchingTagId).prev('div');
						}
						
						var $d = $('#'+switchingTagId).detach();
						console.log($d.attr('id')+','+$next.attr('id'));
						var did = $d.attr('id');
						$d.attr('id', $next.attr('id'));
						$next.attr('id', did);
						console.log($d.attr('id')+','+$next.attr('id'));
						
						if(response.type=='next')
							$d.insertAfter($next);// = $('#'+switchingTagId).next('div');
						if(response.type=='previous')
							$d.insertBefore($next);//
					}
						
				}else{
					alert('오류가 발생했습니다.\ncode : '+response.result);
				}
			},
			error:function(xhr,status,error){
				alert(status+'\n'+error);
			}
		});
	}
}

</script>

<c:set var="mainMenuLen" value="${fn:length(menuList)}"/>

<script>

var slideMenu;

$(window).load(function(){	
	
	//initSlideMenu();
	slideMenu = new SlideMenu('menuPosition', parseInt('${boardInfo.sequence}',10), parseInt('${fn:length(menuList)}',10), 'boardMenu');
});
</script>
<jsp:include page="SlideBoardMenu.jsp"/>

<style>
.embed-container { position: relative; padding-bottom: 56.25%; padding-top: 30px; height: 0; overflow: hidden; max-width: 100%; height: auto; }
.embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
</style>

</head>
<body>
		
	<div data-role="page">
			
		<jsp:include page="../include/main_title_bar.jsp"><jsp:param name="ignore_title_back_btn" value="Y"/></jsp:include>
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
			
			<!-- 메인메뉴 tab -->
			<jsp:include page="../include/main_menu.jsp"/>
			
			<!-- tab -->
			<%-- <div class="tab">
				<div class="tab_area">
					<ul>
						<c:set var="curMenu" value="${boardInfo.sequence}"/>
						<c:set var="mainMenuLen" value="${fn:length(menuList)}"/>
						<c:forEach var="item" items="${menuList}" varStatus="c">
							<c:set var="w">${c.count*100/mainMenuLen - c.index*100/mainMenuLen}</c:set>
							<li style="width: ${w}%;" class="<c:if test="${curMenu-1 eq c.count}">noborder</c:if><c:if test="${curMenu eq c.count}">on</c:if><c:if test="${curMenu ne c.count and mainMenuLen eq c.count}">noborder</c:if>"><a onclick="goPage('serviceHome.latte?idx=${params.idx}&cmid=${item.s_cmid}');" data-role="button">${item.s_name}</a></li>
						</c:forEach>
					</ul>
				</div>
			</div> --%>
			<!-- // tab 끝-->
			
			
			<!-- 탭 영역 시작-->
			<%-- <div class="tab_2depth">
				<p class="btn_l btn_img02"><a href="index.html" data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_l02.png" alt="" width="34" height="45"/></a></p>
				<p class="btn_r btn_img02"><a href="index.html" data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_r02.png" alt="" width="34" height="45"/></a></p>
				<p class="btn_r02 btn_modify02"><a onclick="goPage('serviceMenuEdit.latte')" data-role="button"><img src="${con.IMGPATH}/btn/icon_modify.png" alt="" width="31" height="31"/></a></p>
				<div class="list">
					<ul>
						<li>
							<a href="index.html" class="on">진료서비스<span><img src="${con.IMGPATH}/common/b_arrow02.png" alt="" width="10" height="5"/></span></a>
							<a href="index.html">미용서비스<span><img src="${con.IMGPATH}/common/b_arrow02.png" alt="" width="10" height="5"/></span></a>
							<a href="index.html">호텔<span><img src="${con.IMGPATH}/common/b_arrow02.png" alt="" width="10" height="5"/></span></a>
						</li>
					</ul>
				</div>
			</div> --%>
			<!-- // 탭 영역 끝-->
			
			<!-- 상단 메뉴 영역 시작-->
			<c:set var="curMenu" value="${boardInfo.sequence}"/>
			
			<div id="boardMenu" class="tab_2depth">
				<p id="right_btn" class="btn_l btn_img02"><a data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_l02.png" alt="" width="34" height="45"/></a></p>
				<p id="left_btn" class="btn_r btn_img02"><a data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_r02.png" alt="" width="34" height="45"/></a></p>
				<p class="btn_r02 btn_modify02"><a onclick="goPage('serviceMenuEdit.latte')" data-role="button"><img src="${con.IMGPATH}/btn/icon_modify.png" alt="" width="31" height="31"/></a></p>
				<div class="list" id="list" style="overflow:hidden;">
					<ul id="ccc">
						<li id="center" style="width:${mainMenuLen * 33}%; cursor:pointer;">
							<c:forEach items="${menuList}" var="item" varStatus="c">
							<c:set var="www"><fmt:formatNumber value="${100.0 / mainMenuLen}" pattern="0"/></c:set>
							<a id="menu${c.index}" style="width:${www}%; overflow:hidden;"<c:if test="${c.index eq curMenu-1}"> class="on"</c:if> onclick="slideMenu.goMenuLink('serviceHome.latte?idx=${params.idx}&cmid=${item.s_cmid}');">
								<p style="position:relative; overflow:hidden;">&nbsp;<div style="position:absolute; left:50%; top:0;"><b style="visibility:hidden;">${item.s_name}</b><div style="position:absolute; left:-1000%; top:0; width:2000%;">${item.s_name}</div></div></p>
								<span><img src="${con.IMGPATH}/common/b_arrow02.png" alt="" width="10" height="5"/></span>
							</a>
							</c:forEach>
						</li>
					</ul>
				</div>
			</div>
			<!-- 상단 메뉴 영역 끝-->
			
			
			<div class="a_type01_b">
				<div class="btn_select02" style="margin-right:84px;">
					<a data-role="button" >
					<select onchange="goPage('serviceHome.latte?idx=${params.idx}&cmid=${boardInfo.s_cmid}&cmid='+$(this).val());" data-icon="false">
						<c:forEach var="item" items="${subMenuList}" varStatus="c">
							<option value="${item.s_cmid}" <c:if test="${subBoardInfo.s_cmid eq item.s_cmid}">selected="selected"</c:if>>${item.s_name}</option>
						</c:forEach>
					</select>
					</a>
					<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
				</div>
				<p class="btn_black03 abs_rt02" style="width:80px;"><a onclick="goPage('serviceMenuEdit.latte?cmid=${boardInfo.s_cmid}')" data-role="button">분류 편집</a></p>
			</div>
			<div class="a_type01">
				<p class="btn_red02"><a onclick="goPage('serviceContentEdit.latte?g=<c:choose><c:when test="${empty subMenuList}">${boardInfo.s_cmid}</c:when><c:otherwise>${subBoardInfo.s_cmid}</c:otherwise></c:choose>')" data-role="button">항목추가</a></p>
			</div>
			
			
			<c:if test="${not empty boardList}">
			<c:forEach var="item" items="${boardList}" varStatus="c">
			
				<div class="a_type02_b" id="item${c.index}">
					<p class="btn_admin01 abs_tr01"><a onclick="goPage('serviceContentEdit.latte?bid=${item.s_bid}')" data-role="button"><img src="${con.IMGPATH}/btn/icon_modify.png" alt="" width="31" height="31" /></a></p>
					<p class="btn_admin01 abs_tr02"><a onclick="switching($(this).parent().parent().attr('id'),'${item.s_bid}','previous')" data-role="button"><img src="${con.IMGPATH}/btn/btn_t.png" alt="" width="31" height="31" /></a></p>
					<p class="btn_admin01 abs_tr03"><a onclick="switching($(this).parent().parent().attr('id'),'${item.s_bid}','next')" data-role="button"><img src="${con.IMGPATH}/btn/btn_b.png" alt="" width="31" height="31" /></a></p>
					
					<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />${item.s_subject}</h3>
					<c:if test="${not empty item.image_path or not empty item.s_contents}">
					<div class="w_box02 mt10">
						<c:if test="${not empty item.image_path}">
						<p class="img_area"><img src="<c:choose><c:when test="${empty item.image_path}">${con.IMGPATH}/contents/edit_img.png</c:when><c:otherwise>${con.img_dns}${item.image_path}</c:otherwise></c:choose>" alt="" width="100%" /></p>
						</c:if>
						<c:if test="${not empty item.s_contents}">
						<p class="txt01">${item.s_contents}</p>
						</c:if>
						
						<div id="video_${c.count}">
						<c:forEach var="video_item" items="${item.videoList}" varStatus="v">
						<c:if test="${video_item.s_sub_type eq codes.ELEMENT_BOARD_CONTENTS_SUBTYPE_RAW_CODE}">
							<script>
								$(window).load(function(){
									var video_target_len = $('#video_back_${c.count}').length;
									if(video_target_len > 0)
										$("<div class='embed-container'>${fn:replace(video_item.s_value,quot,equot)}</div>").insertBefore($('#video_back_${c.count}'));
									else
										$('#video_${c.count}').append($("<div class='embed-container'>${fn:replace(video_item.s_value,quot,equot)}</div>"));
										
								});
							</script>
						</c:if>
						</c:forEach>
						</div>
					</div>
					</c:if>
				</div>	
			
				<%-- <div id="item${c.index}" style="position:relative;">
				
					<div id="cp" style="position:absolute; top:-7px; right:0; overflow:hidden; z-index:99999;">
						<div style="float:right;"><a data-role="button" onclick="goPage('serviceContentEdit.latte?bid=${item.s_bid}')" style="padding:10px;">편집</a></div>
						<div style="float:right;"><a data-role="button" onclick="switching($(this).parentsUntil('#cp').parent().parent().parent().attr('id'),'${item.s_bid}','next')" style="padding:10px;">▼</a></div>
						<div style="float:right;"><a data-role="button" onclick="switching($(this).parentsUntil('#cp').parent().parent().parent().attr('id'),'${item.s_bid}','previous')" style="padding:10px;">▲</a></div>
					</div>
			
				<c:if test="${not empty item.s_subject}">
				<div class="shop_info">
					<h3>${item.s_subject}</h3>
				</div>
				</c:if>
				
				<c:if test="${not empty item.image_path}">
				<div class="shopimg_edit">
					<div class="s_edit">
						<ul>
							
							<li id="interiorFooter" <c:if test="${fn:length(imgList) >= 12}">style="display:none;"</c:if>>
		
								<!-- opacity:0; filter:alpha(opacity=0);"  -->
								
								<div class="thum" style="overflow:hidden;"><div style="position:relative;"><a data-role="button" style="z-index:0"><img src="<c:choose><c:when test="${empty item.image_path}">${con.IMGPATH_OLD}/contents/edit_img.png</c:when><c:otherwise>${con.img_dns}${item.image_path}</c:otherwise></c:choose>" width="100%"/></a>
								</div>
							
									
							</li>
							
						</ul>
					</div>
				</div>
				</c:if>
				
				
				
				<c:if test="${not empty item.s_contents}">
				<div class="shop_info">
					<div class="cont_area">
						<p class="textarea02"><textarea id="introduce" class="textarea" style="width:100%; height:150px;" placeholder="샵 소개 내용을 입력하여 주세요">${item.s_contents}</textarea></p>
					</div>
				</div>
				</c:if>
				</div> --%>
			</c:forEach>
			</c:if>
				<c:if test="${empty boardList}">등록된 글이 없습니다.</c:if>
			
		</div>
		<!-- ///// content 끝-->
		
		<jsp:include page="../include/simple_copyright.jsp"/>

		<!-- footer 시작-->
		<%-- <jsp:include page="/common/admin/hospital/INC_JSP_FOOTER.jsp" /> --%>
		<!-- ///// footer 끝-->

	</div>
	
	

</body>
</html>