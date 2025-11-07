package com.fly.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fly.frontcontroller.Command;
import com.fly.model.MemberDAO;
import com.fly.model.MemberVO;
import com.google.gson.Gson;

public class LogTypeService implements Command {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		String type = request.getParameter("type");
		System.out.println(type);
		
		MemberVO mvo = new MemberVO();
		mvo.setType(type);
		
		MemberDAO dao = new MemberDAO();
		List<MemberVO> list = dao.LogType(mvo);
		
		Gson gson = new Gson();
		String json = gson.toJson(list);
		System.out.println(json);
		
		return "fetch:/" + json.toString();
	}

}
