package com.fly.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fly.frontcontroller.Command;
import com.fly.model.MemberDAO;
import com.fly.model.MemberVO;
import com.google.gson.Gson;

public class SearchService implements Command {

	@Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        String keyword = request.getParameter("keyword");

        MemberDAO dao = new MemberDAO();
        List<MemberVO> list = dao.SearchUser(keyword);

        // JSON 형식으로 응답
        response.setContentType("application/json; charset=UTF-8");

        try {
            Gson gson = new Gson();
            String json = gson.toJson(list);
            response.getWriter().print(json);
        } catch (IOException e) {
            e.printStackTrace();
        }

        return null; // JSP로 forward 안 함 (직접 응답)
    }
}
