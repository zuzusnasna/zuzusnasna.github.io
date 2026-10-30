---
layout: post
title: "Java 타입 설계 — Generic과 인터페이스, 추상 클래스"
date: 2026-10-30 11:40:00 +0900
categories: [Spring]
tags: [Java]
---

오늘은 타입을 안전하게 다루는 Generic과 추상화에 사용하는 인터페이스, 추상 클래스를 정리했다.

## 1. Generic

Generic은 클래스나 메서드에서 사용할 타입을 나중에 지정할 수 있게 하는 기능이다.

```java
List<String> names = new ArrayList<>();
names.add("홍길동");
// names.add(100); // 컴파일 오류
```

`String`을 지정했기 때문에 다른 타입의 값을 넣을 수 없다.

Generic을 사용하지 않고 `Object`로 관리하면 값을 꺼낼 때 형변환이 필요하다.

```java
Object value = "hello";
String text = (String) value;
```

Generic을 사용하면 타입을 컴파일 시점에 확인할 수 있어 형변환을 줄이고 타입 안정성을 높일 수 있다.

## 2. 인터페이스

인터페이스는 클래스가 구현해야 할 기능의 규격을 정의할 때 사용한다.

```java
interface Payment {
    void pay();
}

class CardPayment implements Payment {
    @Override
    public void pay() {
        System.out.println("카드 결제");
    }
}
```

사용하는 쪽에서는 `Payment`라는 규격만 알고 있으면 된다.

```java
Payment payment = new CardPayment();
payment.pay();
```

## 3. 추상 클래스

추상 클래스는 공통 상태와 기능을 가지고 있으면서 일부 기능을 자식 클래스가 구현하도록 만들 수 있다.

```java
abstract class Animal {
    String name;

    void eat() {
        System.out.println("먹는다");
    }

    abstract void sound();
}
```

```java
class Dog extends Animal {
    @Override
    void sound() {
        System.out.println("멍멍");
    }
}
```

인터페이스와 추상 클래스를 구분하면 다음과 같다.

```text
인터페이스
→ 구현해야 할 규격을 정의
→ 서로 다른 클래스가 같은 기능을 구현하도록 할 때 사용

추상 클래스
→ 공통 상태와 기능을 공유
→ 상속 관계에서 공통 구현을 제공할 때 사용
```
