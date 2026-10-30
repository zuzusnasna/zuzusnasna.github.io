---
layout: post
title: "Java 멤버와 상수 — static, non-static, final"
date: 2026-10-30 11:30:00 +0900
categories: [Spring]
tags: [Java]
---

오늘은 객체마다 존재하는 멤버와 클래스에 하나만 존재하는 static 멤버의 차이를 정리하고 `final`까지 같이 봤다.

## 1. non-static 멤버

non-static 멤버는 객체마다 별도로 존재한다.

```java
class Person {
    String name;

    void hello() {
        System.out.println(name);
    }
}
```

```java
Person person1 = new Person();
Person person2 = new Person();

person1.name = "홍길동";
person2.name = "김철수";
```

두 객체의 `name`은 서로 다른 값이다.

## 2. static 멤버

`static`은 객체가 아니라 클래스에 속한다.

```java
class Counter {
    static int count = 0;

    Counter() {
        count++;
    }
}
```

```java
new Counter();
new Counter();
new Counter();

System.out.println(Counter.count); // 3
```

객체마다 `count`가 하나씩 생기는 것이 아니라 모든 객체가 하나의 `count`를 공유한다.

| 구분 | static | non-static |
|---|---|---|
| 소속 | 클래스 | 객체 |
| 공유 | 모든 객체가 공유 | 객체마다 별도 |
| 접근 | 클래스명으로 가능 | 객체 필요 |
| 용도 | 공통 데이터/기능 | 객체별 상태/기능 |

## 3. final

`final`은 변경할 수 없도록 제한하는 키워드다.

변수:

```java
final int MAX = 100;
// MAX = 200; // 오류
```

메서드:

```java
class Parent {
    final void run() {
        System.out.println("실행");
    }
}
```

`final` 메서드는 자식 클래스에서 오버라이딩할 수 없다.

클래스:

```java
final class Parent {
}
```

`final` 클래스는 상속할 수 없다.

```text
final 변수 → 값 변경 제한
final 메서드 → 오버라이딩 제한
final 클래스 → 상속 제한
```

`final`, `finally`, `finalize()`는 서로 다른 개념이다. 특히 `finalize()`는 현재 Java에서 일반적인 자원 관리 방법으로 사용하지 않는다.
