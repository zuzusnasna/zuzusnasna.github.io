---
layout: post
title: "Spring Boot 학습 : Spring Security 인증과 인가"
date: 2026-09-09 09:00:00 +0900
categories: [학습]
tags: [Spring Boot, Spring Security, 인증, 인가]
---

Spring Security를 공부하면서 인증과 인가를 구분했다.

## 인증과 인가

- 인증(Authentication) : 사용자가 누구인지 확인
- 인가(Authorization) : 확인된 사용자가 무엇을 할 수 있는지 판단

## UserDetailsService

로그인 과정에서 사용자 정보를 조회하는 역할을 담당한다.

## BCrypt

비밀번호를 평문으로 저장하지 않고 해시 방식으로 저장한다.

```java
passwordEncoder.encode(rawPassword);
```

## 배운 점

로그인 기능을 만든다는 것은 단순히 아이디와 비밀번호를 비교하는 것이 아니라 **사용자 확인 → 인증 정보 생성 → 권한 판단 → 요청 접근 제어**까지 이어지는 흐름이라는 것을 이해했다.
