package com.fly.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fly.model.MemberDAO;
import com.fly.model.MemberVO;
import com.google.gson.Gson;

@WebServlet("/api/mapdata")
public class CameraDataController extends HttpServlet {
	
  @Override
  // 카메라 데이터 + 감지로그데이터 
  protected void doGet(HttpServletRequest req, HttpServletResponse res)
      throws IOException {

    res.setContentType("application/json; charset=UTF-8");
    Gson gson = new Gson();
    MemberDAO dao = new MemberDAO();

    try {
      // 카메라 + 감지 로그 JOIN 데이터 (20건)
      List<MemberVO> detections = dao.LogType(new MemberVO());
      gson.toJson(detections, res.getWriter());
    } catch (Exception e) {
      res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      res.getWriter().write("{\"error\":\"CameraDataController error\"}");
      e.printStackTrace();
    }
  }
}