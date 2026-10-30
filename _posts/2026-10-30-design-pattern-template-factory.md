---
layout: post
title: "Design Pattern — Template Method와 Factory Method"
date: 2026-08-30 00:00:00 +0900
categories: [Spring]
tags: [Design Pattern]
---

오늘은 작업 순서를 정하는 Template Method와 객체 생성을 분리하는 Factory Method를 정리했다.

## 1. Template Method Pattern

전체적인 작업 순서는 부모 클래스에서 정하고, 일부 세부 구현만 자식 클래스가 결정하는 패턴이다.

```java
abstract class Coffee {
    public final void make() {
        boilWater();
        putCoffee();
        putIngredient();
        pour();
    }

    private void boilWater() {
        System.out.println("물을 끓인다");
    }

    private void putCoffee() {
        System.out.println("커피를 넣는다");
    }

    protected abstract void putIngredient();

    private void pour() {
        System.out.println("컵에 따른다");
    }
}
```

Americano와 Latte는 재료만 다르게 구현한다.

```java
class Americano extends Coffee {
    protected void putIngredient() {
        System.out.println("물을 넣는다");
    }
}

class Latte extends Coffee {
    protected void putIngredient() {
        System.out.println("우유를 넣는다");
    }
}
```

작업 순서가 바뀌지 않아야 하고 일부 단계만 달라지는 경우에 사용할 수 있다.

## 2. Factory Method Pattern

객체 생성 과정을 별도의 메서드로 분리하는 패턴이다.

```java
abstract class PizzaStore {
    public Pizza orderPizza() {
        Pizza pizza = createPizza();
        pizza.prepare();
        pizza.bake();
        return pizza;
    }

    protected abstract Pizza createPizza();
}
```

전체 주문 과정은 부모가 알고 있지만 어떤 `Pizza`를 만들지는 자식 클래스가 결정한다.

```java
class KoreanPizzaStore extends PizzaStore {
    @Override
    protected Pizza createPizza() {
        return new BulgogiPizza();
    }
}
```

두 패턴의 차이는 다음처럼 정리할 수 있다.

```text
Template Method
→ 작업의 전체 순서를 부모가 결정

Factory Method
→ 생성할 객체를 하위 클래스가 결정
```
