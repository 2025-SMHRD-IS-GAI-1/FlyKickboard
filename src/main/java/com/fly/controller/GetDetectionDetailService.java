package com.fly.controller;

import javax.servlet.http.*;
import com.fly.frontcontroller.Command;
import com.fly.model.DetectionDAO;
import com.fly.model.DetectionVO;
import com.google.gson.Gson;

public class GetDetectionDetailService implements Command {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            DetectionDAO dao = new DetectionDAO();
            DetectionVO vo = dao.selectDetectionDetail(id);

            response.setContentType("application/json; charset=UTF-8");
            new Gson().toJson(vo, response.getWriter()); // ✅ JSON 직렬화
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "데이터 조회 실패");
            } catch (Exception ignored) {}
        }
        return null; // View 이동 없음 (Ajax 응답이므로)
    }
}