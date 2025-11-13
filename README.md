**1. 프로젝트 개요**
YOLO11 기반 경찰 업무 효율화 공유 킥보드 법규 위반 단속 시스템
- 킥보드 이용자 증가와 비례하여 안전사고 발생 건수도 증가
- 안전모 착용 실태 및 규제 한계
- 대부분의 지자체는 공유 킥보드 안전관리 및 단속 업무를 인력에 의존, 하지만 관할 지역 내 설치된 CCTV 수에 비해 단속 인력은 절대적으로 부족하고 현장 단속 또한 인력과 시간의 한계로 인해 지속적으로 단속하기가 어려움
- 단순 단속 중심의 방식에서 벗어나, 스마트 모니터링 기반의 사전 예방적 안전 관리 체계로 발전할 필요

**2. 주요기능**
▪ 개발 목표 
 - 공유킥보드 이용 증가로 인한 안전사고 문제를 해결하기 위해 이용자의 안전모 미착용 및 2인 이상 탑승을 AI 객체탐지 기반으로 실시간 단속, 관리 함으로써 교통사고 예방과 공공 안전 증진을 도모 
▪ 개발 내용 
 - 영상 입력 처리 기능
 - 객체 탐지 기능
   1) 2인 이상 탐지 기능
   2) 안전모 착용 여부 탐지 기능
 - 알림 및 기록 기능
   1) 단속 대상 탐지 시 관리자에게 알림
   2) 탐지 결과(이미지, 로그, 탐지 시각, 위치 포함) DB 저장
   3) 대시보드에 통계 제공 (탐지 건수, 위반 유형별 비율)
 - 탐지 후 처리 기능

**3. 기술스택**

<img width="1521" height="617" alt="image" src="https://github.com/user-attachments/assets/0d32cc31-007b-426e-856c-d94373b06a97" />


**4. 시스템 아키텍처**

<img width="1521" height="743" alt="image" src="https://github.com/user-attachments/assets/94fbcfe4-cba3-423b-817a-6dc37809f73b" />

**5. 유스케이스**

![KakaoTalk_20251113_121415420](https://github.com/user-attachments/assets/03921c12-ba76-4fe7-a214-1e1831ca282e)

**6. ERD다이어그램**

<img width="1826" height="822" alt="KakaoTalk_20251111_202221392" src="https://github.com/user-attachments/assets/865302a6-ae2e-458d-b4ea-572785dc2654" />

**7. 서비스 흐름도**
![KakaoTalk_20251113_121415420_01](https://github.com/user-attachments/assets/7bc5617f-a313-4abd-aaa6-ca05ca0382ea)

**8. 화면구성**
 
 - 로그인

<img width="1914" height="951" alt="image" src="https://github.com/user-attachments/assets/fd8deec8-f0d5-43bb-8337-45bc90a0c7ff" />
 
 - 메인화면

<img width="1915" height="953" alt="image" src="https://github.com/user-attachments/assets/86ee206c-fb77-4811-a412-3ea57db0eecf" />

 - 감지이력 조회

<img width="1915" height="952" alt="image" src="https://github.com/user-attachments/assets/6730f8ad-a66d-49fc-b9c2-26adac94be2c" />

 - 관리자 메뉴

<img width="1917" height="952" alt="image" src="https://github.com/user-attachments/assets/713949ba-56a7-4101-82d0-f91ead29c0fc" />

**9. 모델 개발 및 트러블 슈팅**

 - 문제 1 

<img width="1592" height="619" alt="image" src="https://github.com/user-attachments/assets/4b5dcd7f-f183-47e1-83ad-bd357b4fa579" />

 - 문제 2

<img width="1594" height="591" alt="image" src="https://github.com/user-attachments/assets/bfa38304-3b04-4ee5-be86-487432f06454" />

**10. 팀원 역할**

<img width="1074" height="523" alt="image" src="https://github.com/user-attachments/assets/0179f8c9-4108-474c-9f89-a2cace31110d" />

**11. 참고문헌**
                        
<img width="946" height="438" alt="image" src="https://github.com/user-attachments/assets/9a6ffcd0-16a0-4d46-9d9d-b3f770103e43" />




