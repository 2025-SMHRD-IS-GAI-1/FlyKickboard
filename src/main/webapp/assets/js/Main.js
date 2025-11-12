console.log("Main.js 로드됨");
/************** 전역 상태 **************/
let ALL_LOGS = [];     // 최근 20개 유지
const MAX_KEEP = 20;
let sharedInfoWindow = null;
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
 * ✅ 초기 20건 로드 (항상 최신순으로 정렬)
 *************************************************/
async function loadLogs() {
  try {
    const ctx = document.body.dataset.ctx || "";
    const res = await fetch(`${ctx}/LogType.do`);
    if (!res.ok) throw new Error("서버 응답 오류");

    const logs = await res.json();

    // ✅ 1. 항상 최신순(내림차순) 정렬
    ALL_LOGS = Array.isArray(logs)
      ? logs.sort((a, b) => new Date(b.date) - new Date(a.date)).slice(0, MAX_KEEP)
      : [];

    // ✅ 2. 렌더링
    renderLogs(ALL_LOGS);
    renderMapMarkers(ALL_LOGS);
    updateSummaryCounts(ALL_LOGS);
  } catch (err) {
    console.error("❌ 감지 로그 불러오기 실패:", err);
  }
}

let monitorInterval = null;
let isMonitorRunning = false;

// 실시간
function startRealTimeMonitor() {
  // 🔹 기존 인터벌이 있다면 먼저 제거
  if (monitorInterval) {
    clearInterval(monitorInterval);
    monitorInterval = null; // ✅ 완전 초기화
    isMonitorRunning = false; // ✅ 상태 리셋
    console.warn("🧹 기존 실시간 모니터 인터벌 제거됨");
  }

  // 🔹 이미 실행 중이면 중복 실행 방지
  if (isMonitorRunning) {
    console.warn("⚠️ startRealTimeMonitor 이미 실행 중 — 중복 방지");
    return;
  }

  isMonitorRunning = true; // ✅ 한 번만 실행
  console.log("🚀 실시간 모니터 시작됨");

  let lastId = 0;

  monitorInterval = setInterval(async () => {
    try {
      const ctx = document.body.dataset.ctx || "";
      const res = await fetch(`${ctx}/LogAfter.do?sinceId=${lastId}`);
      if (!res.ok) return;

      const newLogs = await res.json();
      if (!Array.isArray(newLogs)) return;

      // ✅ 중복 제거 (이미 있는 det_id는 무시)
      let filtered = newLogs.filter(
        (n) => !ALL_LOGS.some((a) => a.det_id === n.det_id)
      );

      // ✅ 새 로그가 전혀 없으면 아무것도 안 그리기
      if (filtered.length === 0) return;

      // ✅ 새 로그가 있을 때만 정렬 + lastId 갱신
      filtered.sort((a, b) => new Date(b.date) - new Date(a.date));
      lastId = Math.max(...filtered.map((l) => Number(l.det_id)));

      // ✅ 새 로그를 기존 로그 앞에 추가
      ALL_LOGS = [...filtered, ...ALL_LOGS]
        .sort((a, b) => new Date(b.date) - new Date(a.date))
        .slice(0, MAX_KEEP);

      // ✅ 필터 유지
      const filter = (window.AppState && AppState.filter) || null;
      let displayLogs = ALL_LOGS;
      if (filter === "helmet") {
        displayLogs = ALL_LOGS.filter((l) => (l.type || "").includes("헬멧"));
      } else if (filter === "double") {
        displayLogs = ALL_LOGS.filter((l) => (l.type || "").includes("2인"));
      }

      // ✅ 새 로그 있을 때만 렌더링
      renderLogs(displayLogs);
      renderMapMarkers(displayLogs);
      updateSummaryCounts(ALL_LOGS);

      console.log(
        `📡 새 로그 ${filtered.length}건, 마지막 ID: ${lastId}, 전체 ${ALL_LOGS.length}건`
      );
    } catch (err) {
      console.error("❌ 실시간 감지 오류:", err);
    }
  }, 2000);
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
    if (t.includes("2인 탑승") || t.includes("2인이상탑승")) dbl += 1;
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
    <li class="log-item">
      <div class="left-info" style="display:flex;align-items:center;gap:8px;">
        <span class="dot" style="color:${color}">●</span>
        <span class="type" style="font-weight:bold;">${log.type}</span>
      </div>
      <span class="region" style="flex:1;text-align:center;color:#555;">
        ${log.loc || ""}
      </span>
      <span class="time" style="width:130px;text-align:right;">
        ${log.date || "날짜 없음"}
      </span>
    </li>
  `;
}

/*************************************************
 * ✅ 지도 마커 표시 (같은 카메라 감지이력 묶기 + 다중 감지 표시)
 *************************************************/
function renderMapMarkers(logs) {
  if (!(window.naver && naver.maps && window.mapInstance)) return;

  // ✅ 기존 마커 완전 제거 (이벤트까지 포함)
  if (window.cameraMarkers && window.cameraMarkers.length > 0) {
    window.cameraMarkers.forEach(m => {
      naver.maps.Event.clearInstanceListeners(m);
      m.setMap(null);
    });
  }
  window.cameraMarkers = [];

  // ✅ 카메라 ID 기준으로 그룹화
  const grouped = {};
  logs.forEach((log) => {
    if (!grouped[log.camera_id]) grouped[log.camera_id] = [];
    grouped[log.camera_id].push(log);
  });

  // ✅ 공용 InfoWindow (전역 1개만 사용)
  if (!sharedInfoWindow) {
    sharedInfoWindow = new naver.maps.InfoWindow({
      backgroundColor: "transparent",
      borderColor: "transparent",
      borderWidth: 0,
      anchorSize: new naver.maps.Size(0, 0),
      disableAnchor: true,
      pixelOffset: new naver.maps.Point(0, -6)
    });
  }

  // ✅ 그룹별 마커 생성
  Object.values(grouped).forEach((group) => {
    const sample = group[0];
    const color =
      group.some((l) => l.type?.includes("헬멧")) ? "#3a46ff" :
      group.some((l) => l.type?.includes("2인")) ? "#12c06a" : "#999999";

    const marker = new naver.maps.Marker({
      position: new naver.maps.LatLng(sample.latitude, sample.longitude),
      map: window.mapInstance,
      icon: {
        content: `
          <div class="fk-marker" style="--mk:${color}">
            <span class="halo"></span>
            <span class="core"></span>
          </div>
        `,
        anchor: new naver.maps.Point(12, 12),
      },
    });

    // ✅ 클릭 시 InfoWindow 내용 갱신
    naver.maps.Event.addListener(marker, "click", () => {
      // 감지유형별 색상 구분 (파랑=헬멧, 초록=2인)
      const detectionsHTML = group
        .map((item, idx) => {
          const itemColor = item.type?.includes("헬멧")
            ? "#3a46ff"
            : item.type?.includes("2인")
            ? "#12c06a"
            : "#555";
          return `
            <div class="det-row" style="margin-bottom:4px;">
              <span style="font-weight:bold;color:${itemColor};">
                ${idx + 1}. ${item.type}
              </span><br>
              <span style="font-size:11px;color:#666;">${item.date}</span>
            </div>
          `;
        })
        .join("<hr style='border:none;border-top:1px solid #ddd;margin:4px 0;'>");

      const content = `
        <div class="fk-infowin" style="min-width:180px;">
          <button class="close-btn"
            onclick="this.parentElement.style.display='none'"
            style="position:absolute;top:2px;right:4px;border:none;background:none;font-size:14px;cursor:pointer;">×</button>
          <div class="tit"
            style="font-weight:bold;font-size:13px;color:#0e3ea9;margin-bottom:6px;">
            ${sample.loc || ""}
          </div>
          <div style="max-height:150px;overflow-y:auto;padding-right:4px;">
            ${detectionsHTML}
          </div>
        </div>
      `;

      sharedInfoWindow.setContent(content);
      sharedInfoWindow.open(window.mapInstance, marker);
    });

    // ✅ 마커 배열에 저장
    window.cameraMarkers.push(marker);
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
    zoom: 12, // 초기 확대 비율
  });

  // ✅ 줌 변경 시 크기 리셋 (커짐 방지)
  naver.maps.Event.addListener(window.mapInstance, "zoom_changed", () => {
    document.documentElement.style.setProperty("--marker-scale", 1);
  });

  // ✅ 범례 표시
  const legend = document.getElementById("mapLegend");
  if (legend) legend.style.display = "block";
}
  /*************************************************
   * ✅ 감지 유형별 필터링 (반복 토글 + 개수 항상 유지)
   *************************************************/
  function setupFilterButtons() {
    const helmetBtn = document.getElementById("btnHelmet");
    const doubleBtn = document.getElementById("btnDouble");

    if (!helmetBtn || !doubleBtn) {
      console.warn("⚠ 필터 버튼을 찾을 수 없습니다.");
      return;
    }

    // ✅ 전역 상태 관리
    if (!window.AppState) window.AppState = { filter: null };

    const applyFilter = (filterType, btn) => {
      const currentFilter = AppState.filter;

      // 🔹 같은 버튼 다시 클릭 → 전체 보기로 복귀
      if (currentFilter === filterType) {
        AppState.filter = null;
        renderLogs(ALL_LOGS);
        renderMapMarkers(ALL_LOGS);
        updateSummaryCounts(ALL_LOGS); // ✅ 전체 기준으로
        highlightButton(null);
        return;
      }

      // 🔹 새 필터 적용
      AppState.filter = filterType;
      let filtered = [];

      if (filterType === "helmet") {
        filtered = ALL_LOGS.filter((log) => (log.type || "").includes("헬멧"));
      } else if (filterType === "double") {
        filtered = ALL_LOGS.filter((log) => (log.type || "").includes("2인"));
      }

      renderLogs(filtered);
      renderMapMarkers(filtered);
      updateSummaryCounts(ALL_LOGS); // ✅ 필터 상태여도 전체 로그 기준으로
      highlightButton(btn);
    };

    // ✅ 이벤트 등록
    helmetBtn.addEventListener("click", () => applyFilter("helmet", helmetBtn));
    doubleBtn.addEventListener("click", () => applyFilter("double", doubleBtn));
  }
  /*************************************************
   * ✅ 버튼 강조 표시 (활성/비활성 시각적 구분)
   *************************************************/
  function highlightButton(activeBtn) {
    const buttons = [document.getElementById("btnHelmet"), document.getElementById("btnDouble")];

    buttons.forEach((btn) => {
      if (!btn) return;
      if (btn === activeBtn) {
        btn.style.outline = "2px solid #0e3ea9";
        btn.style.boxShadow = "0 0 8px rgba(14,62,169,0.4)";
        btn.style.transform = "translateY(-1px)";
      } else {
        btn.style.outline = "none";
        btn.style.boxShadow = "none";
        btn.style.transform = "none";
      }
    });
  }

  
  /*코드추가 */
