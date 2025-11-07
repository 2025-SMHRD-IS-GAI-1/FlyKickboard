// ✅ 검색 + 페이지네이션 변수
const searchBtn = document.getElementById("searchBtn");
const tableBody = document.getElementById("userTable");
const prevBtn = document.querySelector(".page-btn.prev");
const nextBtn = document.querySelector(".page-btn.next");
const pageNo = document.querySelector(".page-no");
const searchInput = document.getElementById("searchInput");

let allData = [];     // 서버에서 받은 전체 사용자 데이터
let currentPage = 1;
const pageSize = 10;  // 한 페이지당 표시할 개수

// ✅ 테이블 렌더링 함수
function renderTable(page = 1) {
  tableBody.innerHTML = "";

  const start = (page - 1) * pageSize;
  const end = start + pageSize;
  const pageData = allData.slice(start, end);

  if (pageData.length === 0) {
    tableBody.innerHTML = `<tr><td colspan="3">검색 결과가 없습니다.</td></tr>`;
    return;
  }

  pageData.forEach(member => {
    const row = document.createElement("tr");
    row.innerHTML = `
      <td>${member.id}</td>
      <td>${member.area}</td>
      <td>
        <button class="btn small UpdaBtn" type="button" data-id="${member.id}">수정</button>
        <button class="btn small danger DelBtn" type="button" data-id="${member.id}">삭제</button>
      </td>
    `;
    tableBody.appendChild(row);
  });

  pageNo.textContent = page;

  bindRowEvents(); // ✅ 버튼 이벤트 바인딩
}

// ✅ 검색 기능 (서버 요청)
if (searchBtn) {
  searchBtn.addEventListener("click", () => {
    const keyword = searchInput.value.trim();

    fetch("SearchUser.do", { // Controller 매핑 이름
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ keyword })
    })
      .then(res => res.json())
      .then(data => {
        allData = data;   // ✅ 검색 결과 저장
        currentPage = 1;  // 페이지 초기화
        renderTable(currentPage);
      })
      .catch(err => console.error("검색 오류:", err));
  });
}

// ✅ 페이지네이션 버튼
if (prevBtn && nextBtn) {
  prevBtn.addEventListener("click", () => {
    if (currentPage > 1) {
      currentPage--;
      renderTable(currentPage);
    }
  });

  nextBtn.addEventListener("click", () => {
    if (currentPage * pageSize < allData.length) {
      currentPage++;
      renderTable(currentPage);
    }
  });
}

// ✅ 수정 / 삭제 버튼 이벤트 바인딩
function bindRowEvents() {
  // 🔹 수정 버튼
  document.querySelectorAll(".UpdaBtn").forEach(btn => {
    btn.addEventListener("click", () => {
      const id = btn.getAttribute("data-id");
      window.location.href = `UpdateUser.do?id=${id}`;
    });
  });

  // 🔹 삭제 버튼
  document.querySelectorAll(".DelBtn").forEach(btn => {
    btn.addEventListener("click", () => {
      const id = btn.getAttribute("data-id");

      if (!confirm(id + " 사용자를 삭제하시겠습니까?")) return;

      fetch("DeleteUser.do?id=" + id)
        .then(res => res.text())
        .then(msg => {
          alert(msg);
          searchBtn.click(); // 리스트 재조회
        })
        .catch(err => console.error("삭제 오류:", err));
    });
  });
}