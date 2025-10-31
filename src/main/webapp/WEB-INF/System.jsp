<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>관리자 메뉴</title>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;600;700;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="system.css" />
</head>
<body>
  <!-- 상단바 -->
  <header class="topbar">
    <div class="brand">날아라킥보드</div>
    <nav class="tabs">
      <a class="tab" href="#">실시간</a>
      <a class="tab active" href="#">감지 이력 조회</a>
    </nav>
    <div class="spacer"></div>
    <button class="ghost">관리자메뉴</button>
    <button class="ghost">로그아웃</button>
  </header>

  <main class="wrap">


    <h1 class="page-title">관리자 메뉴</h1>

    <!-- 상단 액션 줄 -->
    <div class="actions">
      <label for="addUserToggle" class="btn small primary">사용자 추가</label>

      <div class="spacer"></div>

<div class="search">
  <input type="text" placeholder="검색어 입력" />
  <button aria-label="검색" class="search-btn">
    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"
         viewBox="0 0 24 24" fill="none" stroke="currentColor"
         stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <circle cx="11" cy="11" r="8"></circle>
      <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
    </svg>
  </button>
</div>
    </div>

    <!-- 테이블 카드 -->
    <section class="card">
      <div class="table">
        <div class="thead">
          <div class="th id">ID</div>
          <div class="th region">지역</div>
          <div class="th role">권한</div>
          <div class="th act">수정 / 삭제</div>
          <div class="th note">비고</div>
        </div>

        <!-- 행들 -->
        <div class="tr">
          <div class="td id"></div>
          <div class="td region"></div>
          <div class="td role hot"></div>
          <div class="td act"><a class="edit" href="#"></a>  <a class="del" href="#"></a></div>
          <div class="td note"></div>
        </div>

        <div class="tr">
          <div class="td id"></div>
          <div class="td region"></div>
          <div class="td role"></div>
          <div class="td act"><a class="edit" href="#"></a>  <a class="del" href="#"></a></div>
          <div class="td note"></div>
        </div>

        <div class="tr">
          <div class="td id"></div>
          <div class="td region"></div>
          <div class="td role"></div>
          <div class="td act"><a class="edit" href="#"></a>  <a class="del" href="#"></a></div>
          <div class="td note"></div>
        </div>

        <div class="tr">
          <div class="td id"></div>
          <div class="td region"></div>
          <div class="td role"></div>
          <div class="td act"><a class="edit" href="#"></a>  <a class="del" href="#"></a></div>
          <div class="td note"></div>
        </div>

        <div class="tr">
          <div class="td id"></div>
          <div class="td region"></div>
          <div class="td role"></div>
          <div class="td act"><a class="edit" href="#"></a> <a class="del" href="#"></a></div>
          <div class="td note"></div>
        </div>

        <div class="tr">
          <div class="td id"></div>
          <div class="td region"></div>
          <div class="td role"></div>
          <div class="td act"><a class="edit" href="#"></a> <a class="del" href="#"></a></div>
          <div class="td note"></div>
        </div>

        <div class="tr">
          <div class="td id"></div>
          <div class="td region"></div>
          <div class="td role"></div>
          <div class="td act"><a class="edit" href="#"></a> <a class="del" href="#"></a></div>
          <div class="td note"></div>
        </div>

        <div class="tr">
          <div class="td id"></div>
          <div class="td region"></div>
          <div class="td role"></div>
          <div class="td act"><a class="edit" href="#"></a> <a class="del" href="#"></a></div>
          <div class="td note"></div>
        </div>

          <div class="tr">
          <div class="td id"></div>
          <div class="td region"></div>
          <div class="td role"></div>
          <div class="td act"><a class="edit" href="#"></a>  <a class="del" href="#"></a></div>
          <div class="td note"></div>
        </div>
      </div>

      <!-- 하단 페이징 -->
      <div class="table-foot">
        <div class="pager">
          <button class="ghost">‹ Previous</button>
          <span class="page">1</span>
          <button class="ghost">Next ›</button>
        </div>
      </div>
    </section>

    <!-- 사용자 추가 모달 -->
    <div class="modal" role="dialog" aria-modal="true" aria-labelledby="addUserTitle">
      <label class="dim" for="addUserToggle" aria-label="닫기(배경)"></label>
      <div class="dialog">
        <div class="dialog-head">
          <h2 id="addUserTitle">사용자 추가</h2>
          <label class="close" for="addUserToggle" aria-label="닫기">×</label>
        </div>

        <form class="form">
          <label class="field">
            <span class="label">ID</span>
            <input type="text" value="user02" />
          </label>
          <label class="field">
            <span class="label">지역</span>
            <input type="text" value="남구" />
          </label>
          <label class="field">
            <span class="label">권한</span>
            <input type="text" value="사용자" />
          </label>

          <div class="form-actions">
            <button class="btn primary" type="button">등록</button>
            <label class="btn" for="addUserToggle">취소</label>
          </div>
        </form>
      </div>
    </div>
  </main>

</body>
</html>
