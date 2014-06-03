<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html lang="ko">
<head>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="format-detection" content="telephone=no" />
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
	
	<title>All Pet 동물병원</title>
	
	<style>
		body {font-family:"돋움",Dotum,Arial,Verdana,Geneva,sans-serif;}
		h2{ font-size:18px; margin:20px 0 0px 0; text-align:center; font-weight:bold;}
		h3{ font-size:14px; margin:20px 0 5px 0; text-align:left; font-weight:bold; color:#C00;}
		.table_type {font-size:12px;  border-top:solid 1px #b6b6b6; border-left:solid 1px #b6b6b6; width:100%; font-family:"돋움",Dotum,Arial,Verdana,Geneva,sans-serif;}
		.table_type th{font-size:12px; border-right:solid 1px #b6b6b6; border-bottom:solid 1px #b6b6b6; text-align:left; color:#2e2e2e; background:#ededed; padding:10px; font-weight:bold; line-height:120%;}
		.table_type td{font-size:12px; border-right:solid 1px #b6b6b6; border-bottom:solid 1px #b6b6b6; text-align:center; color:#969696; background:#ffffff; padding:10px; font-weight:bold; line-height:120%; word-break:break-all;}
		a {font-size:12px; color:#969696; text-decoration:none; letter-spacing:-1px; line-height:120%;}
		a:hover {color:#00C;}
		
	</style>
	
</head>
<body>


		<div style="margin:0 15px;">
		
			<h2 style="margin-top:50px;">동물병원</h2>
			
			<h3>마이페이지</h3>
			<table class="table_type" style="">
				<colgroup><col width="50%" /><col width="50%" />
				</colgroup>

				<tr>
					<th>홈</th>
					<td><a href="home.jsp">mypage/home.jsp</a></td>
				</tr>
				<tr>
					<th>로그인</th>
					<td><a href="login.jsp">login.jsp</a></td>
				</tr>
				<tr>
					<th>스케줄목록</th>
					<td><a href="schedule_list.jsp">mypage/schedule_list.jsp</a></td>
				</tr>
				<tr>
					<th>스케줄편집</th>
					<td><a href="schedule_reg.jsp">mypage/schedule_reg.jsp</a></td>
				</tr>
				<tr>
					<th>개인정보수정</th>
					<td><a href="personal_info_edit.jsp">mypage/personal_info_edit.jsp</a></td>
				</tr>
				<tr>
					<th>동물추가</th>
					<td><a href="pet_reg.jsp">mypage/pet_reg.jsp</a></td>
				</tr>
				<tr>
					<th>포인트내역</th>
					<td><a href="point_history.jsp">mypage/point_history.jsp</a></td>
				</tr>
				<tr>
					<th>이용약관</th>
					<td><a href="terms.jsp">mypage/terms.jsp</a></td>
				</tr>
				<tr>
					<th>회원탈퇴</th>
					<td><a href="drop.jsp">mypage/drop.jsp</a></td>
				</tr>
				<tr>
					<th>회원탈퇴완료</th>
					<td><a href="drop_ok.jsp">mypage/drop_ok.jsp</a></td>
				</tr>
				<tr>
					<th>카카오톡팝업</th>
					<td><a href="home_kakao.jsp">mypage/home_kakao.jsp</a></td>
				</tr>
			</table>
			
			
			
			<h3>부</h3>
			<table class="table_type" style="">
				<colgroup><col width="50%" /><col width="50%" />
				</colgroup>
				<tr>
					<th>select list</th>
					<td><a href="select_list.jsp">mypage/select_list.jsp</a></td>
				</tr>
			</table>
		
		</div>

</body>
</html>