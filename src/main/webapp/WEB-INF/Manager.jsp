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
  <link rel="stylesheet" href="${ctx}/assets/css/MainPage.css" />
  <link rel="stylesheet" href="${ctx}/assets/css/ManagerPage.css" />
  <link rel="stylesheet" href="${ctx}/assets/css/LogsPage.css" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;600;700&display=swap" rel="stylesheet" />
</head>
<body>
  <!-- 상단바 -->
  <header class="header">
    <div class="logo">날아라킥보드</div>
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
  <script type="text/javascript">
//✅ 검색 + 페이지네이션 변수
  const searchBtn = document.getElementById("searchBtn");
  const tableBody = document.getElementById("userTable");
  const prevBtn = document.querySelector(".page-btn.prev");
  const nextBtn = document.querySelector(".page-btn.next");
  const pageNo = document.querySelector(".page-no");
  const searchInput = document.getElementById("searchInput");

  let allData = [];     // 서버에서 받은 전체 사용자 데이터
  let currentPage = 1;
  const pageSize = 10;  // 한 페이지당 표시할 개수

  // ✅ 테이블 렌더링 함수
  function renderTable(page = 1) {
    tableBody.innerHTML = "";

    const start = (page - 1) * pageSize;
    const end = start + pageSize;
    const pageData = allData.slice(start, end);

    if (pageData.length === 0) {
      tableBody.innerHTML = `<tr><td colspan="3">검색 결과가 없습니다.</td></tr>`;
      return;
    }

    pageData.forEach(member => {
      const row = document.createElement("tr");
      row.innerHTML = `
        <td>${member.id}</td>
        <td>${member.area}</td>
        <td>
          <button class="btn small UpdaBtn" type="button" data-id="${member.id}">수정</button>
          <button class="btn small danger DelBtn" type="button" data-id="${member.id}">삭제</button>
        </td>
      `;
      tableBody.appendChild(row);
    });

    pageNo.textContent = page;

    bindRowEvents(); // ✅ 버튼 이벤트 바인딩
  }

  // ✅ 검색 기능 (서버 요청)
  searchBtn.addEventListener("click", () => {
    const keyword = searchInput.value.trim();

    fetch("SearchUser.do", { // Controller 매핑 이름
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ keyword })
    })
    .then(res => res.json())
    .then(data => {
      allData = data;   // ✅ 검색 결과 저장
      currentPage = 1;  // 페이지 초기화
      renderTable(currentPage);
    });
  });

  // ✅ 페이지네이션 버튼
  prevBtn.addEventListener("click", () => {
    if (currentPage > 1) {
      currentPage--;
      renderTable(currentPage);
    }
  });

  nextBtn.addEventListener("click", () => {
    if (currentPage * pageSize < allData.length) {
      currentPage++;
      renderTable(currentPage);
    }
  });

  // ✅ 수정 / 삭제 버튼 이벤트 바인딩
  function bindRowEvents() {

    // 🔹 수정 버튼
    document.querySelectorAll(".UpdaBtn").forEach(btn => {
      btn.addEventListener("click", () => {
        const id = btn.getAttribute("data-id");
        window.location.href = `UpdateUser.do?id=${id}`;
      });
    });

    // 🔹 삭제 버튼
    document.querySelectorAll(".DelBtn").forEach(btn => {
      btn.addEventListener("click", () => {
        const id = btn.getAttribute("data-id");

        if (!confirm(id + " 사용자를 삭제하시겠습니까?")) return;

        fetch("DeleteUser.do?id=" + id)
          .then(res => res.text())
          .then(msg => {
            alert(msg);
            searchBtn.click(); // 리스트 재조회
          });
      });
    });

  }
</script>
</body>
</html>