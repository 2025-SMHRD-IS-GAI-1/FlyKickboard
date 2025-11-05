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
                    <button class="btn small UpdaBtn" type="button">수정</button>
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
    </main>
  </div>
  <!-- JS 연결 -->
  <script type="text/javascript">
  const logoutBtn = document.querySelector(".login-btn");
  if (logoutBtn) {
    logoutBtn.addEventListener("click", () => {
      alert("로그아웃 되었습니다.");
    });
  }
//2. 사용자 추가 모달
  const addUserBtn = document.getElementById("addUserBtn");
  const userModal = document.getElementById("userModal");

  addUserBtn.addEventListener("click", () => {
    userModal.classList.add("show");
  });

  document.getElementById("cancelUser").addEventListener("click", () => {
    userModal.classList.remove("show");
  });

 
  
//3. 검색 기능
  document.getElementById("searchBtn").addEventListener("click", () => {
    const keyword = document.querySelector(".search-box input").value.trim().toLowerCase();
    const rows = document.querySelectorAll("#userTable tr");

    rows.forEach(row => {
      const text = row.innerText.toLowerCase();
      row.style.display = keyword === "" || text.includes(keyword) ? "" : "none";
    });
  });

//4. 사용자 수정 / 삭제 기능
	const userTable = document.getElementById("userTable");
	
	// userTable(테이블 본문) 영역에 클릭 이벤트 리스너를 추가합니다.
	userTable.addEventListener("click", (event) => {
	
		// 클릭된 요소(event.target)가 "DelBtn" 클래스를 가지고 있는지 확인
		if (event.target.classList.contains("DelBtn")) {
			
			// --- ★★★ 디버깅 코드 ★★★ ---
          // (따옴표 " "가 빠지면 SyntaxError가 발생합니다!)
			console.log("삭제 버튼 클릭됨!"); 
			const row = event.target.closest("tr");
			console.log("찾은 행(tr):", row);
			
			console.log("row.cells[0] 내용:", row.cells[0].textContent);
            console.log("row.cells[1] 내용:", row.cells[1].textContent);
			if (row) { // row를 찾았는지 확인
				const idCell = row.cells[0]; // 첫 번째 셀(td)
				console.log("찾은 ID 셀(td):", idCell);
				
				// innerText 대신 textContent 사용 (공백 제거)
				const id = idCell.textContent.trim(); 
				
				console.log("추출한 ID 값:", id); // ★★★ ID 값이 여기서 찍혀야 합니다 ★★★
				
				if (id) { // ID가 비어있지 않은지 확인
					  if (confirm(`정말로 삭제하시겠습니까?`)) {
						  window.location.href = '${ctx}/Delete.do?id=' + encodeURIComponent(id);
					  }
				} else {
					alert("ID를 찾을 수 없습니다. (콘솔 확인)");
				}
			} else {
				alert("테이블 행(tr)을 찾지 못했습니다.");
			}
		}
		
		if (event.target.classList.contains("UpdaBtn")) {
			console.log("수정 버튼");
			const row = event.target.colsest("tr");
			if (row) {
				const
			}
		}

		// (추후 수정 기능도 여기에 추가)
		// if (event.target.classList.contains("UpdaBtn")) {
		//     // 수정 로직...
		// }
	});
  </script>
</body>
</html>
window.location.href = `Delete.do?id=${id}`; 내생각엔 이게 문제야 