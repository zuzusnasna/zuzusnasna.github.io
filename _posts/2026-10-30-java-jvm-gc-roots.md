---
layout: post
title: "JVM GC Roots — 객체 도달 가능성과 Garbage Collection"
date: 2026-10-26 00:00:00 +0900
categories: [Spring]
tags: [Java, JVM, GC, GCRoots, Memory]
---

## 1. Garbage Collection은 무엇을 기준으로 동작할까?

Java에서는 개발자가 일반적으로 객체 메모리를 직접 해제하지 않는다. JVM의 Garbage Collector(GC)가 더 이상 사용할 수 없는 객체를 찾아 메모리를 회수한다.

여기서 중요한 기준은 객체가 오래되었는지가 아니라 **프로그램에서 도달 가능한 상태인지**다. 객체가 다른 객체에서 참조되고 있고 그 연결이 GC Roots까지 이어진다면 살아 있는 객체로 판단될 수 있다.

## 2. GC Roots란?

GC Roots는 객체 참조 그래프를 탐색할 때 출발점이 되는 참조다. 대표적인 예시는 다음과 같다.

- 현재 실행 중인 스레드의 스택에서 참조하는 지역 변수와 매개변수
- 클래스의 static 필드가 참조하는 객체
- JNI를 통해 유지되는 참조
- JVM 내부에서 특별히 관리하는 참조

GC는 이러한 루트에서 시작해 참조를 따라가며 살아 있는 객체를 표시한다.

```text
GC Roots
  ├─ 지역 변수 ──> Member A
  │                  └─> Profile
  ├─ static 필드 ──> Cache
  │                   └─> Product
  └─ 기타 JVM 참조

루트에서 도달 가능한 객체: 살아 있는 객체
도달할 수 없는 객체: 회수 후보
```

객체끼리 서로 참조하고 있더라도 GC Roots에서 도달할 수 없다면 회수 대상이 될 수 있다. 단순한 참조 카운팅 방식과 구분되는 중요한 점이다.

## 3. 객체가 회수되는 예시

```java
public class GcExample {
    public static void main(String[] args) {
        Member member = new Member("Kim");

        member = null;
        // 기존 Member 객체를 가리키는 참조가 더 이상 없다.
        // 다른 곳에서도 참조하지 않는다면 GC 대상이 될 수 있다.
    }
}

class Member {
    private final String name;

    Member(String name) {
        this.name = name;
    }
}
```

참조 변수에 null을 대입했다고 즉시 메모리가 해제되는 것은 아니다. 단지 해당 참조가 객체를 가리키지 않게 된다. 다른 참조가 남아 있는지 확인하고, 실제 회수 시점은 GC가 결정한다.

## 4. 서로 참조하는 객체는 어떻게 될까?

```java
class Node {
    Node next;
}

Node a = new Node();
Node b = new Node();

a.next = b;
b.next = a;

a = null;
b = null;
```

두 객체가 서로를 참조하지만 외부 루트에서 접근할 수 없다면 둘 다 회수 대상이 될 수 있다. GC는 객체 사이의 연결만 보는 것이 아니라 루트에서 도달할 수 있는지를 기준으로 판단한다.

## 5. 메모리 누수와 GC Roots

Java에서도 메모리 누수가 발생할 수 있다. 객체가 업무적으로는 더 이상 필요하지 않지만 GC Roots에서 계속 도달 가능한 상태로 남아 있으면 메모리를 점유한다.

대표적인 원인은 다음과 같다.

- static 컬렉션에 데이터를 계속 추가하고 제거하지 않는 경우
- 만료되지 않는 캐시에 오래된 객체를 보관하는 경우
- 이벤트 리스너를 등록한 뒤 해제하지 않는 경우
- ThreadLocal 값을 스레드 풀에서 재사용하면서 제거하지 않는 경우
- 종료되지 않는 작업이나 큐가 큰 객체를 계속 붙잡는 경우

예를 들어 static Map은 클래스가 살아 있는 동안 접근 가능한 참조로 남을 수 있다.

```java
class UserCache {
    private static final Map<Long, User> CACHE = new HashMap<>();

    static void put(Long id, User user) {
        CACHE.put(id, user);
    }
}
```

캐시 만료나 제거 정책이 없다면 사용하지 않는 User 객체도 계속 남을 수 있다.

## 6. 강한 참조와 약한 참조

Java에는 참조 강도를 표현하는 여러 참조 타입이 있다.

| 참조 종류 | 특징 |
| --- | --- |
| Strong Reference | 일반적인 참조. 도달 가능한 동안 회수되지 않음 |
| SoftReference | 메모리 상황에 따라 회수될 수 있음 |
| WeakReference | 강한 참조가 사라지면 다음 GC에서 회수될 수 있음 |
| PhantomReference | 객체 회수 후 정리 작업을 추적하는 고급 메커니즘 |

WeakHashMap은 Key를 약한 참조로 관리하는 Map 구현체다. 단, 약한 참조를 사용한다고 모든 캐시 문제가 자동으로 해결되는 것은 아니다. 값이 Key를 다시 강하게 참조하는 구조 등에서는 예상과 다르게 유지될 수 있다.

## 7. GC 로그와 힙 덤프 분석

메모리 문제가 발생하면 단순히 힙 크기를 늘리기 전에 객체가 왜 살아 있는지 확인해야 한다.

분석 순서는 다음과 같이 잡을 수 있다.

1. 시간에 따른 Heap 사용량과 GC 횟수를 확인한다.
2. GC 이후에도 사용량이 계속 증가하는지 살펴본다.
3. 필요한 시점에 Heap Dump를 수집한다.
4. 객체 개수와 Retained Heap이 큰 객체를 찾는다.
5. GC Roots 참조 경로를 따라 누가 객체를 붙잡고 있는지 확인한다.

Heap Dump 분석 도구에서는 Dominator Tree, Retained Heap, Path to GC Roots 등을 확인할 수 있다.

## 핵심 정리

- GC는 객체의 나이가 아니라 도달 가능성을 기준으로 회수 여부를 판단한다.
- GC Roots는 객체 참조 그래프의 출발점이다.
- 서로 참조하는 객체도 루트에서 도달할 수 없다면 회수될 수 있다.
- static 컬렉션, 캐시, 리스너, ThreadLocal은 메모리 누수 원인이 될 수 있다.
- Heap Dump에서는 객체 크기뿐 아니라 GC Roots까지 이어지는 참조 경로를 추적해야 한다.
