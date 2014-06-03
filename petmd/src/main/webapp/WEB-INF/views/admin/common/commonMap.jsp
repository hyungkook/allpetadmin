<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<style>
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
		onload=function(){
			if(typeof parent.mapLoaded==='function')
				parent.mapLoaded();
		};
	</script>

</head>
<body id="wrap" style="margin:0 0 0 0;overflow: hidden;">
	<div class="shop_map" id="map" style="position:relative; height:100%; width:100%; margin:0 0 0 0;"></div>
	
	<!-- 지도영역 start-->
	<script	src="https://apis.skplanetx.com/tmap/js?version=1&format=javascript&appKey=47ede5e5-b03b-3359-85af-60e3da301cf1"></script>

	<!-- 지도영역 -->
	<script type="text/javascript">
	
		try{
	 
		var warpH = parent.document.getElementById("mapArea").offsetHeight;
		
		// Create Map Layer 
		var map = new Tmap.Map({
			div : "map",
			width : '100%;',
			height : warpH - 2
		});
		
		var markerLayer = new Tmap.Layer.Markers("MarkerLayer");
		map.addLayer(markerLayer);

		var pr_3857 = new Tmap.Projection("EPSG:3857"); // 구글 메르카토르 좌표
		var pr_4326 = new Tmap.Projection("EPSG:4326"); // 위경도 좌표

		var lon = '${shopMap.n_longitude}';
		var lat = '${shopMap.n_latitude}';
		
		if (lat == '') lat = '37.4983590';
		if (lon == '') lon = '127.0330886';
		
		// Map Center
		map.setCenter(new Tmap.LonLat(lon, lat).transform(pr_4326, pr_3857), 16);

		// Marker 
		var lonlat = new Tmap.LonLat(lon, lat).transform(pr_4326, pr_3857);
		var size = new Tmap.Size(22, 30);
		var offset = new Tmap.Pixel(-(size.w), -(size.h / 2));

		var state = "${shopMap.s_status}";
		
		var icon = new Tmap.Icon('${con.IMGPATH_OLD}/common/map_redpin.png', size, offset);
	
		if (state == '10001') {
			icon = new Tmap.Icon('${con.IMGPATH_OLD}/common/map_redpin.png', size, offset);
		} else {
			icon = new Tmap.Icon('${con.IMGPATH_OLD}/common/map_graypin.png', size,  offset);
		} 
		
		var marker = new Tmap.Markers(lonlat, icon);
		markerLayer.addMarker(marker);

		// Popup
		var popup;
		if ("${param.alt}" == "default") {
			popup = new Tmap.Popup("p1", lonlat, new Tmap.Size(true, true),
					"<span style='font-size:12px;'><b>${shopMap.s_hospital_name}</b></span>", false);
		} else {
			popup = new Tmap.Popup("p1",  
											new Tmap.LonLat(lon, lat).transform(pr_4326, pr_3857), 
											new Tmap.Size(true, true),
					"<div style='font-size:12px;'>${shopMap.s_hospital_name}</div>", false);
		}
		map.addPopup(popup);
		popup.show();

		Tmap.Map.prototype.isValidZoomLevel = function(zoomLevel) {
	        return ( (zoomLevel != null) &&
	        (zoomLevel >= 7) && 
	        (zoomLevel < this.getNumZoomLevels()) );
		};
		
		if ("${param.zoom}" == "false") {
			map.removeZoomControl();
		} 
		
		}
		catch(e){
			document.getElementById('map').innerHTML='지도를 불러올 수 없습니다.<br/>Name : '+e.name+'<br/>Message : '+e.message;
		}
		
	</script>
	
</body>
</html>