<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="javax.websocket.Session"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <title>감지 이력 조회 - 날아라킥보드</title>
  <link rel="stylesheet" href="${ctx}/assets/css/MainPage.css" />
  <link rel="stylesheet" href="${ctx}/assets/css/ManagerPage.css" /> 
  <link rel="stylesheet" href="${ctx}/assets/css/LogsPage.css" />
  <link rel="stylesheet" href="${ctx}/assets/css/Report.css" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;600;700&display=swap" rel="stylesheet" />
  <script type="text/javascript">
  	const session = "${login}";
  </script>
</head>

  
<body>
	<body data-ctx="${ctx}">
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
      <c:if test="${sessionScope.isAdmin}">
      	<a href="${ctx}/Manager.do">
          <button class="admin-btn active" type="button" aria-current="page">관리자 메뉴</button>
        </a>
      </c:if>
      <a href="Logout.do">
         <button class="login-btn" type="button" data-action="logout">로그아웃</button>
      </a>
        
      </div>
    </header>

    <!-- 본문 -->
    <main class="main-content" role="main">
      <section class="logs-section" aria-labelledby="logsTitle">
        <h2 id="logsTitle">감지 이력 조회</h2>
        <div class="toolbar">
  <div class="toolbar-left">
    <!-- 날짜 + 검색 -->
    <label><input type="date" id="startDate" /></label>
    <span>~</span>
    <label><input type="date" id="endDate" /></label>
    <button class="btn-search" type="button">검색</button>

    <!-- 분류 버튼 + 필터패널 -->
    <div class="filter-wrapper">
      <button class="btn-filter" id="btnFilter" type="button">분류</button>
      <div class="filter-panel" id="filterPanel" role="dialog" aria-label="분류 필터">
        <div class="filter-group">
          <span class="filter-label">상태</span>
          <button class="filter-option">전체</button>
          <button class="filter-option">처리전</button>
          <button class="filter-option">처리중</button>
          <button class="filter-option">처리완료</button>
        </div>
        <div class="filter-group">
          <span class="filter-label">감지 유형</span>
          <button class="filter-option">전체</button>
          <button class="filter-option">2인이상 탑승</button>
          <button class="filter-option">헬멧 미착용</button>
        </div>
      </div>
    </div>
  </div>


        <!-- 동작기능 버튼 -->
  <div class="toolbar-right">
   <button type="button" class="btn blue" id="btnStats">통계</button>
   <!-- ✅ Report 모달 -->
<div id="reportModal" class="report-modal">
  <div class="report-content">
    <button type="button" class="close-btn" id="closeReportBtn">×</button>
    
    <!-- 표지 -->
    <h2>📊 통계 보고서</h2>

    <!-- ① 지역별 통계 -->
    <section class="card" id="sec-3">
      <header class="card-header">
        <h3 class="card-title">지역별 통계</h3>
      </header>
      <div class="card-body">
        <section class="ui-grid" style="grid-template-columns:1fr 1fr; gap:16px;">
          
          <!-- 왼쪽: 그래프 -->
          <article class="card">
            <header class="card-header">
              <h4 class="card-title">지역별 감지건수</h4>
            </header>
            <div class="card-body">
              <div class="chart bar">
                <canvas id="regionBar2" height="240" aria-label="지역별 막대그래프"></canvas>
              </div>
            </div>
          </article>

          <!-- 오른쪽: 표 -->
          <article class="card">
            <header class="card-header">
              <h4 class="card-title">지역별 위반 통계</h4>
            </header>
            <div class="card-body">
              <table class="tbl region-table" id="regionTable2">
                <thead>
                  <tr><th>지역</th><th>건수</th><th>비율(%)</th></tr>
                </thead>
                <tbody>
                  <tr><td>광산구</td><td>—</td><td>—</td></tr>
                  <tr><td>북구</td><td>—</td><td>—</td></tr>
                  <tr><td>서구</td><td>—</td><td>—</td></tr>
                  <tr><td>남구</td><td>—</td><td>—</td></tr>
                  <tr><td>동구</td><td>—</td><td>—</td></tr>
                  <tr><td><strong>총 건수</strong></td><td>—</td><td></td></tr>
                </tbody>
              </table>
            </div>
          </article>

        </section>
      </div>
    </section>

    <!-- ② 위반 유형 통계 -->
    <section class="card" id="sec-4">
      <header class="card-header">
        <h3 class="card-title">위반 유형 통계</h3>
      </header>
      <div class="card-body">
        <section class="ui-grid" style="grid-template-columns:1fr 1fr; gap:16px;">
          
          <!-- 왼쪽: 도넛 -->
          <article class="card">
            <header class="card-header">
              <h4 class="card-title">위반유형별 비율</h4>
            </header>
            <div class="card-body">
              <div class="chart donut">
                <canvas id="typeDonut2" height="220" aria-label="위반유형 도넛차트"></canvas>
              </div>
              
            </div>
          </article>

          <!-- 오른쪽: 감지유형별 건수 -->
          <article class="card">
            <header class="card-header">
              <h4 class="card-title">감지유형별 건수</h4>
            </header>
            <div class="card-body">
              <table class="tbl compact">
                <thead>
                  <tr><th>감지유형</th><th>건수</th></tr>
                </thead>
                <tbody>
                  <tr><td class="left">헬멧 미착용</td><td></td></tr>
                  <tr><td class="left">2인이상 탑승</td><td></td></tr>
                  <tr><td class="left"><strong>총 건수</strong></td><td><strong></strong></td></tr>
                </tbody>
              </table>
            </div>
          </article>

        </section>
      </div>
    </section>

    <!-- ③ 선택 일자 시간대별 추이 -->
    <article class="card" id="selectedDayHourly">
      <header class="card-header">
        <h4 class="card-title">선택 일자 · 시간대별 감지 추이</h4>
      </header>
      <div class="card-body">
        <p id="selectedDateLabel" class="muted" style="margin:0 0 8px 0;">선택 일자: YYYY-MM-DD</p>
		
        <section class="ui-grid" style="grid-template-columns: 320px 1fr; gap:16px;">

          <!-- 왼쪽: 표 -->
          <div class="card" style="margin:0;">
            <header class="card-header">
              <h4 class="card-title">시간대별 건수</h4>
            </header>
            <div class="card-body">
              <table class="tbl compact" id="hourlyTable">
                <thead>
                  <tr><th>시간대</th><th>건수</th></tr>
                </thead>
                <tbody>
                  <tr><td>00:00 ~ 03:00</td><td>—</td></tr>
                  <tr><td>03:00 ~ 06:00</td><td>—</td></tr>
                  <tr><td>06:00 ~ 09:00</td><td>—</td></tr>
                  <tr><td>09:00 ~ 12:00</td><td>—</td></tr>
                  <tr><td>12:00 ~ 15:00</td><td>—</td></tr>
                  <tr><td>15:00 ~ 18:00</td><td>—</td></tr>
                  <tr><td>18:00 ~ 21:00</td><td>—</td></tr>
                  <tr><td>21:00 ~ 24:00</td><td>—</td></tr>
                  <tr><td><strong>총 건수</strong></td><td><strong>—</strong></td></tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- 오른쪽: 라인그래프 -->
          <div class="card" style="margin:0;">
            <header class="card-header">
              <h4 class="card-title">시간대 추이 그래프</h4>
            </header>
            <div class="card-body">
              <div class="chart line">
                <canvas id="selectedDayLine" height="220" aria-label="선택 일자 시간대별 추이"></canvas>
              </div>
            </div>
          </div>

        </section>
      </div>
    </article>
			<!-- 출력/닫기버튼 -->
			<footer class="report-actions" aria-label="보고서 동작">
 			 <button type="button" class="btn btn-primary" id="btnPrint">출력</button>
  			<button type="button" class="btn btn-outline" id="btnClose">닫기</button>
			</footer>

  </div>
</div>

    <button type="button" class="btn blue" id="btnSend">전송</button>

    
    <button type="button" class="btn red" id="btnDel">삭제</button>

  </div>
</div>



<!-- 감지이력 테이블 -->
<table class="logs-table" aria-label="감지 이력 테이블">
  <thead>
    <tr>
      <th scope="col">
        <input type="checkbox" id="checkAll" aria-label="전체 선택" />
      </th>
      <th data-sort="date" scope="col">날짜</th>
      <th data-sort="loc" scope="col">위치</th>
      <th data-sort="type" scope="col">감지 유형</th>
      <th data-sort="prog" scope="col">상세보기</th>
      <th scope="col">상세보기</th>
      <!-- ✅ 상세보기 열 추가 -->
    </tr>
  </thead>

  <tbody id="LogTable">
    <c:forEach var="log" items="${alllog}">
      <tr data-id="${log.det_id}">
        <td><input type="checkbox" /></td>
        <td>${log.date}</td>
        <td>${log.loc}</td>
        <td>${log.type}</td>
        <td>${log.prog}</td>
        <!-- ✅ 상세보기 버튼 추가 -->
        <td><button type="button" class="btn-detail">보기</button></td>
      </tr>
    </c:forEach>
  </tbody>
</table>

<!-- ✅ 상세보기 모달 -->
<div id="detailModal" class="detail-modal" aria-hidden="true" role="dialog" aria-modal="true">
  <div class="detail-dialog">

    <!-- 상단 상태 헤더 -->
    <header class="detail-header">
      <h3>상세보기</h3>
    </header>

    <!-- 감지유형 배지 -->
    <div class="detail-type">
      <span class="badge badge-type" id="detailType">헬멧 미착용</span>
    </div>

    <!-- 이미지 영역 -->
 <div class="detail-image">
  <img id="detailImage"
    src="https://search.pstatic.net/common/?src=http%3A%2F%2Fimgnews.naver.net%2Fimage%2F421%2F2021%2F05%2F11%2F0005343279_001_20210511130405447.jpg&type=sc960_832"
    alt="감지 장면"
  />
</div>

    <!-- 정보 영역 -->
    <div class="detail-info">
      <p><strong>날짜:</strong> <span id="detailDate">2025-10-17 14:32</span></p>
      <p><strong>위치:</strong> <span id="detailLoc">광천동</span></p>
      <p><strong>상태:</strong> <span class="status-badge complete" id="detailStatus">처리완료</span></p>
    </div>

    <!-- 닫기 버튼 -->
    <div class="detail-actions">
      <button type="button" class="btn blue" id="detailCloseBtn">닫 기</button>
    </div>

  </div>
</div>
<!-- ✅ 상세보기 모달 끝 -->





           <!-- 통계 박스 -->
        <div class="stats-box" aria-label="이력 통계">
        <div class="stat-item total">
        <span class="label">총 감지 건수</span>
        <span class="value" id="totalCount">-</span>
        </div>
        <div class="stat-item pending">
        <span class="label">처리전</span>
        <span class="value" id="pendingCount">-</span>
        </div>
        <div class="stat-item progress">
        <span class="label">처리중</span>
        <span class="value" id="progressCount">-</span>
        </div>
        <div class="stat-item complete">
        <span class="label">처리완료</span>
        <span class="value" id="completeCount">-</span>
        </div>
        </div>


        <!-- 페이지 이동 -->
        <div class="pagination" role="navigation" aria-label="페이지네이션">
          <button class="page-btn prev" type="button">이전</button>
          <span class="page-no" aria-live="polite">1</span>
          <button class="page-btn next" type="button">다음</button>
        </div>

      </section>
    </main>
  </div>
  
  
<!-- Chart.js + DataLabels 플러그인-->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0"></script>

<script src="${ctx}/assets/js/Logs.js"></script>






</body>
</html>
