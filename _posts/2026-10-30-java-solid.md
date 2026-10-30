---
layout: post
title: "객체지향 설계 — SOLID 5원칙"
date: 2026-08-05 00:00:00 +0900
categories: [Spring]
tags: [Java, OOP]
---

오늘은 객체지향 설계에서 자주 사용하는 SOLID 5원칙을 코드와 함께 정리했다.

## 1. SRP — 단일 책임 원칙

하나의 클래스가 너무 많은 책임을 갖지 않도록 나누는 원칙이다.

```text
MemberService
 ├─ 회원가입
 ├─ 이메일 발송
 └─ 파일 저장
```

이런 구조라면 회원가입 로직과 관계없는 이메일이나 파일 저장의 변경도 같은 클래스를 수정하게 된다. 기능별로 `MemberService`, `EmailService`, `FileService`처럼 책임을 나누는 것이 좋다.

## 2. OCP — 개방 폐쇄 원칙

기존 코드를 수정하지 않고 기능을 확장할 수 있도록 설계하는 원칙이다.

```java
interface Payment {
    void pay();
}

class CardPayment implements Payment {
    public void pay() {
        System.out.println("카드 결제");
    }
}

class KakaoPayment implements Payment {
    public void pay() {
        System.out.println("카카오 결제");
    }
}
```

새 결제 방식을 추가해도 `Payment`의 기존 구현을 수정할 필요가 없다.

## 3. LSP — 리스코프 치환 원칙

부모 타입을 사용하는 코드에서 자식 타입으로 바꿔도 프로그램이 정상적으로 동작해야 한다는 원칙이다. 단순히 상속 관계를 만드는 것보다 부모가 약속한 동작을 자식이 깨뜨리지 않는지가 중요하다.

## 4. ISP — 인터페이스 분리 원칙

하나의 큰 인터페이스를 억지로 구현하기보다 사용하는 기능에 맞게 인터페이스를 나누는 원칙이다.

```java
interface Printer {
    void print();
}

interface Scanner {
    void scan();
}
```

프린터 기능만 필요한 클래스가 Scanner까지 구현할 필요가 없다.

## 5. DIP — 의존 역전 원칙

구체적인 구현보다 추상화에 의존하도록 만드는 원칙이다.

```java
class OrderService {
    private final Payment payment;

    OrderService(Payment payment) {
        this.payment = payment;
    }
}
```

`OrderService`가 `KakaoPayment` 같은 구체 클래스에 직접 의존하지 않고 `Payment`라는 인터페이스에 의존한다.

이 구조가 이후 Spring의 DI와 연결된다.

```text
SOLID
 ↓
DIP
 ↓
추상화에 의존
 ↓
DI
 ↓
Spring
```
