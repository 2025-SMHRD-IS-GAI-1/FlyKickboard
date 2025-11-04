<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="javax.websocket.Session"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>관리자 메뉴 - 날아라킥보드</title>

  <!-- 공통 폰트 및 스타일 -->
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;600;700&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="main.css" /> <!-- 공통 헤더 -->
  <link rel="stylesheet" href="system.css" /> <!-- 관리자 메뉴 전용 -->
</head>

<body>
  <div class="container">

    <!-- 상단 헤더 -->
    <header class="header">
      <div class="logo">날아라킥보드</div>

      <nav class="nav" aria-label="주요 탭">
        <button class="nav-btn" type="button" data-route="main.html">실시간</button>
        <button class="nav-btn" type="button" data-route="logs.html">감지 이력 조회</button>
      </nav>

      <div class="actions" aria-label="사용자 메뉴">
        <!-- 현재 페이지 표시: aria-current 병행 -->
        <button class="admin-btn active" type="button" data-route="system.html" aria-current="page">
          관리자 메뉴
        </button>
        <!-- 규약 통일: 로그아웃 버튼 클래스는 .login-btn 사용 -->
        <button class="login-btn" type="button" data-action="logout">로그아웃</button>
      </div>
    </header>

    <!-- 본문 -->
    <main class="main-content">
      <section class="system-section" aria-labelledby="adminTitle">
        <h2 id="adminTitle">관리자 메뉴</h2>

        <!-- 사용자 추가 + 검색 -->
        <div class="actions-bar">
          <button class="btn primary" id="addUserBtn" type="button">사용자 추가</button>
          <div class="search-box">
            <input type="text" placeholder="검색어 입력" />
            <button class="btn small" type="button" id="searchBtn">검색</button>
          </div>
        </div>

        <!-- 관리자 테이블 -->
        <table class="admin-table" aria-label="관리자 테이블">
          <thead>
            <tr>
              <th>ID</th>
              <th>지역</th>
              <th>수정 / 삭제</th>
            </tr>
          </thead>
          <tbody id="userTable">
          </tbody>
        </table>

        <!-- 페이지네이션 -->
        <div class="pagination">
          <button class="page-btn prev">이전</button>
          <span class="page-no">1</span>
          <button class="page-btn next">다음</button>
        </div>
      </section>

      <!-- 사용자 추가 모달 -->
      <div class="modal" id="userModal">
        <div class="modal-content">
          <h3>사용자 추가</h3>
          <label>아이디 <input type="text" id="newId" /></label>
          <label>비밀번호 <input type="password" id="newpw" /></label>
          <label>지역 <input type="text" id="newRegion" /></label>
        
          <div class="modal-actions">
            <button id="saveUser" class="btn primary">등록</button>
            <button id="cancelUser" class="btn">취소</button>
          </div>
        </div>
      </div>
    </main>
  </div>

  <!-- JS 연결 -->
  <script src="system.js"></script>
</body>
</html>

window.location.href = `Delete.do?id=${id}`; 내생각엔 이게 문제야 