<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="javax.websocket.Session"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <title>감지 이력 조회 - 날아라킥보드</title>
  <link rel="stylesheet" href="${ctx}/assets/css/MainPage.css" />
  <link rel="stylesheet" href="${ctx}/assets/css/ManagerPage.css" /> 
  <link rel="stylesheet" href="${ctx}/assets/css/LogsPage.css" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;600;700&display=swap" rel="stylesheet" />
</head>

  
<body>
  <div class="container">
    <!-- 상단 헤더 -->
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
      <a href="Manager.do">
      	<button class="admin-btn active" type="button" aria-current="page">관리자 메뉴</button>
      </a>
      <a href="Logout.do">
      	<button class="login-btn" type="button" data-action="logout">로그아웃</button>
      </a>
        
      </div>
    </header>

    <!-- 본문 -->
    <main class="main-content" role="main">
      <section class="logs-section" aria-labelledby="logsTitle">
        <h2 id="logsTitle">감지 이력 조회</h2>
        <div class="toolbar">
  <div class="toolbar-left">
    <!-- 날짜 + 검색 -->
    <label><input type="date" id="startDate" /></label>
    <span>~</span>
    <label><input type="date" id="endDate" /></label>
    <button class="btn-search" type="button">검색</button>

    <!-- 분류 버튼 + 필터패널 -->
    <div class="filter-wrapper">
      <button class="btn-filter" id="btnFilter" type="button">분류</button>
      <div class="filter-panel" id="filterPanel" role="dialog" aria-label="분류 필터">
        <div class="filter-group">
          <span class="filter-label">상태</span>
          <button class="filter-option">전체</button>
          <button class="filter-option">처리전</button>
          <button class="filter-option">처리중</button>
          <button class="filter-option">처리완료</button>
        </div>
        <div class="filter-group">
          <span class="filter-label">감지 유형</span>
          <button class="filter-option">전체</button>
          <button class="filter-option">2인 탑승</button>
          <button class="filter-option">헬멧 미착용</button>
        </div>
      </div>
    </div>
  </div>


        <!-- 동작기능 버튼 -->
  <div class="toolbar-right">
    <button type="button" class="btn blue" id="btnSend">전송</button>
    <button type="button" class="btn blue" id="btnPr">출력</button>
    <button type="button" class="btn red" id="btnDel">삭제</button>
  </div>
</div>




      <!-- 감지이력 테이블 -->
      <table class="logs-table" aria-label="감지 이력 테이블">
    <thead>
       <tr>
      <th scope="col">
        <input type="checkbox" id="checkAll" aria-label="전체 선택" />
      </th>
      <th scope="col">날짜</th>
      <th scope="col">위치</th>
      <th scope="col">감지 유형</th>
      <th scope="col">상태</th>
    </tr>
      </thead>
      <tbody id="LogTable">
      <c:forEach var="log" items="${alllog}">
		  <tr data-id="${log.det_id}">
		    <td><input type="checkbox" /></td>
		    <td>${log.date}</td>
		    <td>${log.loc}</td>
		    <td>${log.type}</td>
		    <td>${log.prog}</td>
		  </tr>
	  </c:forEach>     
      </tbody>
      </table>


           <!-- 통계 박스 -->
        <div class="stats-box" aria-label="이력 통계">
        <div class="stat-item total">
        <span class="label">총 감지 건수</span>
        <span class="value" id="totalCount">-</span>
        </div>
        <div class="stat-item pending">
        <span class="label">처리전</span>
        <span class="value" id="pendingCount">-</span>
        </div>
        <div class="stat-item progress">
        <span class="label">처리중</span>
        <span class="value" id="progressCount">-</span>
        </div>
        <div class="stat-item complete">
        <span class="label">처리완료</span>
        <span class="value" id="completeCount">-</span>
        </div>
        </div>


        <!-- 페이지 이동 -->
        <div class="pagination" role="navigation" aria-label="페이지네이션">
          <button class="page-btn prev" type="button">이전</button>
          <span class="page-no" aria-live="polite">1</span>
          <button class="page-btn next" type="button">다음</button>
        </div>

      </section>
    </main>
  </div>

<script type="text/javascript">

// ==============================
// 로그아웃 알림
// ==============================
const logoutBtn = document.querySelector(".login-btn");
if (logoutBtn) logoutBtn.addEventListener("click", () => alert("로그아웃 되었습니다."));


// ==============================
// 체크된 행 데이터 가져오기 (삭제에 사용)
// ==============================
function getCheckedRows() {
  const checked = document.querySelectorAll("#LogTable input[type='checkbox']:checked");
  let selected = [];

  checked.forEach(chk => {
    const row = chk.closest("tr");
    selected.push({ id: row.dataset.id });
  });

  return selected;
}

// 삭제 버튼 이벤트
document.getElementById("btnDel").addEventListener("click", () => {
  const rows = getCheckedRows();
  if (rows.length === 0) return alert("삭제할 항목을 선택하세요.");
  if (!confirm("정말 삭제하시겠습니까?")) return;

  fetch("DeleteLog.do", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(rows.map(r => Number(r.id)))
  })
  .then(res => res.text())
  .then(msg => {
    alert(msg);
    location.reload();
  });
});


// ==============================
// ✅ 페이징 처리
// ==============================
const tableBody = document.getElementById("LogTable");
const prevBtn = document.querySelector(".page-btn.prev");
const nextBtn = document.querySelector(".page-btn.next");
const pageNo = document.querySelector(".page-no");

// ✅ 서버에서 출력된 HTML → JS 배열로 변환
let allData = Array.from(document.querySelectorAll("#LogTable tr")).map(row => ({
  id: row.dataset.id,
  date: row.cells[1].textContent.trim(),
  loc: row.cells[2].textContent.trim(),
  type: row.cells[3].textContent.trim(),
  prog: row.cells[4].textContent.trim()
}));

let currentPage = 1;
const pageSize = 10;


// ✅ 테이블 렌더링 함수
function renderTable(page = 1) {
  tableBody.innerHTML = "";

  const start = (page - 1) * pageSize;
  const end = start + pageSize;
  const pageData = allData.slice(start, end);

  if (pageData.length === 0) {
    tableBody.innerHTML = `<tr><td colspan="5">감지 이력이 없습니다.</td></tr>`;
    return;
  }

  pageData.forEach(log => {
    const tr = document.createElement("tr");
    tr.setAttribute("data-id", log.id);
    tr.innerHTML = `
      <td><input type="checkbox"></td>
      <td>\${log.date}</td>
      <td>\${log.loc}</td>
      <td>\${log.type}</td>
      <td>\${log.prog}</td>
    `;
    tableBody.appendChild(tr);
  });

  pageNo.textContent = page;
  updateButtons();
}


// ✅ Prev / Next 버튼 상태 변경
function updateButtons() {
  const maxPage = Math.ceil(allData.length / pageSize);
  prevBtn.disabled = currentPage === 1;
  nextBtn.disabled = currentPage === maxPage;
}


// ✅ 페이지 버튼 이벤트
prevBtn.addEventListener("click", () => {
  if (currentPage > 1) {
    currentPage--;
    renderTable(currentPage);
  }
});

nextBtn.addEventListener("click", () => {
  const maxPage = Math.ceil(allData.length / pageSize);
  if (currentPage < maxPage) {
    currentPage++;
    renderTable(currentPage);
  }
});


// ✅ 페이지 처음 출력
renderTable();
console.log("총 감지 이력 수:", allData.length);

// 분류 모달

// 1) 분류 모달
  var filterBtn = document.getElementById("btnFilter");
  var filterPanel = document.getElementById("filterPanel");
  if (filterBtn && filterPanel) {
    var backdrop = document.getElementById("filterBackdrop");
    if (!backdrop) {
      backdrop = document.createElement("div");
      backdrop.id = "filterBackdrop";
      backdrop.className = "filter-modal-backdrop";
      document.body.appendChild(backdrop);
    }
    function openModal() {
      backdrop.classList.add("show");
      backdrop.appendChild(filterPanel);
      filterPanel.classList.add("as-modal");
    }
    function closeModal() {
      backdrop.classList.remove("show");
      var wrapper = document.querySelector(".filter-wrapper");
      if (wrapper) wrapper.appendChild(filterPanel);
      filterPanel.classList.remove("as-modal");
    }
    filterBtn.addEventListener("click", function (e) { e.preventDefault(); openModal(); });
    backdrop.addEventListener("click", function (e) { if (!filterPanel.contains(e.target)) closeModal(); });
    document.addEventListener("keydown", function (e) { if (e.key === "Escape" && backdrop.classList.contains("show")) closeModal(); });

    var opts = filterPanel.querySelectorAll(".filter-option");
    for (var i = 0; i < opts.length; i++) {
      opts[i].addEventListener("click", function () {
        var group = closest(this, ".filter-group");
        var all = group ? group.querySelectorAll(".filter-option") : [];
        for (var j = 0; j < all.length; j++) all[j].classList.remove("active");
        this.classList.add("active");
        // 필터 클릭 즉시 적용 (원본 배열 기준)
        applyActiveFilters();
      });
    }
  }









</script>

  <!-- JS연결 -->
  <script>
	//로그아웃 알림
	const logoutBtn = document.querySelector(".login-btn");
	if (logoutBtn) logoutBtn.addEventListener("click", () => alert("로그아웃 되었습니다."));
	
	//
  </script>
  

</body>
</html>
