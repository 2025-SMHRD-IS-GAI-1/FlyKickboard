<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="javax.websocket.Session"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>관리자 메뉴</title>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;600;700;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${ctx}/assets/css/MainPage.css" />
  <link rel="stylesheet" href="${ctx}/assets/css/ManagerPage.css" />
  <link rel="stylesheet" href="${ctx}/assets/css/LogsPage.css" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
</head>
<body>
  <!-- 상단바 -->
  <header class="header">
    <div class="brand">날아라킥보드</div>
    <nav class="nav" aria-label="주요 탭">
        <a href="Main.do">
            <button class="nav-btn" type="button">실시간</button>
         </a>
         <a href="Logs.do">
            <button class="nav-btn" type="button">감지 이력 조회</button>
         </a> 
      </nav>
      
    <div class="actions" aria-label="사용자 메뉴">
        <!-- 현재 페이지 표시: aria-current 병행 -->
        <a href="Manager.do">
           <button class="admin-btn active" type="button" aria-current="page">관리자 메뉴</button>
        </a>
        <!-- 규약 통일: 로그아웃 버튼 클래스는 .login-btn 사용 -->
        <a href="logout.do">
           <button class="login-btn" type="button" data-action="logout">로그아웃</button>
        </a>        
      </div>
    
  </header>

  <!-- 본문 -->
    <main class="main-content">
      <section class="system-section" aria-labelledby="adminTitle">
        <h2 id="adminTitle">관리자 메뉴</h2>

        <!-- 사용자 추가 + 검색 -->
        <div class="actions-bar">
        <a>
           <button class="btn primary" id="addUserBtn" type="button">사용자 추가</button>
        </a>

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
            <c:forEach var="member" items="${allmanager}">
            <tr>
               <td>${member.id}</td> <td>${member.area}</td>
                <td>
                    <button class="btn small UpdaBtn" type="button" id="UpdateBtn">수정</button>
                    <button class="btn small danger DelBtn" type="button">삭제</button>
                </td>
            </tr>
            </c:forEach>
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
       <form action="Join.do" method="post">
            <label>아이디 <input type="text" name="newId" /></label>
            <label>비밀번호 <input type="password" name="newPw" /></label>
            <label>지역 <input type="text" name="newArea" /></label>
            <div class="modal-actions">
              <button id="saveUser" class="btn primary" type="submit">등록</button>
              <button id="cancelUser" class="btn" type="button">취소</button>
            </div>
         </form>
        </div>
      </div>
      <div class="modal" id="upModal">
        <div class="modal-content">
       <h3>사용자 수정</h3>
       <form action="${ctx}/Update.do" method="post">
        <input type="hidden" name="id" />
        <label>비밀번호 <input type="password" name="UpPw" /></label>
        <label>지역 <input type="text" name="UpArea" /></label>
        <button type="submit" class="btn primary">수정</button>
        <button id="CancelUser" class="btn" type="button">취소</button>
      </form>
        </div>
      </div>
    </main>
  </div>
  <!-- JS 연결 -->
  <script src="${ctx}/assets/js/Manager.js"></script>
</body>
</html>