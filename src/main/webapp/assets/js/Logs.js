// ==============================
// Logs.js (전송/삭제/필터/페이징/통계/그래프 통합버전)
// ==============================

var ctx = (document.body && document.body.getAttribute("data-ctx")) || "";

if (session == "") {
   window.location.href = "GoLogin.do";
}

// 전역 상태
var CURRENT_FILTER = { start:null, end:null, status:null, dtype:null };
var FILTERED_LOGS = [];
var CURRENT_PAGE = 1;
var PAGE_SIZE = 10;

document.addEventListener("DOMContentLoaded", function () {
  try {
    // --- 주요 DOM 캐싱
    var tableBody = document.getElementById("LogTable");
    var prevBtn   = document.querySelector(".page-btn.prev");
    var nextBtn   = document.querySelector(".page-btn.next");
    var pageNo    = document.querySelector(".page-no");
    var searchBtn = document.querySelector(".btn-search");
    var filterBtn = document.getElementById("btnFilter");
    var filterPanel = document.getElementById("filterPanel");
    var statsBtn  = document.getElementById("btnStats");
    var modal     = document.getElementById("reportModal");
    var closeBtn  = document.getElementById("closeReportBtn");
    var btnSend   = document.getElementById("btnSend");
    var btnDel    = document.getElementById("btnDel");
   const btnPrint = document.getElementById("btnPrint");
   var CURRENT_SORT = { key: null, asc: true };
    console.log("✅ Logs.js initialized");

    if (modal) modal.classList.remove("show");

    // 초기 데이터
    window.LAST_LOGS = readLogsFromDom();
    FILTERED_LOGS = window.LAST_LOGS.slice();
    renderTable(CURRENT_PAGE);
   setupSorting();   // ✅ 정렬 이벤트 연결
    
   // ==============================
   // ✅ 로그아웃 알림
   // ==============================
   const logoutBtn = document.querySelector(".login-btn");
   if (logoutBtn) {
     logoutBtn.addEventListener("click", () => {
       alert("로그아웃 되었습니다.");
       // 원래 페이지 이동 (선택)
       window.location.href = "Logout.do";
     });
   }
   
    // ==============================
    // ✅ 날짜 검색
    // ==============================
    if (searchBtn) {
      searchBtn.addEventListener("click", function (e) {
        e.preventDefault();
        var startInput = document.getElementById("startDate");
        var endInput   = document.getElementById("endDate");
        var startDate  = startInput ? startInput.value : "";
        var endDate    = endInput ? endInput.value : "";

        if (!startDate && !endDate) return alert("조회할 날짜를 선택하세요.");

        CURRENT_FILTER.start = startDate ? new Date(startDate + "T00:00:00") : null;
        CURRENT_FILTER.end   = endDate   ? new Date(endDate   + "T23:59:59") : null;
        CURRENT_PAGE = 1;
        applyAllFilters();
      });
    }

    // ==============================
    // ✅ 분류 모달
    // ==============================
    if (filterBtn && filterPanel) {
      var backdrop = document.createElement("div");
      backdrop.id = "filterBackdrop";
      backdrop.className = "filter-modal-backdrop";
      document.body.appendChild(backdrop);

      function openFilter() {
        backdrop.classList.add("show");
        backdrop.appendChild(filterPanel);
        filterPanel.classList.add("as-modal");
      }
      function closeFilter() {
        backdrop.classList.remove("show");
        var wrap = document.querySelector(".filter-wrapper");
        if (wrap) wrap.appendChild(filterPanel);
        filterPanel.classList.remove("as-modal");
      }

      filterBtn.addEventListener("click", e => { e.preventDefault(); openFilter(); });
      backdrop.addEventListener("click", e => { if (!filterPanel.contains(e.target)) closeFilter(); });
      document.addEventListener("keydown", e => { if (e.key === "Escape" && backdrop.classList.contains("show")) closeFilter(); });

      var opts = filterPanel.querySelectorAll(".filter-option");
      for (var i = 0; i < opts.length; i++) {
        opts[i].addEventListener("click", function () {
          var group = closest(this, ".filter-group");
          var all = group ? group.querySelectorAll(".filter-option") : [];
          all.forEach(o => o.classList.remove("active"));
          this.classList.add("active");

          var f = getActiveFilters();
          CURRENT_FILTER.status = f.status;
          CURRENT_FILTER.dtype  = f.dtype;
          CURRENT_PAGE = 1;
          applyAllFilters();
        });
      }
    }

    // ==============================
    // ✅ 통계 모달
    // ==============================
   if (statsBtn && modal) {
     statsBtn.addEventListener("click", function () {
       // ✅ 1. 선택된 행 가져오기
       var checkedRows = getCheckedRows();

       // ✅ 2. 선택된 데이터만 추출
       var selectedLogs = [];
       if (checkedRows.length > 0) {
         var allLogs = FILTERED_LOGS;  // 현재 필터된 전체
         checkedRows.forEach(function (row) {
           var found = allLogs.find(function (log) {
             return String(log.id) === String(row.id);
           });
           if (found) selectedLogs.push(found);
         });
       }

       // ✅ 3. 선택이 없으면 전체로 fallback
       var targetList = selectedLogs.length > 0 ? selectedLogs : FILTERED_LOGS;

       // ✅ 4. 모달 표시 + 통계 갱신
       modal.classList.add("show");
       updateReportModal(targetList);
      
      if (closeBtn) closeBtn.addEventListener("click", function () { modal.classList.remove("show"); });
      if (btnClose) btnClose.addEventListener("click", function () { modal.classList.remove("show"); });
      if (modal) modal.addEventListener("click", function (e) { if (e.target === modal) modal.classList.remove("show"); });
     });
     // ==============================
        // ✅ 통계 모달 내부 출력 버튼
        // ==============================
        
        if (btnPrint) {
          btnPrint.addEventListener("click", async function () {
            const modal = document.getElementById("reportModal");
            if (!modal) return alert("통계 모달을 찾을 수 없습니다.");

            // ✅ 1. 그래프 캔버스 → 이미지 변환
            const canvases = modal.querySelectorAll("canvas");
            const images = [];
            for (let canvas of canvases) {
              try {
                await new Promise(res => setTimeout(res, 300));
                const imgURL = canvas.toDataURL("image/png");
                images.push(imgURL);
              } catch (e) {
                console.warn("⚠️ 차트 변환 실패:", e);
              }
            }

            // ✅ 2. 모달 내의 모든 테이블 추출
            const tables = Array.from(modal.querySelectorAll("table")).map(t => t.outerHTML).join("<br><br>");

            // ✅ 3. 인쇄용 HTML 생성
            const printWindow = window.open("", "_blank");
            const doc = printWindow.document;
            const styles = Array.from(document.querySelectorAll("link[rel='stylesheet'], style"))
              .map(node => node.outerHTML)
              .join("\n");

            // ✅ 4. HTML 작성
            doc.open();
            doc.write(`
              <html lang="ko">
                <head>
                  <meta charset="utf-8">
                  <title>📊 통계 보고서</title>
                  ${styles}
                  <style>
                    body { font-family: 'Noto Sans KR', sans-serif; margin: 25px; background: white; }
                    h1 { text-align: center; margin-bottom: 25px; font-size: 22px; }
                    section { margin-bottom: 40px; page-break-inside: avoid; }
                    img { display: block; margin: 10px auto; max-width: 95%; }
                    table { width: 90%; border-collapse: collapse; margin: 20px auto; }
                    th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
                    th { background: #e9eef9; font-weight: 600; }
                    @page { size: A4 portrait; margin: 15mm; }
                  </style>
                </head>
                <body>
                  <h1>📊 통계 보고서</h1>

                  <section>
                    <h2>1️⃣ 지역별 감지건수</h2>
                    ${images[0] ? `<img src="${images[0]}">` : ""}
                  </section>

                  <section>
                    <h2>2️⃣ 위반유형별 비율</h2>
                    ${images[1] ? `<img src="${images[1]}">` : ""}
                  </section>

                  <section>
                    <h2>3️⃣ 시간대별 추이 그래프</h2>
                    ${images[2] ? `<img src="${images[2]}">` : ""}
                  </section>

                  <section>
                    <h2>📋 상세 표 데이터</h2>
                    ${tables || "<p>표 데이터가 없습니다.</p>"}
                  </section>
                </body>
              </html>
            `);
            doc.close();

            // ✅ 5. 인쇄 실행
            printWindow.focus();
            setTimeout(() => {
              printWindow.print();
              printWindow.close();
            }, 800);
          });
        }
 
   }

    // ==============================
    // ✅ 페이징
    // ==============================
    if (prevBtn) prevBtn.addEventListener("click", function () {
      if (CURRENT_PAGE > 1) { CURRENT_PAGE--; renderTable(CURRENT_PAGE); }
    });
    if (nextBtn) nextBtn.addEventListener("click", function () {
      var maxPage = Math.ceil(FILTERED_LOGS.length / PAGE_SIZE);
      if (CURRENT_PAGE < maxPage) { CURRENT_PAGE++; renderTable(CURRENT_PAGE); }
    });

    // ==============================
    // ✅ 전송 버튼
    // ==============================
   // ==============================
   // ✅ 전송 버튼 이벤트 (삭제 이벤트와 동일한 구조로 정리)
   // ==============================
   if (btnSend) {
     btnSend.addEventListener("click", () => {
       const rows = getCheckedRows();
       if (rows.length === 0) return alert("전송할 항목을 선택하세요.");
       if (!confirm(`선택된 ${rows.length}건을 전송하시겠습니까?`)) return;

       fetch(ctx + "/SendLog.do", {
         method: "POST",
         headers: { "Content-Type": "application/json" },
         body: JSON.stringify(rows.map(r => Number(r.id)))
       })
         .then(res => res.text())
         .then(msg => {
           alert(msg || "전송이 완료되었습니다.");

           // ✅ DOM 즉시 반영: 전송된 행의 상태를 '처리중' 으로 변경
           rows.forEach(r => {
             const tr = document.querySelector(`#LogTable tr[data-id="${r.id}"]`);
             if (tr) {
               const statusCell = tr.querySelector("td:last-child");
               if (statusCell) {
                 statusCell.innerHTML = `<span class="status progress">처리중</span>`;
               }
             }
           });

           // ✅ 통계 갱신 (삭제처럼 실시간 반영)
           window.LAST_LOGS = readLogsFromDom();
           FILTERED_LOGS = window.LAST_LOGS.slice();
           updateStats(FILTERED_LOGS);
         })
         .catch(err => {
           console.error("전송 오류:", err);
           alert("전송 중 오류가 발생했습니다.");
         });
     });
   }

   // ============================== 
   // 삭제 버튼 이벤트 
   // ============================== 
   if (btnDel) { 
   btnDel.addEventListener("click", () => {
   const rows = getCheckedRows(); 
   if (rows.length === 0) return alert("삭제할 항목을 선택하세요.");
   if (!confirm("정말 삭제하시겠습니까?")) return; 
   fetch("DeleteLog.do", { 
   method: "POST",
    headers: { "Content-Type": "application/json" },
     body: JSON.stringify(rows.map(r => Number(r.id))) })
      .then(res => res.text())
      .then(msg => { 
      alert(msg); l
      ocation.reload(); 
     }) 
      .catch(err => console.error("삭제 오류:", err)); 
     }); 
   }

    // ==============================
    // ✅ 전체선택 체크박스 기능
    // ==============================
    const checkAll = document.getElementById("checkAll");
    if (checkAll && tableBody) {
      checkAll.addEventListener("change", function () {
        const allChecks = tableBody.querySelectorAll("input[type='checkbox']");
        allChecks.forEach(chk => chk.checked = checkAll.checked);
      });

      tableBody.addEventListener("change", function (e) {
        if (!e.target.matches("input[type='checkbox']")) return;
        const allChecks = tableBody.querySelectorAll("input[type='checkbox']");
        const checkedCount = Array.from(allChecks).filter(chk => chk.checked).length;

        if (checkedCount === 0) {
          checkAll.indeterminate = false;
          checkAll.checked = false;
        } else if (checkedCount === allChecks.length) {
          checkAll.indeterminate = false;
          checkAll.checked = true;
        } else {
          checkAll.indeterminate = true;
        }
      });
    }

   // ✅ 날짜 문자열을 Date로 (yyyy-mm-dd 또는 yy/mm/dd)
   function toDateSafe(str){
     if(!str) return null;
     var m1 = str.match(/(\d{4})-(\d{2})-(\d{2})/);       // 2025-12-24
     if(m1) return new Date(+m1[1], m1[2]-1, +m1[3]);
     var m2 = str.match(/(\d{2})\/(\d{2})\/(\d{2})/);     // 25/12/24
     if(m2) return new Date(2000 + +m2[1], +m2[2]-1, +m2[3]);
     return new Date(str); // fallback (브라우저 파서)
   }

   // ✅ 상태 정렬용 우선순위
   function progOrder(p){
     var n = normalizeProg(p);
     return (n === "처리전") ? 1 : (n === "처리중") ? 2 : (n === "처리완료") ? 3 : 99;
   }

   // ✅ 실제 정렬 로직 (FILTERED_LOGS를 정렬)
   function sortLogsByKey(key, asc){
     if(!Array.isArray(FILTERED_LOGS)) return;
     FILTERED_LOGS.sort(function(a,b){
       var A = (a[key] || "").trim();
       var B = (b[key] || "").trim();

       if(key === "date"){
         A = toDateSafe(A); B = toDateSafe(B);
         var at = A ? A.getTime() : 0, bt = B ? B.getTime() : 0;
         return asc ? (at - bt) : (bt - at);
       }
       if(key === "prog"){
         var ap = progOrder(a.prog), bp = progOrder(b.prog);
         return asc ? (ap - bp) : (bp - ap);
       }
       // 문자열 기본 비교 (한글 정렬 안정화)
       var cmp = String(A).localeCompare(String(B), "ko");
       return asc ? cmp : -cmp;
     });
   }

   // ✅ 정렬 헤더 화살표 표시
   function highlightSortedColumn(key, asc){
     var ths = document.querySelectorAll(".logs-table th[data-sort]");
     for(var i=0;i<ths.length;i++){
       var t = ths[i];
       t.textContent = t.textContent.replace(/\s*[↑↓]$/,"");
       if(t.getAttribute("data-sort") === key){
         t.textContent += asc ? " ↑" : " ↓";
       }
     }
   }

   // ✅ 헤더 클릭 바인딩 (DOMContentLoaded 안 최상위에서 한 번만 호출)
   function setupSorting(){
     var ths = document.querySelectorAll(".logs-table th[data-sort]");
     for(var i=0;i<ths.length;i++){
       (function(th){
         th.style.cursor = "pointer";
         th.addEventListener("click", function(){
           var key = th.getAttribute("data-sort");
           if(CURRENT_SORT.key === key) CURRENT_SORT.asc = !CURRENT_SORT.asc;
           else { CURRENT_SORT.key = key; CURRENT_SORT.asc = true; }
           sortLogsByKey(key, CURRENT_SORT.asc);
           CURRENT_PAGE = 1;           // 첫 페이지로
           renderTable(CURRENT_PAGE);  // 다시 그리기
           highlightSortedColumn(key, CURRENT_SORT.asc);
         });
       })(ths[i]);
     }
   }

  } catch (err) {
    console.error("[Logs.js] 초기화 중 에러:", err);
  }
});


// ------------------------------
// 체크된 행 가져오기
// ------------------------------
function getCheckedRows() {
  var checked = document.querySelectorAll("#LogTable input[type='checkbox']:checked");
  var selected = [];
  checked.forEach(function (chk) {
    var row = chk.closest("tr");
    if (row && row.dataset.id) selected.push({ id: row.dataset.id });
  });
  return selected;
}

// ------------------------------
// 공통 유틸
// ------------------------------
function closest(el, sel){ while (el && el.nodeType===1){ if (el.matches ? el.matches(sel) : el.msMatchesSelector(sel)) return el; el=el.parentElement; } return null; }
function setText(id, v){ var el=document.getElementById(id); if (el) el.textContent=v; }

// ------------------------------
// 날짜 파서
// ------------------------------
function parseDateForFilter(str){
  if(!str) return null;
  var m1=str.match(/(\d{4})-(\d{2})-(\d{2})/); // yyyy-mm-dd
  if(m1) return new Date(m1[1], m1[2]-1, m1[3]);
  var m2=str.match(/(\d{2})\/(\d{2})\/(\d{2})/); // yy/mm/dd
  if(m2) return new Date(2000+parseInt(m2[1],10), parseInt(m2[2],10)-1, parseInt(m2[3],10));
  return null;
}

// ------------------------------
// 상태 정규화
// ------------------------------
function normalizeProg(s){
  var v=String(s||"").trim().toLowerCase();
  if(["대기","처리전","pending","new","todo","준비중"].indexOf(v)>-1) return "처리전";
  if(["진행","처리중","in_progress","progress","processing","working"].indexOf(v)>-1) return "처리중";
  if(["완료","처리완료","done","complete","completed","success"].indexOf(v)>-1) return "처리완료";
  return s||"-";
}
function statusClass(st){ if(st==="처리전") return "pending"; if(st==="처리중") return "progress"; if(st==="처리완료") return "complete"; return ""; }

// ------------------------------
// 필터 읽기
// ------------------------------
function getActiveFilters(){
  var f={status:null, dtype:null};
  var panel=document.getElementById("filterPanel");
  if(!panel) return f;
  var groups=panel.querySelectorAll(".filter-group");

  if(groups[0]){
    var a1=groups[0].querySelector(".filter-option.active");
    if(a1 && a1.textContent.trim()!=="전체") f.status=a1.textContent.trim();
  }
  if(groups[1]){
    var a2=groups[1].querySelector(".filter-option.active");
    if(a2 && a2.textContent.trim()!=="전체") f.dtype=a2.textContent.trim();
  }
  return f;
}

// ------------------------------
// DOM → 배열
// ------------------------------
function readLogsFromDom(){
  var tbody=document.getElementById("LogTable");
  var out=[];
  if(!tbody){ console.warn("[Logs.js] #LogTable not found"); return out; }
  var rows=tbody.getElementsByTagName("tr");
  for(var i=0;i<rows.length;i++){
    var tds=rows[i].getElementsByTagName("td");
    out.push({
      date: tds[1]? tds[1].textContent.trim() : "",
      loc : tds[2]? tds[2].textContent.trim() : "",
      type: tds[3]? tds[3].textContent.trim() : "",
      prog: tds[4]? tds[4].textContent.trim() : "",
      id  : rows[i].dataset.id || ""
    });
  }
  return out;
}

// ------------------------------
// 통합필터 & 렌더
// ------------------------------
function applyAllFilters(){
  if(!Array.isArray(window.LAST_LOGS)) return;
  FILTERED_LOGS = window.LAST_LOGS.filter(function (log){
    var passDate=true;
    if(CURRENT_FILTER.start || CURRENT_FILTER.end){
      var d=parseDateForFilter(log.date);
      if(!d) passDate=false;
      else{
        if(CURRENT_FILTER.start && d<CURRENT_FILTER.start) passDate=false;
        if(CURRENT_FILTER.end   && d>CURRENT_FILTER.end)   passDate=false;
      }
    }
    var passStatus = CURRENT_FILTER.status ? (normalizeProg(log.prog)===CURRENT_FILTER.status) : true;
    var passType   = CURRENT_FILTER.dtype  ? (log.type===CURRENT_FILTER.dtype) : true;
    return passDate && passStatus && passType;
  });
  CURRENT_PAGE=1;
  renderTable(CURRENT_PAGE);
  setupSorting();
}

// ------------------------------
// 테이블 렌더링 + 통계 갱신
// ------------------------------
function renderTable(page){
  var tbody=document.getElementById("LogTable");
  if(!tbody) return;
  tbody.innerHTML="";

  var start=(page-1)*PAGE_SIZE;
  var end=start+PAGE_SIZE;
  var pageData=FILTERED_LOGS.slice(start,end);

  if(pageData.length===0){
    // ✅ 데이터가 없을 때 colspan을 6으로 수정 (보기 버튼 열 포함)
    tbody.innerHTML="<tr><td colspan='6'>데이터가 없습니다.</td></tr>";
  }else{
    for(var i=0;i<pageData.length;i++){
      var log=pageData[i];
      var st = normalizeProg(log.prog);
      var tr=document.createElement("tr");
      tr.dataset.id=log.id;

      // ✅ 보기 버튼 <td> 추가
      tr.innerHTML =
        "<td><input type='checkbox' class='row-check' /></td>" +       // 체크박스
        "<td>"+(log.date||"-")+"</td>" +                              // 날짜
        "<td>"+(log.loc||"-")+"</td>" +                               // 위치
        "<td>"+(log.type||"-")+"</td>" +                              // 감지유형
        "<td><span class='status "+statusClass(st)+"'>"+st+"</span></td>" + // 상태
        "<td><button type='button' class='btn-detail'>보기</button></td>";   // ✅ 상세보기 버튼 추가

      tbody.appendChild(tr);
    }
  }

  // ✅ 페이지 번호 업데이트
  var pageNo=document.querySelector(".page-no");
  var maxPage=Math.ceil(FILTERED_LOGS.length/PAGE_SIZE)||1;
  if(pageNo) pageNo.textContent = page + " / " + maxPage;

  // ✅ 통계 갱신
  updateStats(FILTERED_LOGS);
}

// ------------------------------
// 통계
// ------------------------------
function updateStats(list){
  var total=list.length, p=0, g=0, c=0;
  for(var i=0;i<list.length;i++){
    var s=normalizeProg(list[i].prog);
    if(s==="처리전") p++;
    else if(s==="처리중") g++;
    else if(s==="처리완료") c++;
  }
  setText("totalCount", total+"건");
  setText("pendingCount", p+"건");
  setText("progressCount", g+"건");
  setText("completeCount", c+"건");
}

// ------------------------------
// 통계 모달 (차트 포함)
// ------------------------------
function updateReportModal(list){
  if(!list || !list.length) return;

  // --- ① 지역별 통계 ---
  var regionCount={}, total=list.length;
  for(var i=0;i<list.length;i++){
    var m=(list[i].loc||"").match(/(광산구|북구|서구|남구|동구)/);
    var r=m?m[1]:"기타";
    regionCount[r]=(regionCount[r]||0)+1;
  }

  var tbody=document.querySelector("#regionTable2 tbody");
  if(!tbody) return;

  var order=["광산구","북구","서구","남구","동구"];
  var sum=0, html="";
  for(var j=0;j<order.length;j++){
    var key=order[j], cnt=regionCount[key]||0; sum+=cnt;
    html += "<tr><td>"+key+"</td><td>"+cnt+"</td><td>"+((cnt/total)*100).toFixed(1)+"</td></tr>";
  }
  html += "<tr><td><strong>총 건수</strong></td><td><strong>"+sum+"</strong></td><td></td></tr>";
  tbody.innerHTML=html;

  drawRegionBarChart(regionCount, sum);

  // --- ② 위반유형 통계 (표 + 도넛그래프 통합 버전) ---
  var typeCount = { "헬멧 미착용": 0, "2인이상 탑승": 0 };
  for (var i = 0; i < list.length; i++) {
    var t = (list[i].type || "").trim();
    if (typeCount.hasOwnProperty(t)) typeCount[t]++;
  }

  // ✅ 총 건수, 퍼센트 계산
  var totalType = typeCount["헬멧 미착용"] + typeCount["2인이상 탑승"];
  var pctHelmet = totalType ? ((typeCount["헬멧 미착용"] / totalType) * 100).toFixed(1) : 0;
  var pctDouble = totalType ? ((typeCount["2인이상 탑승"] / totalType) * 100).toFixed(1) : 0;

  // ✅ 표 갱신
  var typeTable = document.querySelector("#sec-4 .tbl tbody");
  if (typeTable) {
    var typeHtml = "";
    typeHtml += "<tr><td class='left'>헬멧 미착용</td><td>" + typeCount["헬멧 미착용"] + "건 (" + pctHelmet + "%)</td></tr>";
    typeHtml += "<tr><td class='left'>2인이상 탑승</td><td>" + typeCount["2인이상 탑승"] + "건 (" + pctDouble + "%)</td></tr>";
    typeHtml += "<tr><td class='left'><strong>총 건수</strong></td><td><strong>" + totalType + "</strong></td></tr>";
    typeTable.innerHTML = typeHtml;
  }

  // ✅ 도넛 그래프 생성
  drawTypeDonutChart(typeCount, totalType);

  // --- ③ 시간대별 통계 ---
  var hourly=[0,0,0,0,0,0,0,0];
  for(var i=0;i<list.length;i++){
    var dt=(list[i].date||"");
    var hm=dt.match(/(\d{2}):(\d{2}):/);
    if(hm){
      var h=parseInt(hm[1],10);
      var idx=Math.floor(h/3);
      if(idx>=0 && idx<8) hourly[idx]++;
    }
  }
  var ranges=[
    "00:00 ~ 03:00","03:00 ~ 06:00","06:00 ~ 09:00","09:00 ~ 12:00",
    "12:00 ~ 15:00","15:00 ~ 18:00","18:00 ~ 21:00","21:00 ~ 24:00"
  ];
  drawHourlyLineChart(ranges, hourly);
  var hourTable=document.querySelector("#hourlyTable tbody");
    if(hourTable){
      var hourHtml="", totalHour=0;
      for(var i=0;i<ranges.length;i++){
        hourHtml += `<tr><td>${ranges[i]}</td><td>${hourly[i]}</td></tr>`;
        totalHour += hourly[i];
      }
      hourHtml += `<tr><td><strong>총 건수</strong></td><td><strong>${totalHour}</strong></td></tr>`;
      hourTable.innerHTML=hourHtml;
    }

    var label=document.getElementById("selectedDateLabel");
    if(label) label.textContent="선택 일자: "+new Date().toISOString().slice(0,10);
  var label=document.getElementById("selectedDateLabel");
  if(label) label.textContent="선택 일자: "+new Date().toISOString().slice(0,10);
}

// ------------------------------
// Chart.js 그래프들
// ------------------------------
// ------------------------------
// 지역별 막대그래프
// ------------------------------
function drawRegionBarChart(regionCount, total){
  var ctx=document.getElementById("regionBar2");
  if(!ctx) return;
  if(window.regionBarChart) window.regionBarChart.destroy();

  var labels=["광산구","북구","서구","남구","동구"];
  var data=labels.map(function(r){return regionCount[r]||0;});

  window.regionBarChart=new Chart(ctx,{
    type:"bar",
    data:{
      labels:labels,
      datasets:[{
        label:"감지 건수",
        data:data,
        backgroundColor:["#2563eb","#3b82f6","#60a5fa","#93c5fd","#bfdbfe"],
        borderRadius:6
      }]
    },
    options:{
      responsive:true,
      plugins:{legend:{display:false}},
      scales:{y:{beginAtZero:true}}
    }
  });
}

// ------------------------------
// 위반유형 도넛그래프
// ------------------------------
function drawTypeDonutChart(typeCount, totalType){
   var ctx = document.getElementById("typeDonut2");
     if (!ctx) return;
     if (window.typeDonutChart) window.typeDonutChart.destroy();

     var labels = ["헬멧 미착용", "2인이상 탑승"];
     var data = [typeCount["헬멧 미착용"], typeCount["2인이상 탑승"]];
     var total = totalType || data.reduce(function (a, b) { return a + b; }, 0);
     window.typeDonutChart = new Chart(ctx, {
      type: "doughnut",
      data: {
        labels: labels,
        datasets: [{
          data: data,
          backgroundColor: ["#ef4444", "#facc15"],
          borderColor: "#fff",
          borderWidth: 2
        }]
      },
      plugins: [ChartDataLabels], // ✅ 퍼센트 라벨 플러그인 추가
      options: {
        plugins: {
          legend: {
            position: "bottom",
            labels: { font: { size: 13 } }
          },
          title: {
            display: true,
            text: "위반유형 비율(%)",
            font: { size: 14, weight: "bold" }
          },
          // ✅ 퍼센트 표시 옵션
          datalabels: {
            color: "#111827",
            font: { weight: "bold", size: 18 },
            formatter: function(value, context) {
              var percent = total ? (value / total * 100).toFixed(1) + "%" : "0%";
              return percent;
            }
          }
        },
        cutout: "25%"
      }
  });
}

// ------------------------------
// 시간대별 라인그래프
// ------------------------------
function drawHourlyLineChart(labels, data){
  var ctx=document.getElementById("selectedDayLine");
  if(!ctx) return;
  if(window.hourlyLineChart) window.hourlyLineChart.destroy();

  window.hourlyLineChart=new Chart(ctx,{
    type:"line",
    data:{
      labels:labels,
      datasets:[{
        label:"감지 건수",
        data:data,
        borderColor:"#2563eb",
        backgroundColor:"rgba(37,99,235,0.15)",
        tension:0.3,
        fill:true,
        pointRadius:5
      }]
    },
    options:{
      responsive:true,
      plugins:{legend:{display:false}},
      scales:{
        y:{beginAtZero:true, ticks:{stepSize:1}},
        x:{ticks:{font:{size:12}}}
      }
    }
  });
}

         // 상세보기 모달 열기
      document.addEventListener('click', e => {
        if (e.target.classList.contains('btn-detail')) {
       document.getElementById('detailModal').classList.add('show');
        }
   });

      // 닫기 버튼
   document.getElementById('detailCloseBtn').addEventListener('click', () => {
     document.getElementById('detailModal').classList.remove('show');
   });
