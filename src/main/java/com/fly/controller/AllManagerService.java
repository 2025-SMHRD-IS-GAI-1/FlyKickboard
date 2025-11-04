package com.fly.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fly.frontcontroller.Command;
import com.fly.model.MemberDAO;
import com.fly.model.MemberVO;

public class AllManagerService implements Command {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		System.out.println("test1");
		MemberDAO dao = new MemberDAO();
		System.out.println("test2");
		MemberVO mvo = new MemberVO();
		System.out.println("test3");
		List<MemberVO> vo = dao.AllManager();
		System.out.println(vo.size() + "test4");
		
		request.setAttribute("allmanager", vo);
		
		
		return "Manager.jsp";
	}

}
