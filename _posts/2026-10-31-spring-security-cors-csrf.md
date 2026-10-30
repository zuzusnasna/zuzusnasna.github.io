---
layout: post
title: "Spring Security CORS와 CSRF — 브라우저 요청을 구분해서 이해하기"
date: 2026-09-15 00:00:00 +0900
categories: [Spring]
tags: [Spring Security, CORS, CSRF, Cookie, Browser]
---
## CORS와 CSRF는 다른 문제다

CORS는 브라우저가 서로 다른 Origin 간 응답을 JavaScript에 노출할지 결정하는 브라우저 보안 정책이다. CSRF는 사용자가 로그인된 상태를 악용해 의도하지 않은 요청을 보내도록 만드는 공격이다.

CORS 설정을 했다고 CSRF가 방어되는 것은 아니다.

## Origin 구성

Origin은 Scheme, Host, Port의 조합이다. 예를 들어 http://localhost:5173과 http://localhost:8080은 포트가 다르므로 서로 다른 Origin이다.

브라우저는 다른 Origin으로 요청할 때 CORS 정책을 적용한다. JSON POST나 특정 헤더를 포함한 요청은 실제 요청 전에 OPTIONS Preflight를 보낼 수 있다.

## Spring CORS 설정

```java
@Bean
CorsConfigurationSource corsConfigurationSource() {
    CorsConfiguration config = new CorsConfiguration();
    config.setAllowedOrigins(List.of("https://example.com"));
    config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE"));
    config.setAllowedHeaders(List.of("Authorization", "Content-Type"));
    config.setAllowCredentials(true);

    UrlBasedCorsConfigurationSource source =
        new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/api/**", config);
    return source;
}
```

Credentials를 허용할 때 허용 Origin에 와일드카드(*)를 사용할 수 없다. 운영 도메인을 명시하고 개발 환경 Origin과 분리한다.

## CSRF와 인증 방식

브라우저가 쿠키를 자동으로 전송하는 세션 인증은 CSRF 위험을 고려해야 한다. Authorization 헤더에 토큰을 명시적으로 넣는 구조는 위험 모델이 다르지만, 토큰을 쿠키에 저장하면 CSRF 고려가 다시 필요하다.

CSRF 보호를 무조건 끄기보다 인증 정보를 어디에 저장하고 브라우저가 자동으로 전송하는지부터 확인한다.

## 디버깅 순서

1. 요청 Origin과 서버 허용 Origin을 확인한다.
2. OPTIONS Preflight 응답 헤더를 확인한다.
3. credentials 설정과 쿠키 SameSite/Secure 속성을 확인한다.
4. CORS 오류인지 CSRF 토큰 검증 실패인지 구분한다.

**정리:** CORS는 브라우저의 응답 접근 정책이고 CSRF는 사용자 권한을 악용하는 요청 위조 공격이다. 서로 다른 문제이므로 인증 방식과 쿠키 사용 여부에 맞게 각각 설정해야 한다.
