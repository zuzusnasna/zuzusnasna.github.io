---
layout: post
title: "Design Pattern — 디자인 패턴, Singleton, Strategy"
date: 2026-10-30 13:00:00 +0900
categories: [Spring]
tags: [Design Pattern]
---

오늘은 디자인 패턴이 무엇인지 정리하고 Singleton과 Strategy 패턴을 코드로 확인했다.

## 1. 디자인 패턴이란?

디자인 패턴은 개발하면서 반복적으로 발생하는 설계 문제를 해결하기 위한 대표적인 구조다. 완성된 코드를 그대로 가져다 쓰는 것이 아니라 상황에 맞는 설계 방법으로 보는 것이 맞다.

대표적으로 생성, 구조, 행동 패턴으로 나눌 수 있다.

## 2. Singleton Pattern

특정 클래스의 객체를 하나만 생성하도록 제한하는 패턴이다.

```java
class Config {
    private static Config instance;

    private Config() {
    }

    public static Config getInstance() {
        if (instance == null) {
            instance = new Config();
        }
        return instance;
    }
}
```

생성자를 `private`으로 만들어 외부에서 직접 객체를 생성하지 못하게 한다.

```java
Config a = Config.getInstance();
Config b = Config.getInstance();

System.out.println(a == b); // true
```

다만 위 구현은 멀티스레드 환경에서 동시에 객체가 생성될 가능성을 고려해야 한다. Spring에서는 기본적으로 Bean을 Singleton Scope로 관리하기 때문에 직접 Singleton 구현을 만드는 경우가 줄어든다.

## 3. Strategy Pattern

알고리즘이나 처리 방식을 각각의 클래스로 분리하고 필요한 전략을 선택하는 패턴이다.

```java
interface PaymentStrategy {
    void pay(int amount);
}

class CardPayment implements PaymentStrategy {
    public void pay(int amount) {
        System.out.println("카드 결제: " + amount);
    }
}

class KakaoPayment implements PaymentStrategy {
    public void pay(int amount) {
        System.out.println("카카오 결제: " + amount);
    }
}
```

서비스는 구체적인 결제 방식을 직접 만들지 않고 전략을 받는다.

```java
class PaymentService {
    private final PaymentStrategy strategy;

    PaymentService(PaymentStrategy strategy) {
        this.strategy = strategy;
    }

    void pay(int amount) {
        strategy.pay(amount);
    }
}
```

결제 방식이 바뀌어도 `PaymentService`를 수정하지 않고 다른 전략을 주입할 수 있다.
