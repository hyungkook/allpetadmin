<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<jsp:scriptlet>
 
pageContext.setAttribute("crlf", "\r\n");
pageContext.setAttribute("crlfs", "\r\n+");
pageContext.setAttribute("lf", "\n");
pageContext.setAttribute("cr", "\r");

</jsp:scriptlet>


<!DOCTYPE html>
<html lang="ko">
<head>
<title>샵 홈</title>
<%-- <jsp:include page="/WEB-INF/views/admin/hospital/include/INC_JSP_HEADER.jsp"/> --%>
<jsp:include page="/WEB-INF/views/admin/hospital/include/total_header.jsp"/>

<script type="text/javascript" src="${con.JSPATH}/jquery.event.drag-1.5.min.js"></script>
<script type="text/javascript" src="http://dohoons.com/test/flick/jquery.touchSlider.js"></script>

<%-- <script src="${con.JSPATH}/swipe2.js"></script> --%>
<script src="${con.JSPATH}/kakao.js"></script>

<script>
	
	var lastIndex = 1;
	
	var h = 0;
	
	$(window).resize(function(){
		
		$('#touchSlider ul').height($('#touchSlider ul li img').height());
	});
		
	$(document).ready(function(){
	
		lastIndex = 1;
		
		$("#touchSlider").touchSlider({
			flexible : true,
			btn_prev : $("#aprev"),
			btn_next : $("#anext"),
			counter : function (e) {
				pageDotChange(e.current-1);
				lastIndex = e.current;
				// ("current : " + e.current + ", total : " + e.total);
			}
		});
		
		if(parseBool('${fn:length(importantBoardList)>1}'))
			setInterval(function(){ noticeRoll(); }, 5000);
		
	});
	
	$(window).load(function(){
	
		$('#touchSlider ul').height($('#touchSlider ul li img').height());
	});
	
	function goPageChange(index){
		
		var c = index - lastIndex;
		if(c > 0){
			for(var i = 0; i < c; i++){
				$("#anext").click();
			}
		}
		if(c < 0){
			for(var i = 0; i < -c; i++){
				$("#aprev").click();
			}
		}
	}
	
	function pageDotChange(index) {
		
		for (var i=0; i<=parseInt('${fn:length(introImageList)}'); i++){
			$("#paging_img_" + i).attr("src","${con.IMGPATH}/common/paging_off.png");
		}
		$("#paging_img_" + (index + 1)).attr("src","${con.IMGPATH}/common/paging_on${personalLayout}.png");
	}
		
	function noticeRoll(){
		var $t = $('#ticker_notice li:first'); 
		$t.attr('data-margin-top',$t.css('margin-top'));
		$t.animate({
			'margin-top':-$t.height()+"px"
		},800,function () {
			$(this).css('margin-top',$(this).attr('data-margin-top'));
			$(this).appendTo($('#ticker_notice'));
		});
	}
				
	</script>

</head>

<body>
		
	<div data-role="page">
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
		
			<!-- 상단 이미지 영역 시작-->
			<div class="visual_area">
				<div class="logo_area">
					<%--
					<p class="img_area"><span><img src="<c:choose><c:when test="${empty logo_img.s_image_path}">${con.IMGPATH}/common/default_logo.jpg</c:when><c:otherwise>${con.img_dns}${logo_img.s_image_path}</c:otherwise></c:choose>" width="79px" height="79px"/></span></p>
					 --%>
					 <c:choose>
					 <c:when test="${!empty logo_img.s_image_path}">
						<p class="img_area"><span><img src="${con.img_dns}${logo_img.s_image_path}" width="79px" height="79px"/></span></p>
						<p class="txt01">${hospitalInfo.s_hospital_name}</p>
					</c:when>
					<c:otherwise><p class="txt01" style="margin-top: 130px;">${hospitalInfo.s_hospital_name}</p></c:otherwise>
					</c:choose>
				</div>
				<p class="my_info"><a onclick="goPage('manageHome.latte');" data-role="button"><img src="${con.IMGPATH_OLD}/btn/icon_set_t.png" alt="" width="15" height="15"/><label>설정</label></a></p>
				<div class="btn_call">
					<p class="btn0102"><a onclick="goPage('callInfoEdit.latte?idx=${params.idx}')" data-role="button"><img src="${con.IMGPATH_OLD}/btn/icon_kakao_t.png" alt="kakao talk" width="21" height="19"/><label>편집</label></a></p>
					<p class="btn0202 mt04"><a onclick="goPage('manageSchedule.latte');" data-role="button"><img src="${con.IMGPATH_OLD}/btn/icon_schedule_t.png" alt="스케줄" width="19" height="18"/><label>스케줄</label></a></p>
				</div>
				<%-- <p class="bg_img"><img src="${con.img_dns}${header_img.s_image_path}" width="100%"/></p> --%>
				<p class="bg_img"><img src="<c:choose><c:when test="${empty header_img.s_image_path}">${con.IMGPATH}/common/default_header.jpg</c:when><c:otherwise>${con.img_dns}${header_img.s_image_path}</c:otherwise></c:choose>" width="100%"/></p>
				<div style="position:absolute; top:0; left:0;">
					<a onclick="goPage('logout.latte');" data-role="button" style="background:transparent;">로그아웃</a>
				</div>
			</div>
			
			<!-- 메인메뉴 tab -->
			<jsp:include page="../include/main_menu.jsp"/>
			
			<!-- 중요 공지사항 롤링 -->
			<div class="prev_notice">
				<p class="icon"><img src="${con.IMGPATH}/common/icon_notice.png" alt="" width="9" height="10"/></p>
				<ul id="ticker_notice">
					<c:forEach items="${importantBoardList}" var="list" varStatus="c"><li>
						<c:set var="ymd" value="${fn:split(list.d_reg_date,' ')[0]}"/>
						<%-- <a onclick="goPage('hospitalBoardDetail.latte?idx=${params.idx}&cmid=${list.s_group}&bid=${list.s_bid}');" >${list.s_subject}&nbsp;<c:if test="${list.reg_date_diff < 7}"><img src="${con.IMGPATH}/common/icon_new.png" alt="" width="13" height="13"/></c:if><span>${ymd}</span></a></li> --%>
						<a onclick="goPage('boardContentEdit.latte?idx=${params.idx}&cmid=${list.s_group}&bid=${list.s_bid}');" >${list.s_subject}&nbsp;<c:if test="${list.reg_date_diff < 7}"><img src="${con.IMGPATH}/common/icon_new.png" alt="" width="13" height="13"/></c:if><span>${ymd}</span></a></li>
					</c:forEach>
				</ul>
			</div>
			
			<!-- 병원소개-->
			<div class="a_type01_b">
				<p class="btn_modify"><a onclick="goPage('introInfoEdit.latte?idx=${params.idx}')" data-role="button"><img src="${con.IMGPATH}/btn/icon_modify.png" alt="" width="31" height="31" /></a></p>
				<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />병원 소개</h3>
				<p class="txt_type01 mt10">
					<c:if test="${not empty hospitalInfo.s_introduce}">
						${fn:replace(fn:replace(hospitalInfo.s_introduce,'<','&lt;'),crlf,'<br/>')}
					</c:if>
					<c:if test="${empty hospitalInfo.s_introduce}">
						등록된 정보가 없습니다.
					</c:if>
				</p>
				<div class="txt_type01 mt15">
					<dl>
						<dt id="d_test">스탭</dt>
						<dd>${hospitalInfo.s_represent_staff_name} 외 ${hospitalInfo.s_staff_count - 1}명</dd>
					</dl>
				</div>
				<!-- 소개사진-->
				<c:choose>
				<%-- 소개 이미지 2장 이상에서만 슬라이드 활성화 --%>
				<c:when test="${fn:length(introImageList)>1}">
					<div class="photo_area">
						<p class="p_btn_modify"><a onclick="goPage('introduceImgEdit.latte')" data-role="button"><img src="${con.IMGPATH}/btn/icon_modify02.png" alt="" width="19" height="21" /></a></p>
						<p class="btn_l btn"><a id="aprev" data-role="button"><img src="${con.IMGPATH}/btn/btn_photo_l.png" alt="" width="46" height="46" /></a></p>
						<p class="btn_r btn"><a id="anext" data-role="button"><img src="${con.IMGPATH}/btn/btn_photo_r.png" alt="" width="46" height="46" /></a></p>
						<div class="img_area">
							<div id="touchSlider">
								<ul style="position:relative;">
									<c:forEach items="${introImageList}" var="list" varStatus="c">
									<li style="position:absolute; left:0; top:0;">
										<img src="${con.img_dns}${list.s_image_path}" width="100%"  />
									</li>
									</c:forEach>
								</ul>
							</div>
						</div>
						<div class="paging">
							<ul>
								<c:forEach items="${introImageList}" var="list" varStatus="c">
								<li><a><img onClick="goPageChange('${c.count}')" id="paging_img_${c.count}" src="${con.IMGPATH}/common/paging_off.png" width="10" height="10" /></a></li>
								</c:forEach>
							</ul>
						</div>
					</div>
				</c:when>
				<%-- 이미지가 없을 경우 기본 이미지 --%>
				<c:when test="${empty introImageList}">
					<div class="photo_area">
						<p class="p_btn_modify"><a onclick="goPage('introduceImgEdit.latte')" data-role="button"><img src="${con.IMGPATH}/btn/icon_modify02.png" alt="" width="19" height="21" /></a></p>
						<div class="img_area">
							<ul><li><img src="${con.IMGPATH}/noimages/no_thumbnail_800x450.jpg" width="100%" /></li></ul>
						</div>
					</div>
				</c:when>
				<%-- 이미지 1장 --%>
				<c:otherwise>
					<div class="photo_area">
						<p class="p_btn_modify"><a onclick="goPage('introduceImgEdit.latte')" data-role="button"><img src="${con.IMGPATH}/btn/icon_modify02.png" alt="" width="19" height="21" /></a></p>
						<div class="img_area">
							<ul><li><img src="${con.img_dns}${introImageList[0].s_image_path}" width="100%" /></li></ul>
						</div>
					</div>
				</c:otherwise>
				</c:choose>
				<!-- //소개사진 끝-->
			</div>
			
			<!-- 진료시간-->
			<div class="a_type01_b">
				<p class="btn_modify"><a onclick="goPage('workingTimeEdit.latte?idx=${params.idx}')" data-role="button"><img src="${con.IMGPATH}/btn/icon_modify.png" alt="" width="31" height="31" /></a></p>
				<h3 onclick=";"><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />진료시간</h3>
				<div class="txt_type01 mt10">
					<c:forEach items="${workingTimeList}" var="list">
					<dl>
						<c:if test="${list.s_allday eq 'Y'}">
							<dt>연중무휴</dt>
							<dd>
								<c:if test="${list.s_alltime ne 'Y' and not empty list.s_start_time}">
									${list.s_start_time} ~ ${list.s_end_time}
								</c:if>
								<c:if test="${list.s_alltime eq 'Y'}">
									24시간 영업
								</c:if>
								&nbsp;
							</dd>
						</c:if>
						<c:if test="${list.s_allday ne 'Y'}">
							<dt>${list.s_name}</dt>
							<dd>
							<c:if test="${list.s_alltime ne 'Y' and not empty list.s_start_time}">
								${list.s_start_time} ~ ${list.s_end_time}
							</c:if>
							<c:if test="${list.s_alltime eq 'Y'}">
								24시간 영업
							</c:if>
							<c:if test="${list.s_dayoff eq 'Y'}">
								휴무
							</c:if>
							
							<c:if test="${not empty list.s_comment && list.s_comment ne '' && list.s_comment ne ' '}">
								&nbsp;(${list.s_comment})
							</c:if>
							</dd>
						</c:if>
						</dl>
					</c:forEach>
				</div>
			</div>
			
			<!-- 보유장비 -->
			
			<div class="a_type01_b">
				<p class="btn_modify"><a onclick="goPage('equipmentEdit.latte?idx=${params.idx}')" data-role="button"><img src="${con.IMGPATH}/btn/icon_modify.png" alt="" width="31" height="31" /></a></p>
				<h3 onclick=";"><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />보유장비</h3>
				<c:if test="${hospitalInfo.EQUIPMENT_status eq'Y'}">
				<p class="txt_type01 mt10">
					<c:if test="${not empty hospitalInfo.EQUIPMENT}">${fn:replace(hospitalInfo.EQUIPMENT,crlf,'<br/>')}</c:if>
					<c:if test="${empty hospitalInfo.EQUIPMENT}">등록된 정보가 없습니다.</c:if>
				</p>
				</c:if>
			</div>
			
			<!-- 부가정보-->
			<div class="a_type01_b">
				<p class="btn_modify"><a onclick="goPage('extraInfoEdit.latte?idx=${params.idx}')" data-role="button"><img src="${con.IMGPATH}/btn/icon_modify.png" alt="" width="31" height="31" /></a></p>
				<h3 onclick=";"><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />부가정보</h3>
				<div class="txt_type01 mt10">
					<c:if test="${not empty hospitalInfo.s_display_tel}">
					<dl>
						<dt>연락처</dt>
						<dd>
							${hospitalInfo.s_display_tel}
						</dd>
					</dl>
					</c:if>
					<c:if test="${not empty hospitalInfo.s_parking_info}">
					<dl>
						<dt>주차</dt>
						<dd>
							${fn:replace(fn:replace(hospitalInfo.s_parking_info,'<','&lt;'),crlf,'<br/>')}
						</dd>
					</dl>
					</c:if>
					<c:if test="${not empty hospitalInfo.s_credit_info}">
					<dl>
						<dt>신용카드</dt>
						<dd>
							${fn:replace(fn:replace(hospitalInfo.s_credit_info,'<','&lt;'),crlf,'<br/>')}
						</dd>
					</dl>
					</c:if>
				</div>
			</div>
			
			<div class="a_type01_b">
				<p class="btn_modify"><a onclick="goPage('siteInfoEdit.latte?idx=${params.idx}')" data-role="button"><img src="${con.IMGPATH}/btn/icon_modify.png" alt="" width="31" height="31" /></a></p>
				<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />바로가기</h3>
				<div class="btn_list mt10">
					<ul>
						<c:forEach var="site_item" items="${siteList}" varStatus="c">
						<c:if test="${site_item.s_type eq codes.ELEMENT_HOSPITAL_SITE_HOMEPAGE}">
							<c:set var="site_icon" value="${con.IMGPATH}/btn/go_link01.png"/>
							<c:set var="site_class" value="btn_red"/>
						</c:if>
						<c:if test="${site_item.s_type eq codes.ELEMENT_HOSPITAL_SITE_BLOG}">
							<c:set var="site_icon" value="${con.IMGPATH}/btn/go_link02.png"/>
							<c:set var="site_class" value="btn_green"/>
						</c:if>
						<c:if test="${site_item.s_type eq codes.ELEMENT_HOSPITAL_SITE_FACEBOOK}">
							<c:set var="site_icon" value="${con.IMGPATH}/btn/go_link03.png"/>
							<c:set var="site_class" value="btn_purple"/>
						</c:if>
						<c:if test="${site_item.s_type eq codes.ELEMENT_HOSPITAL_SITE_TWITTER}">
							<c:set var="site_icon" value="${con.IMGPATH}/btn/go_link04.png"/>
							<c:set var="site_class" value="btn_blue"/>
						</c:if>
						<c:if test="${site_item.s_type eq codes.ELEMENT_HOSPITAL_SITE_CAFE}">
							<c:set var="site_icon" value="${con.IMGPATH}/btn/go_link05.png"/>
							<c:set var="site_class" value="btn_black"/>
						</c:if>
						<li>
							<p class="${site_class}"><a href="${site_item.s_url}" data-role="button" target="_black"><img src="${site_icon}" alt="" width="100%" /></a></p>
							<p class="txt01">${site_item.s_type_name}</p>
						</li>
						</c:forEach>
					</ul>
				</div>
			</div>
			
			<!-- <div style="height:0; position:relative; border:1px solid black;"> -->
			<!-- <div>
				<a data-role="button" onclick="goPage('introduceImgEdit.latte')">이미지 편집</a>
			</div> -->
			<!-- </div> -->
			
			<!-- 인테리어 이미지 interior -->
			<%-- <c:if test="${not empty introImageList}">
			<div class="shop_img" style="margin-top:10px; position:relative;">
				<!-- <div style="position:absolute; top:0; left:0; z-index:9999999; width:100px; height:100px;">
							<a data-role="button">편집</a>
						</div> -->
				<p class="btn_l"><a id="aprev" data-role="button"><img src="${con.IMGPATH_OLD}/btn/btn_left01.png" width="25" height="30" /></a></p>
				<p class="btn_r"><a id="anext" data-role="button"><img src="${con.IMGPATH_OLD}/btn/btn_right01.png" width="25" height="30" /></a></p>
				
				<c:if test="${fn:length(introImageList) gt 1}"> --%>
				<!-- <div id='slider_i' class='swipe'> -->
     				<%-- <div class='swipe-wrap'>
					<c:forEach items="${introImageList}" var="list" varStatus="c">
						<div>
							<div class="rolling_img">
								<ul>
									<li>
										<img src="${con.img_dns}${list.s_image_path}" onerror="this.src='${con.IMGPATH_OLD}/noimages/no_thumbnail_800x450.jpg'" width="100%"  />
									</li>
								</ul>
							</div>
						</div>
					</c:forEach> --%>
			<%-- 		<div id="touchSlider">
						<ul>
							<c:forEach items="${introImageList}" var="list" varStatus="c">
							<li>
								<img src="${con.img_dns}${list.s_image_path}" onerror="this.src='${con.IMGPATH_OLD}/noimages/no_thumbnail_800x450.jpg'" width="100%"  />
							</li>
							</c:forEach>
						</ul>
						
					</div>
					<!-- </div> -->
				<!-- </div> -->
				</c:if>
				<c:if test="${fn:length(introImageList) eq 1}">
						<c:forEach items="${introImageList}" var="list" varStatus="c" begin="0" end="0">
						<ul>
							<li>
								<img src="${con.img_dns}${list.s_image_path}" onerror="this.src='${con.IMGPATH_OLD}/noimages/no_thumbnail_800x450.jpg'" width="100%"  />
							</li>
						</ul>
						</c:forEach>
				</c:if>
			</div>
			</c:if>
			<c:if test="${empty introImageList}">
				<img src="${con.IMGPATH_OLD}/noimages/no_thumbnail_800x450.jpg" width="100%" />
			</c:if> --%>
			
        	<!-- paging 시작-->
			<%-- <div class="paging">
				<ul>
					<c:forEach items="${introImageList}" var="list" varStatus="c">
					<li><a href="#"><img onClick="goPageChange('${c.count}')" id="paging_img_${c.count}" src="${con.IMGPATH_OLD}/btn/btn_paging_off.png" width="10" height="10" /></a></li>
					</c:forEach>
				</ul>
			</div> --%>
			
			<%-- <div class="main_notice"  style="position:relative; bottom:0;">
	    	<div class="ttl"><img src="${con.IMGPATH_OLD}/common/icon_notice.png" width="8" height="8"/>공지사항</div>
	    	<div class="txt_roll" style="text-overflow:ellipsis; width:72%;">
	    	<ul id="ticker_notice">
	    		<c:forEach items="${importantBoardList}" var="list" varStatus="c"><li><a onclick="goPage('hospitalBoardDetail.latte?idx=${params.idx}&cmid=${list.s_group}&bid=${list.s_bid}');" >${list.s_subject}</a></li>
	    		</c:forEach></ul>
		    </div>
	    </div> --%>
	
		</div>
		<!-- ///// content 끝-->
		
		<jsp:include page="copyright.jsp"/>

		<!-- footer 시작-->
		<jsp:include page="/common/admin/hospital/INC_JSP_FOOTER.jsp" />
		<!-- ///// footer 끝-->

	</div>
	
	

 </body>
</html>
