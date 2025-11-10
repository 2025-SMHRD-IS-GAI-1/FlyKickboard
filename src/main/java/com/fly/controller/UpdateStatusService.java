package com.fly.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fly.frontcontroller.Command;
import com.fly.model.MemberDAO;
import com.fly.model.MemberVO;

public class UpdateStatusService implements Command {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		String id = request.getParameter("id");
		String status = request.getParameter("status");

		MemberVO mvo = new MemberVO();
		mvo.setDet_id(id);   // ✅ 여기 중요
		mvo.setProg(status);

		System.out.println("mvo 내용: " + mvo); // 디버그용
		if (id != null && status != null) {
            MemberDAO dao = new MemberDAO();
            int row = dao.updateStatus(mvo);
        } else {
        	System.out.println("실패");
        }
		return "Logs.jsp";
	}

}
