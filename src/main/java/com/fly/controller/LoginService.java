package com.fly.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fly.frontcontroller.Command;
import com.fly.model.MemberDAO;
import com.fly.model.MemberVO;

public class LoginService implements Command {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		String id = request.getParameter("id");
		String pw = request.getParameter("pw");
		
		MemberVO mvo = new MemberVO();
		mvo.setId(id);
		mvo.setPw(pw);
		
		System.out.println(mvo.getId());
		MemberDAO dao = new MemberDAO();
		MemberVO login = dao.Login(mvo);
		
		System.out.println(login);
		
//		System.out.println(login.getId());
		if (login != null) {
			System.out.println("로그인 성공 !");
			HttpSession session = request.getSession();
			session.setAttribute("login", login);
			System.out.println(login.getId());
			dao.LastLogin(login.getId());
		} else {
			System.out.println("실패151");
		}
		return "redirect:/GoMain.do";
	}

}
