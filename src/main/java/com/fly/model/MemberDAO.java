package com.fly.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import com.fly.db.MySqlSessionManager;

public class MemberDAO {
	
	private SqlSessionFactory factory = MySqlSessionManager.getFactory();
	
	
	// ---------------------- [ 기존 기능 유지 ] ----------------------

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
	
	// 감지이력 조회
	public List<MemberVO> AllLog(MemberVO mvo) {
		SqlSession sqlSession = factory.openSession(true);
		List<MemberVO> vo = sqlSession.selectList("alllog", mvo);
		sqlSession.close();
		return vo;
	}

// 감지이력 삭제
public int DeleteLog(List<Integer> ids) {
	try (SqlSession sqlSession = factory.openSession(true)) {
	      // 1️⃣ 자식 테이블(T_FILE) 먼저 삭제
	      sqlSession.delete("deleteIds", ids);

	      // 2️⃣ 부모 테이블(T_DETECTION) 삭제
	      int row = sqlSession.delete("deleteLogs", ids);

	      return row; // 삭제된 감지이력 행 수 반환
    }
}

	// 메인화면 헬멧미착용 / 2인탑승 분류
	public List<MemberVO> LogType(MemberVO mvo) {
        SqlSession sqlSession = factory.openSession(true);
        // namespace + SQL ID 조합으로 호출됨
        List<MemberVO> list = sqlSession.selectList("com.fly.model.MemberDAO.logtype", mvo);
        sqlSession.close();
        return list;
    }

	// 감지 상태 변경 (처리중 / 완료)
	public int updateStatus(MemberVO vo) {
		SqlSession sqlSession = factory.openSession(true);
		int row = sqlSession.update("updatestatus", vo);
		sqlSession.close();
		return row;
	}

	



	
	
	// ---------------------- [ 지도 + 실시간 로그 기능 추가 ] ----------------------

	/**
	 * ✅ 최근 감지 로그 100건 (초기 로딩용)
	 */
	public List<MemberVO> getRecentLogs() {
		SqlSession sqlSession = factory.openSession(true);
		List<MemberVO> list = sqlSession.selectList("getDetectionWithCamera");
		sqlSession.close();
		return list;
	}

	/**
	 * ✅ 새 감지 로그만 가져오기 (실시간 추가용)
	 * @param sinceId 마지막으로 본 DETECT_ID
	 */
	public List<MemberVO> getLogsAfter(long sinceId) {
		SqlSession sqlSession = factory.openSession(true);
		List<MemberVO> list = sqlSession.selectList("getLogsAfter", sinceId);
		sqlSession.close();
		return list;
	}

	/**
	 * ✅ CCTV 전체 목록 가져오기 (지도용)
	 */
	public List<MemberVO> getAllCameras() {
		SqlSession sqlSession = factory.openSession(true);
		List<MemberVO> list = sqlSession.selectList("getAllCameras");
		sqlSession.close();
		return list;
	}

	/**
	 * ✅ 감지 + CCTV JOIN 조회 (지도 클릭 시 상세)
	 */
	public List<MemberVO> getDetectionWithCamera(MemberVO vo) {
		SqlSession sqlSession = factory.openSession(true);
		List<MemberVO> list = sqlSession.selectList("getDetectionWithCamera", vo);
		sqlSession.close();
		return list;
	}
}

