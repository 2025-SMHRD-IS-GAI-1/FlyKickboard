/*페이지 로드 시 초기 실행*/
window.addEventListener("load", () => {
  setupLogout();
  initNaverMap();
  loadLogs();
  setupFilterButtons();
});

if(session == "") {
	window.location.href="GoLogin.do";
} 
/*로그아웃 버튼 클릭 알림*/
function setupLogout() {
  const logoutBtn = document.querySelector(".login-btn");
  if (logoutBtn) {
    logoutBtn.addEventListener("click", () => alert("로그아웃 되었습니다."));
  }
}


/* 네이버 지도 + 붉은 반경 표시*/
async function initNaverMap() {
  const mapElement = document.getElementById("map");
  if (!mapElement) return;

  if (!(window.naver && naver.maps)) {
    console.error("❌ 네이버 지도 스크립트 로드가 필요합니다.");
    return;
  }

  try {
    const res = await fetch("/api/mapdata");
    const points = res.ok ? await res.json() : [];

    const center = points.length
      ? new naver.maps.LatLng(points[0].lat, points[0].lng)
      : new naver.maps.LatLng(35.1605, 126.8514);

    window.map = new naver.maps.Map("map", {
      center,
      zoom: 14,
      mapTypeControl: true
    });

    points.forEach(p => {
      new naver.maps.Circle({
        map: window.map,
        center: new naver.maps.LatLng(p.lat, p.lng),
        radius: 160,
        strokeOpacity: 0,
        fillColor: "#ff0000",
        fillOpacity: 0.25
      });
    });

    showMapLegend();
  } catch (err) {
    console.error("지도 데이터 로딩 실패:", err);
  }
}


/* 범례 표시*/
function showMapLegend() {
  const legendEl = document.getElementById("mapLegend");
  if (!(legendEl && window.map && naver.maps && naver.maps.Position)) return;
  
  legendEl.style.display = "block";
  window.map.controls[naver.maps.Position.LEFT_BOTTOM].push(legendEl);
}


/*감지 로그 데이터 로드*/
let allLogs = [];
let noHelmet = [];
let doublepl = [];

function loadLogs() {
  fetch("LogType.do", {
    method: "POST",
    headers: { "Content-Type": "application/json" }
  })
    .then(res => res.json())
    .then(data => {
      allLogs = data;
      noHelmet = data.filter(d => d.type.includes("미착용"));
      doublepl = data.filter(d => d.type.includes("2인"));

      renderLogs(allLogs);
      updateCounts(allLogs);
    })
    .catch(err => console.error("데이터 로드 실패:", err));
}


/*************************************************
 * ✅ 감지 목록 화면 표시
 *************************************************/
/* 감지 목록 화면에 표시*/
function renderLogs(logs) {
  const historyList = document.getElementById("historyList");
  if (!historyList) return;

  historyList.innerHTML = "";

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


/*감지 건수 UI 업데이트*/
function updateCounts(logs) {
  document.getElementById("cntHelmet").textContent =
    logs.filter(l => l.type.includes("미착용")).length;

  document.getElementById("cntDouble").textContent =
    logs.filter(l => l.type.includes("2인")).length;
}


/* 버튼 토글(헬멧 / 2인탑승)*/
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