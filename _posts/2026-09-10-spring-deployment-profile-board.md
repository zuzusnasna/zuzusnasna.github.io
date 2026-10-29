---
layout: post
title: "Spring Boot 학습 : Profile, JAR/WAR 배포와 게시판 실습"
date: 2026-09-10 09:00:00 +0900
categories: [학습]
tags: [Spring Boot, 배포, Profile, JPA, Spring Security]
---

Spring Boot 학습 후반에는 개발 코드뿐 아니라 실행 환경과 배포까지 함께 정리했다.

## Profile

개발·운영처럼 환경별 설정을 분리할 수 있다.

```text
application.yml
application-local.yml
application-prod.yml
```

실행 환경에 맞는 profile을 선택해 DB 주소나 외부 서비스 설정을 분리한다.

## JAR와 WAR

- JAR : Spring Boot 내장 서버와 함께 실행하기 쉬운 방식
- WAR : 외부 Tomcat 등에 배포할 수 있는 방식

## 게시판 실습

게시판에서는 다음 흐름을 한 번에 연결했다.

```text
회원가입
 → Spring Security 로그인
 → 게시글 작성
 → 작성자 연결
 → 수정 / 삭제
 → 권한 확인
```

Validation과 `BindingResult`, BCrypt, `@Transactional`까지 적용하면서 단순 CRUD보다 실제 웹 서비스 흐름을 경험할 수 있었다.
