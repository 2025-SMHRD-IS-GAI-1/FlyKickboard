package com.fly.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.SqlSession;

import com.fly.db.SqlSessionManager;

@WebServlet("/showImage")
public class ShowImageServlet extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int fileId = Integer.parseInt(request.getParameter("id"));

        try (SqlSession sqlSession = SqlSessionManager.getSqlSession()) {
            Connection conn = sqlSession.getConnection();
            String sql = "SELECT FILE_DATA, FILE_EXT FROM T_FILE WHERE FILE_ID = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, fileId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                InputStream input = rs.getBinaryStream("FILE_DATA");
                if (input == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "이미지 데이터 없음");
                    return;
                }

                // ✅ 파일 MIME 타입 지정 (DB에 FILE_TYPE이 없으면 기본값으로)
                String fileExt = rs.getString("FILE_Ext");
                if (fileExt == null || fileExt.isEmpty()) {
                    fileExt = "image/jpeg";  // 기본값
                }
                response.setContentType(fileExt);

                OutputStream output = response.getOutputStream();
                byte[] buffer = new byte[4096];
                int bytesRead;

                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }

                input.close();
                output.flush();
                output.close();  // ✅ 명시적으로 닫기
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "이미지 파일을 찾을 수 없습니다.");
            }

            rs.close();
            pstmt.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "이미지 로딩 오류");
        }
    }
}