---
layout: post
title: "생성자 주입과 의존성 역전 — Spring에서 결합도를 낮추는 설계"
date: 2026-10-30 00:00:00 +0900
categories: [Spring]
tags: [Spring, DI, IoC, Constructor Injection, DIP]
---
## 객체가 구현체를 직접 선택하면

서비스가 내부에서 특정 Repository 구현체를 직접 생성하면 구현 변경이 서비스 코드 변경으로 이어진다. 테스트에서도 실제 저장소 대신 가짜 구현을 넣기 어렵다. 의존성 주입은 객체 생성과 연결 책임을 외부 컨테이너로 이동시켜 이 결합을 줄인다.

## 생성자 주입

```java
public interface PaymentGateway {
    void pay(long amount);
}

@Service
public class PaymentService {
    private final PaymentGateway gateway;

    public PaymentService(PaymentGateway gateway) {
        this.gateway = gateway;
    }

    public void pay(long amount) {
        gateway.pay(amount);
    }
}
```

Spring은 컨테이너에 등록된 Bean 중 타입이 맞는 의존성을 찾아 생성자에 전달한다. 구현체가 여러 개라면 @Primary 또는 @Qualifier로 선택 기준을 명시한다.

## 생성자 주입을 기본으로 선택하는 이유

- 필수 의존성을 객체 생성 시점에 보장한다.
- final 필드로 불변성을 유지할 수 있다.
- 컨테이너 없이 new로 테스트 객체를 만들 수 있다.
- 순환 참조를 조기에 발견하기 쉽다.

필드 주입은 간단해 보이지만 객체를 직접 생성하는 테스트가 어렵고 의존성이 코드에 명확히 드러나지 않는다. 수정자 주입은 선택적인 의존성처럼 생성 이후 변경이 필요한 경우에 제한적으로 사용한다.

## 인터페이스가 항상 필요한 것은 아니다

구현이 하나뿐이고 교체 가능성이 낮은 모든 클래스에 인터페이스를 만드는 것은 오히려 구조를 복잡하게 할 수 있다. 외부 시스템, 저장소, 정책처럼 구현 교체나 테스트 대역이 유용한 경계부터 추상화한다.

**정리:** DI는 애너테이션 사용법보다 객체 간 의존 방향을 설계하는 문제다. 변경 가능성이 있는 경계에서 추상화하고 생성자 주입으로 필수 의존성을 명시한다.
