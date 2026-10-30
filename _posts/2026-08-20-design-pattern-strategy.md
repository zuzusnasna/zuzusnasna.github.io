---
layout: post
title: "Strategy Pattern — 상황에 따라 알고리즘을 바꾸는 전략 패턴"
date: 2026-08-20 09:00:00 +0900
categories: [학습]
tags: [Java, 디자인패턴, Strategy]
---

## 1. Strategy Pattern이란?

Strategy Pattern(전략 패턴)은 **같은 목적을 수행하는 여러 알고리즘을 각각 객체로 분리하고, 실행 시점에 필요한 전략을 선택하는 패턴**이다.

예를 들어 쇼핑몰에서 배송비를 계산한다고 생각해 보자. 일반 배송, 빠른 배송, 무료 배송은 모두 배송비를 계산하지만 계산 방식은 서로 다르다.

조건문으로 모든 정책을 한 클래스에 작성하면 배송 정책이 추가될 때마다 기존 코드를 계속 수정해야 한다. 전략 패턴을 사용하면 배송비 계산 방법을 각각 분리할 수 있다.

## 2. 실제 사례: 배송비 계산

배송비 계산 규칙을 공통 인터페이스로 정의한다.

```java
interface DeliveryStrategy {
    int calculate(int orderPrice);
}
```

각 배송 정책은 인터페이스를 구현한다.

```java
class NormalDelivery implements DeliveryStrategy {
    @Override
    public int calculate(int orderPrice) {
        return 3000;
    }
}

class ExpressDelivery implements DeliveryStrategy {
    @Override
    public int calculate(int orderPrice) {
        return 5000;
    }
}

class FreeDelivery implements DeliveryStrategy {
    @Override
    public int calculate(int orderPrice) {
        return 0;
    }
}
```

배송비 계산을 사용하는 쪽은 구체적인 정책이 아니라 인터페이스에 의존한다.

```java
class OrderService {
    private final DeliveryStrategy deliveryStrategy;

    OrderService(DeliveryStrategy deliveryStrategy) {
        this.deliveryStrategy = deliveryStrategy;
    }

    public void order(int orderPrice) {
        int deliveryFee = deliveryStrategy.calculate(orderPrice);
        System.out.println("상품 금액: " + orderPrice);
        System.out.println("배송비: " + deliveryFee);
        System.out.println("결제 금액: " + (orderPrice + deliveryFee));
    }
}
```

실행할 때 원하는 전략을 전달하면 된다.

```java
public class Main {
    public static void main(String[] args) {
        OrderService normal =
                new OrderService(new NormalDelivery());
        normal.order(30000);

        OrderService express =
                new OrderService(new ExpressDelivery());
        express.order(30000);
    }
}
```

## 3. 실행 흐름

```text
OrderService
     |
DeliveryStrategy
     |
  +--+----------------+
  |                   |
NormalDelivery   ExpressDelivery
  |                   |
일반 배송비 계산    빠른 배송비 계산
```

OrderService는 배송비 계산을 직접 구현하지 않는다. 전달받은 전략의 calculate()를 호출할 뿐이다.

## 4. 어떤 상황에서 사용할까?

- 결제 수단별 결제 처리
- 배송 방법별 배송비 계산
- 할인 정책별 할인 금액 계산
- 파일 형식별 압축 및 변환 방식
- 사용자 권한별 접근 정책

새로운 정책이 추가되어도 기존 OrderService를 수정하지 않고 DeliveryStrategy 구현체를 추가할 수 있다. 다만 알고리즘이 하나뿐이고 변경 가능성도 없다면 인터페이스와 클래스를 여러 개 만드는 것이 오히려 복잡할 수 있다.

**핵심:** 바뀔 수 있는 알고리즘을 별도 객체로 분리하고 필요한 전략을 주입해서 사용한다.
