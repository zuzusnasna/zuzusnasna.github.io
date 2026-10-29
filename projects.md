---
layout: default
title: "프로젝트"
permalink: /projects/
---

<section class="intro">
  <p class="eyebrow">PROJECTS</p>
  <h1>프로젝트</h1>
  <p>프로젝트 소개보다 실제로 막혔던 부분과 해결 과정을 중심으로 정리합니다.</p>
</section>

<div class="project-index">
  <section>
    <h2>개인 프로젝트</h2>
    <article class="project-entry">
      <h3>개인 프로젝트 : EMS</h3>
      <p>Spring Boot + React + Oracle 기반 장비 관리 시스템.</p>
      <ul>
        <li>장비 CRUD와 검색·필터링</li>
        <li>장비 상태 변경 이력 관리</li>
        <li>REST API, JUnit/Mockito, Swagger</li>
      </ul>
      <a href="{{ '/2026/09/20/personal-ems/' | relative_url }}">프로젝트 기록 보기 →</a>
    </article>

    <article class="project-entry">
      <h3>개인 프로젝트 : RealTimeChat</h3>
      <p>Spring Boot + React + WebSocket/STOMP + Redis Pub/Sub 기반 실시간 채팅.</p>
      <ul>
        <li>다중 인스턴스 메시지 중계</li>
        <li>EC2 자원 부족과 실시간 지연 분석</li>
        <li>k6 기반 WebSocket 부하 테스트</li>
        <li>메시지 순서 역전과 sequence gap 검증</li>
      </ul>
      <a href="{{ '/2026/09/22/personal-realtimechat/' | relative_url }}">프로젝트 기록 보기 →</a>
    </article>
  </section>

  <section>
    <h2>팀 프로젝트</h2>
    <article class="project-entry">
      <h3>팀 프로젝트 : SmartTicketing</h3>
      <p>3인 팀으로 개발한 영화 예매·취소표·접속 대기열 서비스.</p>
      <ul>
        <li>좌석 잠금 범위 축소</li>
        <li>Transactional Outbox로 취소표 이벤트 처리</li>
        <li>Redis Sorted Set 대기순번 캐시 검증</li>
        <li>Redis 기반 접속 대기열과 Lua 원자 처리</li>
      </ul>
      <a href="{{ '/2026/09/21/team-smartticketing/' | relative_url }}">프로젝트 기록 보기 →</a>
    </article>

    <article class="project-entry">
      <h3>팀 프로젝트 : GameHub</h3>
      <p>Java Servlet + JDBC + Oracle 기반 게임 커뮤니티.</p>
      <ul>
        <li>DAO / DTO / Servlet 구조</li>
        <li>회원·게시글·댓글·권한 구조</li>
        <li>feature → develop → main 협업</li>
      </ul>
      <a href="{{ '/2026/09/23/team-gamehub/' | relative_url }}">프로젝트 기록 보기 →</a>
    </article>

    <article class="project-entry">
      <h3>팀 프로젝트 : Meet-Up</h3>
      <p>모임 장소, 귀가 경로, 막차와 정산을 연결한 서비스. 현재 중단.</p>
      <ul>
        <li>외부 대중교통 API 데이터 정규화</li>
        <li>환승 경로의 막차 계산</li>
        <li>Redis 캐시와 최신 데이터 처리</li>
      </ul>
      <a href="{{ '/2026/09/24/team-meetup/' | relative_url }}">프로젝트 기록 보기 →</a>
    </article>

    <article class="project-entry">
      <h3>팀 프로젝트 : SwingFit</h3>
      <p>Android + TensorFlow Lite 기반 골프 스윙 영상 분석 앱.</p>
      <ul>
        <li>골프공 Detection / Tracking</li>
        <li>ROI 기반 분석 범위 축소</li>
        <li>GPU 실패 시 CPU 전환</li>
      </ul>
      <a href="{{ '/2026/09/25/team-swingfit/' | relative_url }}">프로젝트 기록 보기 →</a>
    </article>
  </section>
</div>
