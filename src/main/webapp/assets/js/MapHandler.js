// ================================
// 📍 MapHandler.js
// - 감지 이력 데이터만 지도에 표시
// ================================

export let map;
export let cameraMarkers = [];

// ✅ 지도 초기화 (지도만 생성)
export async function initNaverMap(ctx) {
  const mapElement = document.getElementById("map");
  if (!mapElement) {
    console.error("❌ 지도 요소(#map)를 찾을 수 없습니다.");
    return;
  }

  if (!(window.naver && naver.maps)) {
    console.error("❌ 네이버 지도 스크립트가 로드되지 않았습니다.");
    return;
  }

  // 지도 기본 중심 (광주)
  map = new naver.maps.Map("map", {
    center: new naver.maps.LatLng(35.1605, 126.8514),
    zoom: 13,
    mapTypeControl: true,
  });

  // ✅ 지도 초기화가 완료된 후 범례 표시 시도
  setTimeout(showMapLegend, 300);
}

// ✅ 범례 표시 (로드 안 된 경우 자동 재시도)
function showMapLegend() {
  const legendEl = document.getElementById("mapLegend");

  // 🧩 요소 또는 지도 객체가 아직 없으면 종료
  if (!legendEl || !window.map) return;

  // 🧩 naver.maps.Position이 아직 준비 안 된 경우 재시도
  if (!window.naver || !naver.maps || !naver.maps.Position) {
    console.warn("⚠️ 네이버 지도 아직 로드 안됨 → 0.3초 후 재시도");
    setTimeout(showMapLegend, 300);
    return;
  }

  // ✅ 정상적으로 범례 추가
  legendEl.style.display = "block";
  map.controls[naver.maps.Position.LEFT_BOTTOM].push(legendEl);
  console.log("✅ 지도 범례 표시 완료");
}

// ✅ 감지 마커 표시 (isNew = true면 빨간색 표시)
export function addDetectionMarker(log, isNew = false) {
  if (!map || !naver.maps) return;
  if (!log.latitude || !log.longitude) return;

  const baseColor = log.type.includes("2인") ? "#007bff" : "#ff4d4d";
  const color = isNew ? "#ff0000" : baseColor;

  const marker = new naver.maps.Marker({
    position: new naver.maps.LatLng(log.latitude, log.longitude),
    map,
    icon: {
      content: `<div style="
          width:14px;
          height:14px;
          background:${color};
          border-radius:50%;
          border:2px solid white;
          box-shadow:0 0 6px rgba(0,0,0,0.3);
        "></div>`,
      anchor: new naver.maps.Point(7, 7),
    },
  });

  // 🔄 신규 감지는 4초 후 원래 색으로 복귀
  if (isNew) {
    setTimeout(() => {
      marker.setIcon({
        content: `<div style="
            width:14px;
            height:14px;
            background:${baseColor};
            border-radius:50%;
            border:2px solid white;
          "></div>`,
        anchor: new naver.maps.Point(7, 7),
      });
    }, 4000);
  }

  cameraMarkers.push(marker);
}
