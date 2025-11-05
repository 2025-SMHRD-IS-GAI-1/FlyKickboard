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
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;600;700;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${ctx}/assets/css/MainPage.css" /> <!-- 공통 헤더 -->
  <link rel="stylesheet" href="${ctx}/assets/css/ManagerPage.css" /> <!-- 관리자 메뉴 전용 -->
</head>

<body>
  <div class="container">
    <!-- 상단바 -->
    <header class="topbar">
      <div class="brand">날아라킥보드</div>
      <nav class="nav" aria-label="주요 탭">
        <a href="Main.do">
      		<button class="nav-btn" type="button">실시간</button>
      	</a>
      	<a href="Log.do">
      		<button class="nav-btn" type="button">감지 이력 조회</button>
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

  <!-- 본문 -->
    <main class="main-content">
      <section class="system-section" aria-labelledby="adminTitle">
        <h2 id="adminTitle">관리자 메뉴</h2>

        <!-- 사용자 추가 + 검색 -->
        <div class="actions-bar">
        <a>
        	<button class="btn primary" id="addUserBtn" type="button">사용자 추가</button>
        </a>
		
		<!-- 사용자 검색  -->
		<div class="search-box">
		<!--
		 searchKeyword => 사용자 검색
		 searchBtn => 검색 버튼
		 keyword => 서버로 보낼 내용
		 --> 
			
          <input type="text" placeholder="검색어 입력" id="keyword" name="keyword"/> 
          <button class="btn small" type="submit" id="searchBtn" >검색</button>
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
(function(){
  const ctx = '${ctx}';

  // 로그아웃 알림
  const logoutBtn = document.querySelector(".login-btn");
  if (logoutBtn) logoutBtn.addEventListener("click", () => alert("로그아웃 되었습니다."));

  // 추가 모달 열기/닫기
  const addUserBtn = document.getElementById("addUserBtn");
  const userModal = document.getElementById("userModal");
  const cancelUser = document.getElementById("cancelUser");
  if (addUserBtn && userModal) addUserBtn.addEventListener("click", () => userModal.classList.add("show"));
  if (cancelUser && userModal) cancelUser.addEventListener("click", () => userModal.classList.remove("show"));

  // 수정 모달 요소
  const upModal = document.getElementById("upModal");
  const editHiddenInput = document.querySelector("#upModal input[name='id']");
  const editPwInput = document.querySelector("#upModal input[name='UpPw']");
  const editAreaInput = document.querySelector("#upModal input[name='UpArea']");
  const cancelUpUser = document.getElementById("CancelUser");
  if (cancelUpUser && upModal) cancelUpUser.addEventListener("click", () => upModal.classList.remove("show"));

//✅ 검색 + 페이지네이션 변수
  const searchBtn = document.getElementById("searchBtn");
  const tableBody = document.getElementById("userTable");
  const prevBtn = document.querySelector(".page-btn.prev");
  const nextBtn = document.querySelector(".page-btn.next");
  const pageNo = document.querySelector(".page-no");

  let allData = [];       // ✅ 항상 allData 로 고정
  let currentPage = 1;
  const pageSize = 10;

  // ✅ 테이블 출력 함수
  function renderTable(page = 1) {
    tableBody.innerHTML = "";

    const start = (page - 1) * pageSize;
    const end = start + pageSize;
    const pageData = allData.slice(start, end);

    if (!pageData.length) {
      tableBody.innerHTML = `<tr><td colspan="3">검색 결과가 없습니다.</td></tr>`;
      return;
    }

    pageData.forEach(member => {
      const row = document.createElement("tr");
      row.innerHTML = `
        <td>\${member.id}</td>
        <td>\${member.area}</td>
        <td>
          <button class="btn small UpdaBtn" type="button">수정</button>
          <button class="btn small danger DelBtn" type="button">삭제</button>
        </td>
      `;
      tableBody.appendChild(row);
    });

    pageNo.textContent = page;
  }

  // ✅ 검색 기능
  if (searchBtn) {
    searchBtn.addEventListener("click", () => {
      const keyword = document.getElementById("keyword").value.trim();
      if (keyword === "") return;

      fetch("Search.do?keyword=" + encodeURIComponent(keyword))
        .then(res => res.json())
        .then(result => {
          console.log("검색 결과:", result);

          allData = result;      // ✅ 데이터 저장
          currentPage = 1;
          renderTable(currentPage);
        })
        .catch(err => console.error("에러 발생:", err));
    });
  }

  // ✅ 이전 / 다음 버튼
  if (prevBtn) {
    prevBtn.addEventListener("click", () => {
      if (currentPage > 1) {
        currentPage--;
        renderTable(currentPage);
      }
    });
  }

  if (nextBtn) {
    nextBtn.addEventListener("click", () => {
      const maxPage = Math.ceil(allData.length / pageSize);
      if (currentPage < maxPage) {
        currentPage++;
        renderTable(currentPage);
      }
    });
  }

  // 삭제 & 수정 이벤트 위임
  const userTable = document.getElementById("userTable");
  if (!userTable) return;

  userTable.addEventListener("click", function(event) {
    const target = event.target;

    // 삭제 버튼
    if (target.classList.contains("DelBtn")) {
      const row = target.closest("tr");
      const id = row.cells[0].textContent.trim();
      if (!id) { alert("ID를 찾을 수 없습니다."); return; }
      if (confirm(`정말로 삭제하시겠습니까?`)) {
        window.location.href = ctx + '/Delete.do?id=' + encodeURIComponent(id);
      }
      return;
    }

    // 수정 버튼
    if (target.classList.contains("UpdaBtn")) {
      const row = target.closest("tr");
      const id = row.cells[0].textContent.trim();
      const area = row.cells[1].textContent.trim();
	  
      // 아이디 불일치시
      if (!id) { alert("ID를 찾을 수 없습니다."); return; }

      editHiddenInput.value = id;
      editPwInput.value = "";
      editAreaInput.value = "";

      if (upModal) upModal.classList.add("show");
      return;
    }
  });

})();
</script>
</body>
</html>