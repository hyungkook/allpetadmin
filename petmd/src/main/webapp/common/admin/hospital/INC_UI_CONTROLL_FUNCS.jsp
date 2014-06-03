<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
function radio_check(group, index){
	
	for(var i = 0; i < group.length; i++){
		if(i == index){
			$(group[i]).find('img').attr('src', "${con.IMGPATH_OLD}/btn/radio_on${personalLayout}.png");
		}
		else{
			$(group[i]).find('img').attr('src', "${con.IMGPATH_OLD}/btn/radio_off.png");
		}
	}
}

function checked_radio_value(group){
	
	for(var i = 0; i < group.length; i++){
		if($(group[i]).find('img').attr('src') == "${con.IMGPATH_OLD}/btn/radio_on${personalLayout}.png")
			return i;
	}
	return -1;
}

function toggleCheckbox(id){
	
	$('#'+id).toggle();

}
function checkCheckbox(id){
	
	$('#'+id).show();
}

function releaseCheckbox(id){
	
	$('#'+id).hide();
}

function chkboxIsChecked(id){
	return $('#'+id+':visible').is($('#'+id));
}

</script>