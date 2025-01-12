## 🏍 바이크 커뮤니티 앱 개발 프로젝트

### 📝 프로젝트 개요
- **프로젝트 유형**: 2인 프로젝트 (기획 1명, 개발 1명)
- **개발 기간**: 2021.06 ~ 2021.11 (6개월)
- **기여도**: 80%

### 🛠 사용 기술
- Flutter 3.0
- Node.js
- Express.js
- Socket.io
- MySQL 5.7
- Firebase Authentication
- Firebase Storage

### 💡 주요 구현 기능
1. 스크롤뷰 성능 최적화
    - 이미지 압축 + 이미지 로컬 캐싱
2. 카카오맵 API 연동
    - WebView 기반 지도 서비스 구현 <- Flask로 HTML 서빙
    - 위치 기반 서비스
3. 실시간 채팅 기능
    - WebSocket 기반

### 구현 화면
<div align="center">
  <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 40px;">
    <div style="text-align: center">
      <img src="img/login.png" width="150" />
      <p style="max-width: 150px; margin: 10px auto; height: 40px; line-height: 1.2">
        로그인 화면<br/>Firebase Auth 기반 문자 인증
      </p>
    </div>
    <div style="text-align: center">
      <img src="img/feed.png" width="150" />
      <p style="max-width: 150px; margin: 10px auto; height: 40px; line-height: 1.2">
        메인화면<br/>바이크 관련 게시글 피드
      </p>
    </div>
    <div style="text-align: center">
      <img src="img/goods_post.png" width="150" />
      <p style="max-width: 150px; margin: 10px auto; height: 40px; line-height: 1.2">
        상품 화면<br/>중고 거래
      </p>
    </div>
    <div style="text-align: center">
      <img src="img/goods_detail.png" width="150" />
      <p style="max-width: 150px; margin: 10px auto; height: 40px; line-height: 1.2">
        상품 상세 화면<br/>중고 거래
      </p>
    </div>
    <div style="text-align: center">
      <img src="img/new_goods.png" width="150" />
      <p style="max-width: 150px; margin: 10px auto; height: 40px; line-height: 1.2">
        상품 등록 화면<br/>중고 거래
      </p>
    </div>
    <div style="text-align: center">
      <img src="img/tour_post.png" width="150" />
      <p style="max-width: 150px; margin: 10px auto; height: 40px; line-height: 1.2">
        투어 모임<br/>모임 게시글 피드
      </p>
    </div>
    <div style="text-align: center">
      <img src="img/bottom_toggle.png" width="150" />
      <p style="max-width: 150px; margin: 10px auto; height: 40px; line-height: 1.2">
        하단 탭 메뉴<br/>홈, 중고거래, 투어모임
      </p>
    </div>
    <div style="text-align: center">
      <img src="img/new_tour.png" width="150" />
      <p style="max-width: 150px; margin: 10px auto; height: 40px; line-height: 1.2">
        투어 모임 등록 화면<br/>카카오맵 API 연동
      </p>
    </div>
  </div>
</div>


