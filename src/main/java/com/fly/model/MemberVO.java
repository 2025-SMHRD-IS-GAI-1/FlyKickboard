package com.fly.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MemberVO {
	private String id; // 아이디
	private String pw; // 비밀번호
	private String area; // 지역 (아이디)
	private String date; // 감지날짜
	private String type; // 감지유형
	private String loc; // 감지 위치
	private String prog; // 처리상태
	private String det_id; // 감지이력 아이디
	
	private int camera_id;        // CAMERA_ID
	private String region;        // REGION
	private String gu;            // GU
	private String dong;          // DONG
	private String inst_purpose;  // INST_PURPOSE (설치 목적)
	private String inst_dt;       // INST_DT (설치일자)
	private double latitude;      // LATITUDE (위도)
	private double longitude;     // LONGITUDE (경도)
	private String camera_loc;    // CAMERA_LOC (카메라 위치 이름)
	
}
