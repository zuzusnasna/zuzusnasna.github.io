---
layout: post
title: "부트캠프 : Spring Validation과 전역 예외 처리"
date: 2026-10-30 14:00:00 +0900
categories: [학습]
tags: [Spring Boot, REST API]
---

실제 API에서는 잘못된 요청을 Controller에서 일일이 검사하면 코드가 반복된다. 입력 검증을 DTO에 모으고 공통 예외 처리를 두면 구조가 깔끔해진다.

## DTO 검증

```java
public record CreateMemberRequest(
    @NotBlank String username,
    @Email String email
) {}
```

```java
@PostMapping
public ResponseEntity<?> create(@Valid @RequestBody CreateMemberRequest request) {
    return ResponseEntity.ok(service.create(request));
}
```

## 전역 예외 처리

```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<?> handle(BusinessException e) {
        return ResponseEntity.badRequest().body(e.getMessage());
    }
}
```

## 왜 중요한가

API가 커질수록 오류 응답 형식이 일정해야 프론트엔드가 처리하기 쉽다.

```text
400 → 잘못된 요청
401 → 인증 필요
403 → 권한 없음
404 → 리소스 없음
409 → 충돌
500 → 서버 오류
```

## 배운 점

검증과 예외 처리는 기능 하나가 아니라 **API 전체의 일관성을 만드는 공통 기반**이라고 생각하게 됐다.
