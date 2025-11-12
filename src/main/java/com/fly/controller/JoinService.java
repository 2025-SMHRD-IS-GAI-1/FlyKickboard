package com.fly.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fly.frontcontroller.Command;
import com.fly.model.MemberDAO;
import com.fly.model.MemberVO;

public class JoinService implements Command {

	@Override
	// 사용자 추가 서비스
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		// 인코딩 작업
		response.setContentType("text/html;charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		// 요청 데이터 꺼내오기
		String id = request.getParameter("newId");
		String pw = request.getParameter("newPw");
		String area = request.getParameter("newArea");
		
		System.out.println(id + " " + pw + " " + area);
		
		// 
		MemberVO mvo = new MemberVO();
		mvo.setId(id);
		mvo.setPw(pw);
		mvo.setArea(area);
		
		MemberDAO dao = new MemberDAO();
		
		int row = dao.Join(mvo);
		
		if(row > 0) {
			request.setAttribute("newId", id);
		}
		return "redirect:/Manager.do";
	}

}
