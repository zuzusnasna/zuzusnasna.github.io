---
layout: post
title: "JPA와 CRUD 흐름"
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

## 더 깊게 이해하기: CRUD 뒤에서 일어나는 일

JPA의 저장 메서드를 호출했다고 해서 매번 즉시 INSERT가 실행되는 것은 아니다. 영속성 컨텍스트는 엔티티의 상태를 관리하고, 변경 감지를 통해 트랜잭션 커밋 시점에 SQL을 실행할 수 있다. 그래서 디버깅할 때는 자바 객체의 값이 바뀐 시점과 데이터베이스에 반영된 시점을 구분해야 한다.

엔티티를 API 응답으로 그대로 반환하는 것도 주의해야 한다. 양방향 연관관계의 순환 참조, 필요하지 않은 필드 노출, 지연 로딩 시점의 문제를 만들 수 있으므로 요청 DTO와 응답 DTO를 분리하는 편이 명확하다.

### 확인할 내용
- `persist`와 `flush`와 `commit`은 각각 무엇을 의미하는가?
- 트랜잭션이 끝난 뒤 엔티티를 수정하면 변경 감지가 계속 동작하는가?
- 삭제·수정 전에 대상이 존재하는지와 권한이 있는지를 어디에서 검증하는가?
- 조회 결과를 DTO로 변환하면 API 계약을 엔티티 구조와 분리할 수 있는가?

CRUD 구현을 마쳤다면 SQL 로그를 켜고 각 작업이 실제로 어떤 SQL을 발생시키는지 확인해야 ORM의 동작을 정확히 이해할 수 있다.
