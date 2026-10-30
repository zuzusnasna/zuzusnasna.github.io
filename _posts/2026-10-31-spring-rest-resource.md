---
layout: post
title: "REST 리소스 URI 설계 — 중첩 리소스와 검색 조건 표현"
date: 2026-09-24 00:00:00 +0900
categories: [Spring]
tags: [Spring, REST, URI Design, Resource, Query Parameter]
---
## URI는 리소스를 식별한다

URI는 동작 명령보다 리소스를 식별하는 데 초점을 둔다. 주문 생성은 POST /api/orders, 특정 주문은 GET /api/orders/{id}로 표현할 수 있다.

## 중첩 리소스

특정 회원의 주문을 조회한다면 GET /api/members/{memberId}/orders처럼 부모와 자식 관계를 표현할 수 있다. 다만 URI가 지나치게 깊어지면 리소스 식별이 어려워진다. 주문 자체가 독립 식별자를 가진다면 GET /api/orders/{orderId}도 함께 제공할 수 있다.

## 검색과 필터

검색 조건은 Query Parameter로 표현한다.

```http
GET /api/orders?status=PAID&from=2026-10-01&size=20
```

경로는 리소스 식별, Query Parameter는 필터·정렬·페이징처럼 조회 조건을 전달하는 용도로 구분하면 API를 이해하기 쉽다.

## URI 설계 원칙

- 컬렉션은 일관된 복수형 이름 사용
- 리소스 식별자는 경로 변수로 표현
- 검색 조건은 Query Parameter로 전달
- HTTP 메서드로 조회·생성·수정·삭제 의도를 표현
- 특정 화면에만 종속된 동사형 엔드포인트를 남발하지 않기

## 버전과 호환성

응답 필드 추가는 대체로 기존 클라이언트와 호환될 수 있지만 필드 삭제, 타입 변경, 의미 변경은 호환성을 깨뜨릴 수 있다. API 변경은 문서화하고, breaking change가 필요한 경우 버전 정책을 정한다.

**정리:** URI는 리소스와 관계를 명확하게 보여주고, 행위는 HTTP 메서드와 상태 코드로 표현한다. 팀 전체가 일관된 규칙을 유지하는 것이 중요하다.
