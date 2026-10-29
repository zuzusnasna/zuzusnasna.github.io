---
layout: post
title: "운영 : 로그, 메트릭, 헬스체크를 분리해서 보는 이유"
date: 2026-10-30 22:00:00 +0900
categories: [학습]
tags: [Spring Boot, AWS, 성능]
---

운영 중 문제가 발생했을 때 애플리케이션 로그만 보는 것에는 한계가 있다. 어떤 종류의 정보가 필요한지에 따라 로그와 메트릭을 나눠서 봐야 한다.

## 로그

특정 요청에서 무슨 일이 발생했는지 확인하는 데 적합하다.

```text
2026-10-30 22:10:03 ERROR OrderService - payment failed
```

## 메트릭

시간에 따른 시스템 상태를 숫자로 확인한다.

- CPU
- Memory
- GC
- 요청 수
- 응답 시간
- 오류율
- DB connection pool

## 헬스체크

애플리케이션이 살아 있는지와 주요 의존성이 정상인지 확인한다.

```text
Client / LB
    ↓
/actuator/health
    ↓
Application
```

## 실제 문제 해결 순서

```text
사용자 지연 발생
 ↓
응답 시간 / 오류율 확인
 ↓
CPU / Memory / I/O 확인
 ↓
애플리케이션 로그 확인
 ↓
DB / Redis 확인
```

RealTimeChat에서 높은 Swap과 I/O wait를 먼저 확인했던 것도 이와 같은 접근이었다.

## 배운 점

운영 문제는 로그 한 줄로 찾는 것이 아니라 **시스템 전체에서 어느 계층이 병목인지 범위를 좁혀가는 과정**이다.
