---
layout: post
title: "Facade Pattern — 복잡한 기능을 하나의 진입점으로 제공하는 퍼사드 패턴"
date: 2026-08-12 00:00:00 +0900
categories: [학습]
tags: [Java, 디자인패턴, Facade]
---

## 1. Facade Pattern이란?

Facade Pattern(퍼사드 패턴)은 **여러 하위 시스템의 복잡한 호출 과정을 하나의 단순한 인터페이스로 감싸는 패턴**이다.

컴퓨터를 켤 때 사용자는 전원 버튼만 누르면 된다. 내부에서는 전원 공급, 운영체제 시작, 장치 초기화 등이 순서대로 실행된다. 사용자가 각 장치를 직접 조작할 필요는 없다.

프로그램에서도 하나의 기능을 수행하기 위해 여러 서비스가 필요할 때 퍼사드가 호출 순서를 묶어줄 수 있다.

## 2. 실제 사례: 온라인 주문 처리

주문을 완료하려면 재고 확인, 결제, 배송 요청이 필요하다고 가정하자.

각 하위 시스템은 자신의 작업만 담당한다.

```java
class InventoryService {
    public void decrease(String product, int quantity) {
        System.out.println(product + " 재고 " + quantity + "개 차감");
    }
}

class PaymentService {
    public void pay(int amount) {
        System.out.println(amount + "원 결제");
    }
}

class DeliveryService {
    public void request(String address) {
        System.out.println(address + " 배송 요청");
    }
}
```

이 서비스들을 사용하는 클라이언트가 매번 직접 호출하면 주문 처리 순서를 모두 알아야 한다.

퍼사드가 복잡한 과정을 하나의 메서드로 제공한다.

```java
class OrderFacade {
    private final InventoryService inventory;
    private final PaymentService payment;
    private final DeliveryService delivery;

    OrderFacade(InventoryService inventory,
                PaymentService payment,
                DeliveryService delivery) {
        this.inventory = inventory;
        this.payment = payment;
        this.delivery = delivery;
    }

    public void completeOrder(String product, int quantity,
                              int amount, String address) {
        inventory.decrease(product, quantity);
        payment.pay(amount);
        delivery.request(address);
    }
}
```

사용하는 쪽은 completeOrder()만 호출하면 된다.

```java
public class Main {
    public static void main(String[] args) {
        OrderFacade order = new OrderFacade(
                new InventoryService(),
                new PaymentService(),
                new DeliveryService()
        );

        order.completeOrder("키보드", 1, 50000, "서울시");
    }
}
```

## 3. 실행 흐름

```text
클라이언트
    |
OrderFacade.completeOrder()
    |
    +-- 재고 차감
    +-- 결제 처리
    +-- 배송 요청
```

클라이언트는 하위 서비스의 세부 호출 순서를 몰라도 된다.

## 4. 실제 적용 사례

- 주문 완료 과정의 여러 서비스 호출
- 회원 가입 시 계정 생성, 기본 설정, 환영 메일 발송
- 파일 업로드 시 검증, 저장, 메타데이터 등록
- 복잡한 외부 API 여러 개를 하나의 기능으로 제공

퍼사드는 복잡한 시스템을 단순하게 사용할 수 있도록 도와준다. 다만 모든 비즈니스 로직을 퍼사드 하나에 몰아넣으면 거대한 클래스가 될 수 있으므로 호출 조정 역할에 집중해야 한다.

**핵심:** 여러 하위 시스템을 직접 다루는 대신, 하나의 진입점을 통해 복잡한 작업을 실행한다.
