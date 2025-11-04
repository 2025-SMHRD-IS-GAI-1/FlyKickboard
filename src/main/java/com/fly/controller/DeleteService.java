package com.fly.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fly.frontcontroller.Command;
import com.fly.model.MemberDAO;
import com.fly.model.MemberVO;

public class DeleteService implements Command {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {
	    
	    System.out.println("===== DeleteService 실행됨! ====="); 
	    
	     String id = request.getParameter("id");
	    
	    // ★★★★★★★ 이렇게 수정하세요! ★★★★★★★
	    // 빈칸("")인지, null인지 정확히 확인
	    System.out.println("삭제할 ID 파라미터: [" + id + "]"); 
	    // ★★★★★★★★★★★★★★★★★★★★★★★

	    if (id == null || id.trim().isEmpty()) {
	        System.out.println("ID가 null이거나 비어있어서 중단합니다.");
	        return "redirect:/Manager.do";
	    }

	    MemberDAO dao = new MemberDAO();
	    int row = dao.DeleteUser(id); 
	    
	    System.out.println("DAO 실행 결과 (삭제된 행 수): " + row);
	    
	    if (row > 0) {
	        System.out.println("성공"); // "성공"으로 변경
	    } else {
	        System.out.println("실패");
	    }
	    
	    return "redirect:/Manager.do";
	}

}
