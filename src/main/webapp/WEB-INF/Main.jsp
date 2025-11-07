<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>YOLO11 기반 킥보드 위반 감지 대시보드</title>

  <!-- CSS -->
  <link rel="stylesheet" href="${ctx}/assets/css/MainPage.css" />
  <link rel="stylesheet" href="${ctx}/assets/css/ManagerPage.css" /> 
  <link rel="stylesheet" href="${ctx}/assets/css/LogsPage.css" />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;600;700&display=swap" rel="stylesheet" />
</head>

<body data-ctx="${ctx}"> <!-- ✅ contextPath를 body 속성으로 전달 -->

  <div class="container">

    <!-- 상단 헤더 -->
    <header class="header">
      <div class="logo">날아라킥보드</div>
      <nav class="nav" aria-label="주요 탭">
        <a href="${ctx}/Main.do">
          <button class="nav-btn" type="button">실시간</button>
        </a>
        <a href="${ctx}/Logs.do">
          <button class="nav-btn" type="button">감지 이력 조회</button>
        </a>      
      </nav>
      
      <div class="actions" aria-label="사용자 메뉴">
        <a href="${ctx}/Manager.do">
          <button class="admin-btn active" type="button" aria-current="page">관리자 메뉴</button>
        </a>
        <a href="${ctx}/logout.do">
          <button class="login-btn" type="button" data-action="logout">로그아웃</button>
        </a>  
      </div>
    </header>

    <!-- 메인 콘텐츠 -->
    <main class="main-content">
      
      <!-- 지도 영역 -->
      <section class="map-section" aria-labelledby="mapTitle">
        <h2 id="mapTitle">감지 위치</h2>
        <div id="map" style="position:relative; overflow:hidden; width:100%; height:700px; border-radius:12px;"></div>

        <div id="mapLegend" class="map-legend" style="display:none">
          <strong class="legend-title">위반유형</strong>
          <div class="legend-item"><span class="dot helmet"></span> 헬멧 미착용</div>
          <div class="legend-item"><span class="dot double"></span> 2인 이상 탑승</div>
        </div>    
      </section>

      <!-- 최근 감지 이력 -->
      <section class="history-section" aria-labelledby="historyTitle">
        <h2 id="historyTitle">최근 감지 이력</h2>

        <div class="summary-box" role="group" aria-label="감지 요약">
          <div class="summary-card helmet" id="btnHelmet">
            <div class="count" id="cntHelmet">0</div>
            <p>헬멧 미착용</p>
          </div>
          <div class="summary-card double" id="btnDouble">
            <div class="count" id="cntDouble">0</div>
            <p>2인 탑승</p>
          </div>
        </div>

        <ul id="historyList">
          <!-- JS에서 자동으로 li 추가됨 -->
        </ul>
      </section>

    </main>
  </div>

  <!-- ✅ main.js 연결 -->
  <script src="${ctx}/assets/js/Main.js"></script>

</body>
</html>
