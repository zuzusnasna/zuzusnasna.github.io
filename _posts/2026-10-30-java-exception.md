---
layout: post
title: "Java 실행 구조 — Call by Value와 Process, Thread"
date: 2026-10-30 12:00:00 +0900
categories: [Spring]
tags: [Java]
---

오늘은 Java에서 메서드에 값이 전달되는 방식과 프로세스, 스레드의 차이를 정리했다.

## 1. Java는 Call by Value

Java에서는 메서드 인자를 항상 값으로 전달한다.

기본 타입을 보면 쉽게 확인할 수 있다.

```java
static void change(int value) {
    value = 100;
}

int number = 10;
change(number);

System.out.println(number); // 10
```

`number`의 값이 복사되어 전달됐기 때문에 메서드 안에서 `value`를 바꿔도 호출한 쪽의 `number`는 바뀌지 않는다.

객체도 Call by Reference가 아니다. 객체를 전달할 때는 객체를 가리키는 참조값이 복사되어 전달된다.

```java
static void change(Member member) {
    member.name = "김철수";
}
```

복사된 참조값이 같은 객체를 가리키기 때문에 객체의 상태 변경은 호출한 쪽에서도 확인할 수 있다.

```text
호출자 참조값 ──┐
               ↓
            Member 객체
               ↑
메서드 참조값 ──┘
```

그래서 Java는 **항상 Call by Value**라고 정리하는 것이 정확하다.

## 2. Process

프로세스는 실행 중인 프로그램이다. 프로세스는 기본적으로 독립적인 메모리 공간을 가진다.

```text
Process A
 ├─ Code
 ├─ Data
 ├─ Heap
 └─ Stack

Process B
 ├─ Code
 ├─ Data
 ├─ Heap
 └─ Stack
```

서로 다른 프로세스는 메모리를 기본적으로 공유하지 않는다.

## 3. Thread

스레드는 프로세스 안에서 실제 작업을 수행하는 실행 흐름이다.

```text
프로세스
 ├─ Thread 1
 ├─ Thread 2
 └─ Thread 3
```

같은 프로세스의 스레드들은 Heap 같은 메모리 영역을 공유할 수 있다.

그래서 여러 스레드가 동시에 같은 데이터를 수정하면 문제가 생길 수 있다.

```java
count++;
```

이런 공유 상태를 안전하게 처리하려면 동기화, Lock, 원자적 연산 등의 방법을 고려해야 한다.

웹 서버가 여러 사용자의 요청을 동시에 처리하는 구조를 이해하려면 Process와 Thread의 차이를 먼저 알고 있어야 했다.
