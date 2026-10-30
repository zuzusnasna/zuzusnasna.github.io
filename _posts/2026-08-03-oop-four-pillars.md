---
layout: post
title: "객체지향 프로그래밍의 네 가지 특징"
date: 2026-10-27 00:00:00 +0900
categories: [학습]
tags: [Java, 객체지향, OOP]
---

객체지향 프로그래밍은 데이터와 데이터를 처리하는 동작을 객체 단위로 구성하는 방식이다. Java의 객체지향을 설명할 때는 캡슐화, 상속, 다형성, 추상화 네 가지 특징을 자주 이야기한다.

## 1. 캡슐화(Encapsulation)

캡슐화는 객체의 상태와 동작을 하나로 묶고, 내부 데이터에 직접 접근하지 못하도록 제한하는 것이다. 외부에는 필요한 기능만 공개하고 상태 변경 규칙은 객체 내부에서 관리한다.

```java
class BankAccount {
    private int balance;

    public void deposit(int amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("입금액은 양수여야 합니다.");
        }
        balance += amount;
    }

    public int getBalance() {
        return balance;
    }
}
```

`balance`를 private으로 감췄기 때문에 외부에서 임의로 잔액을 대입할 수 없다. 입금 메서드가 유효성을 검사한 뒤 값을 변경한다.

## 2. 상속(Inheritance)

상속은 기존 클래스의 필드와 메서드를 하위 클래스가 물려받아 확장하는 기능이다.

```java
class Employee {
    protected String name;

    public void work() {
        System.out.println(name + " 업무 수행");
    }
}

class Developer extends Employee {
    public void develop() {
        System.out.println("프로그램 개발");
    }
}
```

Developer는 Employee의 기능을 물려받으면서 개발자만의 기능을 추가한다. 다만 코드 재사용만을 목적으로 상속을 남발하면 부모 클래스 변경이 자식 클래스에 영향을 주고, 잘못된 상속 관계가 만들어질 수 있다.

## 3. 다형성(Polymorphism)

다형성은 같은 타입이나 메서드 호출이 실제 객체에 따라 다르게 동작하는 특징이다.

```java
interface Notification {
    void send();
}

class EmailNotification implements Notification {
    public void send() {
        System.out.println("이메일 발송");
    }
}

class SmsNotification implements Notification {
    public void send() {
        System.out.println("문자 발송");
    }
}
```

호출하는 코드는 구현 클래스가 무엇인지 몰라도 된다.

```java
Notification notification = new EmailNotification();
notification.send(); // 이메일 발송

notification = new SmsNotification();
notification.send(); // 문자 발송
```

참조 변수의 타입은 Notification이지만 실제 실행되는 메서드는 객체의 구현에 따라 결정된다. 이를 통해 구현체를 교체해도 사용하는 코드를 유지할 수 있다.

## 4. 추상화(Abstraction)

추상화는 대상의 복잡한 내부 구현을 모두 드러내지 않고, 사용자에게 필요한 핵심 기능과 규칙만 표현하는 것이다.

예를 들어 결제 기능을 사용하는 코드는 카드사 내부 승인 절차를 알 필요 없이 `pay()`라는 기능을 호출하면 된다.

```java
interface Payment {
    void pay(int amount);
}
```

구현 클래스는 실제 결제 방식을 담당한다. 인터페이스를 통해 무엇을 할 수 있는지 정의하고, 어떻게 처리하는지는 구현체에 맡긴다.

## 네 가지 특징의 관계

| 특징 | 핵심 질문 | 목적 |
|---|---|---|
| 캡슐화 | 내부 상태를 어떻게 보호할까? | 데이터와 규칙 보호 |
| 상속 | 공통 기능을 어떻게 확장할까? | 타입과 구현의 재사용 |
| 다형성 | 같은 호출을 구현별로 어떻게 다르게 할까? | 교체 가능한 구조 |
| 추상화 | 외부에 어떤 기능만 공개할까? | 복잡성 감소 |

네 가지 특징은 서로 별개로만 동작하지 않는다. 인터페이스로 기능을 추상화하고, 구현체를 다형적으로 사용하며, 각 객체는 캡슐화로 자신의 상태를 보호할 수 있다.

## 정리

객체지향은 클래스를 많이 만드는 방식이 아니다. 객체가 가진 상태와 책임을 명확히 하고, 객체 사이의 관계를 통해 변경에 유연한 구조를 만드는 데 목적이 있다. 네 가지 특징을 문법으로만 외우기보다 실제 코드에서 어떤 문제를 해결하는지 연결해서 이해하는 것이 중요하다.
