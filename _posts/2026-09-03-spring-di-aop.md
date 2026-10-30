---
layout: post
title: "Spring 시작 — Spring Framework, IoC, DI"
date: 2026-10-30 15:00:00 +0900
categories: [Spring]
tags: [Spring]
---

오늘은 Spring Framework가 무엇인지부터 IoC와 DI의 관계를 정리했다.

## 1. Spring Framework

Spring은 Java 애플리케이션을 개발하기 위한 프레임워크다. 객체 생성과 의존성 관리 같은 부분을 Container가 담당하도록 구성할 수 있다.

기존에는 개발자가 직접 객체를 생성했다.

```java
MemberService service = new MemberService();
```

객체와 의존 관계가 많아지면 생성 코드를 직접 관리하기 어려워진다.

## 2. IoC

IoC는 Inversion of Control, 제어의 역전이다.

기존에는 개발자가 객체의 생성과 관리 흐름을 직접 제어했다.

```text
개발자
 ↓
new MemberService()
 ↓
객체 생성
```

Spring에서는 Container가 객체를 생성하고 관리한다.

```text
개발자
 ↓
Bean 등록
 ↓
Spring Container
 ↓
객체 생성 / 관리
```

객체를 누가 생성하고 관리하는지가 바뀐 것이다.

## 3. DI

DI는 Dependency Injection, 의존성 주입이다.

서비스가 Repository를 직접 생성하는 대신 외부에서 전달받는다.

```java
class MemberService {
    private final MemberRepository repository;

    MemberService(MemberRepository repository) {
        this.repository = repository;
    }
}
```

Spring에서는 Container가 필요한 Bean을 찾아 생성자를 통해 주입한다.

```java
@Service
public class MemberService {
    private final MemberMapper mapper;

    public MemberService(MemberMapper mapper) {
        this.mapper = mapper;
    }
}
```

IoC가 객체를 관리하는 제어의 방향에 대한 개념이라면 DI는 그 과정에서 객체의 의존성을 외부에서 넣어주는 방법이라고 구분했다.
