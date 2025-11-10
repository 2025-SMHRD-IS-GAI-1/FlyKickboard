package com.fly.controller;

import java.util.List;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.fly.frontcontroller.Command;
import com.fly.model.MemberDAO;
import com.fly.model.MemberVO;

import javax.servlet.http.HttpServletRequest;   // ✅ 추가
import javax.servlet.http.HttpServletResponse;  // ✅ 추가

public class UpdateStatusService implements Command {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        String idsJson = request.getParameter("ids"); // 다중 처리용
        String status = request.getParameter("status");

        System.out.println("요청 파라미터: id=" + id + ", ids=" + idsJson + ", status=" + status);

        MemberDAO dao = new MemberDAO();
        int successCount = 0;

        if (idsJson != null && !idsJson.isBlank()) {
            try {
                List<String> ids = new Gson().fromJson(idsJson, new TypeToken<List<String>>(){}.getType());
                for (String detId : ids) {
                    MemberVO vo = new MemberVO();
                    vo.setDet_id(detId.trim());
                    vo.setProg(status != null ? status : "처리완료");
                    int row = dao.updateStatus(vo);
                    if (row > 0) successCount++;
                }
                System.out.println("✅ 다중 업데이트 성공: " + successCount + "건");
            } catch (Exception e) {
                e.printStackTrace();
                return "fetch:/JSON 파싱 오류";
            }
        } else if (id != null && !id.isBlank()) {
            MemberVO vo = new MemberVO();
            vo.setDet_id(id.trim());
            vo.setProg(status != null ? status : "처리중");
            int row = dao.updateStatus(vo);
            if (row > 0)
                System.out.println("✅ 단일 업데이트 성공: id=" + id + ", status=" + vo.getProg());
            else
                System.out.println("⚠️ 단일 업데이트 실패");
        }

        return "Logs.jsp";
    }
}