package com.fly.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fly.frontcontroller.Command;

public class LogoutService implements Command {

	@Override
	// 로그인 서비스
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		// 1. session 꺼내오기
		HttpSession session = request.getSession();
		// 2. session 데이터 전부 삭제하기
		session.invalidate();
		return "redirect:/GoLogin.do";
	}

}
