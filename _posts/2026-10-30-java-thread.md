---
layout: post
title: "Java Thread — 스레드 생명 주기와 동시 실행 관리"
date: 2026-08-07 00:00:00 +0900
categories: [Spring]
tags: [Java, Thread, Concurrency, Runnable, Executor]
---

## 1. 프로세스와 스레드

프로세스는 실행 중인 프로그램 단위이며 독립적인 메모리 공간을 가진다. 스레드는 프로세스 내부에서 실행되는 작업 흐름이다.

한 프로세스의 스레드들은 Heap과 메서드 영역 등 프로세스 내 공유 자원을 함께 사용하지만, 각 스레드는 자신만의 Stack과 실행 상태를 가진다.

웹 서버에서는 여러 요청을 서로 다른 스레드에서 처리할 수 있다. 하지만 공유 객체를 동시에 수정하면 동기화 문제가 발생할 수 있다.

## 2. Thread 생성

Thread 클래스를 상속하는 방식과 Runnable을 구현하는 방식이 있다.

```java
class PrintTask implements Runnable {
    @Override
    public void run() {
        for (int i = 1; i <= 3; i++) {
            System.out.println(
                Thread.currentThread().getName() + " : " + i
            );
        }
    }
}

public class Main {
    public static void main(String[] args) {
        Thread t1 = new Thread(new PrintTask(), "worker-1");
        Thread t2 = new Thread(new PrintTask(), "worker-2");

        t1.start();
        t2.start();
    }
}
```

Runnable은 실행할 작업을 표현하고 Thread는 작업을 실행하는 스레드를 표현한다. 작업과 실행 주체를 분리하면 코드 재사용과 관리가 쉬워진다.

## 3. start()와 run()

start()는 새로운 스레드 실행을 시작하고 새 실행 흐름에서 run()을 수행하도록 한다. run()을 직접 호출하면 일반 메서드 호출이므로 현재 스레드에서 실행된다.

스레드를 시작한 뒤 같은 Thread 객체에 start()를 다시 호출할 수 없다. 이미 시작된 스레드를 다시 실행하려면 새로운 Thread 객체를 만들어야 한다.

## 4. Thread의 생명 주기

Java Thread.State는 대표적으로 다음 상태를 제공한다.

| 상태 | 의미 |
| --- | --- |
| NEW | 생성되었지만 아직 시작하지 않음 |
| RUNNABLE | 실행 가능 또는 실행 중 |
| BLOCKED | 모니터 락 획득 대기 |
| WAITING | 다른 스레드의 동작을 무기한 대기 |
| TIMED_WAITING | 제한 시간 동안 대기 |
| TERMINATED | 실행 종료 |

RUNNABLE은 운영체제 CPU에서 실제 실행 중인 경우뿐 아니라 실행 가능한 상태도 포함한다.

## 5. join(), sleep(), interrupt()

join()은 다른 스레드의 실행이 끝날 때까지 현재 스레드가 기다리게 한다.

```java
Thread worker = new Thread(() -> {
    System.out.println("작업 수행");
});

worker.start();
worker.join();

System.out.println("작업 완료 후 실행");
```

sleep()은 현재 스레드를 일정 시간 대기시킨다. 락을 자동으로 해제하는 메서드는 아니다.

interrupt()는 스레드에 인터럽트 요청을 전달한다. sleep, wait, join 등 인터럽트 가능한 대기 상태에 있으면 InterruptedException이 발생할 수 있다. 인터럽트는 강제 종료 명령이 아니라 작업 취소를 알리는 협력적 신호로 다뤄야 한다.

```java
try {
    Thread.sleep(1000);
} catch (InterruptedException e) {
    Thread.currentThread().interrupt();
    return;
}
```

## 6. 공유 데이터와 경쟁 상태

```java
class Counter {
    int count = 0;

    void increase() {
        count++;
    }
}
```

여러 스레드가 같은 Counter를 공유하고 동시에 increase()를 실행하면 증가 결과가 누락될 수 있다. count++는 읽기·계산·쓰기 단계로 이루어진 복합 연산이기 때문이다.

이를 해결하려면 synchronized, Lock, AtomicInteger 등 요구사항에 맞는 동기화 방법을 선택해야 한다.

## 7. 직접 Thread를 계속 생성하지 않는 이유

요청이 들어올 때마다 Thread를 무제한 생성하면 스레드마다 Stack 메모리와 관리 비용이 발생한다. 생성 수가 늘면 CPU 스케줄링과 컨텍스트 스위칭 부담도 커질 수 있다.

실제 서버에서는 보통 ExecutorService 같은 스레드 풀을 사용해 작업 제출과 스레드 관리를 분리한다.

```java
ExecutorService executor = Executors.newFixedThreadPool(4);

executor.submit(() -> {
    System.out.println(Thread.currentThread().getName());
});

executor.shutdown();
```

스레드 풀은 재사용 가능한 스레드 수를 관리하지만, 큐 적체와 종료 정책, 작업 예외 처리, 풀 크기 설정을 함께 고려해야 한다.

## 8. 백엔드에서의 활용

- 웹 요청을 여러 작업 스레드에서 처리
- 비동기 이메일·알림 발송
- 파일 변환이나 배치 작업
- 실시간 채팅 연결과 메시지 처리

스레드 수를 늘리는 것만으로 성능이 좋아지지는 않는다. CPU 작업인지 I/O 대기 작업인지, DB 커넥션 풀 크기와 맞는지, 공유 자원 경합이 있는지 함께 살펴야 한다.

## 핵심 정리

- 프로세스는 메모리 공간, 스레드는 실행 흐름을 의미한다.
- Runnable로 작업과 Thread 실행 주체를 분리할 수 있다.
- start()와 run()은 실행 방식이 다르다.
- join, sleep, interrupt로 스레드 대기와 취소 흐름을 제어한다.
- 실무에서는 ExecutorService 등으로 스레드 생명 주기를 관리한다.
