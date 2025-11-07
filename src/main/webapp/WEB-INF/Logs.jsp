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
  <link rel="stylesheet" href="${ctx}/assets/css/Report.css" />
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
   <button type="button" class="btn blue" id="btnStats">통계</button>
   <!-- ✅ Report 모달 -->
<div id="reportModal" class="report-modal">
  <div class="report-content">
    <button type="button" class="close-btn" id="closeReportBtn">×</button>
    
    <!-- 표지 -->
    <h2>📊 통계 보고서</h2>

    <!-- ① 지역별 통계 -->
    <section class="card" id="sec-3">
      <header class="card-header">
        <h3 class="card-title">지역별 통계</h3>
      </header>
      <div class="card-body">
        <section class="ui-grid" style="grid-template-columns:1fr 1fr; gap:16px;">
          
          <!-- 왼쪽: 그래프 -->
          <article class="card">
            <header class="card-header">
              <h4 class="card-title">지역별 감지건수</h4>
            </header>
            <div class="card-body">
              <div class="chart bar">
                <canvas id="regionBar2" height="240" aria-label="지역별 막대그래프"></canvas>
              </div>
            </div>
          </article>

          <!-- 오른쪽: 표 -->
          <article class="card">
            <header class="card-header">
              <h4 class="card-title">지역별 위반 통계</h4>
            </header>
            <div class="card-body">
              <table class="tbl region-table" id="regionTable2">
                <thead>
                  <tr><th>지역</th><th>건수</th><th>비율(%)</th></tr>
                </thead>
                <tbody>
                  <tr><td>광산구</td><td>—</td><td>—</td></tr>
                  <tr><td>북구</td><td>—</td><td>—</td></tr>
                  <tr><td>서구</td><td>—</td><td>—</td></tr>
                  <tr><td>남구</td><td>—</td><td>—</td></tr>
                  <tr><td>동구</td><td>—</td><td>—</td></tr>
                  <tr><td><strong>총 건수</strong></td><td>—</td><td></td></tr>
                </tbody>
              </table>
            </div>
          </article>

        </section>
      </div>
    </section>

    <!-- ② 위반 유형 통계 -->
    <section class="card" id="sec-4">
      <header class="card-header">
        <h3 class="card-title">위반 유형 통계</h3>
      </header>
      <div class="card-body">
        <section class="ui-grid" style="grid-template-columns:1fr 1fr; gap:16px;">
          
          <!-- 왼쪽: 도넛 -->
          <article class="card">
            <header class="card-header">
              <h4 class="card-title">위반유형별 비율(도넛)</h4>
            </header>
            <div class="card-body">
              <div class="chart donut">
                <canvas id="typeDonut2" height="220" aria-label="위반유형 도넛차트"></canvas>
              </div>
              <div class="legend-row" style="margin-top:10px;">
                <span class="legend">헬멧 미착용 <strong>—%</strong></span>
                <span class="legend">2인 탑승 <strong>—%</strong></span>
              </div>
            </div>
          </article>

          <!-- 오른쪽: 감지유형별 건수 -->
          <article class="card">
            <header class="card-header">
              <h4 class="card-title">감지유형별 건수</h4>
            </header>
            <div class="card-body">
              <table class="tbl compact">
                <thead>
                  <tr><th>감지유형</th><th>건수</th></tr>
                </thead>
                <tbody>
                  <tr><td class="left">헬멧 미착용</td><td>—</td></tr>
                  <tr><td class="left">2인 탑승</td><td>—</td></tr>
                  <tr><td class="left"><strong>총 건수</strong></td><td><strong>—</strong></td></tr>
                </tbody>
              </table>
            </div>
          </article>

        </section>
      </div>
    </section>

    <!-- ③ 선택 일자 시간대별 추이 -->
    <article class="card" id="selectedDayHourly">
      <header class="card-header">
        <h4 class="card-title">선택 일자 · 시간대별 감지 추이</h4>
      </header>
      <div class="card-body">
        <p id="selectedDateLabel" class="muted" style="margin:0 0 8px 0;">선택 일자: YYYY-MM-DD</p>

        <section class="ui-grid" style="grid-template-columns: 320px 1fr; gap:16px;">

          <!-- 왼쪽: 표 -->
          <div class="card" style="margin:0;">
            <header class="card-header">
              <h4 class="card-title">시간대별 건수</h4>
            </header>
            <div class="card-body">
              <table class="tbl compact" id="hourlyTable">
                <thead>
                  <tr><th>시간대</th><th>건수</th></tr>
                </thead>
                <tbody>
                  <tr><td>00:00 ~ 03:00</td><td>—</td></tr>
                  <tr><td>03:00 ~ 06:00</td><td>—</td></tr>
                  <tr><td>06:00 ~ 09:00</td><td>—</td></tr>
                  <tr><td>09:00 ~ 12:00</td><td>—</td></tr>
                  <tr><td>12:00 ~ 15:00</td><td>—</td></tr>
                  <tr><td>15:00 ~ 18:00</td><td>—</td></tr>
                  <tr><td>18:00 ~ 21:00</td><td>—</td></tr>
                  <tr><td>21:00 ~ 24:00</td><td>—</td></tr>
                  <tr><td><strong>총 건수</strong></td><td><strong>—</strong></td></tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- 오른쪽: 라인그래프 -->
          <div class="card" style="margin:0;">
            <header class="card-header">
              <h4 class="card-title">시간대 추이 그래프</h4>
            </header>
            <div class="card-body">
              <div class="chart line">
                <canvas id="selectedDayLine" height="220" aria-label="선택 일자 시간대별 추이"></canvas>
              </div>
            </div>
          </div>

        </section>
      </div>
    </article>

  </div>
</div>
    <button type="button" class="btn blue" id="btnSend">전송</button>
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
// Eclipse / JSP 환경 + ES5 호환 통합본
// ==============================

// JSP에서 <body data-ctx="${pageContext.request.contextPath}">
var ctx = (document.body && document.body.getAttribute('data-ctx')) || "";

// ------------------------------
// DOM 로드
// ------------------------------
document.addEventListener("DOMContentLoaded", function () {
	// ------------------------------
	  // 0) 상단 메뉴/로그아웃
	  // ------------------------------
	  var realtimeBtn = document.querySelector(".nav-btn[data-route='main']");
	  if (realtimeBtn)
	    realtimeBtn.addEventListener("click", function () {
	      window.location.href = ctx + "/Main.jsp";
	    });

	  var logsBtn = document.querySelector(".nav-btn[data-route='logs']");
	  if (logsBtn)
	    logsBtn.addEventListener("click", function () {
	      window.location.href = ctx + "/Logs.jsp";
	    });

	  var adminBtn = document.querySelector(".admin-btn");
	  if (adminBtn)
	    adminBtn.addEventListener("click", function () {
	      window.location.href = ctx + "/Manager.jsp";
	    });

	  var logoutBtn = document.querySelector(".login-btn");
	  if (logoutBtn) {
	    logoutBtn.addEventListener("click", function () {
	      alert("로그아웃 되었습니다.");
	      window.location.href = ctx + "/Login.jsp";
	    });
	  }

	  // ===============================
	  // ✅ 날짜 검색 (LAST_LOGS 기반)
	  // ===============================
	  var searchBtn = document.querySelector(".btn-search");
	  if (searchBtn) {
	    searchBtn.addEventListener("click", function () {
	      var startInput = document.getElementById("startDate");
	      var endInput = document.getElementById("endDate");
	      var startDate = startInput ? startInput.value : "";
	      var endDate = endInput ? endInput.value : "";

	      if (!startDate && !endDate) {
	        alert("조회할 날짜를 선택하세요.");
	        return;
	      }
	      if (
	        !window.LAST_LOGS ||
	        !Array.isArray(window.LAST_LOGS) ||
	        window.LAST_LOGS.length === 0
	      ) {
	        alert("조회할 데이터가 없습니다.");
	        return;
	      }

	      // 날짜 범위 세팅
	      var s = startDate
	        ? new Date(startDate + "T00:00:00")
	        : new Date("2000-01-01T00:00:00");
	      var e = endDate
	        ? new Date(endDate + "T23:59:59")
	        : new Date();

	      // 날짜 필터링
	      var filtered = window.LAST_LOGS.filter(function (log) {
	        var timeStr = (log.time || "").trim();
	        if (!timeStr) return false;
	        var datePart = timeStr.split(" ")[0];
	        var parts = datePart.split("-");
	        if (parts.length < 3) return false;
	        var y = parseInt(parts[0], 10);
	        var m = parseInt(parts[1], 10);
	        var d = parseInt(parts[2], 10);
	        var t = new Date(y, m - 1, d);
	        return t >= s && t <= e;
	      });

	      updateLogsTable(filtered);
	      updateStats(filtered);
	      syncHeaderState();

	      console.log(
	        "[날짜 검색결과] " +
	          filtered.length +
	          "건 (" +
	          (startDate || "-") +
	          " ~ " +
	          (endDate || "-") +
	          ")"
	      );
	    });
	  }

	  // ------------------------------
	  // 1) 분류 모달
	  // ------------------------------
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
	      if (e.key === "Escape" && backdrop.classList.contains("show"))
	        closeModal();
	    });

	    var opts = filterPanel.querySelectorAll(".filter-option");
	    for (var i = 0; i < opts.length; i++) {
	      opts[i].addEventListener("click", function () {
	        var group = closest(this, ".filter-group");
	        var all = group ? group.querySelectorAll(".filter-option") : [];
	        for (var j = 0; j < all.length; j++) all[j].classList.remove("active");
	        this.classList.add("active");
	        // 필터 클릭 즉시 적용
	        applyActiveFilters();
	      });
	    }
	  }

	  // ------------------------------
	  // 2) 통계 모달
	  // ------------------------------
	  var statsBtn = document.getElementById("btnStats");
	  var modal = document.getElementById("reportModal");
	  var closeBtn = document.getElementById("closeReportBtn");

	  if (modal) modal.classList.remove("show");

	  if (statsBtn && modal) {
	    statsBtn.addEventListener("click", function () {
	      modal.classList.add("show");
	      // drawCharts(); // 현재는 주석
	    });
	  }

	  if (closeBtn) {
	    closeBtn.addEventListener("click", function () {
	      modal.classList.remove("show");
	    });
	  }

	  if (modal) {
	    modal.addEventListener("click", function (e) {
	      if (e.target === modal) modal.classList.remove("show");
	    });
	  }

	  // ------------------------------
	  // 3) 테이블/체크박스 초기화
	  // ------------------------------
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
	    var mo = new MutationObserver(function () {
	      ensureRowCheckboxes();
	    });
	    mo.observe(tbody, { childList: true });
	  }

	  bindActionButtons();

	  // ------------------------------
	  // 4) 초기 로그 데이터 세팅
	  // ------------------------------
	  applyStatusBadgeToCurrentRows();
	  var initLogs = map(readLogsFromDom(), function (l) {
	    l.status = normalizeStatus(l.status);
	    return l;
	  });
	  window.LAST_LOGS = initLogs;
	  updateStats(initLogs);
	});

// ------------------------------
// 유틸
// ------------------------------
function hasClass(el, c) { return el && (' ' + el.className + ' ').indexOf(' ' + c + ' ') > -1; }
function closest(el, sel) { while (el && el.nodeType === 1) { if (matches(el, sel)) return el; el = el.parentElement; } return null; }
function matches(el, sel) {
  var p = Element.prototype;
  var f = p.matches || p.webkitMatchesSelector || p.mozMatchesSelector || p.msMatchesSelector;
  return f.call(el, sel);
}
function map(arr, fn) { var out = []; for (var i = 0; i < arr.length; i++) out.push(fn(arr[i], i)); return out; }

// ------------------------------
// 상태 정규화
// ------------------------------
function normalizeStatus(s) {
  var v = String(s || "").trim().toLowerCase();
  if (["대기","처리전","pending","new","todo","준비중"].indexOf(v) > -1) return "처리전";
  if (["진행","처리중","in_progress","progress","processing","working"].indexOf(v) > -1) return "처리중";
  if (["완료","처리완료","done","complete","completed","success"].indexOf(v) > -1) return "처리완료";
  return s || "-";
}

// ------------------------------
// 통계
// ------------------------------
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
function setText(id, v) { var el = document.getElementById(id); if (el) el.textContent = v; }

// ------------------------------
// 체크박스
// ------------------------------
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
  if (checked === 0) { checkAll.checked = false; checkAll.indeterminate = false; }
  else if (checked === cbs.length) { checkAll.checked = true; checkAll.indeterminate = false; }
  else { checkAll.checked = false; checkAll.indeterminate = true; }
}

// ------------------------------
// 버튼
// ------------------------------
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

// ------------------------------
// 행 선택 / 삭제 / 읽기
// ------------------------------
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

// ------------------------------
// 상태 뱃지 적용(초기 DOM용)
// ------------------------------
function applyStatusBadgeToCurrentRows() {
  var rows = document.querySelectorAll(".logs-table tbody tr");
  for (var i = 0; i < rows.length; i++) {
    var statusCell = rows[i].cells[4];
    if (!statusCell) continue;
    var text = (statusCell.textContent || "").trim();
    if (statusCell.querySelector("span.status")) continue; // 이미 변환됨

    var span = document.createElement("span");
    span.className = "status " + statusClass(normalizeStatus(text));
    span.textContent = normalizeStatus(text);
    statusCell.innerHTML = "";
    statusCell.appendChild(span);
  }
}

// ------------------------------
// 필터 로직 (원본 배열 기준)
// ------------------------------
window.LAST_LOGS = window.LAST_LOGS || [];

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

function applyActiveFilters() {
  var filters = getActiveFilters();
  var baseLogs = window.LAST_LOGS || [];
  var filtered = filterLogs(baseLogs, filters);
  updateLogsTable(filtered);
  updateStats(filtered);
  syncHeaderState();
}

// 테이블 갱신 (상태 뱃지 포함)
function updateLogsTable(filteredLogs) {
  var tbody = document.querySelector(".logs-table tbody");
  if (!tbody) return;
  tbody.innerHTML = "";
  for (var i = 0; i < filteredLogs.length; i++) {
    var log = filteredLogs[i];
    var normStatus = normalizeStatus(log.status);
    var tr = document.createElement("tr");
    tr.innerHTML =
      "<td>" + (i + 1) + "</td>" +
      "<td>" + (log.time || "-") + "</td>" +
      "<td>" + (log.location || "-") + "</td>" +
      "<td>" + (log.type || "-") + "</td>" +
      "<td><span class='status " + statusClass(normStatus) + "'>" + normStatus + "</span></td>";
    tbody.appendChild(tr);
  }
  ensureRowCheckboxes();
}

function statusClass(status) {
  if (status === "처리전") return "pending";
  if (status === "처리중") return "progress";
  if (status === "처리완료") return "complete";
  return "";
}
</script>


</body>
</html>
