---
layout: post
title: "REST API 오류 응답 설계 — 클라이언트가 처리할 수 있는 에러 계약"
date: 2026-10-31 11:20:00 +0900
categories: [Spring]
tags: [Spring, REST, API Error, ExceptionHandler, ControllerAdvice]
---
## 오류 응답도 API 계약이다

성공 응답만 일관되고 오류 응답은 Controller마다 다르면 프론트엔드는 화면마다 다른 예외 처리를 해야 한다. 오류 응답에도 공통 구조와 상태 코드 규칙이 필요하다.

예를 들어 다음 정보를 제공할 수 있다.

- code: 클라이언트가 분기할 안정적인 오류 코드
- message: 사용자에게 보여줄 수 있는 설명
- fieldErrors: 입력 필드별 검증 실패
- timestamp 또는 traceId: 로그와 연결할 추적 정보

## 공통 응답 구조

```java
public record ApiError(
    String code,
    String message,
    List<FieldErrorDetail> fieldErrors
) {}

public record FieldErrorDetail(
    String field,
    String reason
) {}
```

@RestControllerAdvice에서 예외를 공통 응답으로 변환한다. 업무 예외는 명시적으로 정의하고, 예상하지 못한 예외는 내부 정보를 노출하지 않는 일반 오류로 처리한다.

## 상태 코드와 오류 코드의 역할

HTTP 상태 코드는 통신 계층에서 큰 실패 유형을 나타내고, 애플리케이션 오류 코드는 업무 의미를 구분한다. 예를 들어 409 Conflict 안에서도 이미 사용 중인 이메일과 재고 부족은 서로 다른 코드로 표현할 수 있다.

## 민감 정보 노출 방지

DB SQL, 스택 트레이스, 파일 경로, 토큰, 비밀번호를 응답에 포함하지 않는다. 상세 원인은 서버 로그에 남기되 민감 정보를 마스킹하고, 응답의 traceId로 운영 로그를 찾을 수 있게 한다.

## 프론트엔드와 합의할 사항

- 상태 코드별 공통 처리 방식
- 오류 코드의 이름과 의미
- 필드 검증 오류 배열 구조
- 로그인 만료 시 이동 정책
- 재시도 가능한 오류인지 여부

**정리:** 오류 응답을 표준화하면 서버 구현 변경과 프론트엔드 예외 처리를 분리할 수 있고, 운영 장애 추적도 쉬워진다.
