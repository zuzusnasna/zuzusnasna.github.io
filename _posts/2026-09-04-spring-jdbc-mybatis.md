---
layout: post
title: "Spring Bean — Bean 등록과 생성자 주입"
date: 2026-10-30 15:10:00 +0900
categories: [Spring]
tags: [Spring]
---

오늘은 Spring Container가 관리하는 Bean과 의존성을 주입하는 방법을 정리했다.

## 1. Bean

Spring Container가 생성하고 관리하는 객체를 Bean이라고 한다.

대표적인 Annotation은 다음과 같다.

```java
@Component
@Service
@Repository
@Controller
```

예를 들어

```java
@Service
public class MemberService {
}
```

라고 하면 `MemberService`를 Spring이 Bean으로 등록하고 관리할 수 있다.

## 2. Bean 사이의 의존 관계

서비스에서 Repository가 필요하다면 생성자를 통해 받을 수 있다.

```java
@Service
public class MemberService {
    private final MemberRepository repository;

    public MemberService(MemberRepository repository) {
        this.repository = repository;
    }
}
```

Spring은 `MemberRepository`가 Bean으로 등록되어 있다면 해당 객체를 찾아 `MemberService`에 주입한다.

```text
Spring Container

MemberRepository
       ↓
MemberService
```

## 3. 생성자 주입

```java
@Service
public class OrderService {
    private final Payment payment;

    public OrderService(Payment payment) {
        this.payment = payment;
    }
}
```

생성자 주입은 객체 생성 시 필요한 의존성이 전달되도록 만들 수 있고 `final`을 사용해 주입된 의존성을 변경하지 않도록 할 수 있다.

구체 클래스에 직접 의존하기보다 인터페이스에 의존하도록 만들면 구현체를 바꾸거나 테스트할 때도 유연하게 구성할 수 있다.
