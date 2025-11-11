package com.fly.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.fly.db.SqlSessionManager;

public class DetectionDAO {

    public DetectionVO selectDetectionDetail(int id) {
        DetectionVO vo = null;

        String sql = """
            SELECT D.DETECT_ID, D.CAMERA_ID, D.DETECT_TYPE, D.PROG_STATUS, D.REG_DT, D.CAMERA_LOC, F.FILE_ID, F.FILE_EXT
            FROM T_DETECTION D            
        	LEFT JOIN T_FILE F ON D.DETECT_ID = F.DETECT_ID   -- ✅ 조인 기준 수정
        	WHERE D.DETECT_ID = ? 
        """;

        try (Connection conn = SqlSessionManager.getSqlSession().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                vo = new DetectionVO();
                vo.setDetectId(rs.getInt("DETECT_ID"));
                vo.setCameraId(rs.getString("CAMERA_ID"));
                vo.setDetetType(rs.getString("DETECT_TYPE"));
                vo.setProgStatus(rs.getString("PROG_STATUS"));
                vo.setRegDt(rs.getString("REG_DT"));
                vo.setCameraLoc(rs.getString("CAMERA_LOC"));
                vo.setFileId(rs.getString("FILE_ID"));
                
                vo.setFileExt(rs.getString("FILE_EXT"));
                
            }
            rs.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return vo;
    }
}