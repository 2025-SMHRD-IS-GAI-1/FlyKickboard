package com.fly.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fly.frontcontroller.Command;
import com.fly.model.MemberDAO;
import com.fly.model.MemberVO;

public class AllLogService implements Command {

	@Override
	// 전체 로그 조회
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		MemberDAO dao = new MemberDAO();
		MemberVO mvo = new MemberVO();
		
		List<MemberVO> vo = dao.AllLog(mvo);
		
		request.setAttribute("alllog", vo);
		
		return "Logs.jsp";
	}

}
