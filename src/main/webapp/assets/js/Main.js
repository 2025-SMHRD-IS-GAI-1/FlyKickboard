
var ctx = document.body.getAttribute("data-ctx") || "";

// -----------------------------
// DOM 로드 후 실행
// -----------------------------
document.addEventListener("DOMContentLoaded", function () {

  // ========================
  // 상단 메뉴 버튼
  // ========================

  // 실시간
  var realtimeBtn = document.querySelector(".nav-btn[data-route='main']");
  if (realtimeBtn) {
    realtimeBtn.addEventListener("click", function () {
      window.location.href = ctx + "/Main.jsp";
    });
  }

  // 감지이력
  var logsBtn = document.querySelector(".nav-btn[data-route='logs']");
  if (logsBtn) {
    logsBtn.addEventListener("click", function () {
      window.location.href = ctx + "/Logs.jsp";
    });
  }

  // 관리자
  var adminBtn = document.querySelector(".admin-btn");
  if (adminBtn) {
    adminBtn.addEventListener("click", function () {
      window.location.href = ctx + "/Manager.jsp";
    });
  }

  // 로그아웃
  var logoutBtn = document.querySelector(".login-btn");
  if (logoutBtn) {
    logoutBtn.addEventListener("click", function () {
      alert("로그아웃 되었습니다.");
      window.location.href = ctx + "/Login.jsp";
    });
  }

  // ========================
  // 지도 + 최근 이력 불러오기
  // ========================
  initNaverMapAndLoad();
  loadRecentHistory();
});

// -----------------------------
// Naver Map 초기화 + 데이터 표시
// -----------------------------
function initNaverMapAndLoad() {
  try {
    fetch(ctx + "/api/mapdata", { headers: { "Accept": "application/json" } })
      .then(function (res) {
        if (!res.ok) throw new Error("지도 데이터 응답 오류");
        return res.json();
      })
      .then(function (points) {
        var center;
        if (points.length > 0) {
          center = new naver.maps.LatLng(points[0].lat, points[0].lng);
        } else {
          center = new naver.maps.LatLng(35.1605, 126.8514);
        }

        var map = new naver.maps.Map("map", {
          center: center,
          zoom: 14,
          mapTypeControl: true
        });

        // 범례 표시
        var legendEl = document.getElementById("mapLegend");
        if (legendEl) {
          legendEl.style.display = "block";
          map.controls[naver.maps.Position.LEFT_BOTTOM].push(legendEl);
        }

        // 붉은 번짐 원 표시
        points.forEach(function (p) {
          var position = new naver.maps.LatLng(p.lat, p.lng);
          new naver.maps.Circle({
            map: map,
            center: position,
            radius: 160,
            strokeOpacity: 0,
            fillColor: "#ff0000",
            fillOpacity: 0.25
          });
        });
      })
      .catch(function (e) {
        console.error(e);
        createEmptyMap();
      });
  } catch (e) {
    console.error(e);
    createEmptyMap();
  }
}

// 지도 생성 실패 시 기본 지도 표시
function createEmptyMap() {
  var map = new naver.maps.Map("map", {
    center: new naver.maps.LatLng(35.1605, 126.8514),
    zoom: 14
  });
  var legendEl = document.getElementById("mapLegend");
  if (legendEl) {
    legendEl.style.display = "block";
    map.controls[naver.maps.Position.LEFT_BOTTOM].push(legendEl);
  }
}

// -----------------------------
// 최근 감지 이력 + 카운트
// -----------------------------
function loadRecentHistory() {
  try {
    fetch(ctx + "/api/history/recent", { headers: { "Accept": "application/json" } })
      .then(function (res) {
        if (!res.ok) throw new Error("최근 이력 응답 오류");
        return res.json();
      })
      .then(function (list) {
        // 카운트 계산
        var helmetCnt = list.filter(function (x) { return x.type === "헬멧 미착용"; }).length;
        var doubleCnt = list.filter(function (x) { return x.type === "2인 탑승"; }).length;

        var elHelmet = document.getElementById("cntHelmet");
        var elDouble = document.getElementById("cntDouble");
        if (elHelmet) elHelmet.textContent = helmetCnt;
        if (elDouble) elDouble.textContent = doubleCnt;

        // 최근 이력 리스트 렌더링
        var ul = document.getElementById("historyList");
        if (!ul) return;
        ul.innerHTML = "";

        list.slice(0, 10).forEach(function (item) {
          var li = document.createElement("li");
          li.innerHTML =
            '<div>' +
            '<span class="dot ' + (item.type === "2인 탑승" ? "double" : "helmet") + '" aria-hidden="true"></span>' +
            '<strong>' + escapeHtml(item.type) + '</strong>' +
            '<span class="time">' + escapeHtml(item.time || "") + '</span>' +
            '</div>' +
            '<span class="region">' + escapeHtml(item.location || "") + '</span>';
          ul.appendChild(li);
        });
      })
      .catch(function (e) {
        console.error(e);
      });
  } catch (e) {
    console.error(e);
  }
}

// HTML 안전 출력
function escapeHtml(s) {
  if (s == null) return "";
  return String(s)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");
}
