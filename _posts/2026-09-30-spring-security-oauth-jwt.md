---
layout: post
title: "Spring Security : 세션, JWT, OAuth2를 구분해서 이해하기"
date: 2026-09-30 09:00:00 +0900
categories: [학습]
tags: [Spring Boot, Spring Security, OAuth2, JWT]
---

인증 방식을 공부하면서 세션, JWT, OAuth2를 모두 로그인이라고 묶으면 오히려 헷갈렸다.

## Session

서버가 인증 상태를 저장하고 클라이언트는 세션 식별자를 전달한다.

```text
로그인
 ↓
서버 세션 생성
 ↓
Session ID
 ↓
이후 요청에서 인증 확인
```

## JWT

인증 정보를 토큰에 담아 클라이언트가 전달하는 방식이다. 서버가 매 요청마다 토큰의 서명과 내용을 검증한다.

## OAuth2

Google, Naver, Kakao 같은 외부 서비스가 사용자의 인증을 수행하고 우리 서비스가 그 결과를 이용하는 방식이다.

```text
우리 서비스
   ↓
OAuth Provider
   ↓
인증 성공
   ↓
Callback
   ↓
우리 서비스의 사용자 처리
```

## 중요한 구분

- Session / JWT → 인증 상태를 어떻게 유지하고 전달할 것인가
- OAuth2 → 외부 인증 제공자와 어떻게 인증을 연동할 것인가

## 배운 점

기술 이름보다 **인증 주체와 인증 상태가 어디에 존재하는지**를 먼저 보면 각 방식의 차이가 명확해졌다.
