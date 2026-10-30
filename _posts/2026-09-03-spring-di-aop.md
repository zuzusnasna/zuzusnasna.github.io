---
layout: post
title: "DI, IoC, AOP, Lombok"
date: 2026-08-14 00:00:00 +0900
categories: [학습]
tags: [Spring Boot, Java]
---

Spring Boot를 처음 공부하면서 DI와 IoC를 먼저 이해했다.

## IoC와 DI

객체를 필요한 곳에서 직접 생성하는 대신 Spring 컨테이너가 객체의 생성과 의존관계를 관리한다.

```java
@Service
public class UserService {
    private final UserRepository repository;

    public UserService(UserRepository repository) {
        this.repository = repository;
    }
}
```

생성자 주입을 사용하면 필요한 의존성이 명확해지고 테스트하기도 편하다.

## AOP

로깅, 트랜잭션처럼 여러 기능에 공통으로 필요한 관심사를 핵심 비즈니스 코드와 분리할 수 있다.

## Lombok

반복되는 getter, setter, constructor 등의 코드를 줄여준다.

Spring의 핵심은 어노테이션을 외우는 것보다 **컨테이너가 객체를 관리하고 의존성을 연결한다는 흐름**을 이해하는 것이었다.

## 더 깊게 이해하기: 객체를 누가 만들고, 누가 책임지는가

DI를 이해할 때 중요한 구분은 **객체를 사용하는 코드와 객체를 조립하는 코드**다. 서비스가 직접 `new UserRepository()`를 호출하면 구현체 생성과 사용이 한 클래스에 묶인다. 생성자 주입은 이 결합을 줄이고, 조립 책임을 Spring 컨테이너로 옮긴다. 테스트에서는 실제 저장소 대신 가짜 구현을 주입할 수도 있다.

AOP는 모든 코드를 자동으로 편하게 만드는 기능이 아니다. 트랜잭션·로깅처럼 여러 객체에 반복되는 횡단 관심사를 분리할 때 유용하지만, 프록시를 거치는 호출 구조를 이해하지 못하면 적용 여부를 오해하기 쉽다. 예를 들어 같은 클래스 내부에서 `this.someTransactionalMethod()`처럼 호출하면 일반적인 프록시 기반 AOP가 기대대로 적용되지 않을 수 있다.

### 실습하며 확인할 것
- 생성자 주입을 사용했을 때 테스트에서 의존 객체를 교체할 수 있는가?
- 서비스가 구현 클래스가 아니라 인터페이스에 의존하도록 바꾸면 무엇이 달라지는가?
- 트랜잭션이나 로깅을 핵심 로직 안에 직접 작성한 경우와 AOP로 분리한 경우를 비교했는가?
- Lombok은 코드를 줄이는 도구일 뿐, 생성자와 의존관계를 이해하는 일을 대신하지 않는다는 점을 구분했는가?

이 개념은 어노테이션을 외우는 것보다 객체 생성 → 의존성 연결 → 메서드 호출의 흐름을 직접 추적할 때 오래 남는다.
