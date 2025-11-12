// ================================
// 📍 MapHandler.js (UTF-8, ES 모듈 버전)
// ================================

export let map;
export let cameraMarkers = [];



// ✅ 지도 초기화
export async function initNaverMap(ctx) {
  const mapElement = document.getElementById("map");
  if (!mapElement) {
    console.error("❌ 지도 요소를 찾을 수 없습니다.");
    return;
  }

  if (!(window.naver && naver.maps)) {
    console.error("❌ 네이버 지도 스크립트가 로드되지 않았습니다.");
    return;
  }

  // 지도 생성
  map = new naver.maps.Map("map", {
    center: new naver.maps.LatLng(35.1605, 126.8514),
    zoom: 13,
    mapTypeControl: true,
  });

  // ✅ 감지 데이터 불러오기
  try {
    const res = await fetch(`${ctx}/api/mapdata`);
    const raw = await res.text();
    let detections;
    try {
      detections = JSON.parse(raw);
    } catch (e) {
      console.error("⚠️ /api/mapdata 응답 원문 >>>\n", raw);
      throw e;
    }

    if (!Array.isArray(detections)) {
      console.error("❌ /api/mapdata 응답이 배열이 아닙니다:", detections);
      return;
    }

    detections.forEach((log, idx) => addDetectionMarker(log, idx < 5));
    showMapLegend();

  } catch (err) {
    console.error("❌ 지도 데이터 로드 실패:", err);
  }
}

// ✅ 범례 표시
function showMapLegend() {
  const legendEl = document.getElementById("mapLegend");
  if (!legendEl || !window.map) return;

  if (!window.naver || !naver.maps || !naver.maps.Position) {
    setTimeout(showMapLegend, 300);
    return;
  }

  legendEl.style.display = "block";
  map.controls[naver.maps.Position.LEFT_BOTTOM].push(legendEl);
  console.log("✅ 지도 범례 표시 완료");
}

// ✅ 감지 마커 표시 (최근 5개는 빨강, 나머지는 유형 색상)
// ✅ 감지 마커 표시 (최근 5개는 빨강, 나머지는 유형 색상)
export function addDetectionMarker(log, isRecent = false) {
  if (!map || !naver.maps) return;
  if (!log.latitude || !log.longitude) return;

  // 기존 마커가 너무 많이 쌓이지 않도록 초기화
  if (cameraMarkers.length > 0) {
    cameraMarkers.forEach(m => m.setMap(null)); // 지도에서 제거
    cameraMarkers = []; // 배열 비움
  }

  // ✅ 카메라/좌표 디버그
  console.debug("[Marker]", { det_id: log.det_id, camera_id: log.camera_id, 
                               lat: log.latitude, lng: log.longitude, reg_date: log.reg_date });

  // 색상
  const baseColor = isRecent ? "#ff0000" : (log.type.includes("2인") ? "#007bff" : "#ff4d4d");

  const marker = new naver.maps.Marker({
    position: new naver.maps.LatLng(log.latitude, log.longitude),
    map,
    icon: {
      content: `<div style="width:14px;height:14px;background:${baseColor};
                           border-radius:50%;
                           border:2px solid #fff;
                           box-shadow:0 0 6px rgba(0,0,0,.3);"></div>`,
      anchor: new naver.maps.Point(7, 7),
    },
  });

  // 카메라별 집계
  const camLogs = getCameraLogs(log.camera_id);
  const helmetCnt = camLogs.filter(l => l.type.includes("미착용")).length;
  const doubleCnt = camLogs.filter(l => l.type.includes("2인")).length;
  const recentDate = getRecentDate(camLogs);

  const infoWindow = new naver.maps.InfoWindow({
    content: `
      <div style="background:#fff;padding:8px 10px;border-radius:8px;
                  box-shadow:0 2px 8px rgba(0,0,0,.2);
                  font-size:13px;line-height:1.5;color:#333;min-width:160px;">
        <strong>📷 해당 카메라 감지내역</strong><br>
        헬멧 미착용: <span style="color:#ff4d4d;font-weight:bold">${helmetCnt}</span>건<br>
        2인 탑승: <span style="color:#007bff;font-weight:bold">${doubleCnt}</span>건<br>
        <hr style="margin:5px 0;border:0;border-top:1px solid #eee;">
        <span style="font-size:12px;color:#555;">최근 감지: ${recentDate}</span>
      </div>
    `,
    backgroundColor: "transparent",
    borderWidth: 0,
    disableAnchor: true,
  });

  naver.maps.Event.addListener(marker, "mouseover", () => infoWindow.open(map, marker));
  naver.maps.Event.addListener(marker, "mouseout", () => infoWindow.close());

  cameraMarkers.push(marker);
}


function getCameraLogs(cameraId) {
  try {
    if (!window.allLogs) return [];
    return window.allLogs.filter(l => String(l.camera_id) === String(cameraId));
  } catch (err) {
    console.error("카메라 로그 추출 오류:", err);
    return [];
  }
}

// ✅ 최근 감지 날짜 계산
function getRecentDate(camLogs) {
  if (!camLogs || camLogs.length === 0) return "없음";
  const sorted = [...camLogs].sort((a, b) => new Date(b.reg_date) - new Date(a.reg_date)); // ✅
  return sorted[0].reg_date ?? "없음"; // ✅
}