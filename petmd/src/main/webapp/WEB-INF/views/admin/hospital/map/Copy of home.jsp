<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>

<jsp:include page="../include/total_header.jsp"/>

<style>

#Tmap_Control_Zoom_3 {z-index:99999;}
/* #Tmap_Map_7_Tmap_Container {display:none;} */
		.tmPopupContent {
			white-space: nowrap;
			border:solid 1px #92a0aa; border-radius:5px; display:inline-block;
			line-height:100%; 
			no-repeat; 
			filter:alpha(opacity=40);
			opacity:0.8; 
			-moz-opacity:0.3; 
			
		}
		
		#p1_GroupDiv{
			border-radius:5px;
			/*opacity:0.4;*/
			/*filter:alpha(opacity=40);*/
		}
		
	</style>


<script>

$(document).ready(function(){
	resize();
});

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



<!-- 지도영역 start-->
<script	src="https://apis.skplanetx.com/tmap/js?version=1&format=javascript&appKey=47ede5e5-b03b-3359-85af-60e3da301cf1"></script>

<!-- 지도영역 -->
<script>

$(window).load(function(){
try{
	//var warpH = 200;//parent.document.getElementById("mapArea").offsetHeight;
	$('#map').css('height',parseInt($('#map').css('width'))/2);
	
	// Create Map Layer 
	var map = new Tmap.Map({
		div : "map",
		width : parseInt($('#map').css('width')),// 300,//'100%;',
		height : parseInt($('#map').css('width'))/2//warpH - 2
	});
	
	var markerLayer = new Tmap.Layer.Markers("MarkerLayer");
	map.addLayer(markerLayer);

	var pr_3857 = new Tmap.Projection("EPSG:3857"); // 구글 메르카토르 좌표
	var pr_4326 = new Tmap.Projection("EPSG:4326"); // 위경도 좌표

	var lon = '${addressInfo.n_longitude}';
	var lat = '${addressInfo.n_latitude}';
	
	if (lat == '') lat = '37.4983590';
	if (lon == '') lon = '127.0330886';
	
	// Map Center
	map.setCenter(new Tmap.LonLat(lon, lat).transform(pr_4326, pr_3857), 16);

	// Marker 
	var lonlat = new Tmap.LonLat(lon, lat).transform(pr_4326, pr_3857);
	var size = new Tmap.Size(22, 30);
	var offset = new Tmap.Pixel(-(size.w), -(size.h / 2));

	var state = "${hospitalInfo.s_status}";
	
	var icon = new Tmap.Icon('${con.IMGPATH_OLD}/common/map_redpin.png', size, offset);

	if (state == '10001') {
		icon = new Tmap.Icon('${con.IMGPATH_OLD}/common/map_redpin.png', size, offset);
	} else {
		icon = new Tmap.Icon('${con.IMGPATH_OLD}/common/map_graypin.png', size,  offset);
	} 
	
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
	
	if ("${param.zoom}" == "false") {
		map.removeZoomControl();
	} 

	// 모바일에 마커가 전부 사라지는 현상 보정
	$('#Tmap_Map_7_Tmap_Container').css('z-index','-1');
	$('.tmLayerGrid').css('z-index','-1');
	//

	}catch(e){
		document.getElementById('map').innerHTML='지도를 불러올 수 없습니다.<br/>Name : '+e.name+'<br/>Message : '+e.message;
	}
});

function onOverMarker (evt){
	this.popup.show();
}

function onMarkerOut(evt){
	this.popup.hide();
}
	
</script>
</head>

<body>
		
	<div data-role="page">
		
		<jsp:include page="../include/main_title_bar.jsp"><jsp:param name="ignore_title_back_btn" value="Y"/></jsp:include>
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
			
			<!-- 메인메뉴 tab -->
			<jsp:include page="../include/main_menu.jsp"/>
			
			<div>
				<a data-role="button" onclick="goPage('addressInfoEdit.latte')" style="padding:10px;">수정하기</a>
			</div>
			
			<div id="addressInfo">
			주소 : ${addressInfo.s_old_addr_sido} ${addressInfo.s_old_addr_sigungu} ${addressInfo.s_old_addr_dong}/ ${addressInfo.s_old_addr_etc}<br/>
			자가용 : ${addressInfo.path_car}<br/>
			지하철 : ${addressInfo.path_subway}<br/>
			버스 : ${addressInfo.path_bus}
			</div>
			
			<%-- <div id="map1" style="position: relative;margin: 0 0 0 0;">
				<iframe id="mapArea" src="mapInfo.latte?idx=${param.idx}&zoom=false"
				style="position: relative; width: 100%; margin: 0; padding: 0; border: 0; overflow-y:hidden;"></iframe>
			</div> --%>
			
			<div id="map" style="position:relative; width:100%; margin:0 0 0 0;"></div>
		</div>
	
	</div>

</body>
</html>