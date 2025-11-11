/************** 전역 상태 **************/
let ALL_LOGS = [];     // 최근 20개 유지
const MAX_KEEP = 20;

/*************************************************
 * 페이지 로드
 *************************************************/
window.addEventListener("load", () => {
  setupLogout();
  initNaverMap();
  loadLogs();
  startRealTimeMonitor();
  setupFilterButtons(); // ✅ 필터 버튼 연결
});

/*************************************************
 * 로그아웃 버튼
 *************************************************/
function setupLogout() {
  const logoutBtn = document.querySelector(".login-btn");
  if (logoutBtn)
    logoutBtn.addEventListener("click", () => alert("로그아웃 되었습니다."));
}

/*************************************************
 * ✅ 초기 20건 로드
 *************************************************/
async function loadLogs() {
  try {
    const ctx = document.body.dataset.ctx || "";
    const res = await fetch(`${ctx}/LogType.do`);
    if (!res.ok) throw new Error("서버 응답 오류");

    const logs = await res.json();

    // 전역 상태 갱신(최신순 가정)
    ALL_LOGS = Array.isArray(logs) ? logs.slice(0, MAX_KEEP) : [];

    renderLogs(ALL_LOGS);
    renderMapMarkers(ALL_LOGS);
    updateSummaryCounts(ALL_LOGS); // ✅ 요약 카드 갱신
  } catch (err) {
    console.error("❌ 감지 로그 불러오기 실패:", err);
  }
}

/*************************************************
 * ✅ 실시간 갱신
 *************************************************/
function startRealTimeMonitor() {
  let lastId = 0;

  setInterval(async () => {
    try {
      const ctx = document.body.dataset.ctx || "";
      const res = await fetch(`${ctx}/LogAfter.do?sinceId=${lastId}`);
      if (!res.ok) return;

      const newLogs = await res.json();
      if (newLogs.length > 0) {
        // 최신 ID 갱신
        lastId = Math.max(...newLogs.map((l) => Number(l.det_id)));

        // 전역 상태 앞에 추가하고 20개 유지
        ALL_LOGS = [...newLogs, ...ALL_LOGS].slice(0, MAX_KEEP);

        // 화면 반영
        prependLogs(newLogs);
        renderMapMarkers(newLogs);
        updateSummaryCounts(ALL_LOGS); // ✅ 요약 카드 갱신
      }
    } catch (err) {
      console.error("❌ 실시간 감지 오류:", err);
    }
  }, 5000);
}

/*************************************************
 * ✅ 요약 카드 개수 갱신
 *************************************************/
function updateSummaryCounts(logs) {
  const helmetEl = document.getElementById("cntHelmet");
  const doubleEl = document.getElementById("cntDouble");
  if (!helmetEl || !doubleEl) return;

  let helmet = 0;
  let dbl = 0;

  logs.forEach((l) => {
    const t = (l.type || "").replace(/\s/g, ""); // 공백 제거
    if (t.includes("헬멧미착용")) helmet += 1;
    if (t.includes("2인탑승") || t.includes("2인이상탑승")) dbl += 1;
  });

  helmetEl.textContent = helmet;
  doubleEl.textContent = dbl;
}

/*************************************************
 * ✅ 로그 리스트 렌더링
 *************************************************/
function renderLogs(logs) {
  const container = document.getElementById("historyList");
  if (!container) return;
  container.innerHTML = "";
  logs.forEach((log) =>
    container.insertAdjacentHTML("beforeend", logItemHTML(log))
  );
}

/*************************************************
 * ✅ 새 로그 상단에 추가 (20개 유지)
 *************************************************/
function prependLogs(newLogs) {
  const container = document.getElementById("historyList");
  if (!container) return;

  // 새 로그들을 상단에 추가
  newLogs.forEach(log => {
    container.insertAdjacentHTML("afterbegin", logItemHTML(log));
  });

  // ✅ 20개 초과 시 하단 오래된 항목 제거
  const items = container.querySelectorAll("li");
  if (items.length > MAX_KEEP) {
    for (let i = MAX_KEEP; i < items.length; i++) {
      items[i].remove();
    }
  }
}

/*************************************************
 * ✅ 항목 템플릿 (한 줄 정렬)
 *************************************************/
function logItemHTML(log) {
  const color =
    log.type?.includes("헬멧") ? "#3a46ff" :
    log.type?.includes("2인") ? "#12c06a" : "#999999";

  return `
    <li class="log-item" style="display:flex;justify-content:space-between;align-items:center;">
      <div class="left-info" style="display:flex;align-items:center;gap:8px;">
        <span class="dot" style="color:${color}">●</span>
        <span class="type" style="font-weight:bold;">${log.type}</span>
      </div>
      <span class="date" style="flex:1;text-align:center;color:#555;">
        ${log.date || "날짜 없음"}
      </span>
      <span class="loc" style="width:130px;text-align:right;">
        ${log.loc || ""}
      </span>
    </li>
  `;
}

/*************************************************
 * ✅ 지도 마커 표시 (같은 카메라 감지이력 묶기)
 *************************************************/
function renderMapMarkers(logs) {
  if (!(window.naver && naver.maps && window.mapInstance)) return;

  const grouped = {};
  logs.forEach((log) => {
    if (!grouped[log.camera_id]) grouped[log.camera_id] = [];
    grouped[log.camera_id].push(log);
  });

  Object.values(grouped).forEach((group) => {
    const sample = group[0];
    const color =
      group.some((l) => l.type?.includes("헬멧")) ? "#3a46ff" :
      group.some((l) => l.type?.includes("2인")) ? "#12c06a" : "#999999";

    const listHTML = group
      .map(
        (l) => `
          <div style="margin-bottom:4px;">
            <b>${l.type}</b><br>
            <span style="font-size:12px;color:gray;">${l.date}</span>
          </div>`
      )
      .join("<hr style='margin:3px 0;border:none;border-top:1px dotted #ccc;'>");

    const marker = new naver.maps.Marker({
      position: new naver.maps.LatLng(sample.latitude, sample.longitude),
      map: window.mapInstance,
      icon: {
        content: `<div style="
          width:12px;height:11px;
          background:${color};
          border-radius:50%;
          box-shadow: 0 0 3px rgba(0,0,0,0.25);
        "></div>`, // ✅ 검은 테두리 제거, 그림자만
      },
    });

    const info = new naver.maps.InfoWindow({
      content: `
        <div style="padding:6px;min-width:160px;">
          <div style="margin-bottom:4px;">
            <b>📍 ${sample.loc}</b>
          </div>
          ${listHTML}
        </div>`,
    });

    naver.maps.Event.addListener(marker, "click", () => {
      info.open(window.mapInstance, marker);
    });
  });
}

/*************************************************
 * ✅ 지도 초기화
 *************************************************/
function initNaverMap() {
  const mapElement = document.getElementById("map");
  if (!mapElement) return console.error("❌ map 요소를 찾을 수 없습니다.");

  window.mapInstance = new naver.maps.Map(mapElement, {
    center: new naver.maps.LatLng(35.159545, 126.852601),
    zoom: 12,
  });

  // ✅ 지도 로드 후 범례 표시
    const legend = document.getElementById("mapLegend");
    if (legend) legend.style.display = "block";
  }
/*************************************************
 * ✅ 감지 유형별 필터링
 *************************************************/
function setupFilterButtons() {
  const helmetBtn = document.getElementById("btnHelmet");
  const doubleBtn = document.getElementById("btnDouble");

  if (!helmetBtn || !doubleBtn) {
    console.warn("⚠ 필터 버튼을 찾을 수 없습니다.");
    return;
  }

  helmetBtn.addEventListener("click", () => {
    const filtered = ALL_LOGS.filter((log) => log.type.includes("헬멧"));
    renderLogs(filtered);
    highlightButton(helmetBtn);
  });

  doubleBtn.addEventListener("click", () => {
    const filtered = ALL_LOGS.filter((log) => log.type.includes("2인"));
    renderLogs(filtered);
    highlightButton(doubleBtn);
  });
}

/*************************************************
 * ✅ 버튼 클릭 시 강조 표시
 *************************************************/
function highlightButton(activeBtn) {
  document.querySelectorAll(".summary-card").forEach((btn) => {
    btn.style.outline = "none";
    btn.style.boxShadow = "none";
    btn.style.transform = "none";
  });
  activeBtn.style.outline = "2px solid #0e3ea9";
  activeBtn.style.boxShadow = "0 0 8px rgba(14,62,169,0.3)";
  activeBtn.style.transform = "translateY(-1px)";
}
