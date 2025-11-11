package com.fly.db;

import java.io.InputStream;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class SqlSessionManager {

    private static SqlSessionFactory sqlSessionFactory;

    static {
        try {
            // MyBatis 설정파일 (경로 주의)
            String resource = "com/fly/db/mybatis-config.xml";
            InputStream inputStream = Resources.getResourceAsStream(resource);
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // SqlSession 열기
    public static SqlSession getSqlSession() {
        return sqlSessionFactory.openSession(true); // auto-commit 모드
    }
}