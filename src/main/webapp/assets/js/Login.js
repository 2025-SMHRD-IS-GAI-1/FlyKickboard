/**
 * 
 */
document.addEventListener("DOMContentLoaded", () => {
  const loginBtn = document.getElementById("loginBtn");

  loginBtn.addEventListener("click", (e) => {
    e.preventDefault(); 

    window.location.href = "Main.jsp"; // 메인 페이지로 이동
  });
});
