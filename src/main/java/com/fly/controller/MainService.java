package com.fly.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fly.frontcontroller.Command;
import com.fly.model.MemberVO;

public class MainService implements Command {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession(false);
		 MemberVO login = (session != null) ? (MemberVO) session.getAttribute("login") : null;
		 
		 if(login == null) {
			 return "redirect:/GoLogin.do";
		 } else {
			 return "Main.jsp";
		 }
		
		
	}

}
