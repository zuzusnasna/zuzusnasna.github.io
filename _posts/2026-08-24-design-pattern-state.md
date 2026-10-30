---
layout: post
title: "State Pattern — 객체의 상태에 따라 동작을 바꾸는 상태 패턴"
date: 2026-09-05 00:00:00 +0900
categories: [학습]
tags: [Java, 디자인패턴, State]
---

## 1. State Pattern이란?

State Pattern(상태 패턴)은 **객체의 내부 상태를 별도의 객체로 표현하고, 현재 상태에 따라 동작을 다르게 수행하도록 만드는 패턴**이다.

주문 시스템을 예로 들어 보자. 주문은 결제 대기, 결제 완료, 배송 중, 배송 완료 상태를 가진다. 주문 상태에 따라 취소나 배송 시작이 가능한지가 달라진다.

모든 상태를 if-else나 switch로 처리하면 상태가 늘어날수록 조건문이 복잡해질 수 있다. 상태 패턴은 상태별 동작을 각각의 클래스로 분리한다.

## 2. 실제 사례: 주문 상태 관리

먼저 상태가 제공해야 할 동작을 인터페이스로 정의한다.

```java
interface OrderState {
    void pay(Order order);
    void ship(Order order);
}
```

결제 대기 상태에서는 결제가 가능하지만 배송을 시작할 수 없다.

```java
class WaitingForPayment implements OrderState {
    public void pay(Order order) {
        System.out.println("결제가 완료되었습니다.");
        order.changeState(new Paid());
    }

    public void ship(Order order) {
        System.out.println("결제 전에는 배송할 수 없습니다.");
    }
}
```

결제 완료 상태에서는 배송을 시작할 수 있다.

```java
class Paid implements OrderState {
    public void pay(Order order) {
        System.out.println("이미 결제된 주문입니다.");
    }

    public void ship(Order order) {
        System.out.println("배송을 시작합니다.");
        order.changeState(new Shipped());
    }
}
```

배송 중 상태에서는 다시 결제하거나 배송을 시작할 필요가 없다.

```java
class Shipped implements OrderState {
    public void pay(Order order) {
        System.out.println("이미 처리된 주문입니다.");
    }

    public void ship(Order order) {
        System.out.println("이미 배송 중입니다.");
    }
}
```

주문 객체는 현재 상태에 동작을 위임한다.

```java
class Order {
    private OrderState state = new WaitingForPayment();

    void changeState(OrderState state) {
        this.state = state;
    }

    public void pay() {
        state.pay(this);
    }

    public void ship() {
        state.ship(this);
    }
}
```

실행 예시는 다음과 같다.

```java
public class Main {
    public static void main(String[] args) {
        Order order = new Order();

        order.ship(); // 결제 전에는 배송할 수 없습니다.
        order.pay();  // 결제 완료
        order.ship(); // 배송 시작
    }
}
```

## 3. 실행 흐름

```text
결제 대기
   | pay()
   v
결제 완료
   | ship()
   v
배송 중
```

각 상태 객체가 자신에게 허용된 동작을 처리하고 다음 상태로 전환한다.

## 4. 실제 적용 사례

- 주문의 결제 대기 / 결제 완료 / 배송 중 / 배송 완료
- 게시글의 임시 저장 / 공개 / 삭제 상태
- 게임 캐릭터의 대기 / 이동 / 공격 / 사망 상태
- 로그인 세션의 활성 / 만료 상태
- 티켓의 발급 / 사용 / 취소 상태

상태와 상태별 동작이 많아지고 조건문이 복잡해질 때 고려할 수 있다. 반대로 상태가 적고 동작도 단순하다면 일반 조건문이 더 이해하기 쉬울 수 있다.

**핵심:** 상태별 동작을 객체로 분리해 조건문 중심의 코드를 상태 객체 중심으로 구성한다.
