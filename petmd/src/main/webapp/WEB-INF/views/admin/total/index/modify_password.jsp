<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<script>
	function changePass() {
		document.getElementById("form").action="accept_modify_password.latte";
		document.getElementById("form").submit();
	}
</script>

<form id="form" name="form" method="post">
<p class="mt05">통합관리자 사이트의 비밀번호는 각종 관리 정보들로 인하여 각별한 보안관리가 필요합니다.</p>
<p class="mt05">따라서 비밀번호는 담당자 이외 다른 사람에게 노출되지 않도록 하여 주시고, 월 단위 비밀번호 변경을 권장합니다.</p>
<p class="ex12 mt05">* 초기 할당된 비밀번호는 아이디와 동일합니다.</p>
<table cellpadding="0" border="0" cellspacing="0" class="table_edit">
 <colgroup>
        <col width="25%" /><col width="75%" />
    </colgroup>
    <tr>
    	<th>
    		<p class="mt15"> 기존 비밀번호</p>
    		<p class="mt15"> 새 비밀번호</p>
    		<p class="mt15"> 새 비밀번호 재입력</p>
    	</th>
    	<td>
			<p><input class="txt mt12" type="password" style="width:200px;"name="s_password" /></p>
			<p><input class="txt mt12" type="password" style="width:200px;"name="s_password" /></p>
			<p><input class="txt mt12" type="password" style="width:200px;"name="s_password" /></p>
		</td>
	</tr>
</table>
<div class="btn_c"><a class="blueGreen" style="padding-left:20px; padding-right:20px;cursor:pointer;"onclick="changePass()">비밀번호 저장</a></div>		
</form>