---
layout: post
title: "Java Thread — 프로그램의 작업을 실행하는 스레드"
date: 2026-10-30 12:40:00 +0900
categories: [Spring]
tags: [Java, Thread, Concurrency]
---

스레드(Thread)는 프로그램 안에서 작업을 실행하는 하나의 흐름이다. 하나의 프로세스 안에는 여러 스레드가 존재할 수 있으며, 각 스레드가 작업을 나누어 처리할 수 있다.

## 1. 프로세스와 스레드

- **프로세스(Process)**: 운영체제에서 실행 중인 프로그램 단위. 독립적인 메모리 공간을 가진다.
- **스레드(Thread)**: 프로세스 내부에서 실행되는 작업 흐름. 같은 프로세스의 스레드들은 Heap 등 메모리 영역을 공유한다.

예를 들어 웹 서버 프로세스가 실행되고 있을 때 여러 스레드가 각각 들어온 요청을 처리할 수 있다.

## 2. Thread 클래스로 스레드 만들기

`Thread` 클래스를 상속하고 `run()` 메서드에 실행할 작업을 작성한다.

```java
class NumberThread extends Thread {
    @Override
    public void run() {
        for (int i = 1; i <= 5; i++) {
            System.out.println(
                Thread.currentThread().getName() + " : " + i
            );
        }
    }
}

public class Main {
    public static void main(String[] args) {
        NumberThread t1 = new NumberThread();
        NumberThread t2 = new NumberThread();

        t1.start();
        t2.start();
    }
}
```

두 스레드가 실행되면 출력 순서는 실행할 때마다 달라질 수 있다. 스레드의 실행 순서는 JVM과 운영체제의 스케줄링에 따라 결정되며, 번갈아 실행된다고 보장되지 않는다.

## 3. start()와 run()의 차이

- `start()`: 새로운 스레드 실행을 시작하고, 새 실행 흐름에서 `run()`이 호출되도록 한다.
- `run()`: 일반 메서드 호출이다. 직접 호출하면 새로운 스레드가 만들어지지 않고 현재 실행 흐름에서 실행된다.

따라서 멀티 스레드 실행을 원한다면 `run()`이 아니라 `start()`를 호출해야 한다.

## 4. Runnable로 작업과 스레드 분리하기

Java에서는 작업 내용을 `Runnable`로 분리할 수도 있다. 작업을 정의하는 역할과 실제 작업을 실행하는 Thread의 역할을 나누는 방식이다.

```java
class PrintTask implements Runnable {
    @Override
    public void run() {
        System.out.println(
            Thread.currentThread().getName() + " 작업 실행"
        );
    }
}

public class Main {
    public static void main(String[] args) {
        Runnable task = new PrintTask();

        Thread t1 = new Thread(task);
        Thread t2 = new Thread(task);

        t1.start();
        t2.start();
    }
}
```

하나의 작업 객체를 여러 스레드가 실행할 수 있다. 다만 작업 객체의 필드를 여러 스레드가 함께 변경한다면 동기화 등 동시성 문제를 고려해야 한다.

## 5. 실제 사용 사례

- 웹 서버에서 여러 사용자의 요청을 동시에 처리
- 파일 다운로드와 다른 작업을 함께 진행
- 백그라운드에서 로그 기록이나 데이터 처리
- 실시간 채팅 서버에서 여러 클라이언트의 연결과 메시지 처리

## 6. 멀티 스레드에서 주의할 점

여러 스레드가 같은 데이터를 동시에 읽고 수정하면 실행 순서에 따라 결과가 달라지는 경쟁 상태(Race Condition)가 발생할 수 있다.

따라서 공유 데이터에 접근하는 코드에서는 `synchronized`, Lock, 원자적 자료형, 동시성 컬렉션 등의 방법을 상황에 맞게 고려해야 한다.

스레드는 작업을 동시에 진행할 수 있게 해주지만, 스레드 수를 늘리는 것만으로 성능이 항상 좋아지는 것은 아니다. 작업의 성격과 공유 자원, 스레드 생성·관리 비용까지 함께 고려해야 한다.
