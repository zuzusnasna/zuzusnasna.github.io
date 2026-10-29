---
layout: post
title: "팀 프로젝트 : GameHub — Servlet과 JDBC에서 직접 해결한 문제"
date: 2026-10-22 09:00:00 +0900
categories: [프로젝트]
tags: [GameHub, Java, Servlet, JDBC, Oracle]
---

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
