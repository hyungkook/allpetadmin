<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<script type='text/javascript' src='${con.JSPATH}/ticker.js'></script>
	<div id="main_c_top">
		<div class="notice01" style="width:900px;"> 
			<script>
				var data = '${noticeJson}';
				var noticeList = eval(data);
				new pausescroller(noticeList, "pscroller", 716, 3000);
			</script>
		</div>
		<div style="padding-left:650px;width:100px;font-size:12px;color:#576364;font-weight:bold;line-height:20px;position:relative;letter-spacing:-1px;">
		</div>
	</div>
	<div class="box1200 mt15" style="padding-left:40px;"> 
            <table cellpadding="0" border="0" cellspacing="0" class="calendar">
                <tr>
                    <th class="sun_t" >${dayWeek }</th>
                    <th>구분</th>
                    <th>페이지뷰</th>
                    <th>광고뷰</th>
                    <th>회원수</th>
                    <th>샵수</th>
                    <th>쿠폰발행수</th>
                    <th>리뷰수</th>
                </tr>
                <tr>
                    <td class="sun" style="text-align:center;vertical-align:middle; font-size:40px; font-weight:bold;" rowspan=2>${today}</td>
                    <td style="text-align:center;vertical-align:middle;">${yesterday }일(전일)</td>
                    <td style="text-align:center;vertical-align:middle; font-size:14px; font-weight:bold;"><fmt:formatNumber value="${yDayBeautyCountVo.pageview_total_count }"  pattern="#,###" /></td>
                    <td style="text-align:center;vertical-align:middle; font-size:14px; font-weight:bold;"><fmt:formatNumber value="${yDayBeautyCountVo.adview_total_count }"  pattern="#,###" /></td>
                    <td style="text-align:center;vertical-align:middle; font-size:14px; font-weight:bold;"><fmt:formatNumber value="${yDayBeautyCountVo.member_total_count }"  pattern="#,###" /></td>
                    <td style="text-align:center;vertical-align:middle; font-size:14px; font-weight:bold;"><fmt:formatNumber value="${yDayBeautyCountVo.shop_total_count }"  pattern="#,###" /></td>
                    <td style="text-align:center;vertical-align:middle; font-size:14px; font-weight:bold;"><fmt:formatNumber value="${yDayBeautyCountVo.coupon_total_count }"  pattern="#,###" /></td>
                    <td  style="text-align:center;vertical-align:middle;font-size:14px; font-weight:bold;"><fmt:formatNumber value="${yDayBeautyCountVo.review_total_count }"  pattern="#,###" /></td>
                </tr>
                <tr>
                    <td style="text-align:center;vertical-align:middle; height:20px;">${twoDaysAgo }일 대비</td>
                    <td style="text-align:center;vertical-align:middle; height:20px;">
                    <c:set var="pageviewCount" value="${yDayBeautyCountVo.pageview_total_count - twoDaysAgoBeautyCountVo.pageview_total_count}"/>
                    <c:if test="${pageviewCount < 0}">
	                    <c:set var="adlength" value="${fn:length('pageviewCount') }"/>
	                    	<font color=00bfff>▼ </font><fmt:formatNumber value="${fn:substring(pageviewCount, 1, adlength)}" pattern="#,###" />
	                    </c:if>
	                    <c:if test="${pageviewCount > 0}">
	                    	<font color=ff4500>▲ </font><fmt:formatNumber value="${pageviewCount}" pattern="#,###" />
	                    </c:if>
	                    <c:if test="${pageviewCount == 0}">
	                    -
	                    </c:if>
                    </td>
                    <td style="text-align:center;vertical-align:middle; height:20px;">
                     <c:set var="adviewCount" value="${yDayBeautyCountVo.adview_total_count - twoDaysAgoBeautyCountVo.adview_total_count}"/>
                    <c:if test="${adviewCount < 0}">
	                    	<c:set var="adlength" value="${fn:length('adviewCount') }"/>
	                    	<font color=00bfff>▼ </font><fmt:formatNumber value="${fn:substring(adviewCount, 1, adlength)}" pattern="#,###" />
	                    </c:if>
	                    <c:if test="${adviewCount > 0}">
	                    	<font color=ff4500>▲ </font><fmt:formatNumber value="${adviewCount}" pattern="#,###" />
	                    </c:if>
	                    <c:if test="${adviewCount == 0}">
	                    -
	                    </c:if>
                    </td>
                    <td style="text-align:center;vertical-align:middle; height:20px;">
                    <c:set var="memberCount" value="${yDayBeautyCountVo.member_total_count - twoDaysAgoBeautyCountVo.member_total_count}"/>
	                    <c:if test="${memberCount < 0}">
	                    	<c:set var="memberlength" value="${fn:length('memberCount') }"/>
	                    	<font color=00bfff>▼ </font><fmt:formatNumber value="${fn:substring(memberCount, 1, memberlength)}" pattern="#,###" />
	                    </c:if>
	                    <c:if test="${memberCount > 0}">
	                    	<font color=ff4500>▲ </font><fmt:formatNumber value="${memberCount}" pattern="#,###" />
	                    </c:if>
	                    <c:if test="${memberCount == 0}">
	                    -
	                    </c:if>
                    </td>
                    <td style="text-align:center;vertical-align:middle; height:20px;">
                    <c:set var="shopCount" value="${yDayBeautyCountVo.shop_total_count - twoDaysAgoBeautyCountVo.shop_total_count}"/>
                     <c:if test="${shopCount < 0}">
	                    	<c:set var="hospitallength" value="${fn:length('shopCount') }"/>
	                    	<font color=00bfff>▼ </font><fmt:formatNumber value="${fn:substring(shopCount, 1, hospitallength)}" pattern="#,###" />
	                    </c:if>
	                    <c:if test="${shopCount > 0}">
	                    	<font color=ff4500>▲ </font><fmt:formatNumber value="${shopCount}" pattern="#,###" />
	                    </c:if>
	                    <c:if test="${shopCount == 0}">
	                    -
	                    </c:if>
                    </td>
                     <c:set var="couponCount" value="${yDayBeautyCountVo.coupon_total_count - twoDaysAgoBeautyCountVo.coupon_total_count}"/>
                    <td style="text-align:center;vertical-align:middle; height:20px;">
                    	<c:if test="${couponCount < 0}">
	                    	<c:set var="counsellength" value="${fn:length('couponCount') }"/>
	                    	<font color=00bfff>▼ </font><fmt:formatNumber value="${fn:substring(couponCount, 1, counsellength)}" pattern="#,###" />
	                    </c:if>
	                    <c:if test="${couponCount > 0}">
	                    	<font color=ff4500>▲ </font><fmt:formatNumber value="${couponCount}" pattern="#,###" />
	                    </c:if>
	                    <c:if test="${couponCount == 0}">
	                    -
	                    </c:if>
                    </td>
                    <td style="text-align:center;vertical-align:middle; height:20px;">
                     <c:set var="reviewCount" value="${yDayBeautyCountVo.review_total_count - twoDaysAgoBeautyCountVo.review_total_count}"/>
                    	<c:if test="${reviewCount < 0}">
	                    	<c:set var="reviewlength" value="${fn:length('reviewCount') }"/>
	                    	<font color=00bfff>▼ </font><fmt:formatNumber value="${fn:substring(reviewCount, 1, reviewlength)}" pattern="#,###" />
	                    </c:if>
	                    <c:if test="${reviewCount > 0}">
	                    	<font color=ff4500>▲ </font><fmt:formatNumber value="${reviewCount}" pattern="#,###" />
	                    </c:if>
	                    <c:if test="${reviewCount == 0}">
	                    -
	                    </c:if>
                    </td>
                  </tr>
                  
                <tr>
                    <td class="sun" style="color:#576364;text-align:center;height:20px;vertical-align:middle; font-size:14px; font-weight:bold;" colspan="2">총계</td>
                    <td style="text-align:center;height:20px;vertical-align:middle; font-size:14px; font-weight:bold;"><fmt:formatNumber value="${totalBeautyCountVO.pageview_total_count }"  pattern="#,###" /></td>
                    <td style="text-align:center;height:20px;vertical-align:middle; font-size:14px; font-weight:bold;"><fmt:formatNumber value="${totalBeautyCountVO.adview_total_count }"  pattern="#,###" /></td>
                    <td style="text-align:center;height:20px;vertical-align:middle; font-size:14px; font-weight:bold;"><fmt:formatNumber value="${totalBeautyCountVO.member_total_count }"  pattern="#,###" /></td>
                    <td style="text-align:center;height:20px;vertical-align:middle; font-size:14px; font-weight:bold;"><fmt:formatNumber value="${totalBeautyCountVO.shop_total_count }"  pattern="#,###" /></td>
                    <td style="text-align:center;height:20px;vertical-align:middle; font-size:14px; font-weight:bold;"><fmt:formatNumber value="${totalBeautyCountVO.coupon_total_count }"  pattern="#,###" /></td>
                    <td  style="text-align:center;height:20px;vertical-align:middle;font-size:14px; font-weight:bold;"><fmt:formatNumber value="${totalBeautyCountVO.review_total_count }"  pattern="#,###" /></td>
                </tr>
            </table>
	<p class="mt30">
	<table class="table_type001" style="width:1200px" >
		<c:set var="pmenu" value="${fn:split('A|B|C|F|G','|')}" />
		<c:forEach var="mlist" varStatus="c" begin="1" end="7">
			<c:if test="${c.count == 1}"> 
				<tr>
					<c:forEach items="${pmenu}" var="plist" varStatus="i">
						<c:set var="tmp" value="PMENU${plist}" />
						<th><a href="${permission[tmp].s_url}" >${permission[tmp].s_link_name}</a></th>
					</c:forEach>
				</tr>
			</c:if>
			<c:if test="${c.count > 1}">
				<tr>
					<c:forEach items="${pmenu}" var="plist" varStatus="i">
						<c:set var="tmp" value="PMENU${plist}${mlist-1}" />
						<td><a href="${permission[tmp].s_url}" >${permission[tmp].s_link_name}</a></td>
					</c:forEach>
				</tr>
			</c:if>
		</c:forEach>
	</table>
</div>
<div class="main_bottom_c01" style="width:1200px">
	<table class="table_type002" >
		<colgroup>
		    <col width="17%" /><col width="14%" /><col width="40%" /><col width="29%" />
		</colgroup>
		<c:forEach items="${mainList }" var="list" varStatus="c">
		<tr>
			<c:if test="${c.count == 1 }">
				<th rowspan="3">실시간 현황<br /><a href="realListView.latte">더 보기</a></th>
			</c:if>
			<td class="date">${fn:split(list.D_REG_DATE, ' ')[0]} (${fn:split(list.D_REG_DATE, ' ')[1]})</td>
			<td class="ttl">
				<c:choose>
					<c:when test="${list.S_TYPE == 'SHOP' }">
						<span class="icon_new">신규등록</span> 
					</c:when>
					<c:when test="${list.S_TYPE == 'CHARGE' }">
						<span class="icon_new">충전</span> 
					</c:when>
					<c:when test="${list.S_TYPE == 'AD' }">
						<span class="icon_new">신규광고</span> 
					</c:when>
					<c:when test="${list.S_TYPE == 'REFUND' }">
						<span class="icon_new03">환불</span> 
					</c:when>
					<c:when test="${list.S_TYPE == 'SUBTRACT' }">
						<span class="icon_new03">차감</span> 
					</c:when>
				</c:choose>
				${list.S_SHOP_NAME}
				<c:if test="${list.ISNEW=='NEW'}">
			 	<span class="icon_new02">N</span> 
			 	</c:if>
			 	<c:if test="${list.N_POINT != '0' }">
				 	<c:choose>
						<c:when test="${list.S_TYPE == 'SHOP' }">
						</c:when>
						<c:when test="${list.S_TYPE == 'CHARGE' }">
							<fmt:formatNumber value="${list.N_POINT }" pattern="#,###" /> <img src="http://img.medilatte.com/admin/images/common/icon_p02.gif" alt=""/>
						</c:when>
						<c:when test="${list.S_TYPE == 'AD' }">
							<fmt:formatNumber value="${list.N_POINT }" pattern="#,###" /> 원 
						</c:when>
						<c:when test="${list.S_TYPE == 'REFUND' }">
						<fmt:formatNumber value="${list.N_POINT }" pattern="#,###" /> <img src="http://img.medilatte.com/admin/images/common/icon_p02.gif" alt=""/>
					</c:when>
					<c:when test="${list.S_TYPE == 'SUBTRACT' }">
						<fmt:formatNumber value="${list.N_POINT }" pattern="#,###" /> <img src="http://img.medilatte.com/admin/images/common/icon_p02.gif" alt=""/> 
					</c:when>
					</c:choose>
				</c:if>
			 </td>
			<td class="td_right">담당자 : ${list.S_CHARGE_TEAM} <c:if test="${not empty list.S_CHARGE_NAME }">- ${list.S_CHARGE_NAME}</c:if></td>
		</tr>
		</c:forEach>
	</table>
</div>
