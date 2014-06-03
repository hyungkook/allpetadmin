<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<!DOCTYPE>
<html>
<head>
<head>

<jsp:include page="/WEB-INF/views/admin/total/include/INC_JSP_HEADER.jsp"/>
		
</head>
<script type="text/javascript">
	window.onload = function ()
	{
		document.getElementById("dong_Input").focus();	
	};
	function cancle(){
		window.close();
	}

	function selectZipCode(iaddr) {
		var addr = iaddr.split('|');
		var code = addr[0];
		var sido = addr[1];
		var gugun = addr[2];
		var dong = addr[3];
		var ri = addr[4];
		var bldg = addr[5];
		opener.document.getElementById("old_zipcode").value=code;
		opener.document.getElementById("old_addr_sido").value=sido;
		opener.document.getElementById("old_addr_sigungu").value=gugun;
		opener.document.getElementById("old_addr_dong").value=dong;
		opener.document.getElementById("old_zipcode_1").value=code.substring(0,3);
		opener.document.getElementById("old_zipcode_2").value=code.substring(4,7);
		
		opener.document.getElementById("old_addr").value=sido +' '+ gugun+' ' + dong;
		//opener.document.getElementById("s_addr_ri").value=ri;
		
		opener.document.getElementById("old_addr_etc").value = bldg;
		/* var param = "s_addr_sido=" + sido;
		param += "&s_addr_gugun=" + gugun;
		param += "&s_addr_dong=" + dong;
		param += "&s_addr_ri=" + ri;
		param += "&s_addr_etc=" + bldg;
		var result = getAjaxPost("getLocation", param);
		if (result != '') {
			opener.document.getElementById("n_latitude").value = result.split('|')[0];
			opener.document.getElementById("n_longitude").value = result.split('|')[1];
		} */
		
		window.close();
	}
	
	function searchAddress() {
		document.form.action = "getAddressZipcode.latte";
		document.form.submit();
	}
	
</script>
<body>
<!-- width:355px; height:546px; -->
<div id="pop355">
   <div class="pop_head">
       우편번호 검색
       <a class="btn" style="cursor:pointer;" onclick="cancle()"><img src="${con.IMGPATH_OLD}/btn/btn_close.gif" /></a>
   </div>
   <div class="pop_contents" style="padding-top:20px; height:467px;">
   <div class="address">
           <p>'동(읍/면/리)' 지역명을 입력해 주세요.</p>
		   <form id="form" name="form" method="post" >
           		<p class="mt05">
           			<input type="text" class="txt" style="width:243px;"  id="dong_Input" name="dong_Input" value="${dong}" />
           			<a class="black01" style="cursor:pointer;" onClick="searchAddress()">검색</a>
           		</p>
           </form>
          <div id="textView">
          <p class="mt20"><span class="ex12"></span> </p>
   			</div>
           <table cellpadding="0" border="0" cellspacing="0" class="pop_list">
               <colgroup>
                    <col width="75%" /><col width="25%" />
               </colgroup>
               <tr>
                   <th class="bgn">주소</th>
                   <th>우편번호</th>
               </tr>
           </table>
           
           <div id="dongList" class="scroll">
           		<c:set var="rownum" value="${fn:length(zipCodeList)}"></c:set>	
	<c:if test="${rownum > 0}">
	<table>
		<colgroup>
        	<col width="200px" /><col width="50px" />
        </colgroup>
		<c:forEach items="${zipCodeList }" var="list" varStatus="c">
		<tr>
			<td class="bgn">
				<a style="cursor:pointer;" onClick="selectZipCode('${list.s_zipcode}|${list.s_sido}|${list.s_gugun}|${list.s_dong}|${list.s_ri}|${list.s_bldg}')">
					${list.s_sido} ${list.s_gugun} ${list.s_dong} ${list.s_ri} ${list.s_bldg} ${list.s_bunji}
				</a>
			</td>
			<td class="">${list.s_zipcode}</td>
		</tr>
		</c:forEach>
	</table>
	</c:if>
	<c:if test="${rownum == 0}">
	<table cellpadding="0" border="0" cellspacing="0" class="pop_list">
    	<colgroup>
        <col width="100%" />
    </colgroup>
    	<tr>
        	<td class="bgn s_no">검색된 <span class="red12">우편번호가 없습니다.</span><br />검색어를 다시 확인해주세요.</td>
        </tr>
    </table>
	</c:if>
           </div>
       </div>
       <p class="mt05 text_gray12 pl20">선택을 하시려면 해당 결과를 클릭해 주세요.</p>
       <p class="mt20 center"><a style="cursor:pointer;" onclick="cancle()" class="black01">닫기</a></p>
   </div>
</div>
</body>
</html>