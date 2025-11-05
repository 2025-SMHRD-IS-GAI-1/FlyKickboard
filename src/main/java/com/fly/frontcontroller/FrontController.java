package com.fly.frontcontroller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fly.controller.ManangerService;
import com.fly.controller.UpdateService;
import com.fly.controller.AllManagerService;
import com.fly.controller.DeleteService;
import com.fly.controller.JoinService;
import com.fly.controller.LogService;
import com.fly.controller.LoginService;
import com.fly.controller.LogoutService;
import com.fly.controller.MainService;
import com.fly.frontcontroller.Command;

@WebServlet("*.do")
public class FrontController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private HashMap<String, Command> map;
	
	@Override
	public void init (ServletConfig config) throws ServletException {
		map = new HashMap<String, Command>();
		map.put("Main.do", new MainService());
		map.put("Join.do", new JoinService());
		map.put("Login.do", new LoginService());
		map.put("logout.do", new LogoutService());
		map.put("Manager.do", new ManangerService());
		map.put("Logs.do", new LogService());
		map.put("Delete.do", new DeleteService());
		map.put("Manager.do", new AllManagerService());
		map.put("Update.do", new UpdateService());
	}
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1. FrontController에 들어온 요청이 어떤 요청인지 파악 !!

		// 실행되는 uri 주소 가져오기
		String uri = request.getRequestURI();
		System.out.println("url : " + uri);

		// 프로젝트 경로 가져오기
		String path = request.getContextPath();
		System.out.println("path : " + path);

		// uri 경로에서 path에 대한 경로 삭제 !

		// /ExMessageSystem_FrontCon + /
		// => /Login.do
		String FinalUrl = uri.substring(path.length() + 1);
		System.out.println("Finalurl : " + FinalUrl);
		// 중복되는 코드들을 한번에 처리
		// 요청 객체에 대한 인코딩 작업
		request.setCharacterEncoding("UTF-8");

		String MoveUrl = "";
		Command com = null;
		// 우리가 정한 패턴 => Go 파일명 .do
		if (FinalUrl.contains("Go")) {
			// ex) Gomain.do
			// main.jsp 파일로 forward 방식 이동
			// 최종적으로 이동해야하는 경로를 만들어주는 작업
			MoveUrl = FinalUrl.substring(2).replaceAll("do", "jsp");  
		} else {
			com = map.get(FinalUrl);
			MoveUrl = com.execute(request, response);
		}
		// 페이지 경로를 이동
		if (MoveUrl.contains("fetch:/")) {
			// 비동기통신으로 요청이 들어왔을때, 페이지를 이동하지 않겠다.
			response.setContentType("application/json;charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.print(MoveUrl.substring(7));
		}
		else if (MoveUrl.contains("redirect:/")) {
			// 1. redirect:/main.jsp --> redirect 방식 이동
			// moveUrl -> redirect:/ 잘라줘야 이동할 경로가 제대로 나온다
			response.sendRedirect(MoveUrl.substring(10));
		} else {
			// 2. join_success.jsp --> forward 방식 이동
			RequestDispatcher rd = request.getRequestDispatcher("WEB-INF/" + MoveUrl);
			rd.forward(request, response);
		}
	}
}

