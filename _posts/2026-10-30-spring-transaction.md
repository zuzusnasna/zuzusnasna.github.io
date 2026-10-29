---
layout: post
title: "부트캠프 : Spring @Transactional을 제대로 이해하기"
date: 2026-10-30 12:00:00 +0900
categories: [학습]
tags: [Spring Boot, Transaction, JPA]
---

트랜잭션은 여러 DB 작업을 하나의 업무 단위로 묶어 **중간 상태가 외부에 노출되지 않도록 하는 것**이다.

## 기본 흐름

```text
트랜잭션 시작
 ↓
변경 1
 ↓
변경 2
 ↓
모두 성공 → commit
하나라도 실패 → rollback
```

## 왜 서비스 계층에서 많이 사용하는가

Controller는 HTTP 요청과 응답에 집중하고 Repository는 DB 접근을 담당한다. 여러 Repository 작업을 하나의 업무로 묶어야 할 때 Service에 트랜잭션 경계를 두면 책임이 명확해진다.

## 주의할 점

트랜잭션 안에서 외부 API 호출이나 오래 걸리는 작업을 수행하면 DB 커넥션과 잠금을 오래 유지할 수 있다.

```text
DB 트랜잭션
  ├─ DB 변경
  ├─ 외부 API 호출  ← 오래 걸리면 문제
  └─ DB 변경
```

가능하면 트랜잭션 범위를 실제 데이터 변경에 필요한 만큼 짧게 유지해야 한다.

## 배운 점

`@Transactional`을 메서드 위에 붙이는 것만 외우는 것보다 **어떤 작업을 하나의 원자적인 업무로 묶어야 하는지**를 먼저 판단하는 것이 중요했다.
