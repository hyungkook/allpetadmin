<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<script>

function SlideMenu(cookieName,curMenuSeq,menuCount,rootId){
	
	var existMenuPositionCookie = true;
	var menuPosition = $.cookie(cookieName);
	
	if(menuPosition==null){	menuPosition = 1;existMenuPositionCookie=false;}
	else{$.removeCookie(cookieName);}
	
	var movingDistance = 0;//parseFloat('${100.0 / fn:length(menuList)}');
	//var menuCount = parseInt('${fn:length(menuList)}');
	
	(function(){
		
		var p_acc = 0;
		// safari/mobile 보정 start
		var p_len = menuCount;
		//alert($('#'+rootId+' #center').width()+"\n"+p_len);
		for(var pi = 0; pi < p_len; pi++){
			var pw =  Math.floor(($('#'+rootId+' #center').width())*(pi+1)/p_len);
			$("#"+rootId+" #menu"+pi).width(pw-p_acc);
			//console.log('11  '+p_acc+","+p_len+","+pw+","+(pw-p_acc));
			//alert(pi+":"+p_acc+',1 '+($("#"+rootId+" #menu"+pi).offset().left-$('#'+rootId+' #center').offset().left)+","+$("#"+rootId+" #menu"+pi).length);

			var m = -($("#"+rootId+" #menu"+pi).offset().left-$('#'+rootId+' #center').offset().left)+p_acc-10;
			$("#"+rootId+" #menu"+pi).css('margin-left',m);
			p_acc=pw;
			//alert($("#"+rootId+" #menu"+pi).offset().left+","+$("#"+rootId+" #menu"+pi).width());
		}
		// end
		
		if(isMobileDevice()){
			$('#'+rootId+' #list').bind("touchstart", function(e){touchstart(e);});
			$('#'+rootId+' #list').bind("touchmove", function(e){e.preventDefault();});
			$('#'+rootId+' #list').bind("touchend", function(e){touchend(e);});
		}
		else{
			$('#'+rootId+' #list').bind("mousedown", function(e){touchstart(e);});
			$('#'+rootId+' #list').bind("mouseup", function(e){touchend(e);});
		}
		
		$('#'+rootId+' #right_btn').on('click',function(){moveRight();});
		$('#'+rootId+' #left_btn').on('click',function(){moveLeft();});
		
//		movingDistance = parseInt($('#'+rootId+' #center').width()*parseInt(100.0 / menuCount, 10)/100.0,10);
		movingDistance = Math.floor(p_acc*(100.0 / menuCount) /100.0);
		//alert($('#'+rootId+' #center').width()+'   '+p_acc+','+menuCount+','+movingDistance);
		
		if(existMenuPositionCookie){savedLock();}
		else{centerLock();};

		validateBtn();
	}());

	function centerLock(){//가운데고정//
		
		var seq = curMenuSeq-2;
		var len = menuCount;
		if(seq<0) seq=0;
		if(seq>len-3) seq=len-3;
		$('#'+rootId+' #center').css('margin-left',(movingDistance*-seq)+10);//+'%');
	}

	function savedLock(){//마지막누른위치//
		
		var seq = -(parseInt(menuPosition)+1-2);
		$('#'+rootId+' #center').css('margin-left',(movingDistance*seq)+10);//+'%');
	}

	var isMoving = false;

	function moveRight(){
		
		if(isMoving)
			return;
		
		var ml = parseInt($('#'+rootId+' #center').css('margin-left'));

		if(ml > -1)
			return;
		
		isMoving = true;
		
		$('#'+rootId+' #center').animate({
			'margin-left':'+='+movingDistance//+'%'
		},'fast',function(){

			validateBtn();
			menuPosition--;
			
			isMoving = false;
		});
	}

	function moveLeft(){
		
		if(isMoving)
			return;
		
		var ml = parseInt($('#'+rootId+' #center').css('margin-left'));
		var ll = -((menuCount-1-2) * movingDistance-1)+10;
		
		if(ml < ll)
			return;
		isMoving = true;
		//alert(movingDistance);
		
		$('#'+rootId+' #center').animate({
			'margin-left':'-='+movingDistance
		},'fast',function(){

			validateBtn();
			menuPosition++;
			
			isMoving = false;
			
			//alert($('#'+rootId+' #center').css('margin-left'));
		});
	}

	function validateBtn(){
		
		var ml = parseInt($('#'+rootId+' #center').css('margin-left'));
		var ll = -((menuCount-1-2) * movingDistance-1)+10;

		if(ml < ll){$('#'+rootId+' #left_btn').hide();
		}else{$('#'+rootId+' #left_btn').show();}
		
		if(ml > -1){$('#'+rootId+' #right_btn').hide();
		}else{$('#'+rootId+' #right_btn').show();}
	}

	var start_x = 0;
	var move_x = 0;

	function touchstart(e){
		
		try{
			start_x = e.pageX || e.originalEvent.touches[0].pageX || e.originalEvent.changedTouches[0];
		}catch(e){}
	}

	function touchend(e){
		
		try{
			var _x = e.pageX || e.originalEvent.changedTouches[0].pageX || e.originalEvent.changedTouches[0];
			move_x = _x - start_x;
			
			if(move_x > -5 && move_x < 5)
				;
			else if(move_x < 0){
				moveLeft();
			}else{
				moveRight();
			};
		}catch(e){}
	}

	this.goMenuLink = function(url){
		
		// 임계값
		if(move_x < 5 && move_x > -5){
			$.cookie(cookieName, menuPosition, {expires:1});
			goPage(url);
		}
	};
	
	this.saveTemporary=function(){
		$.cookie(cookieName, menuPosition, {expires:1});
	};
};

</script>