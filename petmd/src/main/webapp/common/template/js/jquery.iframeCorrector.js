window.onload = function() {
   if(($('#base_div',parent.document).height()+"")=="null")
         // 이 페이지가 iframe 내부가 아닌 단독으로 불릴 경우 이 부분을 수행한다.
          $('html').css('height','100%');
   else{
         // 1. 부모 iframe의 높이를 base_div의 높이로 맞춘다.
          $('#parent_iframe',parent.document).css('height', $('#base_div',parent.document).height());
// 2. html의 높이를 base_div의 크기로 맞춘다.
          $('html').css("height",$('#base_div',parent.document).height());
          // 3. body의 높이를 html의 높이와 맞춘다.
          $('body').height($('html').css("height"));
   }
};