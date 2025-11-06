package com.fly.model;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import com.fly.db.MySqlSessionManager;

public class MemberDAO {
	private SqlSessionFactory factory = MySqlSessionManager.getFactory();
	
	// 로그인
	public MemberVO Login(MemberVO mvo) {
		SqlSession sqlSession = factory.openSession(true);
	
		MemberVO vo = sqlSession.selectOne("login", mvo);
		
		sqlSession.close();
		
		return vo;
	}
	// 사용자 추가
	public int Join(MemberVO mvo) {
		SqlSession sqlSession = factory.openSession(true);
		
		int row = sqlSession.insert("join", mvo);
		
		sqlSession.close();
		
		return row;
	}
	// 최근 로그인 기록
	public void LastLogin(String id) {
		SqlSession sqlSession = factory.openSession(true);
		
		sqlSession.update("lastlogin", id);
		
		sqlSession.close();
	
	}
	// 사용자 전체 조회
	public List<MemberVO> AllManager() {
		SqlSession sqlSession = factory.openSession(true);
		
		List<MemberVO> vo = sqlSession.selectList("allmanager");
		
		sqlSession.close();
		
		return vo;
	}
	// 사용자 삭제
	public int DeleteUser(String id) {
		SqlSession sqlSession = factory.openSession(true);
		
		int row = sqlSession.delete("deleteuser", id);
		
		sqlSession.close();
		
		return row;
	}
	// 사용자 수정
	public int UpdateUser(MemberVO mvo) {
		SqlSession sqlSession = factory.openSession(true);
		
		int row = sqlSession.update("updateuser", mvo);
		
		sqlSession.close();
		
		return row;
	}
	// 사용자 검색
	public List<MemberVO> SearchUser(String keyword) {
		SqlSession sqlSession = factory.openSession(true);
		
		List<MemberVO> vo = sqlSession.selectList("searchuser", keyword);
		
		sqlSession.close();
		
		return vo;
	}
	
	public List<MemberVO> AllLog(MemberVO mvo) {
		SqlSession sqlSession = factory.openSession(true);
		
		List<MemberVO> vo = sqlSession.selectList("alllog", mvo);
		
		sqlSession.close();
		
		return vo;
	}
}
	