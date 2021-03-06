<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/views/include/header.jsp"%>
<title>회원가입 페이지</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.0/themes/base/jquery-ui.css" />
<script src="http://code.jquery.com/ui/1.10.0/jquery-ui.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=fd6d3874e394e3eac26c0dbaeda23a61&libraries=services"></script>
</head>
<body class="signup-pages">
	<h1>회원가입</h1>

	<div class="signup-box-body">
            <p class="box-msg">Register a new membership</p>

            <!-- 가입 폼 양식 -->
            <form:form role="form" name="registerForm" modelAttribute="registerRequest" action="${pageContext.request.contextPath }/register/step2" 
            	method="post" onsubmit="return validate()">
                
                <!-- 아이디 -->
                <div class="form-group has-feedback">
                    <form:input type="text" class="form-control" placeholder="아이디는 4~12자의 영문 대소문자와 숫자로만 입력" 
                    	path="id" style="float:left"/>
                    <span class="glyphicon glyphicon-user form-control-feedback"></span>
                    <input type="button" class="btn btn-danger" onclick="idcheck()" value="중복체크"/><br/>
                    <span id="idChecked" style="display:none"></span>
                    <form:errors path="id" id="idError" class="signup-errors"/>
                </div>
                
                <!-- 비밀번호 -->
                <div class="form-group has-feedback">
                    <form:input type="password" class="form-control" placeholder="영문자,숫자,특수문자를 하나이상 포함하여 8~16자" 
                    	path="pw" onkeyup="checkpw()"/>
                    <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                    <div class="signup-errors" id="pw_rule_check"></div>
                    <form:errors path="pw" id="pwError" class="signup-errors"/>
                </div>
                
                <!-- 비밀번호 확인 -->
                <div class="form-group has-feedback">
                    <form:input type="password" class="form-control" placeholder="비밀번호 확인" 
                    	path="checkPw" onkeyup="checkpw2()"/>
                    <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                    <div class="signup-errors" id="pw_check"></div>
                    <form:errors path="checkPw" id="checkPwError" class="signup-errors"/>
                </div>
                
                <!-- 이름 -->
                <div class="form-group has-feedback">
                    <form:input type="text" class="form-control" placeholder="이름" path="name"/>
                    <span class="glyphicon glyphicon-user form-control-feedback"></span>
                    <form:errors path="name" id="nameError" class="signup-errors"/>
                </div>
                
                <!-- 이메일 -->
                <div class="form-group has-feedback">
                    <input type="text" placeholder="EMAIL" id="emailId" class="form-control" style="float:left"/>
                    <input type="text" id="emailDomain" value="@gmail.com" class="form-control" style="float:left" disabled/>
                    <select id="domain" class="form-control" style="width:20%">
                    	<option value="@gmail.com">Gmail</option>
                    	<option value="@naver.com">Naver</option>
                    	<option value="@daum.net">Daum</option>
                    	<option value="custom">직접입력</option>
                    </select>
                    <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
                    <form:errors path="email" id="emailError" class="signup-errors"/>
                    <form:hidden path="email"/>
                </div>
                
                <!-- 생일 -->
                <div class="form-group has-feedback">
                <input type="text" name="birth" id="datepicker" placeholder="생년월일 (클릭)" class="form-control" readonly/>
                <span class="glyphicon glyphicon-calendar form-control-feedback"></span>
                <form:errors path="birth" id="birthError" class="signup-errors"/>
                </div>
                
                <!-- 주소(카카오API) -->
                <div class="form-group has-feedback">
                	<input type="text" id="postcode" name="postcode" placeholder="우편번호" class="form-control" style="float:left">
                	<input type="button" id="postBtn" onclick="execDaumPostcode()" value="우편번호 찾기" class="btn btn-danger">
                	<br/>
                	<form:errors path="postcode" id="postcodeError" class="signup-errors"/>
                	<input type="text" id="address" name="address" placeholder="주소" class="form-control">
                	<form:errors path="address" id="addrError" class="signup-errors"/>
                	<input type="text" id="detailAddress" name="detailAddress" placeholder="상세주소" class="form-control">
                	<form:errors path="detailAddress" id="detailAddrError" class="signup-errors"/>
                	<input type="text" id="extraAddress" name="extraAddress" placeholder="참고항목" class="form-control">
                	<span class="glyphicon glyphicon-home form-control-feedback"></span>
                	<div id="wrap" style='display:none; border:1px solid; width:500px; height:300px; margin:5px 0; position:relative'>
                		<img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnFoldWrap"
                			style="cursor:pointer; position:absolute; right:0px; top:-1px; z-index:1" onclick="foldDaumPostcode()" alt="접기 버튼">
                	</div>
                	<div id="map" style="width:300px; height:300px; margin-top:10px; display:none"></div>
                </div>
                
                <!-- 이용약관 -->
                <%@ include file="/WEB-INF/views/include/yakguan.jsp"%>
                <form:errors path="agree" id="agreeError" class="signup-errors"/>
                <div class="row">
                    <div class="col-xs-8">
                    </div>
                    <div class="col-xs-3">
                        <button type="submit" class="btn btn-style">가입</button>
                        <a class="btn btn-danger" href="${pageContext.request.contextPath }">취소</a>
                    </div>
                </div>
            </form:form>
               
        </div>
         
<script>
	//전역 변수
	//아이디 중복체크 여부
	var isIdChecked = false;
	
	//에러 메시지 지우는 이벤트
	$('#id').focus(function () {
		$('#idError').remove();
	});
	$('#pw').focus(function () {
		$('#pwError').remove();
	});
	$('#checkPw').focus(function () {
		$('#checkPwError').remove();
	});
	$('#name').focus(function () {
		$('#nameError').remove();
	});
	$('#emailId,#domain').focus(function () {
		$('#emailError').remove();
	});
	$("#datepicker").click(function () {
		$('#birthError').remove();
	});
	$('#postBtn').click(function () {
		$('#postcodeError,#addrError').remove();
	});
	$('#detailAddress').focus(function () {
		$('#detailAddrError').remove();
	});
	$('#agree').click(function () {
		$('#agreeError').remove();
	});
	
	//id 중복체크
	function idcheck(){
		var id = $("#id").val();
		$.ajax({
			url:"${pageContext.request.contextPath }/register/idcheck",
			type: 'POST',
			dataType: "json",
			data: {
				id : id
			},
			success:function(data){
				//alert(data);
				if(data == 0){
					$("#idChecked").text("사용가능한 아이디 입니다.").css({
						display: "block",
						color : "blue",
						margin : "10px"
					});
					isIdChecked = true;
					$("#pw").focus();
				}else if(data == 1) {
					$("#idChecked").text("이미 가입된 아이디 입니다.").css({
						display: "block",
						color : "red",
						margin : "10px"
					});
					isIdChecked = false;
					$("#id").focus();
				}else if(data == 2){
					$("#idChecked").text("필수 정보 입니다.").css({
						display: "block",
						color : "red",
						margin : "10px"
					});
					isIdChecked = false;
					$("#id").focus();
				}else if(data = 3){
					$("#idChecked").text("아이디는 4~12자의 영문 대소문자와 숫자로만 입력 가능합니다.").css({
						display: "block",
						color : "red",
						margin : "10px"
					});
					isIdChecked = false;
					$("#id").focus();
				}
			},
			error:function(request, status, error){
				console.log("error: "+error);
			}
		})
	}
	
	//중복체크 후 id 변경 방지
	$('#id').click(function () {
		isIdChecked = false;
		$('#idChecked').hide();
	})
	
	//비밀번호 체크
	function checkpw(){
		var passwordRule = /^(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9])(?=.*[0-9]).{8,16}$/;
		var pw = $('#pw').val();
		var pw2 = $('#checkPw').val();
		
		if(!passwordRule.test(pw)){
			$('#pw_rule_check').html("영문자,숫자,특수문자를 하나이상 포함하여 8~16자로 입력하세요")
		}else if(passwordRule.test(pw)){
			$('#pw_rule_check').empty();
		}
		if(pw==pw2){
			$('#pw_check').empty();
		}else if (pw2 != "" && pw!=pw2){
			$('#pw_check').html("비밀번호가 일치하지 않습니다.");
		}
	}
	function checkpw2(){
		var pw = $('#pw').val();
		var pw2 = $('#checkPw').val();
		if(pw==pw2){
			$('#pw_check').empty();
		}else{
			$('#pw_check').html("비밀번호가 일치하지 않습니다.");
		}
	}
	
	//email 도메인 셀렉트 이벤트
 	$('#domain').change(function () {
		$('#domain option:selected').each(function(){
			if($(this).val()=='custom'){
				$('#emailDomain').val('@');
				$('#emailDomain').attr('disabled', false);
				$('#emailDomain').focus();
			}else{
				$('#emailDomain').val($(this).val());
				$('#emailDomain').attr("disabled", true);
			}
		})
	})
	
	//달력
	$(function() {
      $("#datepicker").datepicker({
          dateFormat:'yy-mm-dd',
          monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
          dayNamesMin:['일','월','화','수','목','금','토'],
          changeMonth:true, // 월변경가능
          changeYear:true,  // 년변경가능
          showMonthAfterYear:true, // 년 뒤에 월표시
          maxDate:"-1d"
      });
     });
	
	//유효성 검사
	function validate(){
		//id 중복 체크 안했으면 alert 띄움
		//alert("중복체크 여부: "+isIdChecked);
		if(!isIdChecked){
			alert("아이디 중복 체크를 해주세요");
			return false;
		}
		
		//email 결합
		//email = $('#emailId').val();
		//email += '@' + $('#emailDomain').val();
		//alert(email);
		//$('#email').val(email);
		var frm = document.registerForm;
		frm.email.value = frm.emailId.value+""+frm.emailDomain.value;
		alert(frm.email.value);
	}
	
 	
</script>

<script>
	var element_wrap = document.getElementById('wrap');
	//var element_wrap = $('#wrap');
	
	function foldDaumPostcode(){
		element_wrap.style.display = 'none';
	}
	
	var mapContainer = document.getElementById('map'),// 지도 표시할 div
		mapOption = {
			center: new daum.maps.LatLng(37.537187, 127.005476),//지도 중심 좌표
			level: 5 //지도 확대 레벨
		};
	
	//지도를 미리 생성
	var map = new daum.maps.Map(mapContainer, mapOption);
	//주소-좌표 변환 객체를 생성
	var geocoder = new daum.maps.services.Geocoder();
	//마커를 미리 생성
	var marker = new daum.maps.Marker({
		position: new daum.maps.LatLng(37.537187, 127.005476),
		map: map
	});
	
	function execDaumPostcode(){
		var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
		new daum.Postcode({
			oncomplete: function (data) {
				//검색결과 항목을 클릭했을때 실행할 코드
				
				//내려오는 변수가 값이 없는 경우엔 공백값을 가지므로, 이를 참고하여 분기
				var addr = '';//주소변수
				var extraAddr = ''; //참고항목 변수
				
				//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
				if(data.userSelectedType === 'R'){//사용자가 도로명 주소를 선택했을 경우
					addr = data.roadAddress;
				}else{//사용자가 지번 주소를 선택했을 경우(J)
					addr = data.jibunAddress;
				}
				
				//사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합
				if(data.userSelectedType === 'R'){
					// 법정동명이 있을 경우 추가(법정리는 제외)
					// 법정동의 경우 마지막 문자가 "동/로/가"로 끝남
					if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
						extraAddr += data.bname;
					}
					// 건물명이 있고, 공동주택일 경우 추가
					if(data.buildingName !== '' && data.apartment === 'Y'){
						extraAddr += (extraAddr !== '' ? ',' + data.buildingName : data.buildingName);
					}
					// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
					if(extraAddr !== ''){
						extraAddr = ' ('+extraAddr+')';
					}
					// 조합된 참고항목을 해당 필드에 넣는다.
					//$('#extraAddress').value(extraAddr);
					document.getElementById('extraAddress').value = extraAddr;
				}else{
					//$('#extraAddress').value('');
					document.getElementById('extraAddress').value = '';
				}
				
				// 우편번호와 주소 정보를 해당 필드에 넣는다.
				//$('#postcode').value(data.zonecode);
				document.getElementById('postcode').value = data.zonecode;
				//$('#address').value(addr);
				document.getElementById('address').value = addr;
				
				//주소로 상세 정보를 검색
				geocoder.addressSearch(data.address, function (results, status) {
					//정상적으로 검색이 완료되면
					if(status === daum.maps.services.Status.OK){
						var result = results[0]; //첫번째 결과의 값을 활용
						
						//해당 주소에 대한 좌표를 받아서
						var coords = new daum.maps.LatLng(result.y, result.x);
						//지도를 보여준다.
						mapContainer.style.display = "block";
						map.relayout();
						//지도 중심을 변경
						map.setCenter(coords);
						//마커를 결과값으로 받은 위치로 옮긴다
						marker.setPosition(coords);
					}
				})
				// 커서를 상세주소 필드로 이동한다.
				//$('#detailAddress').focus();
				document.getElementById('detailAddress').focus();
				
				// iframe을 넣은 element를 안보이게 한다.
				// (autoClose:false 기능을 이용하면 아래코드를 제거해야 화면에서 사라지지 않는다.)
				element_wrap.style.display = 'none';
				
				// 우편번호 찾기 화면이 보이기 이전으로 scroll 위치를 되돌린다.
				document.body.scrollTop = currentScroll;
			},
			// 우편번호 찾기 화면 크기가 조정되었을때 실행할 코드를 작성
			// iframe을 넣은 element의 높이값을 조정
			onresize : function(size){
				element_wrap.style.height = size.height+'px';
			},
			width : '100%',
			height : '100%'
		}).embed(element_wrap);
		
		// iframe을 넣은 element를 보이게 한다.
		element_wrap.style.display = 'block';
	}
</script>


</body>
</html>