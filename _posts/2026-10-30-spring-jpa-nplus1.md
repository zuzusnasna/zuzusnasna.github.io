---
layout: post
title: "부트캠프 : JPA N+1 문제를 쿼리 관점에서 이해하기"
date: 2026-10-30 13:00:00 +0900
categories: [학습]
tags: [JPA, Spring Boot, SQL Tuning]
---

JPA를 사용할 때 가장 조심해야 하는 문제 중 하나가 N+1이다. 객체 관계를 편하게 조회한 코드가 실제 DB에서는 여러 번의 SELECT로 실행될 수 있다.

## 예시

```java
List<Order> orders = orderRepository.findAll();

for (Order order : orders) {
    order.getMember().getName();
}
```

주문 목록을 한 번 조회한 뒤 각 주문의 회원을 지연 로딩하면 회원 수만큼 추가 쿼리가 실행될 수 있다.

```text
1번 주문 조회
 + 회원 조회
 + 회원 조회
 + 회원 조회
 + ...
```

## 해결 방향

조회 목적에 맞게 fetch join, EntityGraph, DTO projection 등을 검토할 수 있다.

```jpql
select o
from Order o
join fetch o.member
```

## 중요한 점

무조건 모든 연관관계를 EAGER로 바꾸는 것은 해결책이 아니다. 화면에서 실제로 필요한 데이터를 기준으로 조회 전략을 선택해야 한다.

## 배운 점

JPA 코드를 볼 때는 객체 코드만 보면 안 되고 **실제로 몇 개의 SQL이 실행되는지**까지 확인해야 한다.
