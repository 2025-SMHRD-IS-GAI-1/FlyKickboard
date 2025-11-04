package com.fly.model;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import com.fly.db.MySqlSessionManager;

public class MemberDAO {
	private SqlSessionFactory factory = MySqlSessionManager.getFactory();
	
	
	public MemberVO Login(MemberVO mvo) {
		SqlSession sqlSession = factory.openSession(true);
	
		MemberVO vo = sqlSession.selectOne("login", mvo);
		
		sqlSession.close();
		
		return vo;
	}
	public int Join(MemberVO mvo) {
		SqlSession sqlSession = factory.openSession(true);
		
		int row = sqlSession.insert("join", mvo);
		
		sqlSession.close();
		
		return row;
	}
	
	public void LastLogin(String id) {
		SqlSession sqlSession = factory.openSession(true);
		
		sqlSession.update("lastlogin", id);
		
		sqlSession.close();
	
	}
	public List<MemberVO> AllManager() {
		SqlSession sqlSession = factory.openSession(true);
		
		List<MemberVO> vo = sqlSession.selectList("allmanager");
		
		sqlSession.close();
		
		return vo;
	}
	
	public int DeleteUser(String id) {
		SqlSession sqlSession = factory.openSession(true);
		
		int row = sqlSession.delete("deleteuser", id);
		
		sqlSession.close();
		
		return row;
	}
}
	