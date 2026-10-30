---
layout: post
title: "JVM Class Loading — 클래스 로딩, 검증, 초기화"
date: 2026-10-30 12:00:00 +0900
categories: [Spring]
tags: [Java, JVM, ClassLoader, Class Loading]
---

## 1. 클래스 로딩이 필요한 이유

Java 코드를 실행하려면 JVM이 클래스의 바이트코드를 읽고 런타임에서 사용할 수 있는 형태로 준비해야 한다. 이 과정을 클래스 로딩이라고 하며, 단순히 파일을 읽는 것에서 끝나지 않고 검증과 메모리 준비, 초기화까지 이어진다.

일반적인 흐름은 다음과 같다.

```text
Loading
  ↓
Linking
  ├─ Verification
  ├─ Preparation
  └─ Resolution
  ↓
Initialization
```

## 2. Loading: 클래스 읽기

ClassLoader가 클래스의 바이트 정보를 찾아 JVM에 전달한다. 클래스 파일, JAR 파일, 네트워크 등 다양한 위치에서 바이트코드를 가져올 수 있다.

로딩이 끝나면 JVM은 클래스의 런타임 표현을 만들고 해당 클래스의 정보를 메서드 영역에 해당하는 런타임 메모리 구조에 관리한다. 실제 메모리 구현은 JVM 버전에 따라 달라질 수 있다.

## 3. Linking: 연결 과정

### Verification

클래스 파일의 형식과 바이트코드가 JVM 규칙에 맞는지 검사한다. 잘못된 바이트코드가 실행되어 JVM이 비정상 동작하는 일을 방지한다.

### Preparation

클래스 변수(static 필드)를 위한 메모리를 준비하고 기본값을 설정한다.

```java
class Counter {
    static int count = 10;
}
```

준비 단계에서 count는 우선 기본값인 0으로 준비된다. 코드에 작성된 10이라는 명시적 초기화는 초기화 단계에서 실행된다.

### Resolution

상수 풀의 심볼릭 참조를 실제 클래스, 필드, 메서드에 대한 참조로 바꾸는 과정이다. JVM은 필요한 시점에 해석을 수행할 수 있다.

## 4. Initialization: 초기화

클래스의 static 필드에 작성한 초기값과 static 초기화 블록이 실행된다.

```java
class ApplicationConfig {
    static String environment;

    static {
        environment = "local";
        System.out.println("static 초기화 실행");
    }
}
```

해당 클래스가 초기화되는 시점에 static 블록이 실행된다. 단순히 클래스 이름을 참조했다고 항상 즉시 초기화되는 것은 아니며, 인스턴스 생성, static 메서드 호출, static 필드의 특정 접근 등 JVM이 정한 적극적 사용 조건에 따라 초기화된다.

## 5. ClassLoader의 종류

대표적인 ClassLoader 계층은 다음과 같다.

| 종류 | 역할 |
| --- | --- |
| Bootstrap | 핵심 Java 런타임 클래스 로딩 |
| Platform | 플랫폼 관련 클래스 로딩 |
| Application | 애플리케이션 클래스패스의 클래스 로딩 |

JDK 버전에 따라 내부 구현과 클래스 구성은 달라질 수 있다. 애플리케이션에서 확인하려면 다음 코드를 실행해 볼 수 있다.

```java
public class LoaderCheck {
    public static void main(String[] args) {
        System.out.println(String.class.getClassLoader());
        System.out.println(LoaderCheck.class.getClassLoader());
    }
}
```

String은 Bootstrap Loader가 로딩하므로 일반적으로 null이 출력된다. 애플리케이션 클래스는 Application ClassLoader가 담당한다.

## 6. 부모 위임 모델

일반적인 ClassLoader는 먼저 부모에게 클래스 로딩을 요청한다. 부모가 찾지 못하면 현재 로더가 직접 탐색한다.

이 구조는 핵심 런타임 클래스가 애플리케이션 클래스에 의해 임의로 대체되는 문제를 줄이고, 클래스 로딩의 일관성을 유지하는 데 도움이 된다. 다만 모든 프레임워크가 항상 단순한 부모 위임만 사용하는 것은 아니다. 일부 프레임워크나 애플리케이션 서버는 별도의 로딩 정책을 사용할 수 있다.

## 7. 같은 이름의 클래스가 여러 개라면?

JVM에서 클래스의 식별은 단순한 클래스 이름만으로 결정되지 않는다. 일반적으로 클래스의 이름과 이를 정의한 ClassLoader가 함께 중요하다. 서로 다른 ClassLoader가 같은 이름의 클래스를 정의하면 JVM 입장에서는 서로 다른 타입이 될 수 있다.

이런 특성은 플러그인 구조, 애플리케이션 서버, 모듈 격리 환경에서 중요하다. 반대로 ClassCastException이 발생했을 때 클래스 이름이 같아 보이더라도 로더가 다른지 확인해야 하는 원인이 되기도 한다.

## 8. 백엔드 개발에서 만나는 상황

Spring Boot 실행 과정에서는 컴포넌트와 라이브러리 클래스가 로딩된다. 다음과 같은 오류를 만났을 때 클래스 로딩 개념이 도움이 된다.

- ClassNotFoundException: 필요한 클래스를 찾지 못한 경우
- NoClassDefFoundError: 이전에 필요한 클래스 정의를 찾거나 초기화하는 데 실패한 경우 등
- ExceptionInInitializerError: static 초기화 과정에서 예외가 발생한 경우
- ClassCastException: 타입 관계가 맞지 않는 객체를 변환하려 한 경우

오류 메시지와 원인 클래스, 의존성 버전, ClassLoader 관계를 함께 확인해야 한다.

## 핵심 정리

- 클래스 실행 준비는 Loading → Linking → Initialization 흐름으로 이해한다.
- Linking에는 검증, 준비, 해석이 포함된다.
- Preparation에서는 static 필드가 기본값으로 준비되고 명시적 초기화는 Initialization에서 수행된다.
- ClassLoader는 부모 위임 구조를 사용하며, 클래스 이름과 로더 관계가 타입 식별에 중요하다.
