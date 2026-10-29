---
layout: post
title: "Spring Boot 학습 : DI, IoC, AOP, Lombok"
date: 2026-09-03 09:00:00 +0900
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
