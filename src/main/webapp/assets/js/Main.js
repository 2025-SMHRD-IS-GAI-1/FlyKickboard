// ==============================
// Main.js
// ==============================
import { initNaverMap, addDetectionMarker } from "./MapHandler.js";

// ==============================
// 초기 실행
// ==============================
window.addEventListener("load", async () => {
  setupLogout();
  const ctx = document.body.getAttribute("data-ctx");
  await initNaverMap(ctx);
  await loadLogs();
  setupFilterButtons();
  startRealTimeMonitor();
});

if (session == "") {
  window.location.href = "GoLogin.do";
}

// ==============================
// 로그아웃 버튼
// ==============================
function setupLogout() {
  const logoutBtn = document.querySelector(".login-btn");
  if (logoutBtn) {
    logoutBtn.addEventListener("click", () => alert("로그아웃 되었습니다."));
  }
}

// ==============================
// 감지 로그 데이터 로드
// ==============================
let allLogs = [];
let noHelmet = [];
let doublepl = [];

async function loadLogs() {
  try {
    const res = await fetch("LogType.do", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
    });

    const data = await res.json();
    allLogs = data;
    noHelmet = data.filter((d) => d.type.includes("미착용"));
    doublepl = data.filter((d) => d.type.includes("2인"));

    renderLogs(allLogs);
    updateCounts(allLogs);

    // ✅ 지도에 감지 마커 표시
	data.forEach((log) => {
	  if (log.latitude && log.longitude) addDetectionMarker(log, false);
	});

  } catch (err) {
    console.error("데이터 로드 실패:", err);
  }
}

// ==============================
// 감지 로그 렌더링
// ==============================
function renderLogs(logs) {
  const historyList = document.getElementById("historyList");
  if (!historyList) return;

  historyList.innerHTML = "";

  if (!logs || logs.length === 0) {
    historyList.innerHTML = `<li>최근 감지 이력이 없습니다.</li>`;
    return;
  }

  logs.forEach((log) => {
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

// ==============================
// 감지 건수 UI 업데이트
// ==============================
function updateCounts(logs) {
  document.getElementById("cntHelmet").textContent =
    logs.filter((l) => l.type.includes("미착용")).length;
  document.getElementById("cntDouble").textContent =
    logs.filter((l) => l.type.includes("2인")).length;
}

// ==============================
// 필터 버튼
// ==============================
let isHelmetFilter = false;
let isDoubleFilter = false;

function setupFilterButtons() {
  const btnHelmet = document.getElementById("btnHelmet");
  const btnDouble = document.getElementById("btnDouble");

  btnHelmet.addEventListener("click", () => {
    isHelmetFilter = !isHelmetFilter;
    isDoubleFilter = false;
    renderLogs(isHelmetFilter ? noHelmet : allLogs);
  });

  btnDouble.addEventListener("click", () => {
    isDoubleFilter = !isDoubleFilter;
    isHelmetFilter = false;
    renderLogs(isDoubleFilter ? doublepl : allLogs);
  });
}

// ==============================
// 실시간 감지 감시
// ==============================
let lastId = 0;

function startRealTimeMonitor() {
  setInterval(async () => {
    try {
      const res = await fetch(`LogAfter.do?sinceId=${lastId}`);
      if (!res.ok) return;

      const newLogs = await res.json();
      if (newLogs.length > 0) {
        newLogs.forEach((log) => {
          addDetectionMarker(log, true); // 🔴 새 감지 빨간색
          allLogs.unshift(log);
        });

        renderLogs(allLogs);
        updateCounts(allLogs);

        lastId = newLogs[0].det_id; // 마지막 감지 아이디 업데이트
      }
    } catch (err) {
      console.error("실시간 감지 감시 오류:", err);
    }
  }, 5000); // 5초마다 감시
}