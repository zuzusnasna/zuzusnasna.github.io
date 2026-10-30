---
layout: post
title: "부트캠프 : Spring Validation과 전역 예외 처리"
date: 2026-07-21 00:00:00 +0900
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

## 더 깊게 이해하기: 검증은 신뢰 경계에서 수행한다

클라이언트 검증은 사용자가 잘못된 입력을 빠르게 수정하도록 돕지만, 서버 검증을 대신하지 못한다. 요청은 브라우저 개발자 도구나 별도 프로그램으로 조작할 수 있으므로 길이, 범위, 형식, 필수 값, 권한은 서버에서 다시 확인해야 한다.

입력값 검증과 업무 규칙 검증도 구분해야 한다. 이메일 형식이 올바른지는 입력 검증이고, 해당 이메일이 이미 등록되어 있는지는 DB 상태를 확인하는 업무 규칙이다. 두 종류를 같은 위치에 무분별하게 섞으면 테스트와 오류 응답이 복잡해질 수 있다.

### 검증 설계
- DTO에서 형식과 필수값을 검증하는가?
- 여러 요청 경로에서 공유되는 업무 규칙을 서비스 계층에서 확인하는가?
- 필드별 오류를 클라이언트가 이해할 수 있는 구조로 반환하는가?
- 내부 예외 메시지나 SQL 정보를 외부에 노출하지 않는가?

검증과 예외 처리는 입력을 막는 것만이 아니라 잘못된 요청이 시스템 내부 상태를 훼손하지 않도록 하는 경계다.
