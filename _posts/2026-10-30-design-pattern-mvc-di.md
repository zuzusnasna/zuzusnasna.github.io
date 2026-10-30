---
layout: post
title: "Design Pattern — MVC Architecture와 DI"
date: 2026-10-30 13:40:00 +0900
categories: [Spring]
tags: [Design Pattern, MVC, DI]
---

오늘은 웹 애플리케이션에서 자주 사용하는 MVC 구조와 객체의 의존성을 관리하는 DI를 정리했다.

## 1. MVC Architecture

MVC는 Model, View, Controller로 역할을 나누는 구조다.

```text
사용자
 ↓
Controller
 ↓
Model / Service
 ↓
Database
```

Spring에서는 보통 다음처럼 역할을 나눠서 사용한다.

```text
Controller
    ↓
Service
    ↓
Repository / Mapper
    ↓
Database
```

Controller는 HTTP 요청을 받고 적절한 기능을 호출한다.

```java
@RestController
@RequestMapping("/members")
public class MemberController {
    private final MemberService service;

    public MemberController(MemberService service) {
        this.service = service;
    }

    @GetMapping("/{id}")
    public Member find(@PathVariable Long id) {
        return service.find(id);
    }
}
```

Service는 비즈니스 로직을 담당하고 Repository나 Mapper는 DB 접근을 담당한다. 각 계층의 역할을 나누면 Controller에 모든 로직이 몰리는 것을 막을 수 있다.

## 2. DI

DI는 Dependency Injection, 의존성 주입이다.

객체가 필요한 다른 객체를 직접 생성하지 않고 외부에서 전달받는다.

직접 생성하면:

```java
class OrderService {
    private final KakaoPayment payment = new KakaoPayment();
}
```

결제 구현이 바뀔 때 `OrderService`도 수정해야 한다.

인터페이스를 사용하면:

```java
class OrderService {
    private final Payment payment;

    OrderService(Payment payment) {
        this.payment = payment;
    }
}
```

외부에서 원하는 구현체를 넣을 수 있다.

```text
OrderService
     ↓
  Payment
   ↙   ↘
Card   Kakao
```

Spring에서는 Container가 Bean을 관리하면서 이런 의존 관계를 연결한다. 객체를 직접 생성하는 코드보다 역할과 의존 관계를 분리해서 볼 수 있다는 것이 DI의 핵심이다.
