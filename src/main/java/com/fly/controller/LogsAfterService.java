package com.fly.controller;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fly.frontcontroller.Command;
import com.fly.model.MemberDAO;
import com.fly.model.MemberVO;
import com.google.gson.Gson;

public class LogsAfterService implements Command {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {

        // sinceId 파라미터 받기
        String sinceIdParam = request.getParameter("sinceId");
        long sinceId = 0;
        try {
            sinceId = Long.parseLong(sinceIdParam);
        } catch (Exception e) {
            System.out.println("⚠ sinceId 변환 실패 → 기본값 0 사용");
        }

        // DAO 호출
        MemberDAO dao = new MemberDAO();
        List<MemberVO> list = dao.getLogsAfter(sinceId);

        // JSON 변환
        Gson gson = new Gson();
        String json = gson.toJson(list);

        System.out.println("[새 감지이력] " + json);

        // ✅ JSON 응답을 FrontController로 반환
        return "fetch:/" + json;
    }
}