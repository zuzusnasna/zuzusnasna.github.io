---
layout: post
title: "JPA 객체 관계와 식별·비식별 관계를 이해한 과정"
date: 2026-10-13 09:00:00 +0900
categories: [학습]
tags: [JPA, Spring Boot, Database]
---

JPA를 공부하면서 객체 관계와 데이터베이스 관계를 같은 관점으로 보면 헷갈리기 쉬워서 둘을 나눠 정리했다.

## 객체 관계

JPA에서는 엔티티 사이의 연관관계를 `@OneToMany`, `@ManyToOne`, `@OneToOne`, `@ManyToMany` 등으로 표현한다.

```java
@ManyToOne(fetch = FetchType.LAZY)
@JoinColumn(name = "member_id")
private Member member;
```

객체에서는 `member`라는 참조로 연결하지만 DB에서는 외래키 컬럼으로 연결된다.

## 식별 관계와 비식별 관계

식별 관계는 부모의 키가 자식의 기본키 구성에 포함되는 구조이고, 비식별 관계는 외래키가 기본키와 분리된 구조다.

일반적인 업무 시스템에서는 엔티티의 독립적인 식별이 필요한 경우가 많아 비식별 관계를 사용하는 경우가 많다.

## 배운 점

JPA 어노테이션을 외우는 것보다 **객체에서는 어떻게 연결되고 DB에서는 어떤 FK 구조로 저장되는지**를 같이 보는 것이 중요했다.
