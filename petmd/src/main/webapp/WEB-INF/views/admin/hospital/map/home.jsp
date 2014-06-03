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
</jsp:scriptlet>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../include/total_header.jsp" />

<%-- <script src="${con.JSPATH}/jquery.iframeCorrector.js"></script> --%>

<style>
.tmPopupContent {
		white-space: nowrap;
		border:solid 1px #92a0aa; border-radius:5px; display:inline-block;
		line-height:100%;
	}
	#p1_GroupDiv{
	border-radius:5px;
	
	}
</style>
<!-- 
<script>


function resize() {
	
	var ifmHeight = $('#page').height() - $('#tab').height() - $('#addressInfo').height();
	
	var ua = isUA();
	var uaHeight = 0;
	
	if (ua == "A") {
		uaHeight = 0;
	} else if (ua == "I") {
		uaHeight = 70;
	} else if (ua == "AWV") {
		uaHeight = 0;
	} else if (ua == "IWV") {
		uaHeight = 0;
	}
	
	$('#mapArea').height($('#map').width()/2);//ifmHeight+2);
}

function mapLoaded(){
	
	$('#map').append($('<div onclick="goPage(\'hospitalMap.latte?idx=${params.idx}&detail=detail\');" style="position:absolute; top:0; left:0; width:100%; height:100%; filter:alpha(opacity=0); opacity:0; background:black;"></div>'));
}
</script>
 -->
<!-- 지도영역 start-->
<script	src="https://apis.skplanetx.com/tmap/js?version=1&format=javascript&appKey=47ede5e5-b03b-3359-85af-60e3da301cf1"></script>

<!-- 지도영역 -->
<script>

var TmapSetting=function (){
	this.zoomDisable = true;
};

var tm = new TmapSetting();

/* $.getScript("test.js")
.done(function(script, textStatus) {
  console.log( script );
  console.log( textStatus );
})
.fail(function(jqxhr, settings, exception) {
	alert('?Triggered ajaxError handler?');
}); */
		
$(window).load(function(){
	
	loadMap();
});

var map = null;

$(window).resize(function(){
	
	$('#map').css('width','100%');
	map.updateSize();
});

function loadMap(){
	
	try{
		//var warpH = 200;//parent.document.getElementById("mapArea").offsetHeight;
		
		$('#map').css('height',parseInt($('#map').css('width'))/2);
		
		// Create Map Layer 
		map = new Tmap.Map({
			div : "map",
			width : parseInt($('#map').css('width')),// 300,//'100%;',
			height : parseInt($('#map').css('width'))*0.5558//warpH - 2
		});
		
		//console.log(parseInt($('#map').css('width')));
		//
		var markerLayer = new Tmap.Layer.Markers("MarkerLayer");
		map.addLayer(markerLayer);
	
		var pr_3857 = new Tmap.Projection("EPSG:3857"); // 구글 메르카토르 좌표
		var pr_4326 = new Tmap.Projection("EPSG:4326"); // 위경도 좌표
	
		var lon = '${hospitalInfo.n_longitude}';
		var lat = '${hospitalInfo.n_latitude}';
		
		if (lat == '') lat = '37.4983590';
		if (lon == '') lon = '127.0330886';
		
		// Map Center
		map.setCenter(new Tmap.LonLat(lon, lat).transform(pr_4326, pr_3857), 16);
	
		// Marker 
		var lonlat = new Tmap.LonLat(lon, lat).transform(pr_4326, pr_3857);
		var size = new Tmap.Size(22, 30);
		var offset = new Tmap.Pixel(-(size.w / 2), -(size.h));
		
		var icon = new Tmap.Icon('${con.IMGPATH}/common/icon_map.png', size, offset);
		
		//var label = new Tmap.Label('<div style=\'font-size:12px;height:1000px;\'>${hospitalInfo.s_hospital_name}</div>');
		var marker = new Tmap.Markers(lonlat, icon);//,label);
		//marker.events.register("mouseover", marker, onOverMarker);
		//marker.events.register("mouseout", marker, onMarkerOut);
	
		markerLayer.addMarker(marker);
	
		// Popup
		var popup;
		if ("${param.alt}" == "default") {
			popup = new Tmap.Popup("p1", lonlat, new Tmap.Size(true, true),
					"<span style='font-size:12px;'><b>${hospitalInfo.s_hospital_name}</b></span>", false);
		} else {
			popup = new Tmap.Popup("p1",  
											new Tmap.LonLat(lon, lat).transform(pr_4326, pr_3857), 
											new Tmap.Size(true, true),
					"<div style='font-size:12px;'>${hospitalInfo.s_hospital_name}</div>", false);
		}
		map.addPopup(popup);
		
		//marker.popup.show();
	
		Tmap.Map.prototype.isValidZoomLevel = function(zoomLevel) {
			return ( (zoomLevel != null) &&
			(zoomLevel >= 7) && 
			(zoomLevel < this.getNumZoomLevels()) );
		};
		
		if (tm.zoomDisable) {
			map.removeZoomControl();
		} 
	
		// 모바일에 마커가 전부 사라지는 현상 보정
		$('#Tmap_Map_7_Tmap_Container').css('z-index','-1');
		$('.tmLayerGrid').css('z-index','-1');

	}catch(e){
		document.getElementById('map').innerHTML='지도를 불러올 수 없습니다.<br/>Name : '+e.name+'<br/>Message : '+e.message;
	}
}

</script>

</head>

<body>
		
	<div data-role="page">
	
		<jsp:include page="../include/main_title_bar.jsp"><jsp:param name="ignore_title_back_btn" value="Y"/></jsp:include>

		<!-- content 시작-->
		<div data-role="content" id="contents">

			<jsp:include page="../include/main_menu.jsp"/>
			
			<%-- <iframe id="aaa" style="width:100%; height:100px;" src="${con.dns}/include/client/map.jsp?msg=abc"></iframe> --%>
			
			<!-- 등록버튼 -->
			<div class="a_type01_b">
				<p class="btn_red02"><a onclick="goPage('addressInfoEdit.latte')" data-role="button"> 등록/수정하기</a></p>
			</div>
			
			<div class="a_type01">
				<h3>${hospitalInfo.s_old_addr_sido} ${hospitalInfo.s_old_addr_sigungu} ${hospitalInfo.s_old_addr_dong} ${hospitalInfo.s_old_addr_etc} <span class="txt_type01"></span></h3>
				<div class="w_box mt10" style="position:relative;" onclick="goPage('mapHome.latte?p=detail')">
					<div id="map" style="position:relative; width:100%; margin:0 0 0 0;"></div>
					<p class="blind_txt" onClick="">지도를 누르면 더 자세히 보실 수 있습니다.</p>
					<div style="position:absolute; filter:alpha(opacity=0); opacity:0; background-color:black; z-index:9999; width:100%; height:100%; left:0px; top:0px;"></div>
				</div>
				
				<c:if test="${hospitalInfo.path_car_status eq 'Y' or hospitalInfo.path_bus_status eq 'Y' or hospitalInfo.path_subway_status eq 'Y'}">
				<h3 class="mt25"><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />오시는 방법</h3>
				
				<c:if test="${hospitalInfo.path_car_status eq 'Y'}">
				<div class="w_box03 mt05">
					<p class="tt"><img src="${con.IMGPATH}/common/icon_car.png" alt="" width="13" height="12"/> 자가용</p>
					<p class="txt_type01 mt05">${fn:replace(hospitalInfo.path_car,crlf,'<br/>')}</p>
				</div>
				</c:if>
				<c:if test="${hospitalInfo.path_bus_status eq 'Y'}">
				<div class="w_box03 mt05">
					<p class="tt"><img src="${con.IMGPATH}/common/icon_bus.png" alt="" width="11" height="12"/> 버스</p>
					<p class="txt_type01 mt05">${fn:replace(hospitalInfo.path_bus,crlf,'<br/>')}</p>
				</div>
				</c:if>
				<c:if test="${hospitalInfo.path_subway_status eq 'Y'}">
				<div class="w_box03 mt05">
					<p class="tt"><img src="${con.IMGPATH}/common/icon_subway.png" alt="" width="11" height="12"/> 지하철</p>
					<p class="txt_type01 mt05">${fn:replace(hospitalInfo.path_subway,crlf,'<br/>')}</p>
				</div>
				</c:if>
				
				</c:if>
			</div>
			
			<%-- <div id="map" style="position: relative;margin: 0 0 0 0;">
				<iframe id="mapArea" src="mapInfo.latte?idx=${param.idx}&zoom=false"
				style="position: relative; width: 100%; margin: 0; padding: 0; border: 0; overflow-y:hidden;"></iframe>
			</div> --%>
		</div>
		
		<jsp:include page="../include/simple_copyright.jsp"/>
	
	</div>

</body>
</html>