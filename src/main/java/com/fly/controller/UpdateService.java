package com.fly.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fly.frontcontroller.Command;
import com.fly.model.MemberDAO;
import com.fly.model.MemberVO;

public class UpdateService implements Command {

	@Override
	// 사용자 수정
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		// 필요 데이터 꺼내오기 
		// js에서 아이디를 보내 일치한아이디가 잊는지 확인후 일치한이이디의 비밀번호와 지역을 수정
		String id = request.getParameter("id"); // 아이디
		System.out.println(id);
		String pw = request.getParameter("UpPw"); // 비번
		System.out.println(pw);
		String area = request.getParameter("UpArea"); // 지역
		System.out.println(area);
		// (선택) pw나 area가 null이면 빈문자열로 바꾸거나 기존 DB값 유지 로직을 추가
//	    if (pw == null) pw = "";       // 또는 pw = existingPw from DB
//	    if (area == null) area = "";
		MemberVO mvo = new MemberVO();
		mvo.setId(id);
		mvo.setPw(pw);
		mvo.setArea(area);
		
		MemberDAO dao = new MemberDAO();
		
		int row = dao.UpdateUser(mvo);
		
		if(row > 0) {
			request.setAttribute("pw", pw);
			request.setAttribute("area", area);
		}
		return "redirect:/Manager.do";
	}

}
