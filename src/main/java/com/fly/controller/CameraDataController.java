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

@WebServlet("/api/mapdata")  // ✅ 오타, 대소문자 주의!
public class CameraDataController extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse res)
      throws IOException {

    res.setContentType("application/json; charset=UTF-8");

    try {
      MemberDAO dao = new MemberDAO();
      List<MemberVO> cameras = dao.getAllCameras();
      new Gson().toJson(cameras, res.getWriter());
    } catch (Exception e) {
      res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      res.getWriter().write("{\"error\":\"CameraDataController error\"}");
    }
  }
}