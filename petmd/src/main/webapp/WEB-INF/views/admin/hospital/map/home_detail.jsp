<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>

<jsp:include page="../include/total_header.jsp" />

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

<!-- 지도영역 start-->


<!-- 지도영역 -->
<script>

var TmapSetting=function (){
	this.zoomDisable = false;
};

var tm = new TmapSetting();

$(window).resize(function(){
	
	$('#map').css('width','100%');
	map.updateSize();
});

$(window).load(function(){
try{
	//var warpH = 200;//parent.document.getElementById("mapArea").offsetHeight;
	//$('#map').css('height',parseInt($('#map').css('width'))/2);
	
	// Create Map Layer 
	var map = new Tmap.Map({
		div : "map",
		width : parseInt($('#map').css('width')),// 300,//'100%;',
		height : parseInt($('#map').css('height'))//*0.5558//warpH - 2
	});
	
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
});
</script>

</head>

<body>
		
	<div id="page" data-role="page">

		<!-- content 시작-->
		<div data-role="content" id="contents" style="position:absolute; top:0px; left:0px; right:0px; bottom:0px;">
			<div class="pop_map">
				<div id="map" style="position:relative; width:100%; height:100%; line-height:100%; font-size:12px; margin:0 0 0 0; "></div>
				<p class="btn_close" style="line-height:0; font-size:0px;"><a data-role="button" data-rel="back">닫기</a></p>
			</div>
		</div>
	
	</div>

</body>

<script	src="https://apis.skplanetx.com/tmap/js?version=1&format=javascript&appKey=47ede5e5-b03b-3359-85af-60e3da301cf1"></script>

</html>