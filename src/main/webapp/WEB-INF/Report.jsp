<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="javax.websocket.Session"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>통계 보고서</title>
  <link rel="stylesheet" href="repot.css" />
</head>
<body>

  <!-- 표지 -->
  <h2>통계 보고서</h2>

  <!-- 지역별 통계  -->
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
                <tr><td><strong>총 건수</strong></td><td>—</td></tr>
              </tbody>
            </table>
          </div>
        </article>

      </section>
    </div>
  </section>

  <!--  위반 유형 통계-->
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
            <div class="legend-row" style="margin-top:10px;">
              <span class="legend">헬멧 미착용 <strong></strong></span>
              <span class="legend">2인 탑승 <strong></strong></span>
            </div>
          </div> <!-- ✅ FIX: 빠졌던 card-body 닫기 -->
        </article> <!-- ✅ FIX: 빠졌던 article 닫기 -->

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
                <tr><td class="left">2인 탑승</td><td></td></tr>
                <tr><td class="left"><strong>총 건수</strong></td><td><strong></strong></td></tr>
              </tbody>
            </table>
          </div>
        </article>

      </section>
    </div>
  </section>

  <!--  선택 일자 시간대별 추이  -->
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
  
</body>
</html>
