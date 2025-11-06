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
    <button type="button" class="btn blue" id="btnPrint">출력</button>
    <button type="button" class="btn red" id="btnDelete">삭제</button>
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
      <tbody>
      <c:forEach var="log" items="${alllog}">
	      <tr>
	      	<td><input type="checkbox" /></td>
	      	<td>${log.date}</td><td>${log.loc}</td><td>${log.type}</td><td>${log.prog}</td>
	      </tr>
      </c:forEach>
            <tr>
         <!-- 
         <td>2025-11-02</td>
          <td>광주 북구 첨단로 123</td>
          <td>헬멧 미착용</td>
          <td><span class="status complete">처리완료</span></td>
             </tr>
          --> 
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
// Eclipse / JSP 환경 + ES5 호환
// ==============================

// JSP에서 <body data-ctx="${pageContext.request.contextPath}">
var ctx = (document.body && document.body.getAttribute('data-ctx')) || "";

// DOM 로드
document.addEventListener("DOMContentLoaded", function () {
  // 상단 메뉴/로그아웃
  var realtimeBtn = document.querySelector(".nav-btn[data-route='main']");
  if (realtimeBtn) realtimeBtn.addEventListener("click", function () {
    window.location.href = ctx + "/Main.jsp";
  });

  var logsBtn = document.querySelector(".nav-btn[data-route='logs']");
  if (logsBtn) logsBtn.addEventListener("click", function () {
    window.location.href = ctx + "/Logs.jsp";
  });

  var adminBtn = document.querySelector(".admin-btn");
  if (adminBtn) adminBtn.addEventListener("click", function () {
    window.location.href = ctx + "/Manager.jsp";
  });

  var logoutBtn = document.querySelector(".login-btn");
  if (logoutBtn) {
    logoutBtn.addEventListener("click", function () {
      alert("로그아웃 되었습니다.");
      window.location.href = ctx + "/Login.jsp";
    });
  }
  //===============================
  //✅ 날짜 검색 (LAST_LOGS 기반 필터링)
  //===============================
  	  

  // ===============================
  // 필터 모달 (분류 버튼)
  // ===============================
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

    filterBtn.addEventListener("click", function (e) {
      e.preventDefault();
      openModal();
    });

    backdrop.addEventListener("click", function (e) {
      if (!filterPanel.contains(e.target)) closeModal();
    });

    document.addEventListener("keydown", function (e) {
      if (e.key === "Escape" && backdrop.classList.contains("show")) closeModal();
    });

    var opts = filterPanel.querySelectorAll(".filter-option");
    for (var i = 0; i < opts.length; i++) {
      opts[i].addEventListener("click", function () {
        var group = closest(this, ".filter-group");
        var all = group ? group.querySelectorAll(".filter-option") : [];
        for (var j = 0; j < all.length; j++) all[j].classList.remove("active");
        this.classList.add("active");

        // 🔹 [추가] 필터 선택 시 즉시 테이블 갱신
        applyActiveFilters();
      });
    }
  }

  // 체크박스/테이블
  ensureRowCheckboxes();

  var table = document.querySelector(".logs-table");
  var tbody = table ? table.tBodies[0] : null;
  var checkAll = table ? table.querySelector("#checkAll") : null;

  if (checkAll) {
    checkAll.addEventListener("change", function () {
      var cbs = table.querySelectorAll("tbody .row-check");
      for (var i = 0; i < cbs.length; i++) cbs[i].checked = checkAll.checked;
      checkAll.indeterminate = false;
    });
  }

  if (tbody) {
    tbody.addEventListener("change", function (e) {
      var t = e.target || e.srcElement;
      if (t && hasClass(t, "row-check")) syncHeaderState();
    });

    var mo = new MutationObserver(function () { ensureRowCheckboxes(); });
    mo.observe(tbody, { childList: true });
  }

  bindActionButtons();

  // 초기 통계 채우기
  var initLogs = map(readLogsFromDom(), function (l) {
    l.status = normalizeStatus(l.status);
    return l;
  });
  window.LAST_LOGS = initLogs;
  updateStats(initLogs);
});

// ===============================
// 유틸 함수
// ===============================
function hasClass(el, c) { return el && (' ' + el.className + ' ').indexOf(' ' + c + ' ') > -1; }
function closest(el, sel) {
  while (el && el.nodeType === 1) {
    if (matches(el, sel)) return el;
    el = el.parentElement;
  }
  return null;
}
function matches(el, sel) {
  var p = Element.prototype;
  var f = p.matches || p.webkitMatchesSelector || p.mozMatchesSelector || p.msMatchesSelector;
  return f.call(el, sel);
}
function map(arr, fn) {
  var out = [];
  for (var i = 0; i < arr.length; i++) out.push(fn(arr[i], i));
  return out;
}

// ===============================
// 상태 정규화
// ===============================
function normalizeStatus(s) {
  var v = String(s || "").trim().toLowerCase();
  if (["대기","처리전","pending","new","todo","준비중"].indexOf(v) > -1) return "처리전";
  if (["진행","처리중","in_progress","progress","processing","working"].indexOf(v) > -1) return "처리중";
  if (["완료","처리완료","done","complete","completed","success"].indexOf(v) > -1) return "처리완료";
  
  return s || "-";
}

// ===============================
// 통계
// ===============================
function updateStats(logs) {
  var i, norm = [];
  for (i = 0; i < (logs || []).length; i++) {
    norm.push({ time: logs[i].time, location: logs[i].location, type: logs[i].type, status: normalizeStatus(logs[i].status) });
  }
  var total = norm.length, complete = 0, progress = 0, pending = 0;
  for (i = 0; i < norm.length; i++) {
    if (norm[i].status === "처리전") pending++;
    else if (norm[i].status === "처리중") progress++;
    else if (norm[i].status === "처리완료") complete++;
  }
  setText("totalCount", total + "건");
  setText("pendingCount", pending + "건");
  setText("progressCount", progress + "건");
  setText("completeCount", complete + "건");
}
function setText(id, v) {
  var el = document.getElementById(id);
  if (el) el.textContent = v;
}

// ===============================
// 체크박스
// ===============================
function ensureRowCheckboxes() {
  var table = document.querySelector(".logs-table");
  if (!table) return;
  var tbody = table.tBodies[0];
  if (!tbody) return;

  var rows = tbody.rows;
  for (var i = 0; i < rows.length; i++) {
    var firstCell = rows[i].cells[0];
    if (!firstCell) continue;
    if (!firstCell.querySelector("input[type='checkbox']")) {
      var id = (firstCell.textContent || "").trim();
      firstCell.innerHTML = '<input type="checkbox" class="row-check" data-id="' + id + '" aria-label="' + id + '번 선택">';
    }
  }
  syncHeaderState();
}
function syncHeaderState() {
  var table = document.querySelector(".logs-table");
  if (!table) return;
  var checkAll = table.querySelector("#checkAll");
  var cbs = table.querySelectorAll("tbody .row-check");
  if (!checkAll || cbs.length === 0) return;
  var checked = 0;
  for (var i = 0; i < cbs.length; i++) if (cbs[i].checked) checked++;
  if (checked === 0)      { checkAll.checked = false; checkAll.indeterminate = false; }
  else if (checked === cbs.length) { checkAll.checked = true;  checkAll.indeterminate = false; }
  else                    { checkAll.checked = false; checkAll.indeterminate = true;  }
}

// ===============================
// 버튼
// ===============================
function bindActionButtons() {
  var btnSend   = document.getElementById("btnSend");
  var btnPrint  = document.getElementById("btnPrint");
  var btnDelete = document.getElementById("btnDelete");

  if (btnPrint) btnPrint.addEventListener("click", function () { window.print(); });

  if (btnSend) btnSend.addEventListener("click", function () {
    var ids = getSelectedLogIds();
    if (!ids.length) return alert("선택된 항목이 없습니다.");
    alert("전송 대상 번호: " + ids.join(", "));
  });

  if (btnDelete) btnDelete.addEventListener("click", function () {
    var ids = getSelectedLogIds();
    if (!ids.length) return alert("삭제할 항목을 선택하세요.");
    if (!confirm("선택된 " + ids.length + "건을 삭제하시겠습니까?")) return;
    removeSelectedRowsFromDom();
    var logs = readLogsFromDom();
    updateStats(logs);
    syncHeaderState();
    alert("삭제되었습니다.");
  });
}

// ===============================
// 행 선택 / 삭제 / 읽기
// ===============================
function getSelectedLogIds() {
  var cbs = document.querySelectorAll(".logs-table tbody .row-check:checked");
  var out = [];
  for (var i = 0; i < cbs.length; i++) out.push(cbs[i].getAttribute("data-id"));
  return out;
}
function removeSelectedRowsFromDom() {
  var cbs = document.querySelectorAll(".logs-table tbody .row-check:checked");
  for (var i = 0; i < cbs.length; i++) {
    var tr = cbs[i].closest ? cbs[i].closest("tr") : closest(cbs[i], "tr");
    if (tr && tr.parentNode) tr.parentNode.removeChild(tr);
  }
}
function readLogsFromDom() {
  var rows = document.querySelectorAll(".logs-table tbody tr");
  var out = [];
  for (var i = 0; i < rows.length; i++) {
    var cells = rows[i].querySelectorAll("td");
    out.push({
      time:    (cells[1] && cells[1].textContent ? cells[1].textContent.trim() : ""),
      location:(cells[2] && cells[2].textContent ? cells[2].textContent.trim() : ""),
      type:    (cells[3] && cells[3].textContent ? cells[3].textContent.trim() : ""),
      status:  (cells[4] && cells[4].textContent ? cells[4].textContent.trim() : "")
    });
  }
  return out;
}

// ===============================
// 필터 로직 (기존 + 자동 필터링 포함)
// ===============================
window.LAST_LOGS = window.LAST_LOGS || [];

// 조건 필터링
function filterLogs(logs, f) {
  var out = [];
  for (var i = 0; i < logs.length; i++) {
    var it = logs[i];
    var s = normalizeStatus(it.status);
    var okStatus = f.status ? (s === f.status) : true;
    var okType   = f.dtype  ? (it.type === f.dtype) : true;
    if (okStatus && okType) out.push(it);
  }
  return out;
}

// ✅ 현재 활성 필터 읽기
function getActiveFilters() {
  var f = { status: null, dtype: null };
  var panel = document.getElementById("filterPanel");
  if (!panel) return f;

  var groups = panel.querySelectorAll(".filter-group");
  if (groups[0]) {
    var active1 = groups[0].querySelector(".filter-option.active");
    if (active1 && active1.textContent.trim() !== "전체") f.status = active1.textContent.trim();
  }
  if (groups[1]) {
    var active2 = groups[1].querySelector(".filter-option.active");
    if (active2 && active2.textContent.trim() !== "전체") f.dtype = active2.textContent.trim();
  }
  return f;
}

// ✅ 필터 적용 및 테이블 갱신
function applyActiveFilters() {
  var filters = getActiveFilters();
  var baseLogs = window.LAST_LOGS || [];
  var filtered = filterLogs(baseLogs, filters);
  updateLogsTable(filtered);
  updateStats(filtered);
  syncHeaderState();
}

// ✅ 테이블 갱신 함수
function updateLogsTable(filteredLogs) {
  var tbody = document.querySelector(".logs-table tbody");
  if (!tbody) return;
  tbody.innerHTML = "";
  for (var i = 0; i < filteredLogs.length; i++) {
    var log = filteredLogs[i];
    var tr = document.createElement("tr");
    tr.innerHTML =
      "<td>" + (i + 1) + "</td>" +
      "<td>" + (log.time || "-") + "</td>" +
      "<td>" + (log.location || "-") + "</td>" +
      "<td>" + (log.type || "-") + "</td>" +
      "<td><span class='status " + statusClass(log.status) + "'>" + log.status + "</span></td>";
    tbody.appendChild(tr);
  }
  ensureRowCheckboxes();
}

// ✅ 상태별 클래스
function statusClass(status) {
  if (status === "처리전") return "pending";
  if (status === "처리중") return "progress";
  if (status === "처리완료") return "complete";
  return "";
}
var rows = document.querySelectorAll(".logs-table tbody tr");
for (var i = 0; i < rows.length; i++) {
  var statusCell = rows[i].cells[4];
  if (!statusCell) continue;
  var text = (statusCell.textContent || "").trim();

  // 이미 span이 있으면 건너뛰기
  if (statusCell.querySelector("span.status")) continue;

  var span = document.createElement("span");
  span.classList.add("status");

  if (text === "처리완료") span.classList.add("complete");
  else if (text === "처리중") span.classList.add("progress");
  else if (text === "처리전") span.classList.add("pending");

  span.textContent = text;
  statusCell.innerHTML = "";
  statusCell.appendChild(span);
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
