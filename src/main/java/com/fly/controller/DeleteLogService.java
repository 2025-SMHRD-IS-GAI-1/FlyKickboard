package com.fly.controller;

import java.io.BufferedReader;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fly.frontcontroller.Command;
import com.fly.model.MemberDAO;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

public class DeleteLogService implements Command {
	
	// 로그 삭제 데이터
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        try {
            // 요청 body 읽기
            BufferedReader reader = request.getReader();
            String json = reader.readLine();
            System.out.println("받은 JSON : " + json);

            // JSON → List<Integer> 변환 (중요!)
            Gson gson = new Gson();
            List<Integer> idList = gson.fromJson(json, new TypeToken<List<Integer>>(){}.getType());
            System.out.println("변환된 ID 리스트 : " + idList);

            // DAO 호출하여 삭제
            MemberDAO dao = new MemberDAO();
            int result = dao.DeleteLog(idList);

            // 성공 메시지 응답
            return "fetch:/" + result + "건 삭제 완료되었습니다.";

        } catch (Exception e) {
            e.printStackTrace();
            return "fetch:/삭제 실패";                                                
        }
    }
}