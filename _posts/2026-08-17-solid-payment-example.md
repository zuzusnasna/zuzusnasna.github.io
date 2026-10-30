---
layout: post
title: "결제 서비스로 이해하는 SOLID 5원칙 적용"
date: 2026-08-17 09:00:00 +0900
categories: [학습]
tags: [Java, SOLID, 객체지향, 설계]
---

SOLID는 객체지향 설계에서 변경에 유연한 구조를 만들기 위한 다섯 가지 원칙이다. 각 원칙을 따로 외우는 것보다 하나의 기능을 설계하면서 어떤 문제가 생기고 어떻게 개선되는지 살펴보면 이해하기 쉽다.

여기서는 카드 결제와 간편 결제를 지원하는 주문 서비스를 예로 든다.

## 1. SRP — 단일 책임 원칙

단일 책임 원칙(Single Responsibility Principle)은 클래스가 변경되어야 하는 이유를 하나의 책임으로 제한하는 방향이다.

주문 서비스가 주문 생성, 결제 승인, 영수증 발송을 모두 처리한다면 결제 정책이나 이메일 정책이 바뀔 때마다 같은 클래스를 수정해야 한다.

책임을 기능별로 나눌 수 있다.

```java
class OrderService {
    void createOrder() {
        // 주문 생성
    }
}

class PaymentService {
    void pay(int amount) {
        // 결제 처리
    }
}

class ReceiptService {
    void sendReceipt() {
        // 영수증 발송
    }
}
```

클래스 이름만 나누는 것이 목적은 아니다. 실제 변경 이유와 업무 책임이 분리되어야 한다.

## 2. OCP — 개방 폐쇄 원칙

개방 폐쇄 원칙(Open-Closed Principle)은 기존 코드를 무조건 수정하지 않고도 새로운 기능을 확장할 수 있도록 설계하는 것이다.

결제 방식마다 if문을 추가하는 구조를 생각해 보자.

```java
class PaymentService {
    void pay(String type, int amount) {
        if (type.equals("CARD")) {
            // 카드 결제
        } else if (type.equals("EASY")) {
            // 간편 결제
        }
    }
}
```

결제 방식이 늘어날 때마다 기존 메서드의 조건문을 수정해야 한다. 공통 인터페이스를 두면 새로운 구현체를 추가하는 방식으로 확장할 수 있다.

```java
interface Payment {
    void pay(int amount);
}

class CardPayment implements Payment {
    public void pay(int amount) {
        System.out.println("카드 결제: " + amount);
    }
}

class EasyPayment implements Payment {
    public void pay(int amount) {
        System.out.println("간편 결제: " + amount);
    }
}
```

## 3. LSP — 리스코프 치환 원칙

리스코프 치환 원칙(Liskov Substitution Principle)은 상위 타입을 사용하는 코드에 하위 타입을 넣어도 프로그램이 기대한 동작을 유지해야 한다는 원칙이다.

Payment를 구현한 모든 결제 클래스는 계약에 맞게 결제를 수행해야 한다. 예를 들어 특정 구현체가 정상적인 금액에서도 항상 예외를 던지거나 성공했다고 거짓으로 반환하면 호출하는 쪽의 기대를 깨뜨린다.

```java
void process(Payment payment) {
    payment.pay(10000);
}
```

이 메서드는 Payment의 구현체가 바뀌어도 결제 기능을 수행한다는 계약이 지켜진다고 기대한다. 하위 구현은 입력 조건과 결과에 대한 약속을 임의로 강화하거나 약화하지 않아야 한다.

## 4. ISP — 인터페이스 분리 원칙

인터페이스 분리 원칙(Interface Segregation Principle)은 사용하지 않는 기능까지 구현하도록 강요하는 거대한 인터페이스를 피하라는 원칙이다.

결제 인터페이스에 결제, 환불, 포인트 적립, 영수증 출력 기능을 모두 넣으면 일부 기능만 지원하는 구현체가 불필요한 메서드까지 구현해야 한다.

기능별로 계약을 나눌 수 있다.

```java
interface Payable {
    void pay(int amount);
}

interface Refundable {
    void refund(int amount);
}
```

카드 결제 구현체가 환불 기능을 지원하지 않는다면 Payable만 구현할 수 있다. 실제 업무에서는 지원하지 않는 기능의 정책을 명확히 정의해야 한다.

## 5. DIP — 의존 역전 원칙

의존 역전 원칙(Dependency Inversion Principle)은 상위 수준 정책이 구체 구현에 직접 의존하지 않고 추상화에 의존하도록 한다.

```java
class OrderService {
    private final Payment payment;

    OrderService(Payment payment) {
        this.payment = payment;
    }

    void order(int amount) {
        payment.pay(amount);
    }
}
```

OrderService는 CardPayment나 EasyPayment를 직접 생성하지 않는다. Payment 인터페이스에 의존하고, 실제 구현체는 외부에서 전달받는다.

## 6. 전체 구조 연결

```text
OrderService
     |
     v
  Payment
   /    \
Card   Easy
```

- SRP: 주문과 결제, 영수증 책임을 분리한다.
- OCP: 결제 구현체를 추가해 기능을 확장한다.
- LSP: 모든 결제 구현체가 Payment 계약을 지킨다.
- ISP: 결제와 환불처럼 역할에 맞는 인터페이스를 분리한다.
- DIP: 주문 서비스가 구체 결제 클래스가 아닌 Payment에 의존한다.

## 정리

SOLID는 모든 클래스에 인터페이스를 만들거나 코드를 잘게 나누라는 규칙이 아니다. 변경이 발생하는 지점을 찾고, 책임과 의존 관계를 적절히 분리하기 위한 설계 기준이다. 작은 기능에 과도하게 적용하면 오히려 구조가 복잡해질 수 있으므로 실제 변경 가능성과 테스트 필요성을 기준으로 적용해야 한다.
