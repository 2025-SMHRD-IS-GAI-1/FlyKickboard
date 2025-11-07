// ==============================
// 로그아웃 알림
// ==============================
const logoutBtn = document.querySelector(".login-btn");
if (logoutBtn) {
  logoutBtn.addEventListener("click", () => alert("로그아웃 되었습니다."));
}

// ==============================
// 메인 로직 (페이지 로드시 실행)
// ==============================
window.addEventListener('load', () => {

  let allLogs = [];   // 전체 데이터 저장
  let noHelmet = [];  // 헬멧 미착용 데이터
  let doublepl = [];  // 2인 탑승 데이터

  let isHelmetFilter = false; // 현재 헬멧 필터 상태
  let isDoubleFilter = false; // 현재 2인탑승 필터 상태

  const ctx = document.body.dataset.ctx;

  // 요소 선택
  const btnHelmet = document.getElementById("btnHelmet");
  const btnDouble = document.getElementById("btnDouble");
  const cntHelmet = document.getElementById("cntHelmet");
  const cntDouble = document.getElementById("cntDouble");
  const historyList = document.getElementById("historyList");

  // ===============================
  // 감지이력 불러오기
  // ===============================
  function loadLogs() {
    fetch("LogType.do", {
      method: "POST",
      headers: { "Content-Type": "application/json" }
    })
      .then(res => res.json())
      .then(data => {

        allLogs = data; // ✅ 전체 데이터 기억

        noHelmet = data.filter(a => a.type.includes("미착용"));
        doublepl = data.filter(a => a.type.includes("2인"));

        renderLogs(allLogs);
        updateCounts(allLogs);
      })
      .catch(err => console.error("데이터 로드 실패:", err));
  }


  // ===============================
  // 버튼 클릭 시 목록 토글 표시
  // ===============================
  btnHelmet.addEventListener("click", () => {
    if (!isHelmetFilter) {
      renderLogs(noHelmet);
      isHelmetFilter = true;
      isDoubleFilter = false;
    } else {
      renderLogs(allLogs);
      isHelmetFilter = false;
    }
  });

  btnDouble.addEventListener("click", () => {
    if (!isDoubleFilter) {
      renderLogs(doublepl);
      isDoubleFilter = true;
      isHelmetFilter = false;
    } else {
      renderLogs(allLogs);
      isDoubleFilter = false;
    }
  });


  // ===============================
  // 감지이력 화면 표시
  // ===============================
  function renderLogs(logs) {
    historyList.innerHTML = ""; // 기존 목록 비우기

    if (!logs || logs.length === 0) {
      historyList.innerHTML = `<li>최근 감지 이력이 없습니다.</li>`;
      return;
    }

    logs.forEach(log => {
      const li = document.createElement("li");
      li.innerHTML = `
        <span>
          <span class="dot ${log.type.includes("미착용") ? "helmet" : "double"}"></span>
          ${log.type}
        </span>
        <span class="region">${log.loc}</span>
        <span class="time">${log.date}</span>
      `;
      historyList.appendChild(li);
    });
  }

  // ===============================
  // 감지 건수 업데이트
  // ===============================
  function updateCounts(logs) {
    const helmetCount = logs.filter(l => l.type.includes("미착용")).length;
    const doubleCount = logs.filter(l => l.type.includes("2인")).length;

    cntHelmet.textContent = helmetCount;
    cntDouble.textContent = doubleCount;
  }

  // ===============================
  // 페이지 로드시 전체 로그 로드
  // ===============================
  loadLogs();

});
