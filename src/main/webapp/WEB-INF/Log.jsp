<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="javax.websocket.Session"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>AI기반 킥보드 위반 감지 대시보드</title>
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;600;700&display=swap" rel="stylesheet" />
  	<c:url value="/assets/css/MainPage.css" var="mainCss" />
	<c:url value="/assets/css/LogPage.css" var="logCss" />
	<link rel="stylesheet" href="${mainCss}" />
	<link rel="stylesheet" href="${logCss}" />
</head>
<body>
  <div class="container">
    <!-- 상단 헤더 -->
    <header class="header">
      <div class="logo">날아라킥보드</div>
      
      <nav class="nav" aria-label="주요 탭">
      <a href="Main.do">
      	<button class="nav-btn" type="button" >실시간</button>
      </a>
      <a href="Log.do">
      	<button class="nav-btn" type="button" >감지 이력 조회</button>
      </a>  
       
      </nav>
      
      <div class="actions" aria-label="사용자 메뉴">
        <!-- 현재 페이지 표시: aria-current 병행 -->
        <a href="Manager.do">
        	<button class="admin-btn active" type="button" aria-current="page">관리자메뉴</button>
        </a>
        <!-- 규약 통일: 로그아웃 버튼 클래스는 .login-btn 사용 -->
        <a href="logout.do">
        	<button class="login-btn" type="button" data-action="logout">로그아웃</button>
        </a>        
      </div>
    </header>

    <!-- 메인 콘텐츠 -->
    <main class="main-content">
      <section class="map-section" aria-labelledby="mapTitle">
        <h2 id="mapTitle">감지 위치</h2>
        <!--  실제 네이버 지도가 표시될 영역 -->
        <div id="map" style="width:100%; height:500px; border-radius:12px;"></div>
      </section>

      <section class="history-section" aria-labelledby="historyTitle">
        <h2 id="historyTitle">최근 감지 이력</h2>

        <div class="summary-box" role="group" aria-label="감지 요약">
          <div class="summary-card helmet" aria-label="헬멧 미착용 건수">
            <div class="count" id="cntHelmet">0</div>
            <p>헬멧 미착용</p>
          </div>
          <div class="summary-card double" aria-label="2인 탑승 건수">
            <div class="count" id="cntDouble">0</div>
            <p>2인 탑승</p>
          </div>
        </div>

        <ul class="history-list" id="historyList" aria-live="polite">
          <!-- JS에서 li 자동 추가 -->
        </ul>
      </section>
    </main>
  </div>

  <!--  네이버 지도 API (YOUR_CLIENT_ID를 실제 키로 교체하세요) -->
  <script type="text/javascript"
    src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=abcd1234efgh5678ijkl">
  </script>

  <!--  main.js (지도+데이터 로직) -->
  <script src="main.js"></script>
</body>
</html>
