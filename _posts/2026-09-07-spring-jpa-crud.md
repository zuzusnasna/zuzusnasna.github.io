---
layout: post
title: "Spring Boot 학습 : JPA와 CRUD 흐름"
date: 2026-09-07 09:00:00 +0900
categories: [학습]
tags: [Spring Boot, JPA]
---

JPA를 사용하면서 SQL을 직접 작성하지 않고도 엔티티 중심으로 데이터를 다루는 흐름을 익혔다.

## 기본 구조

```text
Controller
   ↓
Service
   ↓
Repository
   ↓
JPA
   ↓
Database
```

```java
public interface UserRepository extends JpaRepository<User, Long> {
}
```

Repository를 통해 기본적인 저장, 조회, 수정, 삭제 작업을 처리할 수 있다.

## 중요한 점

JPA가 SQL을 대신 작성해 준다고 해서 DB를 몰라도 되는 것은 아니다. 실제 실행되는 SQL과 엔티티 관계를 이해해야 성능 문제나 연관관계 문제를 해결할 수 있다.

CRUD 실습을 통해 Controller → Service → Repository의 책임을 나누는 기본 구조를 익혔다.
