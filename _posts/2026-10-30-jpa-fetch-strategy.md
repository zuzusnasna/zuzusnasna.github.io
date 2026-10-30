---
layout: post
title: "JPA Fetch 전략 — LAZY와 EAGER를 선택하는 기준"
date: 2026-10-25 00:00:00 +0900
categories: [Spring]
section: spring-data
tags: [Spring, JPA, FetchType, Lazy Loading, Eager Loading]
---
## Fetch 전략이란

Fetch 전략은 Entity를 조회할 때 연관된 Entity를 언제 가져올지 결정한다.

- LAZY: 연관 객체를 실제로 사용할 때 조회
- EAGER: Entity를 조회할 때 연관 객체도 즉시 로딩하도록 요청

@ManyToOne과 @OneToOne은 기본이 EAGER이고, @OneToMany와 @ManyToMany는 기본이 LAZY다. 기본값을 그대로 두기보다 의도를 명시하는 편이 안전하다.

## LAZY를 기본으로 고려하는 이유

주문 목록 화면에서 주문자 이름만 필요하다고 가정하자. 연관된 회원의 모든 정보를 항상 가져오면 불필요한 조회와 메모리 사용이 발생할 수 있다. LAZY는 필요한 시점까지 조회를 미룬다.

단, 지연 로딩은 영속성 컨텍스트가 닫힌 뒤 접근하면 LazyInitializationException이 발생할 수 있다. 트랜잭션 안에서 DTO로 변환하거나 조회 시점에 필요한 관계를 명시적으로 가져온다.

## 필요한 조회에서만 fetch join

```java
@Query("""
    select o from Order o
    join fetch o.member
    where o.id = :id
    """)
Optional<Order> findDetail(Long id);
```

모든 화면에서 같은 그래프를 가져오려 하지 말고 목록·상세·통계 등 조회 목적에 맞게 쿼리를 설계한다.

## EAGER가 N+1 해결책은 아니다

EAGER를 지정했다고 항상 JOIN 한 번으로 조회되는 것은 아니다. JPA 구현체와 쿼리 형태에 따라 추가 SELECT가 발생할 수 있다. 성능 문제를 FetchType 변경만으로 해결하려 하지 말고 SQL 로그를 확인한다.

**정리:** LAZY를 기본으로 두고 실제 조회 목적에 따라 fetch join, EntityGraph, DTO Projection을 선택한다. 핵심은 연관 데이터를 언제 얼마나 가져올지 명시하는 것이다.
