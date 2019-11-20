<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="/WEB-INF/include/header.jspf"%>
</head>
<body>
	<div class="panel-body">
		<div class="row">
			<div class="col-lg-12">
				<h4>이용약관</h4>
				<div class="panel-body" style="border: 1px solid #ccc">
					<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.
						Vestibulum tincidunt est vitae ultrices accumsan. Aliquam ornare
						lacus adipiscing, posuere lectus et, fringilla augue. Lorem ipsum
						dolor sit amet, consectetur adipisicing elit, sed do eiusmod
						tempor incididunt ut labore et dolore magna aliqua.</p>
				</div>
				<br/>
				<h4>개인정보</h4>
				<div class="panel-body" style="border: 1px solid #ccc">
					<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.
						Vestibulum tincidunt est vitae ultrices accumsan. Aliquam ornare
						lacus adipiscing, posuere lectus et, fringilla augue. Lorem ipsum
						dolor sit amet, consectetur adipisicing elit, sed do eiusmod
						tempor incididunt ut labore et dolore magna aliqua.</p>
				</div>
				<br />
				<form role="form" action="${pageContext.request.contextPath }/register/step2" method="post">
					<div class="form-group">
						<label class="checkbox-inline"> 
						<input type="checkbox"
							name="agree" value="true">동의합니다.
						</label>
					</div>
					<button type="submit" class="btn btn-default">다음 단계</button>
				</form>
			</div>
		</div>
	</div>
</body>
</html>