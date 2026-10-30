---
layout: post
title: "Java 추상 클래스와 인터페이스의 차이"
date: 2026-07-18 00:00:00 +0900
categories: [학습]
tags: [Java, 추상 클래스, 인터페이스]
---

추상 클래스와 인터페이스는 공통적으로 직접 완성된 객체를 만들기보다 하위 클래스나 구현 클래스가 지켜야 할 구조와 기능을 정의하는 데 사용한다. 하지만 목적과 사용 방식에는 차이가 있다.

## 1. 추상 클래스

추상 클래스는 `abstract` 키워드로 선언한다. 추상 메서드와 일반 메서드, 필드, 생성자를 가질 수 있다.

```java
abstract class Animal {
    private String name;

    Animal(String name) {
        this.name = name;
    }

    public void eat() {
        System.out.println(name + "이(가) 먹습니다.");
    }

    public abstract void sound();
}
```

추상 메서드는 선언만 있고 구현 내용이 없다. 추상 클래스를 상속한 구체 클래스는 추상 메서드를 구현해야 한다.

```java
class Dog extends Animal {
    Dog(String name) {
        super(name);
    }

    @Override
    public void sound() {
        System.out.println("멍멍");
    }
}
```

추상 클래스 자체는 `new`로 인스턴스를 생성할 수 없다.

## 2. 인터페이스

인터페이스는 클래스가 제공해야 하는 기능의 계약을 정의한다.

```java
interface Payable {
    void pay(int amount);
}

class CardPayment implements Payable {
    @Override
    public void pay(int amount) {
        System.out.println("카드 결제: " + amount);
    }
}
```

인터페이스를 구현하는 클래스는 추상 메서드를 구현해야 한다. 클래스는 여러 인터페이스를 동시에 구현할 수 있다.

```java
interface Refundable {
    void refund(int amount);
}

class Payment implements Payable, Refundable {
    @Override
    public void pay(int amount) {
        System.out.println("결제: " + amount);
    }

    @Override
    public void refund(int amount) {
        System.out.println("환불: " + amount);
    }
}
```

## 3. 추상 클래스와 인터페이스 비교

| 구분 | 추상 클래스 | 인터페이스 |
|---|---|---|
| 선언 | `abstract class` | `interface` |
| 상속/구현 | 클래스는 하나의 클래스만 상속 | 여러 인터페이스 구현 가능 |
| 인스턴스 필드 | 가질 수 있음 | 인스턴스 필드는 가질 수 없음 |
| 생성자 | 가질 수 있음 | 생성자 없음 |
| 메서드 | 추상/일반 메서드 모두 가능 | 추상 메서드 외 default, static, private 메서드 가능 |
| 주된 목적 | 공통 상태와 기본 구현 공유 | 타입과 기능의 계약 정의 |

인터페이스의 필드는 암묵적으로 `public static final`이다. 인터페이스의 메서드는 종류에 따라 접근 범위와 구현 여부가 다르며, 모든 메서드가 무조건 추상 메서드인 것은 아니다.

## 4. 어떤 경우에 선택할까?

### 추상 클래스를 선택하는 경우

- 여러 하위 클래스가 공통 필드와 상태를 공유해야 할 때
- 하위 클래스가 공통으로 사용할 기본 구현이 있을 때
- 생성자를 통해 공통 상태를 초기화해야 할 때

### 인터페이스를 선택하는 경우

- 서로 상속 관계가 없는 여러 클래스에 같은 기능 계약을 적용할 때
- 구현체를 교체할 수 있도록 사용 코드와 구현 코드를 분리할 때
- 한 클래스가 여러 역할을 수행해야 할 때

예를 들어 결제 서비스는 카드 결제, 계좌 이체 등 구현 방식이 달라도 `pay()`라는 계약을 공유할 수 있다.

```java
interface PaymentService {
    void pay(int amount);
}

class CardPaymentService implements PaymentService {
    public void pay(int amount) {
        System.out.println("카드 결제");
    }
}

class BankPaymentService implements PaymentService {
    public void pay(int amount) {
        System.out.println("계좌 이체");
    }
}
```

호출하는 쪽은 구현 클래스가 무엇인지 몰라도 인터페이스를 통해 기능을 사용할 수 있다.

```java
void processPayment(PaymentService paymentService) {
    paymentService.pay(10000);
}
```

## 정리

추상 클래스는 공통 상태와 기본 동작을 공유하는 기반 클래스에 적합하고, 인터페이스는 구현 방식이 달라도 동일한 기능을 제공하도록 계약을 정의할 때 적합하다. 단순히 코드 중복을 줄이기 위한 선택이 아니라 클래스 사이의 관계와 변경 가능성을 기준으로 결정해야 한다.
