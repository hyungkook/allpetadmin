/**
 * @function createElement
 * @author 바람꽃(wndflwr@gmail.com)
 * @param tag : string : DOM 객체의 태그 이름. 비어있을 경우 빈 div 엘리먼트를 리턴한다.
 * @param options : object : DOM 객체의 여러가지 옵션들을 지정한다.
 * @param options.id : string : DOM 객체의 id
 * @param options.cls : [string | array] : DOM 객체의 class를 설정할 수 있다. 여러개의 class를 가지고 있다면 array로 넘기면 됨.
 * @param options.text : string : DOM 객체의 text
 * @param options.attr : object : DOM 객체의 속성을 지정할 수 있다.
 * @param options.css : object : DOM 객체의 style을 지정할 수 있다.
 * @returns jQuery DOM object
 */
//[출처] jQuery | [함수]jQuery 를 이용해 DOM element 생성하는 함수|작성자 바람의꽃 http://blog.naver.com/k_rifle/179102016
function createElement(tag, options) {
	if (!tag) return $('<div />');
	var $elem = $('<' + tag + '/>');
	if (options){
		if (options.id)
			$elem.attr('id', options.id);
		if (options.cls) {
			if (typeof options.cls == 'null' || typeof options.cls == 'undefined') {
				// do nothing
			} else if (typeof options.cls == 'string') {
				$elem.addClass(options.cls);
			} else if (typeof options.cls == 'object') {
				for ( var i in options.cls) {
					$elem.addClass(options.cls[i]);
				}
			}
		}
		if (options.text)
			$elem.text(options.text);
		if (typeof options.attr != 'null' && typeof options.attr == 'object') {
			for (var i in options.attr) {
				$elem.attr(i, options.attr[i]);
			}
		}
		if (typeof options.css != 'null' && typeof options.css == 'object') {
			for (var i in options.css) {
				$elem.css(i, options.css[i]);
			}
		}
	}
	return $elem;
}




function isNoValue(id){
	
	if(typeof id=='string'){return !!$('#'+id)[0] && !$('#'+id).val();}
	else{return !!id[0] && !id.val();}
}

function onOnlyNumber(obj) {
	
	for (var i = 0; i < obj.value.length ; i++){
		chr = obj.value.substr(i,1);
		chr = escape(chr);
		key_eg = chr.charAt(1);
		if (key_eg == "u"){
			key_num = chr.substr(i,(chr.length-1));
			if((key_num < "AC00") || (key_num > "D7A3")) {
				event.returnValue = false;
			}
		}
	}
	if ((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 96 && event.keyCode <= 105)
			||event.keyCode==8||event.keyCode == 9 || event.keyCode == 46 || (event.keyCode >= 37 && event.keyCode < 40)) {
	} else {
		event.returnValue = false;
	}
}

var KEY_CODE_BACK = 8;
var KEY_CODE_TAB = 9;
var KEY_CODE_ARROW_START = 37;
var KEY_CODE_LEFT_ARROW = 37;
var KEY_CODE_UP_ARROW = 38;
var KEY_CODE_RIGHT_ARROW = 39;
var KEY_CODE_DOWN_ARROW = 40;
var KEY_CODE_ARROW_END = 40;
var KEY_CODE_DELETE = 46;
	
function limitInputLength(obj, len){
	
	if($(obj).val().length >= len && event.keyCode!=KEY_CODE_BACK && event.keyCode!=KEY_CODE_TAB && event.keyCode!=KEY_CODE_DELETE && !(event.keyCode>=KEY_CODE_ARROW_START && event.keyCode<=KEY_CODE_ARROW_END)){
		event.returnValue = false;
		return true;
	}
	return false;
}

function validateIncorrectNumber(obj, len_limit){
	
	var result = true;
	
	var price = $(obj).val();
	
	while(true){
		
		result = true;
		
		var len = price.length;
	
		if(len > 1 && price.charAt(0) == '0'){
			price=price.substr(1, len-1);
			result = false;
			continue;
		}
		
		var test = true;
		
		for( var i = 0; i <= len -1 ; i++ )
		 {
		  if(price.charAt(i) < '0' || price.charAt(i) > '9'){
			  test = false;
			  price=(price.substring(0, i)+price.substring(i+1, len));
			  break;
		  }
		 }
		
		if(!test){
			result = false;
			continue;
		}
		
		if(result)
			break;
	}
	
	var len = price.length;
	
	if(len_limit!=null && len > len_limit){
		//alert('자리수는 '+len_limit+'자리까지만 가능합니다.');
		price=(price.substr(1, len_limit));
	}
	$(obj).val(price);
	
	return true;
}

function validateIncorrectPhoneNumber(obj, len_limit){
	
	while(true){
		
		var result = true;
		
		var price = $(obj).val();
		
		var len = price.length;

		var test = true;
		
		for( var i = 0; i <= len -1 ; i++ )
		 {
		  if(price.charAt(i) < '0' || price.charAt(i) > '9'){
			  test = false;
			  $(obj).val($(obj).val().substring(0, i)+$(obj).val().substring(i+1, len));
			  break;
		  }
		 }
		
		if(!test){
			//alert('숫자만 입력하십시오.');
			//return false;
			result = false;
			continue;
		}
		
		if(len > len_limit){
			//alert('자리수는 '+len_limit+'자리까지만 가능합니다.');
			$(obj).val($(obj).val().substr(1, len_limit));
			//return false;
			result = false;
			continue;
		}
		
		if(result)
			break;
	}
	
	return true;
}

function validateNumberMin(obj,min){
	if(parseInt($(obj).val())<min)$(obj).val(min+'');
}

function validateNumberMax(obj,max){
	if(parseInt($(obj).val())>max)$(obj).val(max+'');
}

function setInputConstraint(){
	
	var constraint = arguments[0];
	var id = arguments[1];
	var len = arguments[2];
	
	if(constraint=='numberOnly'){
		$('#'+id).on('keydown',{len:len},function(event){
			onOnlyNumber(this);limitInputLength(this, event.data.len);
		});
		$('#'+id).on('keyup',{len:len},function(event){
			validateIncorrectNumber(this, event.data.len, 0);
		});
		//document.getElementById(id).type='number';
	}
	else if(constraint=='phoneNumber'){
		$('#'+id).on('keydown',{len:len},function(event){
			onOnlyNumber(this);limitInputLength(this, event.data.len);
		});
		$('#'+id).on('keyup',{len:len},function(event){
			validateIncorrectPhoneNumber(this, event.data.len, 0);
		});
		//document.getElementById(id).type='number';
	}
	else if(constraint=='lengthLimit'){
		$('#'+id).on('keydown',{len:len,fun:arguments[3]},function(p){
			if(limitInputLength(this,p.data.len))
				if(typeof p.data.fun==='function')p.data.fun();
		});
	}
};

// 해당 text_tag_id 요소는 white-space:normal 로 강제 조정됨
// $prepend 문자열 앞에 붙는 요소 (img 등)
// $append 문자열 뒤에 붙는 요소 (img 등)
// height_limit를 넘기면 안 된다. 제약조건
// content 입력 문자열
function createEllipse(content, text_tag_id, height_limit, $append, $prepend, ellipse){
	var _ellipse = ellipse;
	if(_ellipse==null)
		_ellipse = "...";
	var $item = $('#'+text_tag_id);
	$item.css('white-space','normal');
	var item_h = height_limit;
	//console.log(item_h);
	var content_len = content.length;
	var start = 0;
	var end = content_len;
	var cur = end;
	
	$item.text(content);
	if($append!=null) $item.append($append);
	if($prepend!=null) $item.prepend($prepend);
	var h = $item.height();
	
	var c = 0;
	
	if(h > item_h){
		cur = Math.floor((end)/2);
		// binary search
		while(true){
			var text = content.substring(0,cur);
			$item.text(text);
			if($append!=null) $item.append($append);
			if($prepend!=null) $item.prepend($prepend);
			h = $item.height();
			c++;
			if(start >= end-1){
				$item.text(text+_ellipse);
				if($append!=null) $item.append($append);
				if($prepend!=null) $item.prepend($prepend);
				h = $item.height();
				break;
			}
			else if(h > item_h){
				end = cur-1;
				cur = Math.floor((end-start)/2+start);
			}
			else{
				start = cur;
				cur = Math.floor((end-start)/2+start);
			}
		}
		for(var i = 1; i < 10; i++){
			c++;
			if(h > item_h){
				$item.text(content.substring(0,cur-i)+_ellipse);
				if($append!=null) $item.append($append);
				if($prepend!=null) $item.prepend($prepend);
				h = $item.height();
			}
			else
				break;
		}
	}
	else{
	}
	//console.log(c);
	if(content_len < 1)
		$item.html('');
}

function parseBool(str){
	if(str=='true')return true;
	else return false;
}

//http://www.webtoolkit.info/javascript-base64.html
var Base64 = {
	// private property
	_keyStr : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
	// public method for encoding
	encode : function (input) {
		var output = "";
		var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
		var i = 0;
		input = Base64._utf8_encode(input);
		while (i < input.length) {
			chr1 = input.charCodeAt(i++);
			chr2 = input.charCodeAt(i++);
			chr3 = input.charCodeAt(i++);
			enc1 = chr1 >> 2;
			enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
			enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
			enc4 = chr3 & 63;
			if (isNaN(chr2)) {
				enc3 = enc4 = 64;
				} else if (isNaN(chr3)) {
					enc4 = 64;
					}
			output = output +
			this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) +
			this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);
			}
		return output;
	},
	// public method for decoding
	decode : function (input) {
		var output = "";
		var chr1, chr2, chr3;
		var enc1, enc2, enc3, enc4;
		var i = 0;
		input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
		while (i < input.length) {
			enc1 = this._keyStr.indexOf(input.charAt(i++));
			enc2 = this._keyStr.indexOf(input.charAt(i++));
			enc3 = this._keyStr.indexOf(input.charAt(i++));
			enc4 = this._keyStr.indexOf(input.charAt(i++));
			chr1 = (enc1 << 2) | (enc2 >> 4);
			chr2 = ((enc2 & 15) << 4) | (enc3 >> 2); 
			chr3 = ((enc3 & 3) << 6) | enc4;
			output = output + String.fromCharCode(chr1);
			if (enc3 != 64) {
				output = output + String.fromCharCode(chr2);
				}
			if (enc4 != 64) {
				output = output + String.fromCharCode(chr3);
				}
			}
		output = Base64._utf8_decode(output);
		return output;
	},
	// private method for UTF-8 encoding
	_utf8_encode : function (string) {
		string = string.replace(/\r\n/g,"\n");
		var utftext = "";
		for (var n = 0; n < string.length; n++) {
			var c = string.charCodeAt(n);
			if (c < 128) {
				utftext += String.fromCharCode(c);
				}
			else if((c > 127) && (c < 2048)) {
				utftext += String.fromCharCode((c >> 6) | 192);
				utftext += String.fromCharCode((c & 63) | 128);
				}
			else {
				utftext += String.fromCharCode((c >> 12) | 224);
				utftext += String.fromCharCode(((c >> 6) & 63) | 128);
				utftext += String.fromCharCode((c & 63) | 128);
				}
			}
		return utftext;
	},
	// private method for UTF-8 decoding
	_utf8_decode : function (utftext) {
		var string = "";
		var i = 0;
		var c = c1 = c2 = 0;
		while ( i < utftext.length ) {
			c = utftext.charCodeAt(i);
			if (c < 128) {
				string += String.fromCharCode(c);
				i++;
				}
			else if((c > 191) && (c < 224)) {
				c2 = utftext.charCodeAt(i+1);
				string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
				i += 2;
				
			}
			else {
				c2 = utftext.charCodeAt(i+1);
				c3 = utftext.charCodeAt(i+2);
				string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
				i += 3;
				}
			}
		return string;
	}
};

//태그생성함수를 jquery에 추가
(function(__jquery){
	
	__jquery.createTagElement=function(tagName,params){
		
		var constants_str = '';
		if(constants_str=='');
		
		if(!(typeof params.constants === 'undefined')){
			for(var con_item in params.constants){
				var con_item1 = con_item;
				for(var i=0; i < con_item.length; i++){
					//console.log((attr_item.charAt(i)+""));
					if((con_item.charAt(i)+"").match(/A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z/)){
						con_item=con_item.substring(0,i)+"-"+con_item.substring(i).toLowerCase();
						//alert(attr_item);
						i++;
					}
				}
				if(con_item=='cls'){alert('1');constants_str=' class="'+params.constants[con_item1]+'"';}
				else{constants_str=' '+con_item+'="'+params.constants[con_item1]+'"';};
			}
		}
		
		var tag = $('<'+tagName+constants_str+'/>');
		
		//tag.attr('aaa-aaa','aaaa');
		
		if(!(typeof params.attrs === 'undefined')){
			for(var attr_item in params.attrs){
				var attr_item1 = attr_item;
				for(var i=0; i < attr_item.length; i++){
					//console.log((attr_item.charAt(i)+""));
					if((attr_item.charAt(i)+"").match(/A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z/)){
						attr_item=attr_item.substring(0,i)+"-"+attr_item.substring(i).toLowerCase();
						//alert(attr_item);
						i++;
					}
				}
				console.log(attr_item);
				if(attr_item=='cls'){tag.attr('class',params.attrs[attr_item1]);}
				else{tag.attr(attr_item,params.attrs[attr_item1]);};
			}
		}
		
		if(!(typeof params.css === 'undefined')){
			for(var css_item in params.css){
				tag.css(css_item,params.css[css_item]);
			}
		}
		
		if(!(typeof params.html === 'undefined')){
			tag.html(params.html);
		}
		
		if(!(typeof params.children === 'undefined')){
			for(var ci=0;ci<params.children.length;ci++){
				tag.append(params.children[ci]);
			}
			tag.trigger('create');
		}
		
		return tag;
	};
}($));

//태그생성함수를 jquery에 추가
(function(__jquery){
	
	__jquery.createElementJson=function(p){
		
		var tag = $("<"+p.tagName+"/>");
		
		for(var attr in p){
			var attr1 = attr;
			if(attr.length>0&&attr.charAt(0)=='_'){
				attr=attr.substring(1);
			}
			for(var i=0; i < attr.length; i++){
				if((attr.charAt(i)+"").match(/A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z/)){
					attr=attr.substring(0,i)+"-"+attr.substring(i).toLowerCase();
					i++;
				}
			}
			if(!(attr=='css'||attr=='tagName'||attr=='children')){
				if(attr=='cls'){tag.attr('class',p[attr1]);}
				else{
					if(attr=='html'){
						tag.html(p[attr1]);
					}
					else if(attr=='text'){
						tag.text(p[attr1]);
					}
					else if(attr=='value'){
						tag.val(p[attr1]);
					}
					else{
						tag.attr(attr,p[attr1]);
					}
				};
			}
		}
		
		if(!(typeof p.css === 'undefined')){
			for(var css_item in p.css){
				tag.css(css_item,p.css[css_item]);
			}
		}
		
		if(!(typeof p.child === 'undefined')){
			tag.append(__jquery.createElementJson(p.child));
		}
		
		if(!(typeof p.children === 'undefined')){
			for(var ci=0;ci<p.children.length;ci++){
				tag.append(__jquery.createElementJson(p.children[ci]));
			}
		}
		
		return tag;
	};
}($));

// jquery 함수 추가
(function($){
	$.pjAjax=function(option){
		$.ajax($.extend({
			type:'POST',
			dataType:'json'
		},option));
	};
}($));