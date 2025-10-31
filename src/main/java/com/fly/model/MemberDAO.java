package com.fly.model;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import com.fly.db.MySqlSessionManager;

public class MemberDAO {
	private SqlSessionFactory factory = MySqlSessionManager.getFactory();
	
	
	public MemberVO Login(MemberVO mvo) {
		SqlSession sqlSession = factory.openSession();
		
		MemberVO vo = sqlSession.selectOne("login", mvo);
		
		sqlSession.close();
		
		return vo;
	}
}
