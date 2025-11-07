<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="javax.websocket.Session"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>  
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>YOLO11 기반 공유 킥보드 헬멧미착용·2인탑승 자동 인식 시스템 - 로그인</title>

  <!-- 웹폰트 (선택) -->
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;600;700;900&display=swap" rel="stylesheet">

  <!-- 외부 CSS 연결 -->
  <link rel="stylesheet" href="${ctx}/assets/css/LoginPage.css">
</head>
<body>
  <div class="wrapper">
    <h1 class="hero">YOLO11 기반 공유 킥보드 헬멧미착용·2인탑승 자동 인식 시스템</h1>


    <main class="card" role="main" aria-labelledby="loginTitle">
      <form action="Login.do" method="post" autocomplete="on">
        <div class="form-row">
          <input class="input user" type="text" id="id" name="id"
                 placeholder="아이디" inputmode="email" autocomplete="username" />
        </div>
        <div class="form-row">
          <input class="input lock" type="password" id="pw" name="pw"
                 placeholder="비밀번호" autocomplete="current-password" />
        </div>

        <label class="checkbox" for="rememberId">
          <input type="checkbox" id="rememberId" name="rememberId" value="Y" />
          아이디 저장
        </label>
        
        <button class="button" type="submit" id="loginBtn">로그인</button>
        
      </form>

      <div class="version" aria-hidden="true">ver 1.0.0</div>
    </main>
    <script src="Login.js"></script>
  </div>
</body>
</html>
