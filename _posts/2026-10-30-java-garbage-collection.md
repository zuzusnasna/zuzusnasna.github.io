---
layout: post
title: "Java Garbage Collection — 객체 메모리를 관리하는 GC"
date: 2026-10-30 12:30:00 +0900
categories: [Spring]
tags: [Java, JVM, GC, Memory]
---

Java에서는 개발자가 일반적으로 객체의 메모리를 직접 해제하지 않는다. JVM의 Garbage Collection(GC)이 더 이상 사용할 수 없는 객체를 찾아 메모리를 회수한다.

## 1. 객체는 어디에 생성될까?

일반적인 객체와 배열은 JVM의 Heap 영역에 생성된다. 지역 변수에 저장된 참조값 등을 통해 객체에 접근한다.

```java
public class Main {
    public static void main(String[] args) {
        Member member = new Member();
    }
}
```

이 코드에서 `new Member()`로 생성한 객체는 Heap에 만들어지고, 지역 변수 `member`가 해당 객체를 참조한다.

## 2. GC 대상이 되는 시점

객체가 더 이상 프로그램에서 도달할 수 없는 상태가 되면 GC가 회수할 수 있는 대상이 된다.

```java
public class Main {
    public static void main(String[] args) {
        Member member = new Member();

        member = null;
        // 기존 Member 객체를 가리키는 참조가 사라짐
        // 다른 곳에서도 참조하지 않는다면 GC 대상이 될 수 있음
    }
}
```

```text
member ─────> Member 객체

member = null

member       Member 객체
  │              ↑
  └─ 참조 끊김   다른 참조도 없다면 GC 대상
```

중요한 점은 `null`을 대입했다고 즉시 메모리가 해제되는 것은 아니라는 것이다. GC 실행 시점과 방식은 JVM이 판단한다.

## 3. GC는 어떻게 객체를 판단할까?

GC는 단순히 변수가 null인지 확인하는 것이 아니라, GC Root에서 객체까지 도달할 수 있는 참조 경로가 있는지를 기준으로 판단한다.

GC Root에는 실행 중인 스레드의 스택 참조, 정적 필드 등 JVM이 루트로 취급하는 참조가 포함된다.

- GC Root에서 도달할 수 있는 객체: 사용 가능한 객체로 판단
- GC Root에서 도달할 수 없는 객체: 회수 후보

객체끼리 서로 참조하고 있더라도 GC Root에서 도달할 수 없다면 회수 대상이 될 수 있다.

## 4. 메모리 누수는 GC가 있어도 발생할 수 있다

GC가 있다고 해서 메모리 문제가 모두 사라지는 것은 아니다. 더 이상 필요하지 않은 객체를 컬렉션이나 static 필드가 계속 참조하면 GC가 회수하지 못한다.

```java
public class Cache {
    private static final List<Object> values = new ArrayList<>();

    public static void add(Object value) {
        values.add(value);
    }
}
```

위 목록에 데이터를 계속 추가하고 제거하지 않는다면 객체가 계속 참조되어 메모리 사용량이 증가할 수 있다.

## 5. System.gc()는 즉시 실행 명령이 아니다

```java
System.gc();
```

GC 수행을 요청하는 힌트일 뿐, 반드시 즉시 GC가 실행된다고 보장하지 않는다. 일반적인 애플리케이션 코드에서 메모리 정리를 위해 반복적으로 호출하는 방식은 피해야 한다.

## 6. 실제 서버에서 중요한 이유

웹 서버는 요청을 처리하면서 DTO, 엔티티, 문자열 등 다양한 객체를 계속 생성한다. 객체가 적절한 시점에 더 이상 참조되지 않으면 GC가 메모리를 회수할 수 있다.

반대로 불필요한 참조가 계속 남으면 메모리 사용량이 증가하고, GC가 자주 동작하거나 애플리케이션 성능에 영향을 줄 수 있다.

GC는 메모리 해제를 자동화하지만, 객체 참조를 불필요하게 유지하지 않도록 설계하는 책임은 개발자에게 있다.
