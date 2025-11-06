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
	private String prog;
}
