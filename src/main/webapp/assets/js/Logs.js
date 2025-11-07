// ==============================
// 로그아웃 알림
// ==============================
const logoutBtn = document.querySelector(".login-btn");
if (logoutBtn) {
  logoutBtn.addEventListener("click", () => alert("로그아웃 되었습니다."));
}

// ==============================
// 체크된 행 데이터 가져오기 (삭제에 사용)
// ==============================
function getCheckedRows() {
  const checked = document.querySelectorAll("#LogTable input[type='checkbox']:checked");
  const selected = [];

  checked.forEach(chk => {
    const row = chk.closest("tr");
    selected.push({ id: row.dataset.id });
  });

  return selected;
}

// ==============================
// 삭제 버튼 이벤트
// ==============================
const btnDel = document.getElementById("btnDel");
if (btnDel) {
  btnDel.addEventListener("click", () => {
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
      })
      .catch(err => console.error("삭제 오류:", err));
  });
}

// ==============================
// ✅ 페이징 처리
// ==============================
const tableBody = document.getElementById("LogTable");
const prevBtn = document.querySelector(".page-btn.prev");
const nextBtn = document.querySelector(".page-btn.next");
const pageNo = document.querySelector(".page-no");

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
    tr.dataset.id = log.id;
    tr.innerHTML = `
      <td><input type="checkbox"></td>
      <td>${log.date}</td>
      <td>${log.loc}</td>
      <td>${log.type}</td>
      <td>${log.prog}</td>
    `;
    tableBody.appendChild(tr);
  });

  pageNo.textContent = page;
  updateButtons();
}

// ✅ Prev / Next 버튼 상태 변경
function updateButtons() {
  const maxPage = Math.ceil(allData.length / pageSize);
  if (prevBtn) prevBtn.disabled = currentPage === 1;
  if (nextBtn) nextBtn.disabled = currentPage === maxPage;
}

// ✅ 페이지 버튼 이벤트
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

// ✅ 페이지 처음 출력
renderTable();
console.log("총 감지 이력 수:", allData.length);

// ==============================
// ✅ 분류 모달 관련
// ==============================
const filterBtn = document.getElementById("btnFilter");
const filterPanel = document.getElementById("filterPanel");

if (filterBtn && filterPanel) {
  let backdrop = document.getElementById("filterBackdrop");
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
    const wrapper = document.querySelector(".filter-wrapper");
    if (wrapper) wrapper.appendChild(filterPanel);
    filterPanel.classList.remove("as-modal");
  }

  filterBtn.addEventListener("click", e => {
    e.preventDefault();
    openModal();
  });

  backdrop.addEventListener("click", e => {
    if (!filterPanel.contains(e.target)) closeModal();
  });

  document.addEventListener("keydown", e => {
    if (e.key === "Escape" && backdrop.classList.contains("show")) closeModal();
  });

  const opts = filterPanel.querySelectorAll(".filter-option");
  opts.forEach(opt => {
    opt.addEventListener("click", function () {
      const group = this.closest(".filter-group");
      if (!group) return;
      group.querySelectorAll(".filter-option").forEach(o => o.classList.remove("active"));
      this.classList.add("active");
      applyActiveFilters();
    });
  });

  // ✅ 날짜 검색 버튼 (검색 기능 자리)
  const searchBtn = document.querySelector(".btn-search");
  if (searchBtn) {
    searchBtn.addEventListener("click", () => {
      const startDate = document.getElementById("startDate").value;
      const endDate = document.getElementById("endDate").value;

      console.log("검색 클릭됨:", startDate, endDate);
      // TODO: fetch("DateLog.do") 요청 추가 가능
    });
  }
}

console.log("Logs.js loaded ✅");