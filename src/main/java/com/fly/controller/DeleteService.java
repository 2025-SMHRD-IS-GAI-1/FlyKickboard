package com.fly.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fly.frontcontroller.Command;
import com.fly.model.MemberDAO;
import com.fly.model.MemberVO;

public class DeleteService implements Command {
	
	
	@Override
	// 유저 삭제
	public String execute(HttpServletRequest request, HttpServletResponse response) {
	    
	    System.out.println("===== DeleteService 실행됨! ====="); 
	    
	     String id = request.getParameter("id");
	    
	    // 빈칸("")인지, null인지 정확히 확인
	    System.out.println("삭제할 ID 파라미터 : " +  id); 

	    if (id == null || id.trim().isEmpty()) {
	        System.out.println("실패");
	        return "redirect:/Manager.do";
	    }

	    MemberDAO dao = new MemberDAO();
	    int row = dao.DeleteUser(id); 
	    
	    System.out.println("행 : " + row);
	    
	    if (row > 0) {
	        System.out.println("성공"); 
	    } else {
	        System.out.println("실패");
	    }
	    
	    return "redirect:/Manager.do";
	}

}
