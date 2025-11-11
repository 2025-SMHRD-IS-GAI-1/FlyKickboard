<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>AI 기반 킥보드 위반 감지 대시보드</title>

  <!-- ✅ 스타일 -->
  <link rel="stylesheet" href="${ctx}/assets/css/MainPage.css" />
  <link rel="stylesheet" href="${ctx}/assets/css/LogsPage.css" />

  <script>
    window.ctx = "${ctx}";
    window.session = "${login}";
  </script>
</head>

<body data-ctx="${ctx}">
  <div class="container">
    <header class="header">
      <div class="logo">날아라킥보드</div>
      <nav class="nav">
        <a href="${ctx}/Main.do"><button class="nav-btn">실시간</button></a>
        <a href="${ctx}/Logs.do"><button class="nav-btn">감지 이력 조회</button></a>
      </nav>
      <div class="actions">
        <a href="${ctx}/Logout.do"><button class="login-btn">로그아웃</button></a>
      </div>
    </header>

    <main class="main-content">
      <!-- 지도 영역 -->
      <section class="map-section">
        <h2>감지 위치</h2>
        <div id="map" style="width:100%;height:700px;border-radius:12px; position:relative;">
		</div>
      </section>

      <!-- 최근 감지 이력 -->
      <section class="history-section">
        <h2>최근 감지 이력</h2>
        <div class="summary-box">
          <div class="summary-card helmet" id="btnHelmet">
            <div class="count" id="cntHelmet">0</div>
            <p>헬멧 미착용</p>
          </div>
          <div class="summary-card double" id="btnDouble">
            <div class="count" id="cntDouble">0</div>
            <p>2인 탑승</p>
          </div>
        </div>
        <ul id="historyList"></ul>
      </section>
    </main>
  </div>

  <!-- ✅ 네이버 지도 SDK -->
  <script src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=azilk7tpsg"></script>

  <!-- ✅ JS 모듈 로드 -->
  <script type="module" src="${ctx}/assets/js/MapHandler.js"></script>
  <script type="module" src="${ctx}/assets/js/Main.js"></script>
</body>
</html>