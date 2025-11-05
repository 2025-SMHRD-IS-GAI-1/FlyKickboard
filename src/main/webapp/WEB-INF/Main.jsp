<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="javax.websocket.Session"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>AI기반 킥보드 위반 감지 대시보드</title>
  <link rel="stylesheet" href="${ctx}/assets/css/MainPage.css" />
  <link rel="stylesheet" href="${ctx}/assets/css/ManagerPage.css" /> 
  <link rel="stylesheet" href="${ctx}/assets/css/LogsPage.css" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;600;700&display=swap" rel="stylesheet" />

  <!--  네이버 지도 API (YOUR_CLIENT_ID를 실제 키로 교체하세요) -->
  <script type="text/javascript"
    src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=azilk7tpsg">

  document.addEventListener("DOMContentLoaded", () => {
	  initNaverMapAndLoad();   // 지도 + 마커
	  loadRecentHistory();     // 최근 이력 + 카운트
	});

	/* 지도와 마커 */
	async function initNaverMapAndLoad() {
	  try {
	    // DB에서 좌표/유형/시간/위치 등 가져오기
	    const res = await fetch("/api/mapdata", { headers: { "Accept": "application/json" } });
	    if (!res.ok) throw new Error("지도 데이터 응답 오류");
	    const points = await res.json(); // [{lat,lng,type,time,location}, ...]

	    // 초기 중심
	    const center = points.length
	      ? new naver.maps.LatLng(points[0].lat, points[0].lng)
	      : new naver.maps.LatLng(35.1605, 126.8514);

	    const map = new naver.maps.Map("map", {
	      center,
	      zoom: 14,
	      mapTypeControl: true
	    });

	    /* 지도 생성 직후 위반유형 범례 */
	    const legendEl = document.getElementById("mapLegend");
	    if (legendEl) {
	      legendEl.style.display = "block";
	      document.getElementById("map").appendChild(legendEl);
	    }

	    /* 붉은 번짐 원 */
	    points.forEach((p) => {
	      const position = new naver.maps.LatLng(p.lat, p.lng);
	      new naver.maps.Circle({
	        map,
	        center: position,
	        radius: 160,
	        strokeOpacity: 0,
	        fillColor: "#ff0000",
	        fillOpacity: 0.25
	      });
	    });

	  } catch (e) {
	    console.error(e);

	    //  지도가 필수라면 빈 지도라도 생성
	    const map = new naver.maps.Map("map", {
	      center: new naver.maps.LatLng(35.1605, 126.8514),
	      zoom: 14
	    });

	    // 지도 안쪽 좌하단에 범례 추가
	    const legendEl = document.getElementById("mapLegend");
	    if (legendEl) {
	      legendEl.style.display = "block";
	      document.getElementById("map").appendChild(legendEl); 
	    }
	  }
	} 



	    // 범례 표시
	    const legendEl = document.getElementById("mapLegend");
	    if (legendEl) {
	      legendEl.style.display = "block";
	      map.controls[naver.maps.Position.LEFT_BOTTOM].push(legendEl);
	    }
  </script>

</head>
<body>
  <div class="container">
   <!-- 상단 헤더 -->
    <header class="header">
      <div class="logo">날아라킥보드</div>
      <nav class="nav" aria-label="주요 탭">
      	<a href="Main.do">
      		<button class="nav-btn" type="button">실시간</button>
      	</a>
      	<a href="Logs.do">
      		<button class="nav-btn" type="button">감지 이력 조회</button>
      	</a>      
      </nav>
      
      <div class="actions" aria-label="사용자 메뉴">
      <a href="Manager.do">
      	<button class="admin-btn active" type="button" aria-current="page">관리자 메뉴</button>
      </a>
        
        <button class="login-btn" type="button" data-action="logout">로그아웃</button>
      </div>
    </header>

    <!-- 메인 콘텐츠 -->
    <main class="main-content">
      <section class="map-section" aria-labelledby="mapTitle">
        <h2 id="mapTitle">감지 위치</h2>
        
        <!--  실제 네이버 지도가 표시될 영역 -->
        <div id="map" style="position:relative; overflow:hidden; 
            width:100%; height:700px; border-radius:12px;"></div>
            
        <!-- 위반유형 -->
          <div id="mapLegend" class="map-legend" style="display:none">
          <strong class="legend-title">위반유형</strong>
          <div class="legend-item"><span class="dot helmet" aria-hidden="true"></span> 헬멧 미착용</div>
          <div class="legend-item"><span class="dot double" aria-hidden="true"></span> 2인 이상 탑승</div>
        </div>    
      </section>

      <!-- 최근 감지 이력 -->
      <section class="history-section" aria-labelledby="historyTitle">
        <h2 id="historyTitle">최근 감지 이력</h2>

        <div class="summary-box" role="group" aria-label="감지 요약">
          <div class="summary-card helmet" aria-label="헬멧 미착용 건수">
            <div class="count" id="cntHelmet">0</div>
            <p>헬멧 미착용</p>
          </div>
          <div class="summary-card double" aria-label="2인 탑승 건수">
            <div class="count" id="cntDouble">0</div>
            <p>2인 탑승</p>
          </div>
        </div>

        <ul id="historyList" >
          <!-- JS에서 li 자동 추가 -->
        </ul>
      </section>
    </main>
  </div>

  
  

  <!--  main.js (지도+데이터 로직) -->
  <script src="${ctx}/assets/js/Main.js"></script>

</body>
</html>

