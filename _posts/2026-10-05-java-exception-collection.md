---
layout: post
title: "객체지향 기본 — 객체, OOP 4가지 특징, 오버로딩과 오버라이딩"
date: 2026-10-30 11:20:00 +0900
categories: [Spring]
tags: [Java, OOP]
---

오늘은 객체지향 프로그래밍의 기본 개념과 Java에서 자주 헷갈리는 오버로딩, 오버라이딩을 같이 정리했다.

## 1. 객체(Object)

객체는 상태와 행동을 하나의 단위로 묶어서 표현한 것이다.

```java
class Car {
    String model;
    int speed;

    void accelerate() {
        speed += 10;
    }

    void stop() {
        speed = 0;
    }
}
```

`model`, `speed`는 상태이고 `accelerate()`, `stop()`은 행동이다.

## 2. OOP 4가지 특징

### 추상화

복잡한 내부 구현을 모두 드러내지 않고 필요한 특징만 표현한다.

### 캡슐화

객체의 내부 데이터를 외부에서 함부로 변경하지 못하게 숨긴다.

```java
class Account {
    private int balance;

    public void deposit(int money) {
        if (money > 0) {
            balance += money;
        }
    }
}
```

### 상속

기존 클래스의 기능을 자식 클래스가 물려받는다.

```java
class Animal {
    void eat() {
        System.out.println("먹는다");
    }
}

class Dog extends Animal {
    void bark() {
        System.out.println("멍멍");
    }
}
```

### 다형성

하나의 부모 타입으로 여러 자식 객체를 사용할 수 있다.

```java
Animal animal = new Dog();
animal.eat();
```

## 3. 오버로딩과 오버라이딩

오버로딩은 같은 이름의 메서드를 매개변수만 다르게 여러 개 정의하는 것이다.

```java
class Calculator {
    int add(int a, int b) {
        return a + b;
    }

    int add(int a, int b, int c) {
        return a + b + c;
    }
}
```

오버라이딩은 부모 클래스의 메서드를 자식 클래스에서 재정의하는 것이다.

```java
class Animal {
    void sound() {
        System.out.println("동물 소리");
    }
}

class Dog extends Animal {
    @Override
    void sound() {
        System.out.println("멍멍");
    }
}
```

차이는 간단하게 정리할 수 있다.

```text
오버로딩
→ 같은 클래스
→ 같은 메서드 이름
→ 매개변수 다름

오버라이딩
→ 부모-자식 관계
→ 같은 메서드 시그니처
→ 자식이 부모 메서드를 재정의
```
