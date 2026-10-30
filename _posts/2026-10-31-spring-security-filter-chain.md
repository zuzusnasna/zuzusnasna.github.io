---
layout: post
title: "Spring Security Filter Chain — 인증과 인가가 처리되는 순서"
date: 2026-10-30 00:00:00 +0900
categories: [Spring]
tags: [Spring Security, Filter Chain, Authentication, Authorization]
---
## Spring Security는 어디서 동작하는가

Spring Security는 Controller에 도착하기 전 Servlet Filter 영역에서 요청을 검사한다. DelegatingFilterProxy가 Spring의 FilterChainProxy로 요청을 전달하고, FilterChainProxy는 요청에 맞는 SecurityFilterChain을 선택한다.

## 인증과 인가

- 인증(Authentication): 요청을 보낸 사용자가 누구인지 확인
- 인가(Authorization): 인증된 사용자가 해당 리소스에 접근할 권한이 있는지 확인

일반적인 흐름은 요청 수신 → SecurityContext 확인 → 인증 필터 처리 → SecurityContext 저장 → Authorization 검사 → DispatcherServlet 전달 순서로 이해할 수 있다. 실제 필터 순서는 설정과 인증 방식에 따라 달라진다.

## SecurityFilterChain 설정

```java
@Bean
SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    return http
        .authorizeHttpRequests(auth -> auth
            .requestMatchers("/api/auth/**").permitAll()
            .requestMatchers("/api/admin/**").hasRole("ADMIN")
            .anyRequest().authenticated()
        )
        .build();
}
```

인증이 필요 없는 경로를 구체적으로 선언하고 나머지는 기본 차단하는 방식이 안전하다. 경로 패턴 순서와 매칭 범위를 검토해야 한다.

## 401과 403

인증되지 않았거나 인증 정보가 유효하지 않으면 일반적으로 401, 인증은 되었지만 권한이 없으면 403을 반환한다. API 서버는 로그인 페이지로 리다이렉트하는 기본 동작 대신 JSON 오류 응답을 제공하도록 EntryPoint와 AccessDeniedHandler를 구성할 수 있다.

## 실무 디버깅

- 요청이 Controller에 도달하지 않는다면 Security 로그와 필터 체인을 확인한다.
- 인증 객체가 SecurityContext에 들어갔는지 확인한다.
- 특정 URL이 예상과 다른 규칙에 매칭되는지 확인한다.
- CORS preflight OPTIONS 요청이 인증 규칙에 막히지 않는지 확인한다.

**정리:** Security 문제는 Controller보다 앞단에서 발생하는 경우가 많다. 필터 체인과 인증·인가의 차이를 알면 401·403 문제를 추적하기 쉽다.
