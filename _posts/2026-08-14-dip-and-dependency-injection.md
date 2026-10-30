---
layout: post
title: "DIP와 DI의 차이, 의존성을 관리하는 방법"
date: 2026-08-14 09:00:00 +0900
categories: [학습]
tags: [Java, SOLID, DIP, DI]
---

DIP와 DI는 이름이 비슷하지만 서로 다른 개념이다. DIP는 객체지향 설계 원칙이고, DI는 객체가 필요로 하는 의존성을 외부에서 전달하는 방식이다. Spring의 의존성 주입을 이해하려면 두 개념을 구분해야 한다.

## 1. 구체 클래스에 직접 의존하는 구조

주문 서비스가 특정 결제 구현체를 직접 생성한다고 가정해 보자.

```java
class KakaoPay {
    void pay(int amount) {
        System.out.println("카카오페이 결제: " + amount);
    }
}

class OrderService {
    private final KakaoPay payment = new KakaoPay();

    void order(int amount) {
        payment.pay(amount);
    }
}
```

이 구조에서는 OrderService가 KakaoPay라는 구체 클래스에 직접 의존한다. 결제 방식을 바꾸려면 OrderService의 코드도 수정해야 한다.

## 2. DIP: 추상화에 의존하기

의존 역전 원칙(Dependency Inversion Principle)은 상위 수준 정책이 하위 수준의 구체 구현에 직접 의존하지 않고, 양쪽 모두 추상화에 의존하도록 설계하라는 원칙이다.

```java
interface Payment {
    void pay(int amount);
}

class KakaoPay implements Payment {
    public void pay(int amount) {
        System.out.println("카카오페이 결제: " + amount);
    }
}

class CardPay implements Payment {
    public void pay(int amount) {
        System.out.println("카드 결제: " + amount);
    }
}

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

OrderService는 KakaoPay나 CardPay가 아니라 Payment 인터페이스에 의존한다. 구체 결제 방식이 추가되어도 주문 서비스의 핵심 코드는 바뀌지 않는다.

## 3. DI: 의존 객체를 외부에서 전달하기

의존성 주입(Dependency Injection)은 객체가 사용할 의존 객체를 직접 생성하지 않고 외부에서 전달받는 방식이다.

```java
Payment payment = new KakaoPay();
OrderService orderService = new OrderService(payment);

orderService.order(15000);
```

여기서는 생성자를 통해 Payment 구현체를 전달했다. 이것이 생성자 주입(Constructor Injection)의 간단한 예다.

## 4. DIP와 DI 비교

| 구분 | DIP | DI |
|---|---|---|
| 의미 | 의존 역전 설계 원칙 | 의존 객체를 외부에서 주입하는 기법 |
| 목적 | 구체 구현에 대한 결합 완화 | 객체 생성과 의존 관계 연결 분리 |
| 적용 | 인터페이스 등 추상화에 의존하도록 설계 | 생성자, setter, 필드 등을 통해 전달 |
| 관계 | 설계 방향을 제시 | 원칙을 구현하는 데 활용 가능 |

DI를 사용한다고 자동으로 DIP를 지키는 것은 아니다. 구체 클래스 자체를 주입받는 코드도 DI 형태일 수 있다. 중요한 것은 의존 방향과 추상화의 경계다.

## 5. Spring에서는 어떻게 연결될까?

Spring IoC 컨테이너는 Bean을 생성하고 객체 사이의 의존 관계를 연결한다.

```java
public interface Payment {
    void pay(int amount);
}

@Component
public class CardPayment implements Payment {
    @Override
    public void pay(int amount) {
        System.out.println("카드 결제: " + amount);
    }
}

@Service
public class OrderService {
    private final Payment payment;

    public OrderService(Payment payment) {
        this.payment = payment;
    }

    public void order(int amount) {
        payment.pay(amount);
    }
}
```

Spring은 등록된 Bean 중 Payment 타입에 맞는 구현체를 찾아 생성자에 전달한다. 같은 타입의 구현 Bean이 여러 개라면 `@Primary`, `@Qualifier` 등으로 어떤 구현체를 사용할지 지정해야 한다.

실무에서는 필수 의존성을 생성자에서 명확하게 표현하는 생성자 주입을 많이 사용한다. 테스트에서도 가짜 구현체를 전달해 OrderService의 동작을 검증할 수 있다.

## 정리

DIP는 구체 구현보다 추상화에 의존하라는 설계 원칙이고, DI는 필요한 객체를 외부에서 전달하는 구현 기법이다. Spring은 IoC 컨테이너를 통해 객체 생성과 의존 관계 연결을 관리한다. 인터페이스 설계와 DI를 함께 사용하면 구현 교체와 테스트가 쉬운 구조를 만들 수 있다.
