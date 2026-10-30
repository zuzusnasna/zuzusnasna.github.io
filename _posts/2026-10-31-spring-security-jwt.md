---
layout: post
title: "JWT 인증 흐름 — Access Token 검증과 Refresh Token 재발급"
date: 2026-10-14 00:00:00 +0900
categories: [Spring]
tags: [Spring Security, JWT, Access Token, Refresh Token]
---
## JWT가 필요한 상황

서버 세션 방식은 서버가 로그인 상태를 보관한다. JWT 기반 인증은 서명된 토큰을 클라이언트가 보관하고 요청마다 전달하며, 서버가 서명과 만료를 검증해 인증 정보를 구성한다. 토큰을 쓴다고 인증과 권한 관리가 자동으로 해결되는 것은 아니다.

## 요청 흐름

1. 사용자가 로그인 정보를 전송한다.
2. 서버가 자격 증명을 검증한다.
3. Access Token을 발급한다.
4. 클라이언트는 Authorization: Bearer 헤더에 토큰을 담아 API를 호출한다.
5. 필터가 서명, 만료, 발급자 등 필요한 Claim을 검증한다.
6. 검증된 사용자 정보를 SecurityContext에 설정한다.

## Access와 Refresh의 역할

Access Token은 API 접근에 사용하고 수명을 짧게 가져간다. Refresh Token은 Access Token 재발급에 사용하므로 더 엄격하게 보관·폐기 정책을 관리해야 한다.

Refresh Token을 DB나 Redis에 저장하면 로그아웃, 강제 만료, 기기별 세션 관리가 가능하다. JWT가 자체 완결형이라고 해도 폐기 요구사항이 있다면 서버 측 상태 저장이 필요할 수 있다.

## 보안 체크

- 서명 알고리즘과 검증 키를 서버에서 고정한다.
- 토큰의 만료, 발급자, 대상 등을 검증한다.
- 비밀번호나 민감 정보를 Claim에 넣지 않는다.
- 로그에 토큰 원문을 남기지 않는다.
- XSS와 CSRF 위험을 고려해 저장 위치를 결정한다.
- Refresh Token 재사용 감지와 회전 정책을 검토한다.

## 로그아웃

Access Token이 만료되기 전까지 유효한 구조라면 로그아웃만으로 이미 발급된 토큰이 즉시 무효가 되지 않을 수 있다. 블랙리스트, 짧은 만료 시간, Refresh Token 폐기 등 요구사항에 맞는 정책을 선택한다.

**정리:** JWT는 세션을 없애는 마법이 아니라 인증 상태를 전달하는 토큰 형식이다. 만료, 폐기, 저장 위치, 재발급 정책을 함께 설계해야 한다.
