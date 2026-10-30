---
layout: post
title: "Singleton Pattern — 애플리케이션에서 하나의 인스턴스를 공유하는 싱글톤 패턴"
date: 2026-08-27 09:00:00 +0900
categories: [학습]
tags: [Java, 디자인패턴, Singleton]
---

## 1. Singleton Pattern이란?

Singleton Pattern(싱글톤 패턴)은 **클래스의 인스턴스가 하나만 생성되도록 제한하고, 그 인스턴스에 접근할 수 있는 방법을 제공하는 패턴**이다.

애플리케이션 전체에서 공통으로 사용하는 설정 객체나 공유 서비스처럼 하나의 인스턴스만 관리하고 싶을 때 활용할 수 있다.

## 2. 실제 사례: 애플리케이션 설정 관리

생성자를 private으로 선언하면 외부에서 new로 객체를 생성할 수 없다. 클래스 내부에서 인스턴스를 하나 생성하고 정적 메서드로 반환한다.

```java
class AppConfig {
    private static final AppConfig INSTANCE = new AppConfig();

    private AppConfig() {
        System.out.println("설정 객체 생성");
    }

    public static AppConfig getInstance() {
        return INSTANCE;
    }

    public void printConfig() {
        System.out.println("애플리케이션 설정 정보");
    }
}
```

사용하는 곳에서는 getInstance()를 통해 인스턴스를 얻는다.

```java
public class Main {
    public static void main(String[] args) {
        AppConfig config1 = AppConfig.getInstance();
        AppConfig config2 = AppConfig.getInstance();

        config1.printConfig();

        System.out.println(config1 == config2); // true
    }
}
```

두 변수는 서로 다른 객체가 아니라 같은 인스턴스를 참조한다.

## 3. 실행 흐름

```text
AppConfig.getInstance()
          |
    INSTANCE 확인
          |
   동일한 객체 반환
       /       \
  config1     config2
       \       /
       같은 인스턴스
```

위 예제는 클래스가 초기화될 때 인스턴스를 생성하는 방식이다. Java의 클래스 초기화는 JVM이 관리하므로 이 방식은 기본적인 싱글톤 구현으로 사용할 수 있다.

## 4. 실제 적용 사례와 주의점

- 애플리케이션 공통 설정
- 인스턴스 하나로 관리하는 공유 객체
- 무상태(stateless) 서비스 객체
- 공통 자원이나 객체 생성 비용을 관리하는 경우

싱글톤은 전역에서 접근 가능한 상태를 만들기 쉽다는 단점도 있다. 내부에 변경 가능한 데이터를 보관하면 여러 요청이 같은 상태를 공유해 동시성 문제가 발생할 수 있다. 테스트에서 구현체 교체가 어려워지는 문제도 고려해야 한다.

Spring의 기본 Bean Scope인 singleton도 이름은 같지만, Spring 컨테이너가 Bean 인스턴스를 관리한다는 점에서 직접 구현한 싱글톤 패턴과 구분해서 이해해야 한다.

**핵심:** 인스턴스 생성을 하나로 제한해 동일한 객체를 공유한다. 다만 전역 상태와 동시성 문제를 주의해야 한다.
