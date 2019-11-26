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

            <form:form role="form" commandName="registerRequest"  
            	method="post">
                <div class="form-group has-feedback">
                    <form:input type="text" class="form-control" placeholder="ID" path="id"/>
                    <span class="glyphicon glyphicon-user form-control-feedback"></span>
                    <input type="submit" class="btn btn-danger" formaction="${pageContext.request.contextPath }/register/idcheck" value="가입"/>
                    <form:errors path="id" class="signup-errors"/>
                </div>
                <div class="form-group has-feedback">
                    <form:input type="password" class="form-control" placeholder="PASSWORD" 
                    	path="pw" onkeyup="checkpw()"/>
                    <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                    <form:errors path="pw" class="signup-errors"/>
                </div>
                <div class="form-group has-feedback">
                    <form:input type="password" class="form-control" placeholder="Retype PASSWORD" 
                    	path="checkPw" onkeyup="checkpw2()"/>
                    <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                    <div class="signup-errors" id="pw_check"></div>
                    <form:errors path="checkPw" class="signup-errors"/>
                </div>
                <div class="form-group has-feedback">
                    <form:input type="text" class="form-control" placeholder="NAME" path="name"/>
                    <span class="glyphicon glyphicon-user form-control-feedback"></span>
                    <form:errors path="name" class="signup-errors"/>
                </div>
                <%-- <div class="form-group has-feedback">
                    <form:input type="email" class="form-control" placeholder="EMAIL" path="email"/>
                    <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
                    <form:errors path="email" class="signup-errors"/>
                </div> --%>
                <div class="form-group has-feedback">
                
                    <form:input type="text" placeholder="EMAIL" path="email"/>@
                    <input type="text" id="email2" disabled value="gmail.com"/>
                    <select id="domain">
                    	<option value="gmail.com">gmail.com</option>
                    	<option value="naver.com">naver.com</option>
                    	<option value="daum.net">daum.net</option>
                    	<option value="custom">직접입력</option>
                    </select>
                    <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
                    <form:errors path="email" class="signup-errors"/>
                    
                </div>
                
                <div class="form-group has-feedback">
                <input type="text" id="datepicker" placeholder="BIRTHDAY" class="form-control" readonly/>
                <span class="glyphicon glyphicon-calendar form-control-feedback"></span>
                </div>
                
                <div class="form-group has-feedback">
                	<input type="text" id="postcode" placeholder="우편번호">
                	<input type="button" onclick="execDaumPostcode()" value="우편번호 찾기"><br/>
                	<input type="text" id="address" placeholder="주소"><br/>
                	<input type="text" id="detailAddress" placeholder="상세주소">
                	<input type="text" id="extraAddress" placeholder="참고항목">
                	<span class="glyphicon glyphicon-home form-control-feedback"></span>
                	<div id="wrap" style='display:none; border:1px solid; width:500px; height:300px; margin:5px 0; position:relative'>
                		<img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnFoldWrap"
                			style="cursor:pointer; position:absolute; right:0px; top:-1px; z-index:1" onclick="foldDaumPostcode()" alt="접기 버튼">
                	</div>
                	<div id="map" style="width:300px; height:300px; margin-top:10px; display:none"></div>
                </div>
                
                <%@ include file="/WEB-INF/views/include/yakguan.jsp"%>
                <form:errors path="agree" class="signup-errors"/>
                <div class="row">
                    <div class="col-xs-8">
                    </div>
                    <div class="col-xs-3">
                        <input type="submit" formaction="${pageContext.request.contextPath }/register/step2" value="가입" 
                        	onsubmit="return validate()" class="btn btn-style">
                        <button type="submit" class="btn btn-danger">취소</button>
                    </div>
                </div>
            </form:form>
               
        </div>
         
<script>
	$('#id').focus(function () {
		//alert("1");
		$("span").remove();
	});
		
	//id 중복체크
	function idcheck(){
		var id = $("#id").val();
		alert(id);
		$.ajax({
			url:"${pageContext.request.contextPath }/register/idcheck",
			type: 'POST',
			data: {
				id : id
			},
			success:function(data){
				console.log(data);
				if(data.id == 0){
					alert("ok");
				}else{
					alert("no");
				};
			},
			error:function(request, status, error){
				alert("error: "+error);
			}
		})
	}
	//비밀번호 체크
	function checkpw(){
		var pw = $('#pw').val();
		var pw2 = $('#checkPw').val();
		if(pw==pw2){
			$('#pw_check').empty();
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
	
	//email 선택
 	$('#domain').change(function () {
		$('#domain option:selected').each(function(){
			if($(this).val()=='custom'){
				$('#email2').val('');
				$('#email2').attr('disabled', false);
			}else{
				$('#email2').val($(this).text());
				$('#email2').attr("disabled", true);
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
	
	function validate(){
		//email 결합
		email = $('#email').val();
		email += '@' + $('#email2').val();
		alert(email);
		$('#email').val(email);
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