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

  // 필터 모달
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

// 유틸
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

// 상태 정규화
function normalizeStatus(s) {
  var v = String(s || "").trim().toLowerCase();
  if (["완료","처리완료","done","complete","completed","success"].indexOf(v) > -1) return "처리완료";
  if (["진행","처리중","in_progress","progress","processing","working"].indexOf(v) > -1) return "처리중";
  if (["대기","처리전","pending","new","todo","준비중"].indexOf(v) > -1) return "처리전";
  return s || "-";
}

// 통계
function updateStats(logs) {
  var i, norm = [];
  for (i = 0; i < (logs || []).length; i++) {
    norm.push({ time: logs[i].time, location: logs[i].location, type: logs[i].type, status: normalizeStatus(logs[i].status) });
  }
  var total = norm.length, complete = 0, progress = 0, pending = 0;
  for (i = 0; i < norm.length; i++) {
    if (norm[i].status === "처리완료") complete++;
    else if (norm[i].status === "처리중") progress++;
    else if (norm[i].status === "처리전") pending++;
  }
  setText("totalCount", total + "건");
  setText("completeCount", complete + "건");
  setText("progressCount", progress + "건");
  setText("pendingCount", pending + "건");
}
function setText(id, v) {
  var el = document.getElementById(id);
  if (el) el.textContent = v;
}

// 체크박스
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

// 버튼
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

// 선택/읽기
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

// 필터
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

