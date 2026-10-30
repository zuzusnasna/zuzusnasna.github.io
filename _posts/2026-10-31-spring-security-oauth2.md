---
layout: post
title: "OAuth 2.0 로그인 — Authorization Code와 Spring Security 연동"
date: 2026-09-13 00:00:00 +0900
categories: [Spring]
tags: [Spring Security, OAuth2, OpenID Connect, Authorization Code]
---
## OAuth 2.0의 목적

OAuth 2.0은 사용자가 비밀번호를 서비스에 직접 제공하지 않고도 제3자 애플리케이션에 제한된 권한을 위임할 수 있도록 하는 권한 부여 프레임워크다. 소셜 로그인에서 사용자 인증 정보가 필요하다면 OpenID Connect(OIDC)가 OAuth 2.0 위에 사용자 인증 계층을 제공한다.

## Authorization Code 흐름

1. 사용자가 외부 인증 제공자 로그인 버튼을 누른다.
2. 애플리케이션이 인증 제공자로 브라우저를 리다이렉트한다.
3. 사용자가 동의하면 제공자가 Authorization Code를 Redirect URI로 전달한다.
4. 서버가 Code를 Token Endpoint에 전달해 토큰을 교환한다.
5. 서버가 사용자 정보를 확인하고 서비스 내부 계정과 연결한다.
6. 서비스 자체 로그인 세션이나 토큰을 발급한다.

브라우저에 Client Secret을 노출하지 않아야 한다. 서버 측 웹 애플리케이션은 Authorization Code 흐름을 사용하고, 공개 클라이언트는 PKCE 적용을 검토한다.

## 외부 계정과 내부 계정 연결

외부 제공자의 이메일만을 계정 식별자로 무조건 사용하면 이메일 변경이나 제공자별 중복 문제가 생길 수 있다. 제공자(provider)와 제공자 내부 식별자(provider user id)를 함께 저장해 외부 계정을 구분하는 방식이 안전하다.

## Spring Security 설정 관점

Spring Security OAuth2 Client는 ClientRegistration, Redirect URI, Client ID, Client Secret, 사용자 정보 엔드포인트 등을 설정으로 관리한다. 제공자별 응답 필드가 다르면 OAuth2UserService에서 서비스 내부 사용자 모델로 변환한다.

## 운영 체크리스트

- Redirect URI를 정확히 등록한다.
- Client Secret은 환경 변수나 Secret 저장소로 관리한다.
- state 검증과 PKCE 등 CSRF 방어 흐름을 확인한다.
- 최초 로그인과 기존 계정 연결 정책을 구분한다.
- 인증 실패·동의 취소·이메일 미제공 상황을 처리한다.

**정리:** OAuth2 로그인은 외부 인증 성공을 서비스 내부 계정으로 연결하는 과정이다. 외부 토큰과 서비스 자체 인증 수단을 구분하고 계정 연결 정책을 명확히 해야 한다.
