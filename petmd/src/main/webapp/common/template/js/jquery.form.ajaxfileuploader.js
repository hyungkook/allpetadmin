/*
 * uploadImage 함수의 인자로 업로드 할 file element를 jquery 형식으로 넘긴다.
 * 서버의response 값은 json으로 와야한다.
 */
function AjaxFileUploader(opts){
	
	var vars = {
		responseType:'json',
		elementType:'jquery'
	};
	
	if(typeof opts.success==='function'&&!(typeof opts.success_func==='function')){
		opts.success_func=opts.success;
	}
	if(typeof opts.error==='function'&&!(typeof opts.error_func==='function')){
		opts.error_func=opts.error;
	}
	
	$.extend(vars,opts);
	
	var form = $('<form method="post" enctype="multipart/form-data"></form>');
	$('body').append(form);
	
	this.uploadImage = function ($fileInput){
		
		var uploadForm = form;
		uploadForm.append($fileInput);
			
		form.ajaxForm({
			beforeSubmit: function(a,f,o) {
			},
			clearForm: false,
			resetForm: false,
			url:vars.url,
			type:'POST',
			success: function (responseText, statusText, xhr, $form) {
				
				form.unbind('submit').find('input:submit,input:image,button:submit').unbind('click');
				form.detach();
				form.remove();
				
				var map = $.parseJSON(responseText);
				
				if(typeof vars.success_func==='function'){
					vars.success_func(map, vars.userData, statusText, xhr, $form);
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				
				form.detach();
				form.remove();
				if(typeof vars.error_func==='function'){
					vars.error_func(vars.userData, jqXHR, textStatus, errorThrown);
				}
				else{
					alert('File Upload Failed : ' + jqXHR);
				}
			}
		});
		
		form.submit(function(e){
			return false;
		});
		
		form.submit();
	};
}

/*
 * Custom file input creator (Single)
 * file input 을 자동으로 붙이는 버전
 * 
 * attachTagId : file input 을 붙일 부모 요소의 id(필수)
 * opts (options)
 * fileTagName : 서버에서 multipartRequest.getFile(fileTagName) 에 사용하는 이름
 * click : file input 에 파일 선택 이후 수행되는 함수
 * success or success_func : 성공시 마지막에 수행되는 함수
 * error or error_func : 에러시 마지막에 수행되는 함수
 * userData : 내부 콜백 함수에서 쓰고 싶은 데이터 저장
 * final_func : 성공 실패 관계없이 마지막 수행
 */
function AjaxFileUploader2(attachTagId,opts){
	
	var _this = this;
	
	var vars = {
		attachTagId:attachTagId,
		responseType:'json',
		elementType:'jquery',
		fileTagName:'image'
	};
	
	this.click = opts.click;
	
	if(typeof opts.success==='function'&&!(typeof opts.success_func==='function')){
		opts.success_func=opts.success;
	}
	if(typeof opts.error==='function'&&!(typeof opts.error_func==='function')){
		opts.error_func=opts.error;
	}
	
	$.extend(vars,opts);
	
	var btn = $('<input type="file" id="'+attachTagId+'_file_btn" name="'+vars.fileTagName
			+'" style="width:100%; height: 100%; cursor:pointer; font-size: 500px; opacity:0; filter:alpha(opacity=0);"/>');
	
	var d = $('<div id="'+attachTagId+'_file_btn_area" style="position:absolute; overflow:hidden; top:0; left:0; z-index:1;"/>');
	d.mouseover(function(){$(this).parent().find('span').mouseover();$(this).parent().find('a').mouseover();});
	d.mouseout(function(){$(this).parent().find('span').mouseout();$(this).parent().find('a').mouseout();});
	
	var cb = btn.clone();
	if(typeof vars.click==='function'){
		cb.change(function(){vars.click();_this.uploadImage();});
	}
	else{
		cb.change(function(){_this.uploadImage();});
	}
	d.append(cb);
	
	d.height($('#'+attachTagId).height());
	d.width($('#'+attachTagId).width());
	$('#'+attachTagId).css('position','relative');
	$('#'+attachTagId).append(d);
	
	var form = null;
	
	this.preAction = function(){
		if(typeof vars.preAction === 'function'){
			vars.preAction();
		}
	};
	
	this.uploadImage = function ($fileInput){
		
		form = $('<form method="post" enctype="multipart/form-data"></form>');
		
		var uploadForm = form;
		uploadForm.append($('#'+vars.attachTagId+'_file_btn'));
		
		$('body').append(form);
	
		form.ajaxForm({
			beforeSubmit: function(a,f,o) {
			},
			clearForm: false,
			resetForm: false,
			url:vars.url,
			type:'POST',
			success: function (responseText, statusText, xhr, $form) {
				
				form.unbind('submit').find('input:submit,input:image,button:submit').unbind('click');
				form.detach();
				form.remove();
				
				//var map = $.parseJSON(responseText);
				
				$('#'+vars.attachTagId+'_file_btn').remove();
				cb.remove();
				
				cb = btn.clone();
				if(typeof vars.click==='function'){
					cb.change(function(){vars.click();_this.uploadImage();});
				}
				else{
					cb.change(function(){_this.uploadImage();});
				}
				d.append(cb);
				$('#'+vars.attachTagId+'_file_btn_area').append(cb);
				
				if(typeof vars.success_func==='function'){
					vars.success_func(responseText, vars.userData, statusText, xhr, $form);
				}
				if(typeof vars.final_func==='function'){
					vars.final_func(vars.userData);
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				
				form.detach();
				form.remove();
				if(typeof vars.error_func==='function'){
					vars.error_func(vars.userData, jqXHR, textStatus, errorThrown);
				}
				else{
					alert('File Upload Failed : ' + jqXHR);
				}
				if(typeof vars.final_func==='function'){
					vars.final_func(vars.userData);
				}
			}
		});
		
		form.submit(function(e){
			return false;
		});
		
		form.submit();
	};
}