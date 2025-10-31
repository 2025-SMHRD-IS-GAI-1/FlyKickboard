<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="javax.websocket.Session"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>AI기반 킥보드 위반 감지 대시보드</title>
  <link rel="stylesheet" href="${ctx}/assets/css/MainPage.css" />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;600;700&display=swap" rel="stylesheet" />
</head>
<body>
  <div class="container">
    <!-- 헤더 -->
    <header class="header">
      <div class="logo">날아라킥보드</div>
      <nav class="nav">
        <button id="livebutton" class="nav-btn active">실시간</button>
        <a href="find.do">
        	<button class="nav-btn">감지 이력 조회</button>
        </a>
      </nav>
      <button class="admin-btn">관리자 메뉴</button>
      <a href="logout.do">
      	<button class="login-btn">로그아웃</button>
      </a>
      
    </header>

    <!-- 메인 콘텐츠 -->
    <main class="main-content">
      <!-- 감지 위치 -->
      <section class="map-section">
        <h2>감지 위치</h2>
        <div class="map-box">
          <img src="https://i.imgur.com/FKX3v5T.png" alt="지도 이미지 예시" class="map-img" />
        </div>
      </section>

      <!-- 최근 감지 이력 -->
      <section class="history-section">
        <h2>최근 감지 이력</h2>
        <div class="summary-box">
          <div class="summary-card helmet">
            <div class="count"></div>
            <p><br><span></span></p>
          </div>
          <div class="summary-card double">
            <div class="count"></div>
            <p><br><span></span>
          </div>
        </div>

        <ul class="history-list">

          <li>
            <span class="dot helmet"></span>
            <span class="region"></span>
            <span class="time"></span>
          </li>
        </ul>
      </section>
    </main>
  </div>
</body>
</html>
