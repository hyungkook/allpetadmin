<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<script src="${con.JSPATH}/jcrop/jquery.color.js"></script>
<script src="${con.JSPATH}/jcrop/jquery.Jcrop.js"></script>

<link rel="stylesheet" href="${con.CSSPATH}/jquery.Jcrop.css" type="text/css"/>

<style>
/* 사진 편집 팝업 */
#poparea02{ width:100%; height:100%; background:#1b1b1b; position:absolute; top:0; left:0; right:0; bottom:0; position:fixed; z-index:9;}
#p02_head{width:100%; height:40px; background:#1b1b1b; position:absolute; top:0; left:0; position:fixed; z-index:99; overflow:hidden;}
#p02_contents{background:#1b1b1b; position:absolute; top:41px; left:0px; right:0px; bottom:56px;  position:fixed; z-index:99;}
#p02_bottom{ width:100%; height:55px; background:#1b1b1b; position:absolute; left:0; bottom:0;  position:fixed; z-index:99;}

#p02_head .btn_head{ float:right; width:39px; height:39px;}
#p02_head .btn_head .ui-btn-up-c    {margin:0; padding:10px 0; height:19px; line-height:0; font-size:0; background:#1b1b1b; border:none; box-shadow:none; -webkit-box-shadow:none;}
#p02_head .btn_head .ui-btn-hover-c {margin:0; padding:10px 0; height:19px; line-height:0; font-size:0; background:#000; border:none; box-shadow:none; -webkit-box-shadow:none;} 
#p02_head .btn_head .ui-btn-down-c  {margin:0; padding:10px 0; height:19px; line-height:0; font-size:0; background:#000; border:none; box-shadow:none; -webkit-box-shadow:none;}
#p02_head .btn_head .ui-btn-active  {margin:0; padding:10px 0; height:19px; line-height:0; font-size:0; background:#000; border:none; box-shadow:none; -webkit-box-shadow:none;}

#p02_contents .p_area{ position:relative; margin:0; padding:0; height:100%; width:100%;}
#p02_contents .crop_img_area{ position:absolute; top:50%; left:0; right:0; margin:0; padding:0; font-size:0; background:#333333; text-align:center;}

#p02_bottom .pop_btn_area{margin:10px 15px 0 15px; padding:0; overflow:hidden;}
#p02_bottom .pop_btn_area .pop_btn_type01{margin:0 5px 0 0; padding:0; height:32px; width:85px; float:left;}
#p02_bottom .pop_btn_area .pop_btn_type01 .ui-btn-up-c    {margin:0; padding:1px 0 0 0; height:29px; line-height:29px; font-size:12px; color:#ffffff; background:#313435; border:solid 1px #171717; border-radius:4px; box-shadow:0 1px 0 #505253 inset; -webkit-box-shadow:0 1px 0 #505253 inset;}
#p02_bottom .pop_btn_area .pop_btn_type01 .ui-btn-hover-c {margin:0; padding:1px 0 0 0; height:29px; line-height:29px; font-size:12px; color:#ffffff; background:#1e1f20; border:solid 1px #171717; border-radius:4px; box-shadow:0 1px 0 #505253 inset; -webkit-box-shadow:0 1px 0 #505253 inset;}
#p02_bottom .pop_btn_area .pop_btn_type01 .ui-btn-down-c  {margin:0; padding:1px 0 0 0; height:29px; line-height:29px; font-size:12px; color:#ffffff; background:#1e1f20; border:solid 1px #171717; border-radius:4px; box-shadow:0 1px 0 #505253 inset; -webkit-box-shadow:0 1px 0 #505253 inset;}
#p02_bottom .pop_btn_area .pop_btn_type01 .ui-btn-active  {margin:0; padding:1px 0 0 0; height:29px; line-height:29px; font-size:12px; color:#ffffff; background:#1e1f20; border:solid 1px #171717; border-radius:4px; box-shadow:0 1px 0 #505253 inset; -webkit-box-shadow:0 1px 0 #505253 inset;}
#p02_bottom .pop_btn_area .pop_btn_type01 img{ vertical-align:middle; margin-top:-2px;}

#p02_bottom .pop_btn_area .pop_btn_type02{margin:0 5px 0 0; padding:0; height:32px; width:85px; float:right;}
#p02_bottom .pop_btn_area .pop_btn_type02 .ui-btn-up-c    {margin:0; padding:1px 0 0 0; height:29px; line-height:29px; font-size:12px; color:#ffffff; background:#e93a5b; border:solid 1px #d02747; border-radius:4px; box-shadow:0 1px 0 #fb8fa3 inset; -webkit-box-shadow:0 1px 0 #fb8fa3 inset;}
#p02_bottom .pop_btn_area .pop_btn_type02 .ui-btn-hover-c {margin:0; padding:1px 0 0 0; height:29px; line-height:29px; font-size:12px; color:#ffffff; background:#d62c4c; border:solid 1px #d02747; border-radius:4px; box-shadow:0 1px 0 #fb8fa3 inset; -webkit-box-shadow:0 1px 0 #fb8fa3 inset;}
#p02_bottom .pop_btn_area .pop_btn_type02 .ui-btn-down-c  {margin:0; padding:1px 0 0 0; height:29px; line-height:29px; font-size:12px; color:#ffffff; background:#d62c4c; border:solid 1px #d02747; border-radius:4px; box-shadow:0 1px 0 #fb8fa3 inset; -webkit-box-shadow:0 1px 0 #fb8fa3 inset;}
#p02_bottom .pop_btn_area .pop_btn_type02 .ui-btn-active  {margin:0; padding:1px 0 0 0; height:29px; line-height:29px; font-size:12px; color:#ffffff; background:#d62c4c; border:solid 1px #d02747; border-radius:4px; box-shadow:0 1px 0 #fb8fa3 inset; -webkit-box-shadow:0 1px 0 #fb8fa3 inset;}
#p02_bottom .pop_btn_area .pop_btn_type02 img{ vertical-align:middle; margin-top:-2px;}
</style>
    
<script>

function JcropCore(){
	
	var _this = this;
	
	this.jcrop_api=null;
	
	this.jcadata={
		jcrop_id:0,
		x1:0,
		x2:0,
		y1:0,
		y2:0,
		plate_width:0,
		plate_height:0,
		next_url:'',
		targetTagId:'',
		iid:null,
		crop_padding_flag:'',
		crop_width:0,
		crop_height:0,
		crop_rate:0
	};
	
	this.jcrop_options = {
		rate_fixed:true
	};
	
	this.setTargetTagId=function(id){
		_this.jcadata.targetTagId = id;
	};

	this.setJcropOptions=function(option){
		
		$.extend(_this.jcrop_options,option);
		//jcrop_options = option;
	};
	
	this.showCoords=function(c)
	{
		_this.jcadata.x1=c.x;
		_this.jcadata.x2=c.x2;
		_this.jcadata.y1=c.y;
		_this.jcadata.y2=c.y2;
	};
	
	this.expansion=function(val){
		
		var x1 = _this.jcadata.x1;
		var x2 = _this.jcadata.x2;
		var y1 = _this.jcadata.y1;
		var y2 = _this.jcadata.y2;
		
		_this.jcrop_api.setSelect([x1 - parseInt(val), y1 - parseInt(val), x2 - -parseInt(val), y2 - -parseInt(val)]);
	};
	
	this.reduce=function(val){
		
		var x1 = _this.jcadata.x1;
		var x2 = _this.jcadata.x2;
		var y1 = _this.jcadata.y1;
		var y2 = _this.jcadata.y2;
		
		_this.jcrop_api.setSelect([x1 - -parseInt(val), y1 - -parseInt(val), x2 - parseInt(val), y2 - parseInt(val)]);
	};
	
	this.cropStart=function(){
		
		if(_this.jcadata.x2 - _this.jcadata.x1 < 1 || _this.jcadata.y2 - _this.jcadata.y1 < 1){
			alert('잘라낼 영역을 선택해주세요.');
			return;
		}
		
		_this.jcadata.plate_width=$('#cropImage').width();
		_this.jcadata.plate_height=$('#cropImage').height();
			
		$.ajax({
			type:"POST",
			url:_this.jcadata.crop_url,
			data:_this.jcadata,
			dataType:'json',
			success:function(response, statusText, xhr, $form){
				
				if(response.result=='${codes.ERROR_NOT_FOUND_IMAGE}'){
					alert('이미지가 없습니다.');
				}
				else if(response.result!='${codes.SUCCESS_CODE}'){
					alert('오류가 발생했습니다.');
				}
				
				_this.cropClose();
				imageUpdate(_this.jcadata.targetTagId,"data:image/jpg;base64,"+response.imgData,response.iid);//map.index_target,map.tmp_index);;
				 
			}, error: function(xhr,status,error){
				alert("Crop Failure\n"+xhr+"\n"+status+"\n"+error);
			}
		}); 
		
		$('#cropStartBtn').hide();
	};
	
	this.cropOpen = function(){
		
		$('#poparea02').show();
		$('#crop_msg').hide();
		
		$('.crop_img_area').css('height',$('.crop_img_area').css('width'));
		
		$('.crop_img_area').show();
		var cont = $('.crop_img_area').css('height');
		var contHeight = parseInt(cont.substring(0,cont.length -2)*0.5 );
		$('.crop_img_area').css('margin-top',-contHeight);
		
		$('#cropStartBtn').show();
		
		$('#contents').hide();
	};
	
	this.cropClose=function(){
		
		$('#poparea02').hide();
		$('#contents').show();
	};
	
	this.openCropLayer=function(map){
		
		_this.jcadata.iid = map.iid;
		
		var default_width = parseInt(map.base_w);
		var default_height = parseInt(map.base_h);

		var p = $('#cropImage').parent().parent();
		p.empty();
		p.append('<div class="crop_img_area"><img id="cropImage" src="" alt=""/></div>');
		
		_this.cropOpen();
		
		if(default_width < default_height){
			_this.jcadata.crop_padding_flag = 'H';
		}
		else{
			_this.jcadata.crop_padding_flag = 'W';
		}
		
		_this.jcadata.crop_width = parseInt(map.crop_w);
		_this.jcadata.crop_height = parseInt(map.crop_h);
		_this.jcadata.crop_rate = _this.jcadata.crop_width / _this.jcadata.crop_height;

		_this.jcadata.crop_url=map.crop_url;
		
		var img = new Image();
		img.src = "data:image/jpg;base64,"+map.imgsrc;
		img.onload = function()
		{
			$('#cropImage').attr('src', this.src);
			
			var img_rate = this.width / this.height;

			var h = 0;
			var w = 0;
			
			if(_this.jcadata.crop_padding_flag=='H'){
				h = parseFloat($('.crop_img_area').css('height'));
				w = h * img_rate;
			}
			else{
				w = parseFloat($('.crop_img_area').css('width'));
				h = w / img_rate;
			}
			
			$('#cropImage').css('height',h);
			$('#cropImage').css('width',w);
			
			var option = {
					onChange: _this.showCoords,
					onSelect: _this.showCoords
				};
			
			try{
				if(_this.jcrop_options.rate_fixed){
					option.aspectRatio = _this.jcadata.crop_rate;
					option.setSelect = [0, 0, _this.jcadata.crop_width, _this.jcadata.crop_height];
				}
				else
					option.setSelect = [0, 0, w, h];
				
			}catch(e){
				option.aspectRatio = _this.jcadata.crop_rate;
				option.setSelect = [0, 0, _this.jcadata.crop_width, _this.jcadata.crop_height];
			}
			
			$('#cropImage').Jcrop(option, function(){
				_this.jcrop_api = this;
				
				$('.jcrop-handle').css('width','20px');
				$('.jcrop-handle').css('height','20px');
				for(var handle_index = 0; handle_index < $('.jcrop-handle').length; handle_index++){
					if($($('.jcrop-handle')[handle_index]).css('margin-top','-11px')!='0px')
						$('.jcrop-handle').css('margin-top','-11px');
					if($($('.jcrop-handle')[handle_index]).css('margin-left','-11px')!='0px')
						$('.jcrop-handle').css('margin-left','-11px');
					if($($('.jcrop-handle')[handle_index]).css('margin-right','-11px')!='0px')
						$('.jcrop-handle').css('margin-right','-11px');
					if($($('.jcrop-handle')[handle_index]).css('margin-bottom','-11px')!='0px')
						$('.jcrop-handle').css('margin-bottom','-11px');
				}
				
				if(_this.jcadata.crop_padding_flag=='H'){
					var bw = $('.crop_img_area').css('width');
					var iw = $('#cropImage').css('width');
					$('.crop_img_area').css('padding-top',0);
					$('.crop_img_area').css('padding-left',(parseFloat(bw) - parseFloat(iw)) / 2);
				}
				else{
					var bw = $('.crop_img_area').css('height');
					var iw = $('#cropImage').css('height');
					$('.crop_img_area').css('padding-left',0);
					$('.crop_img_area').css('padding-top',(parseFloat(bw) - parseFloat(iw)) / 2);
				}
			});
		};
	};
	
	$('#cropStartBtn').on('click',function(){
		_this.cropStart();
	});
	$('#cropCloseBtn').on('click',function(){
		_this.cropClose();
	});
	$('#cropExpansionBtn').on('click',function(){
		_this.expansion(2);
	});
	$('#cropReduceBtn').on('click',function(){
		_this.reduce(2);
	});
}

</script>
    
<!-- 이미지 편집 팝업 시작-->
<div id="poparea02" style="display:none;z-index:99999;">

	<!-- head 시작-->
	<div id="p02_head">
		<p class="btn_head"><a id="cropCloseBtn" data-role="button"><img src="${con.IMGPATH_OLD}/btn/btn_pop_close.png" alt="" width="19" height="19"/></a></p>
	</div>
	<!-- //head 끝-->
	
	<!-- content 시작-->
	<div id="p02_contents">
		<p id="crop_msg" style="text-align:center;"><span style="font-size:30px;"><font color="#ffffff">잠시만 기다려 주십시오.</font></span></p>
		<div class="p_area">
			<div class="crop_img_area"><img id="cropImage" src="" alt=""/></div>
		</div>
	</div>
	<!-- //content 끝-->
	
	<!-- bottom 시작-->
	<div id="p02_bottom">
		<div class="pop_btn_area">
			
			<p class="pop_btn_type01"><a id="cropExpansionBtn" data-role="button"><img src="${con.IMGPATH_OLD}/btn/btn_expand.png" alt="" width="16" height="16"/> 확대</a></p>
			<p class="pop_btn_type01"><a id="cropReduceBtn" data-role="button"><img src="${con.IMGPATH_OLD}/btn/btn_cont.png" alt="" width="16" height="16"/> 축소</a></p>
			<p class="pop_btn_type02"><a id="cropStartBtn" data-role="button"><img src="${con.IMGPATH_OLD}/btn/btn_cut.png" alt="" width="16" height="16"/> 잘라내기</a></p>
		</div>
	</div>
	<!-- //content 끝-->
	
</div>
<!-- 이미지 편집 팝업 시작-->