---
layout: post
title: "팀 프로젝트 : GameHub — Servlet과 JDBC에서 직접 해결한 문제"
date: 2026-10-22 09:00:00 +0900
categories: [프로젝트]
tags: [GameHub, Java, Servlet, JDBC, Oracle]
---

<figure class="project-visual">
  <img src="https://raw.githubusercontent.com/zuzusnasna/miniproject/main/src/main/webapp/images/icon/lol.jpg" alt="GameHub 게임 목록에 사용되는 게임 썸네일 예시" loading="lazy">
  <figcaption>GameHub의 게임 카탈로그에서 사용하는 썸네일 이미지 예시.</figcaption>
</figure>

GameHub는 Spring 없이 Java Servlet + Tomcat + JDBC + Oracle을 직접 연결한 프로젝트라서 웹 요청부터 DB 연결까지 각 단계가 눈에 보였다.

## 전체 요청 흐름

```text
Browser
  ↓ HTTP
Servlet Controller
  ↓
Service
  ↓
DAO
  ↓ JDBC
Oracle
```

Spring을 사용하면 프레임워크가 대신 처리해 주는 부분을 직접 작성했기 때문에 구조를 이해하는 데 도움이 됐다.

## JDBC 연결 문제

Oracle 연결에서는 DB URL, 포트, 서비스명과 PDB 설정이 맞지 않으면 연결 자체가 실패한다.

예를 들어 Oracle XE 환경에서는 다음과 같은 PDB 접속 주소를 사용했다.

```text
jdbc:oracle:thin:@localhost:1521/XEPDB1
```

환경에 따라 SID와 Service Name을 혼동하면 연결 오류가 발생할 수 있었다.

## DAO의 역할

```java
public MemberDTO findByUsername(String username) {
    // SQL 실행
    // ResultSet 조회
    // DTO 변환
}
```

DAO는 SQL과 DB 접근을 담당하고 Servlet은 HTTP 요청과 응답에 집중하도록 책임을 나눴다.

## 배운 점

Spring을 사용하기 전 직접 JDBC를 구현해 보니 이후 Spring Data JPA나 MyBatis를 사용할 때 **프레임워크가 무엇을 추상화하고 있는지** 이해하기 쉬워졌다.

## 더 깊게 이해하기: 오류 메시지에서 원인 범위를 좁히기

데이터베이스 연결 문제는 SQL 문법 오류와 구분해야 한다. 연결 URL, 서비스 이름, 포트, 계정 권한, 드라이버, 네트워크 접근이 서로 다른 실패 지점을 만든다. 예를 들어 Oracle의 컨테이너 데이터베이스에서 PDB를 사용하는 경우 SID와 서비스 이름을 혼동하면 서버는 실행 중이어도 접속이 실패할 수 있다.

JDBC 디버깅은 애플리케이션 코드만 읽기보다 연결 문자열과 실제 DB 상태를 각각 확인하는 방식이 효과적이다. 먼저 DB 클라이언트로 동일한 접속 정보가 유효한지 확인하고, 그다음 Java 드라이버와 애플리케이션 설정을 검증한다.

### 확인 순서
1. DB 프로세스와 리스너가 실행 중인지 확인한다.
2. 호스트·포트·서비스 이름이 실제 환경과 일치하는지 확인한다.
3. 계정의 로그인 권한과 대상 스키마 접근 권한을 확인한다.
4. JDBC 드라이버 버전과 URL 형식을 확인한다.
5. 비밀번호나 접속 문자열을 로그에 노출하지 않고 오류 원인을 분리한다.

연결 실패를 해결할 때는 설정을 여러 개 동시에 바꾸지 말고 한 조건씩 검증해야 무엇이 원인이었는지 학습할 수 있다.
