package com.fly.db;

import java.io.IOException;
import java.io.InputStream;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class MySqlSessionManager {
	static SqlSessionFactory sqlSessionFactory;
	//
	// static 형태의 인스턴스 블록 == 생성자 역할
	// "객체를 생성하지 않더라도", 인스턴스를 부르기만 하면 호출되는 영역
	static {
		String resource = "com/fly/db/mybatis-config.xml";
		InputStream inputStream;
		try {
			inputStream = Resources.getResourceAsStream(resource);
			sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
			// SqlSession == Connection
			// SqlSessionFactory == DBCP (Data Base Connection Pool)
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	// DBCP를 리턴하는 메소드 생성
		public static SqlSessionFactory getFactory() {
			
			return sqlSessionFactory;
			
		}
	
}
